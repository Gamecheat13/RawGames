#include common_scripts\utility;
#include maps\_utility;
//#include maps\_debug;
#include maps\_hud_util;
#include maps\_load_common;

#insert raw\common_scripts\utility.gsh;

#using_animtree("generic_human");

main( bScriptgened,bCSVgened,bsgenabled )
{
	init_session_mode_flags();

	init_client_flags();

	println( "_LOAD START TIME = " + GetTime() );

	register_overloaded_func( "maps\_stealth_logic", "stealth_ai", maps\_stealth_logic::stealth_ai );

	register_overloaded_func( "animscripts\traverse\shared", "init_traverse", animscripts\traverse\shared::init_traverse );

	register_overloaded_func( "animscripts\shoot_behavior", "decideWhatAndHowToShoot", animscripts\shoot_behavior::decideWhatAndHowToShoot );
	register_overloaded_func( "animscripts\shoot_behavior", "setShootEnt", animscripts\shoot_behavior::setShootEnt );

	register_overloaded_func( "animscripts\rush", "sideStepInit", animscripts\rush::sideStepInit );
	register_overloaded_func( "animscripts\rush", "trySideStep", animscripts\rush::trySideStep );

	register_overloaded_func( "animscripts\run", "GetCrouchRunAnim", animscripts\run::GetCrouchRunAnim );
	register_overloaded_func( "animscripts\run", "ShouldShootWhileRunningBackward", animscripts\run::ShouldShootWhileRunningBackward );
	register_overloaded_func( "animscripts\run", "ShouldTacticalWalk", animscripts\run::ShouldTacticalWalk );
	register_overloaded_func( "animscripts\run", "ShouldFaceMotionWhileRunning", animscripts\run::ShouldFaceMotionWhileRunning );
	register_overloaded_func( "animscripts\run", "UpdateRunWeightsOnce", animscripts\run::UpdateRunWeightsOnce );
	register_overloaded_func( "animscripts\run", "UpdateRunWeights", animscripts\run::UpdateRunWeights );
	
	register_overloaded_func( "maps\_rusher", "rush", maps\_rusher::rush );

	register_overloaded_func( "animscripts\react", "shouldReact", animscripts\react::shouldReact );

	register_overloaded_func( "animscripts\pain", "wasDamagedByExplosive", animscripts\pain::wasDamagedByExplosive );
	register_overloaded_func( "animscripts\pain", "removeBlockedAnims", animscripts\pain::removeBlockedAnims );
	register_overloaded_func( "animscripts\pain", "additive_pain_think", animscripts\pain::additive_pain_think );
	register_overloaded_func( "animscripts\pain", "isExplosiveDamageMOD", animscripts\pain::isExplosiveDamageMOD );

	register_overloaded_func( "animscripts\move", "MayShootWhileMoving", animscripts\move::MayShootWhileMoving );

	register_overloaded_func( "animscripts\init", "initWeapon", animscripts\init::initWeapon );
	register_overloaded_func( "animscripts\init", "set_anim_playback_rate", animscripts\init::set_anim_playback_rate );
	register_overloaded_func( "animscripts\init", "infiniteLoop", animscripts\init::infiniteLoop );

	register_overloaded_func( "animscripts\first_frame", "main", animscripts\first_frame::main );

	register_overloaded_func( "animscripts\death", "PlayDeathSound", animscripts\death::PlayDeathSound );
	register_overloaded_func( "animscripts\death", "helmetLaunch", animscripts\death::helmetLaunch );
	register_overloaded_func( "animscripts\death", "precache_gib_fx", animscripts\death::precache_gib_fx );
	register_overloaded_func( "animscripts\death", "isValidGibRef", animscripts\death::isValidGibRef );

	register_overloaded_func( "animscripts\cqb", "shouldCQB", animscripts\cqb::shouldCQB );
	register_overloaded_func( "animscripts\cqb", "findCQBPointsOfInterest", animscripts\cqb::findCQBPointsOfInterest );
	/#register_overloaded_func( "animscripts\cqb", "CQBDebug", animscripts\cqb::CQBDebug );#/

	register_overloaded_func( "animscripts\cover_corner", "canSeePointFromExposedAtCorner", animscripts\cover_corner::canSeePointFromExposedAtCorner );

	register_overloaded_func( "animscripts\cover_wall", "useSelfPlacedTurret", animscripts\cover_wall::useSelfPlacedTurret );
	register_overloaded_func( "animscripts\cover_wall", "useStationaryTurret", animscripts\cover_wall::useStationaryTurret );

	register_overloaded_func( "animscripts\cover_prone", "UpdateProneWrapper", animscripts\cover_prone::UpdateProneWrapper );

	register_overloaded_func( "animscripts\cover_arrival", "startMoveTransition", animscripts\cover_arrival::startMoveTransition );
	register_overloaded_func( "animscripts\cover_arrival", "setupApproachNode", animscripts\cover_arrival::setupApproachNode );

	register_overloaded_func( "animscripts\combat", "main", animscripts\combat::main );
	
	register_overloaded_func( "animscripts\balcony", "balconyDamage", animscripts\balcony::balconyDamage );

	register_overloaded_func( "animscripts\animmode", "main", animscripts\animmode::main );
	
	set_early_level(); 
		
	animscripts\weaponList::precacheWeaponSwitchFx();
	// AI revive feature - turned on by default in any level.
	if(!IsDefined(level.reviveFeature))
		level.reviveFeature = false;

	maps\_constants::main();
	
	// Setup animations for doing hand signals with the _utility function 
	level.scr_anim[ "generic" ][ "signal_onme" ]	= %CQB_stand_wave_on_me;
	level.scr_anim[ "generic" ][ "signal_go" ]		= %CQB_stand_wave_go_v1;
	level.scr_anim[ "generic" ][ "signal_stop" ]	= %CQB_stand_signal_stop;
	level.scr_anim[ "generic" ][ "signal_moveup" ]	= %CQB_stand_signal_move_up;
	level.scr_anim[ "generic" ][ "signal_moveout" ]	= %CQB_stand_signal_move_out;

	if( !IsDefined( level.script_gen_dump_reasons ) )
	{
		level.script_gen_dump_reasons = []; 
	}
	if( !IsDefined( bsgenabled ) )
	{
		level.script_gen_dump_reasons[level.script_gen_dump_reasons.size] = "First run"; 
	}
	if( !IsDefined( bCSVgened ) )
	{
		bCSVgened = false; 
	}
	level.bCSVgened = bCSVgened; 
	
	if( !IsDefined( bScriptgened ) )
	{
		bScriptgened = false; 
	}
	else
	{
		bScriptgened = true; 
	}
	level.bScriptgened = bScriptgened; 

	/#
	ascii_logo();
	#/
	
	if( GetDvar( "debug" ) == "" )
	{
		SetDvar( "debug", "0" ); 
	}

	if( GetDvar( "fallback" ) == "" )
	{
		SetDvar( "fallback", "0" ); 
	}

	if( GetDvar( "angles" ) == "" )
	{
		SetDvar( "angles", "0" ); 
	}

	if( GetDvar( "noai" ) == "" )
	{
		SetDvar( "noai", "off" ); 
	}

	if( GetDvar( "scr_RequiredMapAspectratio" ) == "" )
	{
		SetDvar( "scr_RequiredMapAspectratio", "1" ); 
	}
		
	CreatePrintChannel( "script_debug" ); 

	if( !IsDefined( anim.notetracks ) )
	{
		// string based array for notetracks
		anim.notetracks = []; 
		animscripts\shared::registerNoteTracks(); 
	}

	if( !IsDefined( anim.balcony_nodes ) )
	{
		animscripts\init::balcony_init(); 
	}
	
		// TFLAME - 3/22/11 - This skipto is added automatically and must be added before the next line
	add_skipto( "no_game", maps\_skipto::skipto_nogame );
	
	level._loadStarted = true; 
	level.first_frame = true; 
	level.level_specific_dof = false; 
	
	// CODER_MOD
	// DSL - 05/21/08 - Set to true when all players have connected to the game.
	//level._players_connected = false;
	flag_init( "all_players_connected" );
	flag_init( "level.player" );
	flag_init( "all_players_spawned" );
	flag_init( "drop_breadcrumbs");
	flag_set( "drop_breadcrumbs" );
	
	thread remove_level_first_frame(); 

	level.wait_any_func_array = []; 
	level.run_func_after_wait_array = []; 
	level.do_wait_endons_array = []; 
	
	level.script = Tolower( GetDvar( "mapname" ) ); 
	level.radiation_totalpercent = 0; 

	level.clientscripts = ( GetDvar( "cg_usingClientScripts" ) != "" );; 

	level._client_exploders = [];
	level._client_exploder_ids = [];

	registerClientSys( "levelNotify" ); 
	registerClientSys( "lsm" );
	
	flag_init( "missionfailed" ); 
	flag_init( "auto_adjust_initialized" ); 
	flag_init( "global_hint_in_use" ); 
	
	level.default_run_speed = 190; 
	SetSavedDvar( "g_speed", level.default_run_speed ); 
	
	SetDvar( "ui_deadquote", "" );
	
	//maps\_gamemode::setup();
	
	SetSavedDvar( "sv_saveOnStartMap", maps\_gamemode::shouldSaveOnStartup() ); 
	if( arcadeMode() )
	{
		// MikeD( 12/15/2007 ): This only seems be setup for the Credits level of CoD4.
		thread arcademode_save(); 
	}

	level thread maps\_vehicle::init_vehicles();
	level thread maps\_perks_sp::perks_preload();
	
	level.dronestruct = []; 
	struct_class_init(); 

	if( !IsDefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
	}
	else
	{
		// flags initialized before this should be checked for stat tracking
		flags = GetArrayKeys( level.flag );
		level array_ent_thread( flags, ::check_flag_for_stat_tracking );
	}
	
	// can be turned on and off to control friendly_respawn_trigger
	flag_init( "respawn_friendlies" );
	flag_init( "player_flashed" );

	// for script gen
	flag_init( "scriptgen_done" );
	level.script_gen_dump_reasons = [];
	if( !IsDefined( level.script_gen_dump ) )
	{
		level.script_gen_dump = [];
		level.script_gen_dump_reasons[0] = "First run";
	}

	if( !IsDefined( level.script_gen_dump2 ) )
	{
		level.script_gen_dump2 = []; 
	}
		
	if( IsDefined( level.createFXent ) )
	{
		script_gen_dump_addline( "maps\\createfx\\"+level.script+"_fx::main(); ", level.script+"_fx" );  // adds to scriptgendump
	}

	if( IsDefined( level.script_gen_dump_preload ) )
	{
		for( i = 0; i < level.script_gen_dump_preload.size; i++ )
		{
			script_gen_dump_addline( level.script_gen_dump_preload[i].string, level.script_gen_dump_preload[i].signature ); 
		}
	}

//	level.aim_delay_off = false; 
//	level.last_wait_spread = -1; 
	level.last_mission_sound_time = -5000; 

	// MikeD( 9/4/2007 ): These 2 arrays are needed for _colors.
	level.hero_list = []; 
	level.ai_array = []; 
	thread precache_script_models(); 
	
	// SCRIPT_MOD
	// these are head icons so you can see who the players are
	PrecacheHeadIcon( "headicon_american" ); 

/#
	PrecacheModel( "fx" ); 
//	PrecacheModel( "temp" ); 
#/	
	PrecacheModel( "tag_origin" ); 
	PrecacheModel( "tag_origin_animate" ); 
	PrecacheShellShock( "level_end" ); 
	PrecacheShellShock( "default" ); 
	PrecacheShellShock( "flashbang" ); 
	PrecacheShellShock( "dog_bite" ); 
	PrecacheShellShock( "pain" ); 
	PrecacheRumble( "damage_heavy" ); 
	precacherumble( "dtp_rumble" );
	precacherumble( "slide_rumble" );
	PrecacheRumble( "damage_light" ); 
	PrecacheRumble( "grenade_rumble" ); 
	PrecacheRumble( "artillery_rumble" ); 
	PrecacheRumble( "reload_small" ); 
	PrecacheRumble( "reload_medium" ); 
	PrecacheRumble( "reload_large" ); 
	PrecacheRumble( "reload_clipin" ); 
	PrecacheRumble( "reload_clipout" ); 
	PrecacheRumble( "reload_rechamber" ); 
	PrecacheRumble( "pullout_small" ); 
	
	// knife model and effect used by aivsai melee
	precacheModel( "weapon_parabolic_knife" );
	level._effect[ "impacts/flesh_hit_knife" ] = loadfx( "impacts/flesh_hit_knife" );
	
	PrecacheString( &"GAME_GET_TO_COVER" ); 
	PrecacheString( &"SCRIPT_GRENADE_DEATH" ); 
	PrecacheString( &"SCRIPT_GRENADE_SUICIDE_LINE1" ); 
	PrecacheString( &"SCRIPT_GRENADE_SUICIDE_LINE2" ); 
	PrecacheString( &"SCRIPT_EXPLODING_VEHICLE_DEATH" ); 
	PrecacheString( &"SCRIPT_EXPLODING_BARREL_DEATH" ); 
	PrecacheString( &"STARTS_AVAILABLE_STARTS" ); 
	PrecacheString( &"STARTS_CANCEL" );  
	PrecacheString( &"STARTS_DEFAULT" ); 
	if ( !GameModeIsMode( level.GAMEMODE_ZOMBIES ) )
	{
		PreCacheShader( "overlay_low_health_splat" );
	}
	PrecacheShader( "overlay_low_health" ); 
//	PrecacheShader( "overlay_low_health_compass" ); 
	PrecacheShader( "hud_grenadeicon" ); 
	PrecacheShader( "hud_grenadepointer" );
	PrecacheShader( "hud_explosive_arrow_icon" );
	PrecacheShader( "black" );
	PrecacheShader( "white" );

	PreCacheShellShock( "death" );
	PreCacheShellShock( "explosion" );
	PreCacheShellShock( "tank_mantle" );
	
	// If gamemode calls for it, precache optional assets here.
	if(isdefined(level._gamemode_precache))
	{
		[[level._gamemode_precache]]();
	}
	
	//BJOYAL(7/12/11):  Added init call for _fxanim - added before createfx starts
	level thread maps\_fxanim::fxanim_init();

	level.createFX_enabled = ( GetDvar( "createfx" ) != "" ); 

	maps\_cheat::init();

	setupExploders();
	maps\_art::main();
	
	maps\_anim::init();
	
	maps\_damagefeedback::precache();

	thread maps\_createfx::fx_init(); 
	if( level.createFX_enabled )
	{
		maps\_callbackglobal::init(); 
		maps\_callbacksetup::SetupCallbacks();
		calculate_map_center(); 
		
		maps\_loadout::init_loadout(); // MikeD: Just to set the level.campaign		

		level thread all_players_connected();
		level thread all_players_spawned();
		thread maps\_introscreen::main();
		
		/#
		level thread level_notify_listener();
		level thread client_notify_listener();
		#/
		
		if ( IsDefined( level.createfx_callback_thread ) )
		{
			level thread [[ level.createfx_callback_thread ]]();
		}
		
		maps\_createfx::createfx();
	}

	maps\_weapons::init();
	maps\_detonategrenades::init(); 
	thread maps\_flareWeapon::init();
	
	thread setup_simple_primary_lights(); 
	
	// MikeD( 10/28/2007 3:06:12 ): Precache Gib FX
	call_overloaded_func( "animscripts\death", "precache_gib_fx" ); 
	
	// --------------------------------------------------------------------------------
	// ---- PAST THIS POINT THE SCRIPTS DONT RUN WHEN GENERATING REFLECTION PROBES ----
	// --------------------------------------------------------------------------------
	
	/#	
	if( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		maps\_global_fx::main(); 
		maps\_loadout::init_loadout(); // MikeD: Just to set the level.campaign
		level waittill( "eternity" ); 
	}
	#/
	
	// TFLAME - 3/21/11 - Replacing with skipto system, but still supporting starts for now
	if ( isdefined(level.start_functions) )
		thread handle_starts(); 
	else
		thread maps\_skipto::handle_skiptos();

		
	if( GetDvar( "g_connectpaths" ) == "2" )
	{
		/# println( "g_connectpaths == 2; halting script execution" ); #/
		level waittill( "eternity" ); 
	}

	println( "level.script: ", level.script ); 

	// CODE_MOD
	maps\_callbackglobal::init(); 
	maps\_callbacksetup::SetupCallbacks(); 

	// If gamemode calls for it, override callbacks as needed here.
	if(isdefined(level._gamemode_initcallbacks))
	{
		[[level._gamemode_initcallbacks]]();
	}	
		
		// TFLAME - 3/22/11 - don't go past here on no_game skipto
	maps\_skipto::do_no_game_skipto();
		
	maps\_autosave::main(); 
	maps\_anim::init(); 
	maps\_busing::businit(); 
	maps\_music::music_init();
	maps\_dds::dds_init();
	
	thread maps\_radiant_live_update::main();
	
	// legacy... necessary?
	anim.useFacialAnims = false; 

	if( !IsDefined( level.missionfailed ) )
	{
		level.missionfailed = false; 
	}
	
	if( GetDvar( "g_gametype" ) != "vs" )
	{
		if(isDefined(level.skill_override))
		{
			maps\_gameskill::setSkill(undefined,level.skill_override);
		}
		else
		{
			maps\_gameskill::setSkill();
		}
	}

	maps\_loadout::init_loadout();
	maps\_destructible::init();
	maps\_hud_message::init();
	SetObjectiveTextColors();
//	maps\_laststand::init();
	
	// CODE_MOD
	thread maps\_cooplogic::init();
	thread maps\_ingamemenus::init();
	calculate_map_center(); 

	// global effects for objects
	maps\_global_fx::main(); 
	
	//thread devhelp(); // disabled due to localization errors
	
// CODER_MOD
// moved from _loadout::give_loadout()
	if( !IsDefined( level.campaign ) )
	{
		level.campaign = "american"; 
	}
	
	if ( !GameModeIsMode( level.GAMEMODE_ZOMBIES ) )
	{
		maps\_contextual_melee::setup();
	}
	
	SetSavedDvar( "ui_campaign", level.campaign ); // level.campaign is set in maps\_loadout::init_loadout

	/#
	thread maps\_debug::mainDebug(); 
	thread animscripts\debug::mainDebug();
	#/

// SCRIPTER_MOD
// MikeD( 3/20/2007 ): Added for _createcam to work.
/#
	// commented out prevent variable limit being hit
	//maps\_createcam::main(); 
	maps\_createdynents::init_once(); 
	thread maps\_createdynents::main(); 
#/	

	// MikeD( 7/27/2007 ): Added the SaveGame here for the beginning of the level.
//	if( GetDvar( "sv_saveOnStartMap" ) == "1" && !IsDefined(level.noAutoStartLevelSave) )
//	{
//		level thread maps\_autosave::start_level_save(); 
//	}

	// CODER_MOD
	// DSL - 05/21/08 - All players have connected mechanism.
	level thread all_players_connected();
	level thread all_players_spawned();
	thread maps\_introscreen::main(); 

	thread maps\_minefields::main(); 
//	thread maps\_shutter::main(); 
//	thread maps\_breach::main(); 
//	thread maps\_inventory::main(); 
//	thread maps\_photosource::main(); 
	thread maps\_endmission::main(); 
	maps\_friendlyfire::main(); 

	// For _anim to track what animations have been used. Uncomment this locally if you need it.
//	thread usedAnimations(); 

	level array_ent_thread( GetEntArray( "badplace", "targetname" ), ::badplace_think ); 
	
	array_delete(GetEntArray( "delete_on_load", "targetname" ));
	
	setup_traversals();

// SCRIPTER_MOD: dguzzo: 3/24/2009 : need these anymore?
//	array_thread( GetEntArray( "piano_key", "targetname" ), ::pianoThink ); 
//	array_thread( GetEntArray( "piano_damage", "targetname" ), ::pianoDamageThink ); 
	array_thread( GetEntArray( "water", "targetname" ), ::waterThink ); 
	
	thread maps\_interactive_objects::main(); 
	thread maps\_audio::main(); 
	
	// this has to come before _spawner moves the turrets around
	thread massNodeInitFunctions(); 
	
	thread maps\_collectibles::main(); 
	
	// Various newvillers globalized scripts
	flag_init( "spawning_friendlies" ); 
	flag_init( "friendly_wave_spawn_enabled" ); 
	flag_clear( "spawning_friendlies" ); 
	
	level.spawn_funcs = [];
	level.spawn_funcs["allies"] = [];
	level.spawn_funcs["axis"] = [];
	level.spawn_funcs["team3"] = [];
	level.spawn_funcs["neutral"] = [];
	
	thread maps\_spawner::goalVolumes();
	
	level.trigger_hint_string = [];
	level.trigger_hint_func = [];
	level.fog_trigger_current = undefined;
	
	if( !IsDefined( level.trigger_flags ) )
	{
		// may have been defined by AI spawning
		init_trigger_flags();
	}

	trigger_funcs = [];
	trigger_funcs["flood_spawner"] = maps\_spawner::flood_trigger_think;
	trigger_funcs["trigger_spawner"] = maps\_spawner::trigger_spawner;
	trigger_funcs["trigger_autosave"] = maps\_autosave::trigger_autosave;
	trigger_funcs["autosave_now"] = maps\_autosave::autosave_now_trigger;
	trigger_funcs["trigger_unlock"] = ::trigger_unlock;
	trigger_funcs["trigger_lookat"] = ::trigger_lookat;
	trigger_funcs["trigger_looking"] = ::trigger_looking;
	trigger_funcs["trigger_cansee"] = ::trigger_cansee;
	trigger_funcs["flag_set"] = ::flag_set_trigger;
	trigger_funcs["flag_clear"] = ::flag_clear_trigger;
	trigger_funcs["flag_on_cleared"] = ::flag_on_cleared;
	trigger_funcs["flag_set_touching"] = ::flag_set_touching;
	trigger_funcs["objective_event"] = maps\_spawner::objective_event_init;
	trigger_funcs["friendly_respawn_trigger"] = ::friendly_respawn_trigger;
	trigger_funcs["friendly_respawn_clear"] = ::friendly_respawn_clear;
	trigger_funcs["trigger_ignore"] = ::trigger_ignore;
	trigger_funcs["trigger_pacifist"] = ::trigger_pacifist;
	trigger_funcs["trigger_delete"] = ::trigger_turns_off;
	trigger_funcs["trigger_delete_on_touch"] = ::trigger_delete_on_touch;
	trigger_funcs["trigger_off"] = ::trigger_turns_off;
	trigger_funcs["trigger_outdoor"] = maps\_spawner::outdoor_think;
	trigger_funcs["trigger_indoor"] = maps\_spawner::indoor_think;
	trigger_funcs["trigger_hint"] = ::trigger_hint;
	trigger_funcs["trigger_grenade_at_player"] = ::throw_grenade_at_player_trigger;
	trigger_funcs["delete_link_chain"] = ::delete_link_chain;
	trigger_funcs["trigger_fog"] = ::trigger_fog;
//	trigger_funcs["trigger_coop_warp"] = maps\_utility::trigger_coop_warp;
	trigger_funcs["no_crouch_or_prone"] = ::no_crouch_or_prone_think;
	trigger_funcs["no_prone"] = ::no_prone_think;

	triggers = get_triggers("trigger_radius", "trigger_multiple", "trigger_once", "trigger_box");
	for( i = 0; i < triggers.size; i++ )
	{
		if( triggers[i] has_spawnflag( SPAWNFLAG_TRIGGER_SPAWN ) )
		{
			thread maps\_spawner::trigger_spawner( triggers[i] ); 
		}
	}

	triggers = get_triggers( );
	for( i = 0; i < triggers.size; i++ )
	{
		if ( ( triggers[i].classname != "trigger_once" ) && triggers[i] has_spawnflag( SPAWNFLAG_TRIGGER_TRIGGER_ONCE ) )
		{
			level thread trigger_once(triggers[i]);
		}
		if( IsDefined( triggers[i].script_flag_true ) )
		{
			level thread script_flag_true_trigger( triggers[i] );
		}
		if( IsDefined( triggers[i].script_flag_set ) )
		{
			level thread flag_set_trigger( triggers[i], triggers[i].script_flag_set );
		}
		if( IsDefined( triggers[i].script_flag_clear ) )
		{
			level thread flag_clear_trigger( triggers[i], triggers[i].script_flag_clear );
		}
		if( IsDefined( triggers[i].script_flag_false ) )
		{
			level thread script_flag_false_trigger( triggers[i] );
		}
		if( IsDefined( triggers[i].script_autosavename ) || IsDefined( triggers[i].script_autosave ) )
		{
			level thread maps\_autosave::autosave_name_think( triggers[i] );
		}
		if( IsDefined( triggers[i].script_fallback ) )
		{
			level thread maps\_spawner::fallback_think( triggers[i] );
		}
		if( IsDefined( triggers[i].script_mgTurretauto ) )
		{
			//level thread maps\_mgturret::mgTurret_auto( triggers[i] );
		}
		if( IsDefined( triggers[i].script_killspawner ) )
		{
			level thread maps\_spawner::kill_spawner_trigger( triggers[i] );
		}
		if( IsDefined( triggers[i].script_emptyspawner ) )
		{
			level thread maps\_spawner::empty_spawner( triggers[i] );
		}
		if( IsDefined( triggers[i].script_prefab_exploder ) )
		{
			triggers[i].script_exploder = triggers[i].script_prefab_exploder;
		}
		if( IsDefined( triggers[i].script_exploder ) )
		{
			level thread exploder_load( triggers[i] );
		}
			
		if( IsDefined( triggers[i].script_trigger_group ) )
		{
			triggers[i] thread trigger_group();
		}
			// MikeD( 06/26/07 ): Added script_notify, which will send out the value set to script_notify as a level notify once triggered
		if( IsDefined( triggers[i].script_notify ) )
		{
			level thread trigger_notify( triggers[i], triggers[i].script_notify );
		}
		if( IsDefined( triggers[i].targetname ) )
		{
			// do targetname specific functions
			targetname = triggers[i].targetname;
			if( IsDefined( trigger_funcs[targetname] ) )
			{
				level thread[[trigger_funcs[targetname]]]( triggers[i] );
			}
		}
	}

	// SJ ( 2/15/2010 ) Updates script_forcespawn KVP based on the SPAWNFLAG_ACTOR_SCRIPTFORCESPAWN
	// flag for later use in _spawner and other functions of the script
	update_script_forcespawn_based_on_flags();

	// BB (4.24.09): For AI awareness of explodables
	trigs = GetEntArray("explodable_volume", "targetname");
	array_thread(trigs, ::explodable_volume);
	
	level.ai_number = 0; 
	level.shared_portable_turrets = [];
		
	// Call the spawner main and then the spawn manager main
	maps\_spawner::main();
	maps\_spawner::spawner_targets_init();
	maps\_spawn_manager::spawn_manager_main();

	maps\_hud::init(); 

	thread load_friendlies(); 

	thread maps\_animatedmodels::main(); 	
	script_gen_dump(); 
	thread weapon_ammo(); 

	PrecacheShellShock( "default" ); 

	level thread onFirstPlayerReady(); 
	level thread onPlayerConnect(); 

	maps\_swimming::main();

	// Handles the "placed weapons" in the map. Deletes the ones that we do not want depending on the amount of coop players
	level thread adjust_placed_weapons();

	// MikeD( 5/20/2008 ): Check to make sure splitscreen fog is setup
	if( !IsDefined( level.splitscreen_fog ) )
	{
		set_splitscreen_fog();
	}
	
	level notify( "load main complete" ); 
	
	/#
	level thread level_notify_listener();
	level thread client_notify_listener();
	level thread save_game_on_notify();
	#/

	// devgui hotness
	/#
	thread maps\_dev::init();
	#/
		
	maps\_turret::init_turrets();

	maps\_dialog::main();
	
	// setup level.player for campaign scripts
	level thread init_connected_player();

	println( "_LOAD END TIME = " + GetTime() );
}

