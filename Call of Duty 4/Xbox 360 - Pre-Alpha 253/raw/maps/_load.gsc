#include maps\_utility;
#include maps\_hud_util;
#include common_scripts\utility;

main( bScriptgened,bCSVgened,bsgenabled )
{
	if( !isdefined( level.script_gen_dump_reasons ) )
		level.script_gen_dump_reasons = [];
	if( !isdefined( bsgenabled ) )
		level.script_gen_dump_reasons[ level.script_gen_dump_reasons.size ] = "First run";
		
	if( !isdefined( bCSVgened ) )
		bCSVgened = false;
	level.bCSVgened = bCSVgened;
	
	if( !isdefined( bScriptgened ) )
		bScriptgened = false;
	else
		bScriptgened = true;
	level.bScriptgened = bScriptgened;
	
	/# star( 4 + randomint( 4 ) ); #/

	if( getDvar( "debug" ) == "" )
		setDvar( "debug", "0" );

	if( getDvar( "fallback" ) == "" )
		setDvar( "fallback", "0" );

	if( getDvar( "angles" ) == "" )
		setDvar( "angles", "0" );

	if( getDvar( "noai" ) == "" )
		setDvar( "noai", "off" );

	if( getDvar( "scr_RequiredMapAspectratio" ) == "" )
		setDvar( "scr_RequiredMapAspectratio", "1" );
		
	createPrintChannel( "script_debug" );
	
	level._loadStarted = true;
	
	level.script = tolower( getdvar( "mapname" ) );
	level.player = getent( "player", "classname" );
	level.player.a = spawnStruct();
	
	level.default_run_speed = 190;
	setSavedDvar( "g_speed", level.default_run_speed );
	setSavedDvar( "sv_saveOnStartMap", true );
	

	level.dronestruct = [];
	maps\_utility_code::struct_class_init();
	

//	if( !level.xenon )
//		level.player enableHealthShield( false );

	if( !isdefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
	}
	// can be turned on and off to control friendly_respawn_trigger
	flag_init( "respawn_friendlies" );

	// for script gen
	flag_init( "scriptgen_done" );
	level.script_gen_dump_reasons = [];
	if( !isdefined( level.script_gen_dump ) )
	{
		level.script_gen_dump = [];
		level.script_gen_dump_reasons[ 0 ] = "First run";
	}

	if( !isdefined( level.script_gen_dump2 ) )
		level.script_gen_dump2 = [];
		
	if( isdefined( level.createFXent ) )
		script_gen_dump_addline( "maps\\createfx\\"+level.script+"_fx::main();",level.script+"_fx" );  // adds to scriptgendump
		
	if( isdefined( level.script_gen_dump_preload ) )
		for( i=0;i<level.script_gen_dump_preload.size;i++ )
			script_gen_dump_addline( level.script_gen_dump_preload[ i ].string, level.script_gen_dump_preload[ i ].signature );

	level.player.maxhealth = level.player.health;
	level.player.shellshocked = false;
	level.aim_delay_off = false;
	level.player.inWater = false;
	level.last_wait_spread = -1;
	level.hero_list = [];
//	level.ai_array = [];
	
	level.player thread maps\_utility::flashMonitor();
	level.player thread maps\_utility::shock_ondeath();
//	level.player thread ai_eq();
//	level.player thread maps\_spawner::setup_ai_eq_triggers();
//	level.eq_trigger_num = 0;
//	level.eq_trigger_table = [];
//	level.touched_eq_function[ true ] = ::player_touched_eq_trigger;
//	level.touched_eq_function[ false ] = ::ai_touched_eq_trigger;

/#
	precachemodel( "fx" );
//	precachemodel( "temp" );
#/	
	precacheShellshock( "victoryscreen" );
	precacheShellshock( "default" );
	precacheShellshock( "flashbang" );
	precacheShellshock( "dog_bite" );
	precacheRumble( "damage_heavy" );
	precacheRumble( "damage_light" );
	precacheRumble( "grenade_rumble" );
	precacheRumble( "artillery_rumble" );
	
	precachestring( &"GAME_GET_TO_COVER" );
	precachestring( &"SCRIPT_GRENADE_DEATH" );
	precachestring( &"SCRIPT_GRENADE_SUICIDE_LINE1" );
	precachestring( &"SCRIPT_GRENADE_SUICIDE_LINE2" );
	precacheShader( "hud_grenadeicon" );
	precacheShader( "hud_grenadepointer" );


	level.createFX_enabled =( getdvar( "createfx" ) != "" );

	maps\_mgturret::main();
	maps\_mgturret::setdifficulty();

	setupExploders();
	maps\_art::main();
	thread maps\_vehicle::init_vehicles();	

	thread maps\_createfx::fx_init();
	if( level.createFX_enabled )
		maps\_createfx::createfx();

	animscripts\weaponList::precacheglobalfx();
	animscripts\weaponList::precacheglobalmodels();
	
	if( getdvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		maps\_global_fx::main();
		level waittill( "eternity" );
	}

	thread handle_starts();
		
	if( getDvar( "g_connectpaths" ) == "2" )
	{
		/# printLn( "g_connectpaths == 2; halting script execution" ); #/
		level waittill( "eternity" );
	}

	printLn( "level.script: ", level.script );

	maps\_autosave::main();
	maps\_anim::init();
	maps\_ambient::init();

	// lagacy... necessary?
	anim.useFacialAnims = false;

	if( !isdefined( level.missionfailed ) )
		level.missionfailed = false;
	maps\_gameskill::setSkill();
	maps\_loadout::init_loadout();
	maps\_destructible::main();
	
	// global effects for objects
	maps\_global_fx::main();
	
	thread devhelp(); //don't know any other good places to put this so It's here for now.
	
	setSavedDvar( "ui_campaign", level.campaign ); // level.campaign is set in maps\_loadout::init_loadout

	/#
	thread maps\_debug::mainDebug();
	#/
	thread maps\_introscreen::main();
	thread maps\_quotes::main();
	thread maps\_minefields::main();
	thread maps\_shutter::main();
//	thread maps\_breach::main();
	thread maps\_inventory::main();
//	thread maps\_photosource::main();
	thread maps\_endmission::main();
	thread maps\_nightvision::main();
	maps\_friendlyfire::main();

	// For _anim to track what animations have been used. Uncomment this locally if you need it.
//	thread usedAnimations();

	array_levelthread( getentarray( "badplace","targetname" ), ::badplace_think );
	array_levelthread( getentarray( "delete_on_load", "targetname" ), ::deleteEnt );
	array_thread( getnodearray( "traverse","targetname" ), ::traverseThink );
	array_thread( getentarray( "piano_key","targetname" ), ::pianoThink );
	array_thread( getentarray( "piano_damage","targetname" ), ::pianoDamageThink );
	array_thread( getentarray( "water","targetname" ), ::waterThink );
	
	thread maps\_interactive_objects::main();
	thread maps\_pipes::main();
	thread maps\_leak::main();
	thread maps\_intelligence::main();
	
	thread maps\_gameskill::playerHealthRegen();
	thread playerDamageRumble();
	thread player_death_grenade_hint();

	// this has to come before _spawner moves the turrets around
	thread massNodeInitFunctions();
	
	// Various newvillers globalized scripts
	flag_init( "spawning_friendlies" );
	flag_init( "friendly_wave_spawn_enabled" );
	flag_clear( "spawning_friendlies" );
	
	level.friendly_spawner[ "rifleguy" ] = getentarray( "rifle_spawner","script_noteworthy" );			
	level.friendly_spawner[ "smgguy" ] = getentarray( "smg_spawner","script_noteworthy" );
	thread maps\_spawner::goalVolumes();
	thread maps\_spawner::friendlyChains();
	thread maps\_spawner::friendlychain_onDeath();

//	array_thread( getentarray( "ally_spawn", "targetname" ), maps\_spawner::squadThink );
	array_thread( getentarray( "friendly_spawn","targetname" ), maps\_spawner::friendlySpawnWave );
	array_thread( getentarray( "flood_and_secure", "targetname" ), maps\_spawner::flood_and_secure );
	
	// Do various things on triggers
	array_thread( getentarray( "ambient_volume","targetname" ),maps\_ambient::ambientVolume );

	level.trigger_hint_string = [];
	level.trigger_hint_func = [];
	if( !isdefined( level.trigger_flags ) )
	{
		// may have been defined by AI spawning
		init_trigger_flags();
	}

	trigger_funcs = [];
	trigger_funcs[ "camper_spawner" ] = maps\_spawner::camper_trigger_think;
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
	trigger_funcs[ "flag_set_player" ] = ::flag_set_player_trigger;
	trigger_funcs[ "flag_unset" ] = ::flag_unset_trigger;
	trigger_funcs[ "random_spawn" ] = maps\_spawner::random_spawn;
	trigger_funcs[ "objective_event" ] = maps\_spawner::objective_event_init;
//	trigger_funcs[ "eq_trigger" ] = ::eq_trigger;
	trigger_funcs[ "friendly_respawn_trigger" ] = ::friendly_respawn_trigger;
	trigger_funcs[ "friendly_respawn_clear" ] = ::friendly_respawn_clear;
	trigger_funcs[ "radio_trigger" ] = ::radio_trigger;
	trigger_funcs[ "trigger_ignore" ] = ::trigger_ignore;
	trigger_funcs[ "trigger_pacifist" ] = ::trigger_pacifist;
	trigger_funcs[ "trigger_delete" ] = ::trigger_turns_off;
	trigger_funcs[ "trigger_delete_on_touch" ] = ::trigger_delete_on_touch;
	trigger_funcs[ "trigger_off" ] = ::trigger_turns_off;
	trigger_funcs[ "trigger_outdoor" ] = maps\_spawner::outdoor_think;
	trigger_funcs[ "trigger_indoor" ] = maps\_spawner::indoor_think;
	trigger_funcs[ "trigger_hint" ] = ::trigger_hint;
	trigger_funcs[ "trigger_grenade_at_player" ] = ::throw_grenade_at_player_trigger;
	trigger_funcs[ "two_stage_spawner" ] = maps\_spawner::two_stage_spawner_think;
	trigger_funcs[ "flag_on_cleared" ] = maps\_load::flag_on_cleared;
	trigger_funcs[ "flag_set_touching" ] = ::flag_set_touching;


	// trigger_multiple and trigger_radius can have the trigger_spawn flag set
	trigger_multiple = getentarray( "trigger_multiple", "classname" );
	trigger_radius = getentarray( "trigger_radius", "classname" );
	triggers = array_merge( trigger_multiple, trigger_radius );

	for( i=0; i < triggers.size; i++ )
	{
		if( triggers[ i ].spawnflags & 32 )
			thread maps\_spawner::trigger_spawner( triggers[ i ] );
	}

	for( p=0;p<6;p++ )
	{
		switch( p )
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
				assert( p == 5 );
				triggertype = "trigger_damage";
				break;
		}

		triggers = getentarray( triggertype,"classname" );

		for( i=0;i<triggers.size;i++ )
		{
			if( isdefined( triggers[ i ].target ) )
				level thread maps\_spawner::trigger_spawn( triggers[ i ] );

			if( isdefined( triggers[ i ].script_flag_true ) )
				level thread script_flag_true_trigger( triggers[ i ] );

			if( isdefined( triggers[ i ].script_flag_false ) )
				level thread script_flag_false_trigger( triggers[ i ] );

			if( isdefined( triggers[ i ].script_autosavename ) || isdefined( triggers[ i ].script_autosave ) )
				level thread maps\_autosave::autoSaveNameThink( triggers[ i ] );

			if( isdefined( triggers[ i ].script_fallback ) )
				level thread maps\_spawner::fallback_think( triggers[ i ] );

			if( isdefined( triggers[ i ].script_mgTurretauto ) )
				level thread maps\_mgturret::mgTurret_auto( triggers[ i ] );

			if( isdefined( triggers[ i ].script_killspawner ) )
				level thread maps\_spawner::kill_spawner( triggers[ i ] );

			if( isdefined( triggers[ i ].script_emptyspawner ) )
				level thread maps\_spawner::empty_spawner( triggers[ i ] );

			if( isdefined( triggers[ i ].script_prefab_exploder ) )
				triggers[ i ].script_exploder = triggers[ i ].script_prefab_exploder;

			if( isdefined( triggers[ i ].script_exploder ) )
				level thread maps\_load::exploder_load( triggers[ i ] );

			if( isdefined( triggers[ i ].ambient ) )
				triggers[ i ] thread maps\_ambient::ambient_trigger();

			if( isdefined( triggers[ i ].script_triggered_playerseek ) )
				level thread triggered_playerseek( triggers[ i ] );
				
			if( isdefined( triggers[ i ].script_bctrigger ) )
				level thread bctrigger( triggers[ i ] );

			if( isdefined( triggers[ i ].script_trigger_group ) )
				triggers[ i ] thread trigger_group();

			if( isdefined( triggers[ i ].script_random_killspawner ) )
				level thread maps\_spawner::random_killspawner( triggers[ i ] );

			if( isdefined( triggers[ i ].targetname ) )
			{
				// do targetname specific functions
				targetname = triggers[ i ].targetname;
				if( isdefined( trigger_funcs[ targetname ] ) )
				{
					level thread [ [ trigger_funcs[ targetname ] ] ]( triggers[ i ] );
				}
			}
		}
	}
	
	level.ai_number = 0;
	level.shared_portable_turrets = [];
	maps\_spawner::main();
	array_thread( getentarray( "misc_turret", "classname" ), ::mg42ModelReplace );

	// for cobrapilot extended visible distance and potentially others, stretch that horizon! -nate
	// origin of prefab is copied manually by LD to brushmodel contained in the prefab, no real way to automate this AFAIK
	array_thread( getentarray( "background_block", "targetname" ), ::background_block );

	maps\_hud::init();
	//maps\_hud_weapons::init();

	thread maps\_utility::load_friendlies();
	