init_connected_player()
{
	flag_wait( "all_players_connected" );
	a_players = get_players();
	
	if( IsDefined( level.usePerksHud ) && level.usePerksHud )
	{
		level thread maps\_perks_sp::perks_init( true );
	}
	else
	{
		level thread maps\_perks_sp::perks_init( false );
	}
	
	//GLocke: level.player only used in CAMPAIGN levels
	//TODO: only create level.player if level.script matches a single player campaign level.
	level.player = a_players[0];
	
	flag_set( "level.player" );
}

init_client_flags()
{
	level.CF_PLAYER_UNDERWATER = 15;
}

onPlayerConnect()
{
	for( ;; )
	{
		level waittill( "connecting", player ); 

		// do not redefine the .a variable if there already is one
		if( !IsDefined( player.a ) )
		{
			player.a = SpawnStruct(); 
		}
		
		player thread animscripts\init::onPlayerConnect(); 
		player thread onPlayerSpawned(); 
		player thread onPlayerDisconnect(); 

		player thread maps\_audio::missile_audio_watcher();

		// if we are in splitscreen then turn the water off to 
		// help the frame rate
		if( IsSplitScreen() )
		{
			SetDvar( "r_watersim", false ); 
		}
	}
}

onPlayerDisconnect()
{
	self waittill( "disconnect" ); 
	
	// if we are in dropping out of splitscreen then turn 
	// the water back on
	if( IsSplitScreen() )
	{
		SetDvar( "r_watersim", true ); 
	}
}

// CODE_MOD
// moved most of the player initialization functionality out of the main() function
// into player_init() so we can call it every spawn.  Nothing should be in here
// that you dont want to happen every spawn.
onPlayerSpawned()
{
	self endon( "disconnect" ); 
	
	// TODO CAC ?? Will need this if special grenades and bettys are brought over to sp/coop
	//self thread onPlayerSpawnedWeapons();
	
	for( ;; )
	{
		self waittill( "spawned_player" ); 

		self.maxhealth = 100; 
		self.attackeraccuracy = 1; 

		self.pers["class"] = "closequarters";
		self.pers["team"] = "allies";

		println( "player health: "+self.health ); 

		// MikeD: Stop all of the extra stuff, if createFX is enabled.
		if( level.createFX_enabled )
		{
			continue; 
		}
		self SetThreatBiasGroup( "allies" ); 

		self notify( "noHealthOverlay" ); 

		// SCRIPTER_MOD: JesseS( 6/4/200 ):  added start health for co-op health scaling
		self.starthealth = self.maxhealth; 

		self.shellshocked = false; 
		self.inWater = false; 

		// make sure any existing attachments have been removed	
		self DetachAll(); 

		self maps\_loadout::give_model( /*self.pers["class"]*/ ); 

		// TODO CAC remove default loadout
		maps\_loadout::give_loadout( true );

		self notify ( "CAC_loadout");	
		// SCRIPTER_MOD: SRS 5/3/2008: to support _weather
/*			if( IsDefined( level.playerWeatherStarted ) && level.playerWeatherStarted )
		{
			self thread maps\_weather::player_weather_loop(); 
		} */

		self maps\_art::setdefaultdepthoffield(); 

		if( !IsDefined( self.player_inited ) || !self.player_inited )
		{
			self maps\_friendlyfire::player_init(); 

			// SCRIPTER_MOD: JesseS( 4/12/2008 ): Per player init
/*			if( arcademode() )
			{
				self thread maps\_arcademode::player_init(); 
			}*/

			// CODER_MOD - JamesS added self to player_death_detection
			self thread player_death_detection(); 
			if ( !GameModeIsMode( level.GAMEMODE_ZOMBIES ) )
			{
				// Adding some death sound effects
				self thread maps\_audio::death_sounds(); 
			}			
//			self thread flashMonitor(); 
			self thread shock_ondeath(); 
			self thread shock_onpain(); 

//			self thread maps\_quotes::main(); 	-- Removed by DSL 4/3/2010 2:08:46 PM

			// handles satchels/claymores with special script
			self thread maps\_detonategrenades::watchGrenadeUsage();
			self maps\_dds::player_init();

			self thread playerDamageRumble(); 
			self thread maps\_gameskill::playerHealthRegen();
			self thread maps\_colors::player_init_color_grouping();

			self maps\_laststand::revive_hud_create();

			self thread maps\_cheat::player_init(); 
			
			self maps\_damagefeedback::init();

			wait( 0.05 );
			self.player_inited = true;
		}
	}
}