//	level.player thread stun_test();
	level.player thread maps\_detonategrenades::watchGrenadeUsage();  // handles c4/claymores with special script - nate
	
	thread maps\_animatedmodels::main();
	script_gen_dump();
}


mg42ModelReplace()
{
	self setModel( "weapon_saw_MG_Setup" );
}

trigger_group()
{
	self thread trigger_group_remove();

	level endon( "trigger_group_" + self.script_trigger_group );
	self waittill( "trigger" );
	level notify( "trigger_group_" + self.script_trigger_group, self );
}

trigger_group_remove()
{
	level waittill( "trigger_group_" + self.script_trigger_group, trigger );
	if( self != trigger )
		self delete();
}

/#



star( total )
{
	println( "         " );
	println( "         " );
	println( "         " );
	for( i=0;i<total;i++ )
	{
		for( z=total-i;z>1;z-- )
		print( " " );
		print( "*" );
		for( z=0;z<i;z++ )
			print( "**" );
		println( "" );
	}
	for( i=total-2;i>-1;i-- )
	{
		for( z=total-i;z>1;z-- )
		print( " " );
		print( "*" );
		for( z=0;z<i;z++ )
			print( "**" );
		println( "" );
	}

	println( "         " );
	println( "         " );
	println( "         " );
}
#/


exploder_load( trigger )
{
	level endon( "killexplodertridgers"+trigger.script_exploder );
	trigger waittill( "trigger" );
	if( isdefined( trigger.script_chance ) && randomfloat( 1 )>trigger.script_chance )
	{
		if( isdefined( trigger.script_delay ) )
			wait trigger.script_delay;
		else
			wait 4;
		level thread exploder_load( trigger );
		return;
	}
	maps\_utility::exploder( trigger.script_exploder );
	level notify( "killexplodertridgers"+trigger.script_exploder );
}

shock_onpain()
{
	precacheShellshock( "pain" );
	precacheShellshock( "default" );
	level.player endon( "death" );
	if( getdvar( "blurpain" ) == "" )
		setdvar( "blurpain", "on" );

	while( 1 )
	{
		oldhealth = level.player.health;
		level.player waittill( "damage" );
		if( getdvar( "blurpain" ) == "on" )
		{
//			println( "health dif was ", oldhealth - level.player.health );
			if( oldhealth - level.player.health < 129 )
			{
				//level.player shellshock( "pain", 0.4 );
			}
			else
			{
				level.player shellshock( "default", 5 );
			}
		}
	}
}