handle_starts()
{
	if( !IsDefined( level.start_functions ) )
	{
		level.start_functions = []; 
	}

	assert( GetDvar( "jumpto" ) == "", "Use the START dvar instead of JUMPTO" ); 

	start = Tolower( GetDvar( "start" ) ); 

	// find the start that matches the one the dvar is set to, and execute it
	dvars = GetArrayKeys( level.start_functions ); 

	for( i = 0; i < dvars.size; i++ )
	{
		if( start == dvars[i] )
		{
			level.start_point = start; 
			break; 
		}
	}

	if( !IsDefined( level.start_point ) )
	{
		level.start_point = "default"; 
	}
	
	wait_for_first_player(); 
	
	thread start_menu(); 
	
	// CODER_MOD - JamesS - wait( here for a frame so that things will get setup properly before running the start
	// This is currently needed because ONLINE is not defined and wait_for_first_player returns immediately
	//wait 0.05 ); // MikeD: online should be enabled now.
	
	if( level.start_point != "default" )
	{
		thread indicate_start( level.start_loc_string[level.start_point] ); 
		thread[[level.start_functions[level.start_point]]](); 
		return; 
	}
	
	if( IsDefined( level.default_start ) )
	{
		thread[[level.default_start]](); 
	}

	string = get_string_for_starts( dvars ); 
	SetDvar( "start", string ); 
	
}

get_string_for_starts( dvars )
{
	string = " ** No starts have been set up for this map with maps\_utility::add_start()."; 
	if( dvars.size )
	{
		string = " ** "; 
		for( i = dvars.size - 1; i >= 0; i-- )
		{
			string = string + dvars[i] + " "; 
		}
	}
	
	SetDvar( "start", string ); 
	return string; 
}

devhelp_hudElements( hudarray, alpha )
{
	for( i = 0; i < hudarray.size; i++ )
	{
		for( p = 0; p < 2; p++ )
		{
			hudarray[i][p].alpha = alpha; 
		}
	}

}

create_start( start, index )
{
	hudelem = NewHudElem(); 
	hudelem.alignX = "left"; 
	hudelem.alignY = "middle"; 
	hudelem.x = 10; 
	hudelem.y = 80 + index * 20; 
	hudelem.label = start; 
	hudelem.alpha = 0; 

	hudelem.fontScale = 2; 
	hudelem FadeOverTime( 0.5 ); 
	hudelem.alpha = 1; 
	return hudelem; 
}

start_menu()
{
	level.start_loc_string["default"] = &"STARTS_DEFAULT"; 
	level.start_loc_string["cancel"] = &"STARTS_CANCEL"; 

	for( ;; )
	{
		if( GetDvarint( "debug_start" ) )
		{
			SetDvar( "debug_start", 0 ); 
			SetSavedDvar( "hud_drawhud", 1 ); 
			display_starts(); 
		}
		else
		{
			level.display_starts_Pressed = false; 
		}
		wait( 0.05 ); 
	}
}