usedAnimations()
{
	setdvar( "usedanim", "" );
	while( 1 )
	{
		if( getdvar( "usedanim" ) == "" )
		{
			wait( 2 );
			continue;
		}

		animname = getdvar( "usedanim" );
		setdvar( "usedanim", "" );

		if( !isdefined( level.completedAnims[ animname ] ) )
		{
			println( "^d---- No anims for ", animname,"^d -----------" );
			continue;
		}

		println( "^d----Used animations for ", animname,"^d: ", level.completedAnims[ animname ].size, "^d -----------" );
		for( i=0;i<level.completedAnims[ animname ].size;i++ )
			println( level.completedAnims[ animname ][ i ] );
	}
}


badplace_think( badplace )
{
	if( !isdefined( level.badPlaces ) )
		level.badPlaces = 0;
		
	level.badPlaces++;		
	badplace_cylinder( "badplace" + level.badPlaces, -1, badplace.origin, badplace.radius, 1024 );
}


setupExploders()
{
	// Hide exploder models.
	ents = getentarray( "script_brushmodel","classname" );
	smodels = getentarray( "script_model","classname" );
	for( i=0;i<smodels.size;i++ )
		ents[ ents.size ] = smodels[ i ];

	for( i=0;i<ents.size;i++ )
	{
		if( isdefined( ents[ i ].script_prefab_exploder ) )
			ents[ i ].script_exploder = ents[ i ].script_prefab_exploder;

		if( isdefined( ents[ i ].script_exploder ) )
		{
			if(( ents[ i ].model == "fx" ) &&(( !isdefined( ents[ i ].targetname ) ) ||( ents[ i ].targetname != "exploderchunk" ) ) )
				ents[ i ] hide();
			else if(( isdefined( ents[ i ].targetname ) ) &&( ents[ i ].targetname == "exploder" ) )
			{
				ents[ i ] hide();
				ents[ i ] notsolid();
				if( isdefined( ents[ i ].script_disconnectpaths ) )
					ents[ i ] connectpaths();
			}
			else if(( isdefined( ents[ i ].targetname ) ) &&( ents[ i ].targetname == "exploderchunk" ) )
			{
				ents[ i ] hide();
				ents[ i ] notsolid();
				if( isdefined( ents[ i ].spawnflags ) &&( ents[ i ].spawnflags & 1 ) )
					ents[ i ] connectpaths();
			}
		}
	}

	script_exploders = [];

	potentialExploders = getentarray( "script_brushmodel","classname" );
	for( i=0;i<potentialExploders.size;i++ )
	{
		if( isdefined( potentialExploders[ i ].script_prefab_exploder ) )
			potentialExploders[ i ].script_exploder = potentialExploders[ i ].script_prefab_exploder;
			
		if( isdefined( potentialExploders[ i ].script_exploder ) )
			script_exploders[ script_exploders.size ] = potentialExploders[ i ];
	}

	potentialExploders = getentarray( "script_model","classname" );
	for( i=0;i<potentialExploders.size;i++ )
	{
		if( isdefined( potentialExploders[ i ].script_prefab_exploder ) )
			potentialExploders[ i ].script_exploder = potentialExploders[ i ].script_prefab_exploder;

		if( isdefined( potentialExploders[ i ].script_exploder ) )
			script_exploders[ script_exploders.size ] = potentialExploders[ i ];
	}

	potentialExploders = getentarray( "item_health","classname" );
	for( i=0;i<potentialExploders.size;i++ )
	{
		if( isdefined( potentialExploders[ i ].script_prefab_exploder ) )
			potentialExploders[ i ].script_exploder = potentialExploders[ i ].script_prefab_exploder;

		if( isdefined( potentialExploders[ i ].script_exploder ) )
			script_exploders[ script_exploders.size ] = potentialExploders[ i ];
	}
	
	if( !isdefined( level.createFXent ) )
		level.createFXent = [];
	
	acceptableTargetnames = [];
	acceptableTargetnames[ "exploderchunk visible" ] = true;
	acceptableTargetnames[ "exploderchunk" ] = true;
	acceptableTargetnames[ "exploder" ] = true;
	
	for( i=0; i<script_exploders.size; i++ )
	{
		exploder = script_exploders[ i ];
		ent = createExploder( exploder.script_fxid );
		ent.v = [];
		ent.v[ "origin" ] = exploder.origin;
		ent.v[ "angles" ] = exploder.angles;
		ent.v[ "delay" ] = exploder.script_delay;
		ent.v[ "firefx" ] = exploder.script_firefx;
		ent.v[ "firefxdelay" ] = exploder.script_firefxdelay;
		ent.v[ "firefxsound" ] = exploder.script_firefxsound;
		ent.v[ "firefxtimeout" ] = exploder.script_firefxtimeout;
		ent.v[ "earthquake" ] = exploder.script_earthquake;
		ent.v[ "damage" ] = exploder.script_damage;
		ent.v[ "damage_radius" ] = exploder.script_radius;
		ent.v[ "soundalias" ] = exploder.script_soundalias;
		ent.v[ "repeat" ] = exploder.script_repeat;
		ent.v[ "delay_min" ] = exploder.script_delay_min;
		ent.v[ "delay_max" ] = exploder.script_delay_max;
		ent.v[ "target" ] = exploder.target;
		ent.v[ "ender" ] = exploder.script_ender;
		ent.v[ "type" ] = "exploder";
//		ent.v[ "worldfx" ] = true;
		if( !isdefined( exploder.script_fxid ) )
			ent.v[ "fxid" ] = "No FX";
		else
			ent.v[ "fxid" ] = exploder.script_fxid;
		ent.v[ "exploder" ] = exploder.script_exploder;
		assertEx( isdefined( exploder.script_exploder ), "Exploder at origin " + exploder.origin + " has no script_exploder" );

		if( !isdefined( ent.v[ "delay" ] ) )
			ent.v[ "delay" ] = 0;
			
		if( isdefined( exploder.target ) )
		{
			org = getent( ent.v[ "target" ], "targetname" ).origin;
			ent.v[ "angles" ] = vectortoangles( org - ent.v[ "origin" ] );
//			forward = anglestoforward( angles );
//			up = anglestoup( angles );
		}
			
		// this basically determines if its a brush/model exploder or not
		if( exploder.classname == "script_brushmodel" || isdefined( exploder.model ) )
		{
			ent.model = exploder;
			ent.model.disconnect_paths = exploder.script_disconnectpaths;
		}
		
		if( isdefined( exploder.targetname ) && isdefined( acceptableTargetnames[ exploder.targetname ] ) )
			ent.v[ "exploder_type" ] = exploder.targetname;
		else
			ent.v[ "exploder_type" ] = "normal";
		
		ent maps\_createfx::post_entity_creation_function();
	}
}


nearAIRushesPlayer()
{
	if( isalive( level.enemySeekingPlayer ) )
		return;
	enemy = get_closest_ai( level.player.origin, "axis" );
	if( !isdefined( enemy ) )
		return;
		
	if( distance( enemy.origin, level.player.origin ) > 400 )
		return;
		
	level.enemySeekingPlayer = enemy;
	enemy setgoalentity( level.player );
	enemy.goalradius = 512;
	
}

		
playerDamageRumble()
{
	while( true )
	{
		level.player waittill( "damage", amount );
		
		if( isdefined( level.player.specialDamage ) )
			continue;

		level.player PlayRumbleOnEntity( "damage_heavy" );		
	}
}

playerDamageShellshock()
{
	while( true )
	{
		level.player waittill( "damage", damage, attacker, direction_vec, point, cause );

		if( cause == "MOD_EXPLOSIVE" ||
			cause == "MOD_GRENADE" ||
			cause == "MOD_GRENADE_SPLASH" ||
			cause == "MOD_PROJECTILE" ||
			cause == "MOD_PROJECTILE_SPLASH" )
		{
			time = 0;

			multiplier = level.player.maxhealth / 100;
			scaled_damage = damage * multiplier;
			
			if( scaled_damage >= 90 )
				time = 4;
			else if( scaled_damage >= 50 )
				time = 3;
			else if( scaled_damage >= 25 )
				time = 2;
			else if( scaled_damage > 10 )
				time = 1;
			
			if( time )
				level.player shellshock( "default", time );
		}
	}
}

map_is_early_in_the_game()
{
	if( level.script == "moscow" )
		return true;
	return( level.script == "demolition" );
}