display_starts() 
{
	level.display_starts_Pressed = true; 
	dvars = GetArrayKeys( level.start_functions ); 
	if( dvars.size <= 0 )
	{
		return; 
	}
		
	dvars[dvars.size] = "default"; 
	dvars[dvars.size] = "cancel"; 
	
	title = create_start( &"STARTS_AVAILABLE_STARTS", -1 ); 
	title.color = ( 1, 1, 1 ); 
	elems = []; 
	
	//-- Glocke 2/28 - Only put starts with defined string values into debug menu
	level.start_loc_string = array_remove( level.start_loc_string, &"MISSING_LOC_STRING", true ); 
	dvars = GetArrayKeys( level.start_loc_string ); 
	
	for( i = 0; i < dvars.size; i++ )
	{
		elems[elems.size] = create_start( level.start_loc_string[dvars[i]] , dvars.size - i ); 
	}
	
	selected = dvars.size - 1; 
	
	up_pressed = false; 
	down_pressed = false; 
	
	players = get_players(); 
	for( ;; )
	{	
		if( !( players[0] ButtonPressed( "F10" ) ) )
		{
			level.display_starts_Pressed = false; 
		}

		
		for( i = 0; i < dvars.size; i++ )
		{
			elems[i].color = ( 0.7, 0.7, 0.7 ); 
		}
	
		elems[selected].color = ( 1, 1, 0 ); 

		if( !up_pressed )
		{
			if( players[0] ButtonPressed( "UPARROW" ) || players[0] ButtonPressed( "DPAD_UP" ) || players[0] ButtonPressed( "APAD_UP" ) )
			{
				up_pressed = true; 
				selected++; 
			}
		}
		else
		{
			if( !players[0] ButtonPressed( "UPARROW" ) && !players[0] ButtonPressed( "DPAD_UP" ) && !players[0] ButtonPressed( "APAD_UP" ) )
			{
				up_pressed = false; 
			}
		}
		

		if( !down_pressed )
		{
			if( players[0] ButtonPressed( "DOWNARROW" ) || players[0] ButtonPressed( "DPAD_DOWN" ) || players[0] ButtonPressed( "APAD_DOWN" ) )
			{
				down_pressed = true; 
				selected--; 
			}
		}
		else
		{
			if( !players[0] ButtonPressed( "DOWNARROW" ) && !players[0] ButtonPressed( "DPAD_DOWN" ) && !players[0] ButtonPressed( "APAD_DOWN" ) )
			{
				down_pressed = false; 
			}
		}
		
		if( selected < 0 )
		{
			selected = dvars.size - 1; 
		}
			
		if( selected >= dvars.size )
		{
			selected = 0; 
		}
		
		
		if( players[0] ButtonPressed( "kp_enter" ) || players[0] ButtonPressed( "BUTTON_A" ) || players[0] ButtonPressed( "enter" ) )
		{
			if( dvars[selected] == "cancel" )
			{
				title Destroy(); 
				for( i = 0; i < elems.size; i++ )
				{
					elems[i] Destroy(); 
				}
				break; 
			}
			
			SetDvar( "start", dvars[selected] ); 
			//ChangeLevel( level.script, false ); 
			fastrestart();
		}
		
		wait( 0.05 ); 
	}

}