player_death_grenade_hint()
{
	if( isalive( level.player ) )
		thread maps\_quotes::setDeadQuote();

	level.player waittill( "death", attacker, cause );
	
	if( cause != "MOD_GRENADE" && cause != "MOD_GRENADE_SPLASH" && cause != "MOD_SUICIDE" )
		return;
		
	if( level.gameskill >= 2 )
	{
		// less grenade hinting on hard/fu
		if( !map_is_early_in_the_game() && randomint( 100 ) < 85 )
			return;
	}		

	level notify( "new_quote_string" );
	
	if( cause == "MOD_SUICIDE"	 )
	{
		thread grenade_death_text_hudelement( &"SCRIPT_GRENADE_SUICIDE_LINE1", &"SCRIPT_GRENADE_SUICIDE_LINE2" );
		return;
	}

	//if( isdefined( attacker ) && attacker == level.player )
	//	return;

	setdvar( "ui_deadquote", "@SCRIPT_GRENADE_DEATH" );
	thread grenade_death_indicator_hudelement();
}

grenade_death_text_hudelement( textLine1, textLine2 )
{
	setdvar( "ui_deadquote", "" );

	wait( 1.5 );

	fontElem = newHudElem();
	fontElem.elemType = "font";
	fontElem.font = "default";
	fontElem.fontscale = 1.5;
	fontElem.x = 0;
	fontElem.y = 0;
	fontElem.alignX = "center";
	fontElem.alignY = "middle";
	fontElem.horzAlign = "center";
	fontElem.vertAlign = "middle";
	fontElem settext( textLine1 );
	fontElem.foreground = true;
	fontElem.alpha = 0;
	fontElem fadeOverTime( 1 );
	fontElem.alpha = 1;

	
	fontElem = newHudElem();
	fontElem.elemType = "font";
	fontElem.font = "default";
	fontElem.fontscale = 1.5;
	fontElem.x = 0;
	fontElem.y = level.fontHeight * fontElem.fontscale;
	fontElem.alignX = "center";
	fontElem.alignY = "middle";
	fontElem.horzAlign = "center";
	fontElem.vertAlign = "middle";
	fontElem settext( textLine2 );
	fontElem.foreground = true;
	fontElem.alpha = 0;
	fontElem fadeOverTime( 1 );
	fontElem.alpha = 1;
}

grenade_death_indicator_hudelement()
{
	wait( 1.5 );
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 68;
	overlay setshader( "hud_grenadeicon", 50, 50 );
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.foreground = true;
	overlay.alpha = 0;
	overlay fadeOverTime( 1 );
	overlay.alpha = 1;

	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 25;
	overlay setshader( "hud_grenadepointer", 50, 25 );
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.foreground = true;
	overlay.alpha = 0;
	overlay fadeOverTime( 1 );
	overlay.alpha = 1;
}


triggered_playerseek( trig )
{
	groupNum = trig.script_triggered_playerseek;
	trig waittill( "trigger" );
	
	ai = getaiarray();
	for( i=0;i<ai.size;i++ )
	{
		if( !isAlive( ai[ i ] ) )
			continue;
		if(( isdefined( ai[ i ].script_triggered_playerseek ) ) &&( ai[ i ].script_triggered_playerseek == groupNum ) )
		{
			ai[ i ].goalradius = 800;
			ai[ i ] setgoalentity( level.player );
			level thread maps\_spawner::delayed_player_seek_think( ai[ i ] );
		}
	}
}

traverseThink()
{
	ent = getent( self.target,"targetname" );
	self.traverse_height = ent.origin[ 2 ];
	ent delete();
}


pianoDamageThink()
{
	org = self getorigin();
//	note = "piano_" + self.script_noteworthy;
//	self setHintString( &"SCRIPT_PLATFORM_PIANO" );
	note[ 0 ] = "large";
	note[ 1 ] = "small";
	for( ;; )
	{
		self waittill( "trigger" );
		thread play_sound_in_space( "bullet_" + random( note ) + "_piano", org );
	}
}

pianoThink()
{
	org = self getorigin();
	note = "piano_" + self.script_noteworthy;
	self setHintString( &"SCRIPT_PLATFORM_PIANO" );
	for( ;; )
	{
		self waittill( "trigger" );
		thread play_sound_in_space( note ,org );
	}
}



bcTrigger( trigger )
{
	realTrigger = undefined;
	
	if( isDefined( trigger.target ) )
	{
		targetEnts = getEntArray( trigger.target, "targetname" );

		if( isSubStr( targetEnts[ 0 ].classname, "trigger" ) )
			realTrigger = targetEnts[ 0 ];
	}
	
	if( isDefined( realTrigger ) )
		realTrigger waittill( "trigger", other );
	else
		trigger waittill( "trigger", other );
	
	soldier = undefined;
	
	if( isDefined( realTrigger ) )
	{
		if( other.team == "axis" && level.player isTouching( trigger ) )
		{
			soldier = get_closest_ai( level.player getOrigin(), "allies" );
			if( distance( soldier.origin, level.player getOrigin() ) > 512 )
				return;
		}
		else if( other.team == "allies" )
		{
			soldiers = getAIArray( "axis" );
			
			for( index = 0; index < soldiers.size; index++ )
			{
				if( soldiers[ index ] isTouching( trigger ) )
					soldier = soldiers[ index ];
			}
		}
	}
	else if( other == level.player )
	{
		soldier = get_closest_ai( level.player getOrigin(), "allies" );
		if( distance( soldier.origin, level.player getOrigin() ) > 512 )
			return;
	}
	else
	{
		soldier = other;
	}
	
	if( !isDefined( soldier ) )
		return;

	soldier custom_battlechatter( trigger.script_bctrigger );
}

waterThink()
{
	assert( isdefined( self.target ) );
	targeted = getent( self.target,"targetname" );
	assert( isdefined( targeted ) );
	waterHeight = targeted.origin[ 2 ];
	targeted = undefined;
	
	level.depth_allow_prone = 8;
	level.depth_allow_crouch = 33;
	level.depth_allow_stand = 50;
	
	prof_begin( "water_stance_controller" );
	
	for( ;; )
	{
		wait 0.05;
		//restore all defaults
		if( !level.player.inWater )
		{
			level.player allowProne( true );
			level.player allowCrouch( true );
			level.player allowStand( true );
			thread waterThink_rampSpeed( level.default_run_speed );
		}
		
		//wait until in water
		self waittill( "trigger" );
		level.player.inWater = true;
		while( level.player isTouching( self ) )
		{
			level.player.inWater = true;
			playerOrg = level.player getOrigin();
			d =( playerOrg[ 2 ] - waterHeight );
			if( d > 0 )
				break;
			
			//slow the players movement based on how deep it is
			newSpeed = int( level.default_run_speed - abs( d * 5 ) );
			if( newSpeed < 50 )
				newSpeed = 50;
			assert( newSpeed <= 190 );
			thread waterThink_rampSpeed( newSpeed );
			
			//controll the allowed stances in this water height
			if( abs( d ) > level.depth_allow_crouch )
				level.player allowCrouch( false );
			else
				level.player allowCrouch( true );
			
			if( abs( d ) > level.depth_allow_prone )
				level.player allowProne( false );
			else
				level.player allowProne( true );
			
			wait 0.5;
		}
		level.player.inWater = false;
		wait 0.05;
	}
	
	prof_end( "water_stance_controller" );
}

waterThink_rampSpeed( newSpeed )
{
	level notify( "ramping_water_movement_speed" );
	level endon( "ramping_water_movement_speed" );
	
	rampTime = 0.5;
	numFrames = int( rampTime * 20 );
	
	currentSpeed = getdvarint( "g_speed" );
	
	qSlower = false;
	if( newSpeed < currentSpeed )
		qSlower = true;
	
	speedDifference = int( abs( currentSpeed - newSpeed ) );
	speedStepSize = int( speedDifference / numFrames );
	
	for( i = 0 ; i < numFrames ; i++ )
	{
		currentSpeed = getdvarint( "g_speed" );
		if( qSlower )
			setsaveddvar( "g_speed",( currentSpeed - speedStepSize ) );
		else
			setsaveddvar( "g_speed",( currentSpeed + speedStepSize ) );
		wait 0.05;
	}
	setsaveddvar( "g_speed", newSpeed );
}



massNodeInitFunctions()
{
	nodes = getallnodes();

	thread maps\_mgturret::auto_mgTurretLink( nodes );	
	thread maps\_mgturret::saw_mgTurretLink( nodes );	
	thread maps\_colors::init_color_grouping( nodes );
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
	if( isdefined( trigger.script_noteworthy ) )
		noteworthy = trigger.script_noteworthy;
		
	target_triggers = getentarray( trigger.target, "targetname" );

	trigger thread trigger_unlock_death( trigger.target );

	for( ;; )
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
	for( i=0; i<triggers.size; i++ )
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
	assertEx( isdefined( trigger.script_flag ) || isdefined( trigger.script_noteworthy ), "Trigger_lookat at " + trigger.origin + " has no script_flag! The script_flag is used as a flag that gets set when the trigger is activated." );
	flagName = trigger get_trigger_flag();
	if( !isdefined( level.flag[ flagName ] ) )
		flag_init( flagName );
	
	dot = 0.78;
	if( isdefined( trigger.script_dot ) )
	{
		dot = trigger.script_dot;
	}
		
	target_origin = trigger.origin;
	if( isdefined( trigger.target ) )
	{
		target = getent( trigger.target, "targetname" );
		target_origin = target.origin;
		target delete();
	}

	trigger endon( "death" );
	
	for( ;; )
	{
		flag_clear( flagName );
		trigger waittill( "trigger", other );
	
		assertEx( other == level.player, "trigger_lookat currently only supports looking from the player" );
		while( level.player istouching( trigger ) )
		{
			if( !sightTracePassed( other geteye(), target_origin, false, undefined ) )
			{
				wait( 0.5 );
				continue;
			}
				
			normal = vectorNormalize( target_origin - other.origin );
		    player_angles = level.player GetPlayerAngles();
		    player_forward = anglesToForward( player_angles );
	
	//		angles = vectorToAngles( target_origin - other.origin );
	//	    forward = anglesToForward( angles );
	//		draw_arrow( level.player.origin, level.player.origin + vectorscale( forward, 150 ),( 1,0.5,0 ) );
	//		draw_arrow( level.player.origin, level.player.origin + vectorscale( player_forward, 150 ),( 0,0.5,1 ) );
	
			dot = vectorDot( player_forward, normal );
			if( dot >= 0.78 )
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
	if( !isdefined( level.start_functions ) )
		level.start_functions = [];

	assertEx( getdvar( "jumpto" ) == "", "Use the START dvar instead of JUMPTO" );
	
	start = tolower( getdvar( "start" ) );

	
	// find the start that matches the one the dvar is set to, and execute it
	dvars = getArrayKeys( level.start_functions );
	
	if( start == "" )
	{
		string = " ** No starts setup for this map.";
		if( dvars.size )
		{
			string = " ** ";
			for( i=0; i < dvars.size; i++ )
			{
				string = string + dvars[ i ] + " ";
			}
		}
		
		setdvar( "start", string );
	}

	for( i=0; i < dvars.size; i++ )
	{
		if( start == dvars[ i ] )
		{
			level.start_point = dvars[ i ];
			thread [ [ level.start_functions[ dvars[ i ] ] ] ]();
			return;
		}
	}
	
	// If safe_start is set then it will load that start position only if its possible
	// so you can have a start set without affecting maps that don't have that start
	safe_start = tolower( getdvar( "safe_start" ) );
	for( i=0; i < dvars.size; i++ )
	{
		if( safe_start == dvars[ i ] )
		{
			level.start_point = dvars[ i ];
			thread [ [ level.start_functions[ dvars[ i ] ] ] ]();
			// move the safe_start to the start
			setdvar( "start", level.start_point );
			setdvar( "safe_start", "" );
			return;
		}
	}

	if( isdefined( level.default_start ) )
	{
		level.start_point = "default";
		thread [ [ level.default_start ] ]();
	}
	
	if( start != "" )
	{
		assertEx( issubstr( start, " ** " ), "Start " + start + " has not been added to the startlist for this map. Add it with the add_start _utility command." );
		return;
	}
	
	string = " ** No starts setup for this map.";
	if( dvars.size )
	{
		string = " ** ";
		for( i=0; i < dvars.size; i++ )
		{
			string = string + dvars[ i ] + " ";
		}
	}
	
	setdvar( "start", string );
	return;
#/

	level.start_point = "default";
	if( isdefined( level.default_start ) )
	{
		thread [ [ level.default_start ] ]();
	}

}


devhelp_hudElements( hudarray, alpha )
{
	for( i=0;i<hudarray.size;i++ )
		for( p=0;p<5;p++ )
			hudarray[ i ][ p ].alpha = alpha;

}

devhelp()
{
	/#
	helptext = [];
	helptext[ helptext.size ] ="P: pause                                                       ";
	helptext[ helptext.size ] ="T: super speed                                                 ";
	helptext[ helptext.size ] =".: fullbright                                                  ";
	helptext[ helptext.size ] ="U: toggle normal maps                                          ";
	helptext[ helptext.size ] ="Y: print a line of text, useful for putting it in a screenshot ";
	helptext[ helptext.size ] ="H: toggle detailed ent info                                    ";
	helptext[ helptext.size ] ="g: toggle simplified ent info                                  ";
	helptext[ helptext.size ] =",: show the triangle outlines                                  ";
	helptext[ helptext.size ] ="-: Back 10 seconds                                             ";
	helptext[ helptext.size ] ="6: Replay mark                                                 ";
	helptext[ helptext.size ] ="7: Replay goto                                                 ";
	helptext[ helptext.size ] ="8: Replay live                                                 ";
	helptext[ helptext.size ] ="0: Replay back 3 seconds                                       ";
	helptext[ helptext.size ] ="[ : Replay restart                                              ";
	helptext[ helptext.size ] ="\: map_restart                                                 ";
	helptext[ helptext.size ] ="U: draw material name                                          ";
	helptext[ helptext.size ] ="J: display tri counts                                          ";
	helptext[ helptext.size ] ="B: cg_ufo                                                      ";
	helptext[ helptext.size ] ="N: ufo                                                         ";
	helptext[ helptext.size ] ="C: god                                                         ";                                      
	helptext[ helptext.size ] ="K: Show ai nodes                                               ";                                      
	helptext[ helptext.size ] ="L: Show ai node connections                                    ";                                      
	helptext[ helptext.size ] ="Semicolon: Show ai pathing                                     ";                                      

	
	strOffsetX = [];
	strOffsetY = [];
	strOffsetX[ 0 ] = 0;
	strOffsetY[ 0 ] = 0;
	strOffsetX[ 1 ] = 1;
	strOffsetY[ 1 ] = 1;
	strOffsetX[ 2 ] = -2;
	strOffsetY[ 2 ] = 1;
	strOffsetX[ 3 ] = 1;
	strOffsetY[ 3 ] = -1;
	strOffsetX[ 4 ] = -2;
	strOffsetY[ 4 ] = -1;
	hudarray = [];
	for( i=0;i<helptext.size;i++ )
	{
		newStrArray = [];
		for( p=0;p<5;p++ )
		{
			// setup instructional text
			newStr = newHudElem();
			newStr.alignX = "left";
			newStr.location = 0;
			newStr.foreground = 1;
			newStr.fontScale = 1.30;
			newStr.sort = 20 - p;
			newStr.alpha = 1;
			newStr.x = 54 + strOffsetX[ p ];
			newStr.y = 80 + strOffsetY[ p ]+ i * 15;
			newstr settext( helptext[ i ] );
			if( p > 0 )
				newStr.color =( 0,0,0 );
			
			newStrArray[ newStrArray.size ] = newStr;
		}
		hudarray[ hudarray.size ] = newStrArray;
	}
	
	devhelp_hudElements( hudarray , 0 );

	while( 1 )
	{
		update = false;
		if( level.player buttonpressed( "F1" ) )
		{
				devhelp_hudElements( hudarray , 1 );
				while( level.player buttonpressed( "F1" ) )
					wait .05;
		}
		devhelp_hudElements( hudarray , 0 );
		wait .05;
	}
	#/
}


flag_set_player_trigger( trigger )
{
	flag = trigger get_trigger_flag();
	
	if( !isdefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
	
	for( ;; )
	{
		trigger waittill( "trigger", other );
		if( other != level.player )
			continue;
		flag_set( flag );
	}
}

flag_set_trigger( trigger )
{
	flag = trigger get_trigger_flag();
	
	if( !isdefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
	
	for( ;; )
	{
		trigger waittill( "trigger" );
		flag_set( flag );
	}
}

flag_unset_trigger( trigger )
{
	flag = trigger get_trigger_flag();
	
	if( !isdefined( level.flag[ flag ] ) )
		flag_init( flag );
	for( ;; )
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
	for( ;; )
	{
		trigger waittill( "trigger" );
		ai = getaiarray( "allies" );
		for( i=0; i < ai.size; i++ )
		{
			ai[ i ] [ [ level.set_eq_func[ ai[ i ] istouching( targ ) ] ] ]();
		}
		while( level.player istouching( trigger ) )
			wait( 0.05 );

		ai = getaiarray( "allies" );
		for( i=0; i < ai.size; i++ )
		{
			ai[ i ] [ [ level.set_eq_func[ false ] ] ]();
		}
	}
	/*
	num = level.eq_trigger_num;
	trigger.eq_num = num;
	level.eq_trigger_num++;
	waittillframeend; // let the ai get their eq_num table created
	waittillframeend; // let the ai get their eq_num table created
	level.eq_trigger_table[ num ] = [];
	if( isdefined( trigger.script_linkto ) )
	{
		tokens = strtok( trigger.script_linkto, " " );
		for( i=0; i < tokens.size; i++ )
		{
			target_trigger = getent( tokens[ i ], "script_linkname" );
			// add the trigger num to the list of triggers this trigger hears 
			level.eq_trigger_table[ num ][ level.eq_trigger_table[ num ].size ] = target_trigger.eq_num;		
		}
	}
	
	for( ;; )
	{
		trigger waittill( "trigger", other );
		
		// are we already registered with this trigger?
		if( other.eq_table[ num ] )
			continue;
			
		other thread [ [ level.touched_eq_function[ other.is_the_player ] ] ]( num, trigger );
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
	for( i=0; i < level.eq_trigger_table[ num ].size; i++ )
	{
		nums[ nums.size ] = level.eq_trigger_table[ num ][ i ];
	}
	return nums;
}


player_touched_eq_trigger( num, trigger )
{
	self endon( "death" );

	nums = get_trigger_eq_nums( num );	
	for( r=0; r < nums.size; r++ )
	{
		self.eq_table[ nums[ r ] ] = true;
		self.eq_touching[ nums[ r ] ] = true;
	}

	thread player_ignores_triggers();

	ai = getaiarray();
	for( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		// is the ai in this trigger with us?
		for( r=0; r < nums.size; r++ )
		{
			if( guy.eq_table[ nums[ r ] ] )
			{
				guy eqoff();
				break;
			}
		}
	}

	while( self istouching( trigger ) )
		wait( 0.05 );
		
	for( r=0; r < nums.size; r++ )
	{
		self.eq_table[ nums[ r ] ] = false;
		self.eq_touching[ nums[ r ] ] = undefined;
	}
	
	ai = getaiarray();
	for( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];

		was_in_our_trigger = false;
		// is the ai in the trigger we just left?
		for( r=0; r < nums.size; r++ )
		{
			// was the guy in a trigger we could hear into?
			if( guy.eq_table[ nums[ r ] ] )
			{
				was_in_our_trigger = true;
			}
		}
		
		if( !was_in_our_trigger )
			continue;

		// check to see if the guy is in any of the triggers we're still in
	
		touching = getarraykeys( self.eq_touching );
		shares_trigger = false;
		for( p=0; p < touching.size; p++ )
		{
			if( !guy.eq_table[ touching[ p ] ] )
				continue;
				
			shares_trigger = true;
			break;
		}
		
		// if he's not in a trigger with us, turn his eq back on
		if( !shares_trigger )
			guy eqOn();
	}
}

ai_touched_eq_trigger( num, trigger )
{
	self endon( "death" );

	nums = get_trigger_eq_nums( num );	
	for( r=0; r < nums.size; r++ )
	{
		self.eq_table[ nums[ r ] ] = true;
		self.eq_touching[ nums[ r ] ] = true;
	}

	// are we in the same trigger as the player?
	for( r=0; r < nums.size; r++ )
	{
		if( level.player.eq_table[ nums[ r ] ] )
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
	for( r=0; r < nums.size; r++ )
	{
		self.eq_table[ nums[ r ] ] = false;
		self.eq_touching[ nums[ r ] ] = undefined;
	}
		
	touching = getarraykeys( self.eq_touching );
	for( i=0; i < touching.size; i++ )
	{
		// is the player in a trigger that we're still in?
		if( level.player.eq_table[ touching[ i ] ] )
		{
			// then don't turn eq back on
			return;
		}
	}

	self eqon();
}

ai_eq()
{
	level.set_eq_func[ false ] = ::set_eq_on;
	level.set_eq_func[ true ] = ::set_eq_off;
	index = 0;
	for( ;; )
	{
		while( !level.ai_array.size )
		{
			wait( 0.05 );
		}
		waittillframeend;
		waittillframeend;
		keys = getarraykeys( level.ai_array );
		index++;
		if( index >= keys.size )
			index = 0;
		guy = level.ai_array[ keys[ index ] ];
		guy [ [ level.set_eq_func[ sighttracepassed( level.player geteye(), guy geteye(), false, undefined ) ] ] ]();
		wait( 0.05 );
	}
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
	for( i=0; i < tokens.size; i++ )
	{
		if( !isdefined( level.flag[ tokens[ i ] ] ) )
		{
			flag_init( tokens[ i ] );
		}
	}
	
	return tokens;
}

set_trigger_flag_permissions( msg )
{
	// turns triggers on or off depending on if they have the proper flags set, based on their shift-g menu settings

	// this can be init before _load has run, thanks to AI.
	if( !isdefined( level.trigger_flags ) )
		return;

	// cheaper to do the upkeep at this time rather than with endons and waittills on the individual triggers	
	level.trigger_flags[ msg ] = remove_undefined_from_array( level.trigger_flags[ msg ] );
	array_thread( level.trigger_flags[ msg ], ::update_trigger_based_on_flags );
}

add_tokens_to_trigger_flags( tokens )
{
	for( i=0; i < tokens.size; i++ )
	{
		flag = tokens[ i ];
		if( !isdefined( level.trigger_flags[ flag ] ) )
		{
			level.trigger_flags[ flag ] = [];
		}
		
		level.trigger_flags[ flag ][ level.trigger_flags[ flag ].size ] = self;
	}
}

script_flag_false_trigger( trigger )
{
	// all of these flags must be false for the trigger to be enabled
	tokens = create_flags_and_return_tokens( trigger.script_flag_false );
	trigger add_tokens_to_trigger_flags( tokens );
	trigger update_trigger_based_on_flags();
}

script_flag_true_trigger( trigger )
{
	// all of these flags must be false for the trigger to be enabled
	tokens = create_flags_and_return_tokens( trigger.script_flag_true );
	trigger add_tokens_to_trigger_flags( tokens );
	trigger update_trigger_based_on_flags();
}

update_trigger_based_on_flags()
{
	true_on = true;
	if( isdefined( self.script_flag_true ) )
	{
		true_on = false;
		tokens = create_flags_and_return_tokens( self.script_flag_true );
		
		// stay off unless all the flags are false
		for( i=0; i < tokens.size; i++ )
		{
			if( flag( tokens[ i ] ) )
			{
				true_on = true;
				break;
			}
		}	
	}
	
	false_on = true;
	if( isdefined( self.script_flag_false ) )
	{
		tokens = create_flags_and_return_tokens( self.script_flag_false );
		
		// stay off unless all the flags are false
		for( i=0; i < tokens.size; i++ )
		{
			if( flag( tokens[ i ] ) )
			{
				false_on = false;
				break;
			}
		}	
	}
	
	[ [ level.trigger_func[ true_on && false_on ] ] ]();
}

	

/*
	for( ;; )
	{
		trigger trigger_on();
		wait_for_flag( tokens );
		
		trigger trigger_off();
		wait_for_flag( tokens );
		for( i=0; i < tokens.size; i++ )
		{
			flag_wait( tokens[ i ] );
		}		
	}
	*/


/*
script_flag_true_trigger( trigger )
{
	// any of these flags have to be true for the trigger to be enabled
	tokens = create_flags_and_return_tokens( trigger.script_flag_true );

	for( ;; )
	{
		trigger trigger_off();
		wait_for_flag( tokens );
		trigger trigger_on();
		for( i=0; i < tokens.size; i++ )
		{
			flag_waitopen( tokens[ i ] );
		}		
	}
}
*/

wait_for_flag( tokens )
{
	for( i=0; i < tokens.size; i++ )
	{
		level endon( tokens[ i ] );
	}
	level waittill( "foreverrr" );
}

friendly_respawn_trigger( trigger )
{
	spawners = getentarray( trigger.target, "targetname" );
	assertEx( spawners.size == 1, "friendly_respawn_trigger targets multiple spawner with targetname " + trigger.target + ". Should target just 1 spawner." );
	spawner = spawners[ 0 ];
	spawners = undefined;
	
	spawner endon( "death" );
	
	for( ;; )
	{
		trigger waittill( "trigger" );
		level.respawn_spawner = spawner;
		flag_set( "respawn_friendlies" );
		wait( 0.5 );
	}
}

friendly_respawn_clear( trigger )
{
	for( ;; )
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

background_block()
{
		assert( isdefined( self.script_bg_offset ) );
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
	for( ;; )
	{
		trigger waittill( "trigger", other );
		if( !isalive( other ) )
			continue;
		if( other [ [ get_func ] ]() )
			continue;
		other thread touched_trigger_runs_func( trigger, set_func );
	}
}

touched_trigger_runs_func( trigger, set_func )
{
	self endon( "death" );
	self.ignoreme = true;
	[ [ set_func ] ]( true );
	// so others can touch the trigger
	self.ignoretriggers = true;	
	wait( 1 );
	self.ignoretriggers = false;
	
	while( self istouching( trigger ) )
	{
		wait( 1 );
	}
	
	[ [ set_func ] ]( false );
}

trigger_turns_off( trigger )
{
	trigger waittill( "trigger" );
	trigger trigger_off();
	
	if( !isdefined( trigger.script_linkTo ) )
		return;
	
	// also turn off all triggers this trigger links to
	tokens = strtok( trigger.script_linkto, " " );
	for( i=0; i < tokens.size; i++ )
		array_thread( getentarray( tokens[ i ], "script_linkname" ), ::trigger_off );
}



script_gen_dump_checksaved()
{
	signatures = getarraykeys( level.script_gen_dump );
	for( i=0;i<signatures.size;i++ )
		if( !isdefined( level.script_gen_dump2[ signatures[ i ] ] ) )
		{
			level.script_gen_dump[ signatures[ i ] ] = undefined;
			level.script_gen_dump_reasons[ level.script_gen_dump_reasons.size ] = "Signature unmatched( removed feature ): "+signatures[ i ];
			
		}
}

script_gen_dump()
{
	//initialize scriptgen dump
	/#

	script_gen_dump_checksaved(); // this checks saved against fresh, if there is no matching saved value then something has changed and the dump needs to happen again.
	
	if( !level.script_gen_dump_reasons.size )
	{
		flag_set( "scriptgen_done" );
		return; // there's no reason to dump the file so exit
	}
	
	firstrun = false;
	if( level.bScriptgened )
	{
		println( " " );
		println( " " );
		println( " " );
		println( "^2----------------------------------------" );
		println( "^3Dumping scriptgen dump for these reasons" );
		println( "^2----------------------------------------" );
		for( i=0;i<level.script_gen_dump_reasons.size;i++ )		
		{
			if( issubstr( level.script_gen_dump_reasons[ i ],"nowrite" ) )
			{
				substr = getsubstr( level.script_gen_dump_reasons[ i ],15 ); // I don't know why it's 15, maybe investigate -nate
				println( i+". ) "+substr );
				
			}
			else
				println( i+". ) "+level.script_gen_dump_reasons[ i ] );
			if( level.script_gen_dump_reasons[ i ] == "First run" )
				firstrun = true;
		}
		println( "^2----------------------------------------" );
		println( " " );
		if( firstrun )
		{
			println( "for First Run make sure you delete all of the vehicle precache script calls, createart calls, createfx calls( most commonly placed in maps\\"+level.script+"_fx.gsc ) " );
			println( " " );
			println( "replace:" );
			println( "maps\\\_load::main( 1 );" );
			println( " " );
			println( "with( don't forget to add this file to P4 ):" );
			println( "maps\\scriptgen\\"+level.script+"_scriptgen::main();" );
			println( " " );
		}
//		println( "make sure this is in your "+level.script+".csv:" );
//		println( "rawfile,maps/scriptgen/"+level.script+"_scriptgen.gsc" );
		println( "^2----------------------------------------" );
		println( " " );
		println( "^2/\\/\\/\\" );
		println( "^2scroll up" );
		println( "^2/\\/\\/\\" );
		println( " " );
	}
	else
	{
/*		println( " " );
		println( " " );
		println( "^3for legacy purposes I'm printing the would be script here, you can copy this stuff if you'd like to remain a dinosaur:" );
		println( "^3otherwise, you should add this to your script:" );
		println( "^3maps\\\_load::main( 1 );" );
		println( " " );
		println( "^3rebuild the fast file and the follow the assert instructions" );
		println( " " );
		
		*/
		return;
	}
	
	filename = "scriptgen/"+level.script+"_scriptgen.gsc";
	csvfilename = "zone_source/"+level.script+".csv";
	
	if( level.bScriptgened )
		file = openfile( filename,"write" );
	else
		file = 0;

	assertex( file != -1, "File not writeable( check it and and restart the map ): " + filename );

	script_gen_dumpprintln( file,"//script generated script do not write your own script here it will go away if you do." );
	script_gen_dumpprintln( file,"main()" );
	script_gen_dumpprintln( file,"{" );
	script_gen_dumpprintln( file,"" );
	script_gen_dumpprintln( file,"\tlevel.script_gen_dump = [];" );
	script_gen_dumpprintln( file,"" );

	signatures = getarraykeys( level.script_gen_dump );
	for( i=0;i<signatures.size;i++ )
		if( !issubstr( level.script_gen_dump[ signatures[ i ] ], "nowrite" ) )
			script_gen_dumpprintln( file,"\t"+level.script_gen_dump[ signatures[ i ] ] );

	for( i=0;i<signatures.size;i++ )
		if( !issubstr( level.script_gen_dump[ signatures[ i ] ],"nowrite" ) )
			script_gen_dumpprintln( file,"\tlevel.script_gen_dump[ "+"\""+signatures[ i ]+"\""+" ] = "+"\""+signatures[ i ]+"\""+";" );
		else
			script_gen_dumpprintln( file,"\tlevel.script_gen_dump[ "+"\""+signatures[ i ]+"\""+" ] = "+"\"nowrite\""+";" );

	script_gen_dumpprintln( file,"" );
	
	keys1 = undefined;
	keys2 = undefined;
	// special animation threading to capture animtrees
	if( isdefined( level.sg_precacheanims ) )
		keys1 = getarraykeys( level.sg_precacheanims );
	if( isdefined( keys1 ) )
		for( i=0;i<keys1.size;i++ )
			script_gen_dumpprintln( file,"\tanim_precach_"+keys1[ i ]+"();" );

	
	script_gen_dumpprintln( file,"\tmaps\\\_load::main( 1,"+level.bCSVgened+",1 );" );
	script_gen_dumpprintln( file,"}" );
	script_gen_dumpprintln( file,"" );
	
	/// animations section
	
//	level.sg_precacheanims[ animtree ][ animation ]
	if( isdefined( level.sg_precacheanims ) )
		keys1 = getarraykeys( level.sg_precacheanims );
	if( isdefined( keys1 ) )
	for( i=0;i<keys1.size;i++ )
	{
		//first key being the animtree
		script_gen_dumpprintln( file,"#using_animtree( \""+keys1[ i ]+"\" );" );
		script_gen_dumpprintln( file,"anim_precach_"+keys1[ i ]+"()" );  // adds to scriptgendump
		script_gen_dumpprintln( file,"{" );
		script_gen_dumpprintln( file,"\tlevel.sg_animtree[ \""+keys1[ i ]+"\" ] = #animtree;" );  // adds to scriptgendump get the animtree without having to put #using animtree everywhere.

		keys2 = getarraykeys( level.sg_precacheanims[ keys1[ i ] ] );
		if( isdefined( keys2 ) )
		for( j=0;j<keys2.size;j++ )
		{
			script_gen_dumpprintln( file,"\tlevel.sg_anim[ \""+keys2[ j ]+"\" ] = %"+keys2[ j ]+";" );  // adds to scriptgendump
		
		}
		script_gen_dumpprintln( file,"}" );
		script_gen_dumpprintln( file,"" );
	}
	
	
	if( level.bScriptgened )
		saved = closefile( file );
	else
		saved = 1;  //dodging save for legacy levels
	
	//CSV section	
		
	if( level.bCSVgened )
		csvfile = openfile( csvfilename,"write" );
	else
		csvfile = 0;
	
	assertex( csvfile != -1, "File not writeable( check it and and restart the map ): " + csvfilename );
	
	signatures = getarraykeys( level.script_gen_dump );
	for( i=0;i<signatures.size;i++ )
		script_gen_csvdumpprintln( csvfile,signatures[ i ] );

	if( level.bCSVgened )
		csvfilesaved = closefile( csvfile );
	else
		csvfilesaved = 1; //dodging for now

	// check saves
		
	assertex( csvfilesaved == 1,"csv not saved( see above message? ): " + csvfilename );
	assertex( saved == 1,"map not saved( see above message? ): " + filename );

	#/
	
	//level.bScriptgened is not set on non scriptgen powered maps, keep from breaking everything
	assertex( !level.bScriptgened,"SCRIPTGEN generated: follow instructions listed above this error in the console" );
	if( level.bScriptgened )
		assertmsg( "SCRIPTGEN updated: Rebuild fast file and run map again" );
		
	flag_set( "scriptgen_done" );
	
}


script_gen_csvdumpprintln( file,signature )
{
	
	prefix = undefined;
	writtenprefix = undefined;
	path = "";
	extension = "";
	
	
	if( issubstr( signature,"ignore" ) )
		prefix = "ignore";
	else
	if( issubstr( signature,"col_map_sp" ) )
		prefix = "col_map_sp";
	else
	if( issubstr( signature,"gfx_map" ) )
		prefix = "gfx_map";
	else
	if( issubstr( signature,"rawfile" ) )
		prefix = "rawfile";
	else
	if( issubstr( signature,"sound" ) )
		prefix = "sound";
	else
	if( issubstr( signature,"xmodel" ) )
		prefix = "xmodel";
	else
	if( issubstr( signature,"xanim" ) )
		prefix = "xanim";
	else
	if( issubstr( signature,"item" ) )
	{
		prefix = "item";
		writtenprefix = "weapon";
		path = "sp/";
	}
	else
	if( issubstr( signature,"fx" ) )
	{
		prefix = "fx";
	}
	else
	if( issubstr( signature,"menu" ) )
	{
		prefix = "menu";
		writtenprefix = "menufile";
		path = "ui/scriptmenus/";
		extension = ".menu";
	}
	else
	if( issubstr( signature,"rumble" ) )
	{
		prefix = "rumble";
		writtenprefix = "rawfile";
		path = "rumble/";
	}
	else
	if( issubstr( signature,"shader" ) )
	{
		prefix = "shader";
		writtenprefix = "material";
	}
	else
	if( issubstr( signature,"shock" ) )
	{
		prefix = "shock";
		writtenprefix = "rawfile";
		extension = ".shock";
		path = "shock/";
	}
	else
	if( issubstr( signature,"string" ) )
	{
		prefix = "string";
		assertmsg( "string not yet supported by scriptgen" );  // I can't find any instances of string files in a csv, don't think we've enabled localization yet
	}
	else
	if( issubstr( signature,"turret" ) )
	{
		prefix = "turret";
		writtenprefix = "weapon";
		path = "sp/";
	}
	else
	if( issubstr( signature,"vehicle" ) )
	{
		prefix = "vehicle";
		writtenprefix = "rawfile";
		path = "vehicles/";
	}
	
	
/*		
sg_precachevehicle( vehicle )
*/

		
	if( !isdefined( prefix ) )
		return;
	if( !isdefined( writtenprefix ) )
		string = prefix+","+getsubstr( signature,prefix.size+1,signature.size );
	else
		string = writtenprefix+","+path+getsubstr( signature,prefix.size+1,signature.size )+extension;

	
	/*		
	ignore,code_post_gfx
	ignore,common
	col_map_sp,maps/nate_test.d3dbsp
	gfx_map,maps/nate_test.d3dbsp
	rawfile,maps/nate_test.gsc
	sound,voiceovers,rallypoint,all_sp
	sound,us_battlechatter,rallypoint,all_sp
	sound,ab_battlechatter,rallypoint,all_sp
	sound,common,rallypoint,all_sp
	sound,generic,rallypoint,all_sp
	sound,requests,rallypoint,all_sp	
*/

	// printing to file is optional	
	if( file == -1 || !level.bCSVgened )
		println( string );
	else
		fprintln( file,string );
}

script_gen_dumpprintln( file,string )
{
	// printing to file is optional
	if( file == -1 || !level.bScriptgened )
		println( string );
	else
		fprintln( file,string );
}

trigger_hint( trigger )
{
	assertEx( isdefined( trigger.script_hint ), "Trigger_hint at " + trigger.origin + " has no .script_hint" );
	
	// give level script a chance to set the hint string and optional boolean functions on this hint
	waittillframeend;
	assertEx( isdefined( level.trigger_hint_string[ trigger.script_hint ] ), "Trigger_hint with hint " + trigger.script_hint + " had no hint string assigned to it. Define hint strings with add_hint_string()" );
	trigger waittill( "trigger", other );
	assertEx( other == level.player, "Tried to do a trigger_hint on a non player entity" );
	
	// hint triggers have an optional function they can boolean off of to determine if the hint will occur
	// such as not doing the NVG hint if the player is using NVGs already
	if( isdefined( level.trigger_hint_func[ trigger.script_hint ] ) )
	{
		if( ![ [ level.trigger_hint_func[ trigger.script_hint ] ] ]() )
			return;
	}
	
	iprintlnbold( level.trigger_hint_string[ trigger.script_hint ] );
}

stun_test()
{
	
	if( getDvar( "stuntime" ) == "" )
		setDvar( "stuntime", "1" );
	level.player.allowads = true;


	for( ;; )
	{
		self waittill( "damage" );
		if( getDvarint( "stuntime" ) == 0 )
			continue;
		
		thread stun_player( self playerADS() );			
	}
}

stun_player( ADS_fraction )
{
	self notify( "stun_player" );
	self endon( "stun_player" );
	
	if( ADS_fraction > .3 )
	{
		if( level.player.allowads == true )
			level.player playsound( "player_hit_while_ads" );
			
		level.player.allowads = false;
		level.player allowads( false );
	}
	level.player setspreadoverride( 20 );
	
	wait( getDvarint( "stuntime" ) );
	
	level.player allowads( true );
	level.player.allowads = true;
	level.player resetspreadoverride();
}

throw_grenade_at_player_trigger( trigger )
{
	trigger endon( "death" );
	
	trigger waittill( "trigger" );

	ThrowGrenadeAtPlayerASAP();
}

flag_on_cleared( trigger )
{
	flag = trigger get_trigger_flag();
	
	if( !isdefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
	
	for( ;; )
	{
		trigger waittill( "trigger" );
		wait( 1 );
		if( trigger found_toucher() )
		{
			continue;
		}

		break;
	}
	
	flag_set( flag );
}

found_toucher()
{			
	ai = getaiarray( "axis" );
	for( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if( !isalive( guy ) )
		{
			continue;
		}
			
		if( guy istouching( self ) )
		{
			return true;
		}

		// spread the touches out over time
		wait( 0.1 );
	}
	
	// couldnt find any touchers so do a single frame complete check just to make sure
	
	ai = getaiarray( "axis" );
	for( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if( guy istouching( self ) )
		{
			return true;
		}
	}
	
	return false;
}

trigger_delete_on_touch( trigger )
{
	for( ;; )
	{
		trigger waittill( "trigger", other );
		if( isdefined( other ) )
		{
			// might've been removed before we got it
			other delete();
		}
	}
}


flag_set_touching( trigger )
{
	flag = trigger get_trigger_flag();
	
	if( !isdefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
	
	for( ;; )
	{
		trigger waittill( "trigger", other );
		flag_set( flag );
		while( isalive( other ) && other istouching( trigger ) && isdefined( trigger ) )
		{
			wait( 0.25 );
		}
		flag_clear( flag );
	}
}


init_trigger_flags()
{
	level.trigger_flags = [];
	level.trigger_func[ true ] = ::trigger_on;
	level.trigger_func[ false ] = ::trigger_off;
}