load_friendlies()
{
	if( IsDefined( game["total characters"] ) )
	{
		game_characters = game["total characters"]; 
		println( "Loading Characters: ", game_characters ); 
	}
	else
	{
		println( "Loading Characters: None!" ); 
		return; 
	}

	ai = GetAiArray( "allies" ); 
	total_ai = ai.size; 
	index_ai = 0; 

	spawners = GetSpawnerTeamArray( "allies" ); 
	total_spawners = spawners.size; 
	index_spawners = 0; 

	while( 1 )
	{
		if( ( ( total_ai <= 0 ) &&( total_spawners <= 0 ) ) ||( game_characters <= 0 ) )
		{
			return; 
		}

		if( total_ai > 0 )
		{
			if( IsDefined( ai[index_ai].script_friendname ) )
			{
				total_ai -- ; 
				index_ai ++ ; 
				continue; 
			}

			println( "Loading character.. ", game_characters ); 
			ai[index_ai] codescripts\character::new(); 
			ai[index_ai] thread codescripts\character::load( game["character" +( game_characters - 1 )] ); 
			total_ai -- ; 
			index_ai ++ ; 
			game_characters -- ; 
			continue; 
		}

		if( total_spawners > 0 )
		{
			if( IsDefined( spawners[index_spawners].script_friendname ) )
			{
				total_spawners -- ; 
				index_spawners ++ ; 
				continue; 
			}

			println( "Loading character.. ", game_characters ); 
			info = game["character" +( game_characters - 1 )]; 
			precache( info["model"] ); 
			precache( info["model"] ); 
			spawners[index_spawners] thread spawn_setcharacter( game["character" +( game_characters - 1 )] ); 
			total_spawners -- ; 
			index_spawners ++ ; 
			game_characters -- ; 
			continue; 
		}
	}
}
