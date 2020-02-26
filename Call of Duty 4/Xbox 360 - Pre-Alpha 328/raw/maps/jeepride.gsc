#include common_scripts\utility;
#include maps\_utility;
#include maps\_utility_code;
#include maps\_vehicle;
#include maps\jeepride_code;
#include maps\_anim;

main()
{

	level.fxplay_writeindex = 0;
	level.startdelay = 0;
	level.recorded_fx_timer = 0;
	level.recorded_fx = [];
	level.sparksclaimed = 0;
	level.whackamolethread = ::whackamole;
	level.playerlinkinfluence = .75;
	level.exploder_fast = [];
	level.cosine = [];
	level.cosine[ "180" ] = cos( 180 );
	level.minBMPexplosionDmg = 50;
	level.maxBMPexplosionDmg = 100;
	level.bmpCannonRange = 2048;
	level.bmpMGrange = 850;
	level.bmpMGrangeSquared = level.bmpMGrange * level.bmpMGrange;
	level.potentialweaponitems = [];
// 	level.struct_remove = [];

	array_levelthread( getentarray( "delete_on_load", "targetname" ), ::deleteEnt );
	array_levelthread( getentarray( "delete_on_load", "target" ), ::deleteEnt );

	// precache stuff
	precacherumble( "tank_rumble" );
	precacheItem( "hind_FFAR_jeepride" );// this is kind of dumb
	precacheItem( "hunted_crash_missile" );
	precacheItem( "stinger" );
	precacheItem( "rpg" );
	precacheshader( "jeepride_smoke_transition_overlay" );
	precacheshader( "overlay_hunted_black" );
	
	precacheshellshock( "jeepride_bridgebang" );
	precacheshellshock( "jeepride_action" );
	precacheshellshock( "jeepride_zak" );
	
	precachemodel( "viewhands_player_usmc" );
	precachemodel( "weapon_colt1911_white" );
	precachemodel( "weapon_saw" );
	

	default_start( ::ride_start );
	add_start( "start", ::ride_start );
// 	add_start( "wip", ::wip_start );
	add_start( "first_hind", ::wip_start );
	add_start( "against_traffic", ::wip_start );
	add_start( "final_stretch", ::wip_start );
	add_start( "bridge_explode", ::bridge_explode_start );
	add_start( "bridge_combat", ::bridge_combat );
	add_start( "bridge_zak", ::bridge_zak );

	if ( getdvar( "jeepride_smoke_shadow" ) == "" )
		setdvar( "jeepride_smoke_shadow", "off" );
	if ( getdvar( "jeepride_crashrepro" ) == "" )
		setdvar( "jeepride_crashrepro", "off" );
	if ( getdvar( "jeepride_showhelitargets" ) == "" )
		setdvar( "jeepride_showhelitargets", "off" );
	if ( getdvar( "jeepride_recordeffects" ) == "" )
		setdvar( "jeepride_recordeffects", "off" );
	if ( getdvar( "jeepride_startgen" ) == "" )
		setdvar( "jeepride_startgen", "off" );
	if ( getdvar( "jeepride_rpgbox" ) == "" )
		setdvar( "jeepride_rpgbox", "off" );
	if ( getdvar( "jeepride_nobridgefx" ) == "" )
		setdvar( "jeepride_nobridgefx", "off" );
	if ( getdvar( "jeepride_tirefx" ) == "" )
		setdvar( "jeepride_tirefx", "off" );

	// comment out this to record effects.
	if ( getdvar( "jeepride_crashrepro" ) == "off" && getdvar( "jeepride_recordeffects" ) == "off" )
	 	thread maps\jeepride_fx::jeepride_fxline();

	array_thread( getentarray( "bridge_triggers", "script_noteworthy" ), ::trigger_off );
	array_thread( getentarray( "bridge_triggers2", "script_noteworthy" ), ::trigger_off );

	// todo, convert these to script_structs
	array_thread( getentarray( "ambient_setter", "targetname" ), ::ambient_setter );
	array_thread( getentarray( "sound_emitter", "targetname" ), ::sound_emitter );
	
	maps\jeepride_fx::main();
	
	level.weaponClipModels[ 0 ] = "weapon_ak47_clip";
	level.weaponClipModels[ 1 ] = "weapon_m16_clip";
	level.weaponClipModels[ 2 ] = "weapon_saw_clip";

	maps\_mi28::main( "vehicle_mi-28_flying" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_cover" );
	maps\_uaz::main( "vehicle_uaz_hardtop" );
	maps\_uaz::main( "vehicle_uaz_fabric" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed_destructible" );
	maps\_80s_wagon1::main( "vehicle_80s_wagon1_tan_destructible" );
	maps\_80s_wagon1::main( "vehicle_80s_wagon1_green_destructible" );
	maps\_small_hatchback::main( "vehicle_small_hatch_turq_destructible" );
	maps\_small_hatchback::main( "vehicle_small_hatchback_turq" );
	maps\_80s_sedan1::main( "vehicle_80s_sedan1_brn_destructible" );
	maps\_luxurysedan::main( "vehicle_luxurysedan" );
	maps\_bus::main( "vehicle_bus_destructable" );
	maps\_80s_hatch1::main( "vehicle_80s_hatch1_silv_destructible" );
	maps\_hind::main( "vehicle_mi24p_hind_woodland" );
	maps\_uaz::main( "vehicle_uaz_hardtop_destructible" );
	maps\_uaz::main( "vehicle_uaz_fabric_destructible" );
	maps\_uaz::main( "vehicle_uaz_open_destructible" );
	maps\_uaz::main( "vehicle_uaz_open" );
	maps\_uaz::main( "vehicle_uaz_open_for_ride" );
	build_aianims( maps\jeepride_anim::uaz_overrides, maps\jeepride_anim::uaz_override_vehicle );
	maps\_blackhawk::main( "vehicle_blackhawk" );
	maps\_tanker::main( "vehicle_tanker_truck_civ" );
	maps\_truck::main( "vehicle_pickup_4door" );
	maps\_truck::main( "vehicle_pickup_roobars" );
	maps\_small_wagon::main( "vehicle_small_wagon_white" );
	maps\_bmp::main( "vehicle_bmp_woodland" );
	maps\_mi17::main( "vehicle_mi17_woodland_fly" );

	maps\createart\jeepride_art::main();
	maps\createfx\jeepride_fx::main();


	maps\_load::main();
	maps\jeepride_anim::main_anim();

	level.vehicle_aianimthread[ "hide_attack_forward" ] = maps\jeepride_code::guy_hide_attack_forward;
	level.vehicle_aianimcheck[ "hide_attack_forward" ] = maps\jeepride_code::guy_hide_attack_forward_check;

	level.vehicle_aianimthread[ "hidetoback_attack" ] = 					maps\jeepride_code::guy_hidetoback_startingback;
	level.vehicle_aianimcheck[ "hidetoback_attack" ] = 					maps\jeepride_code::guy_hidetoback_check;
	
	level.vehicle_aianimthread[ "back_attack" ] = 			 		maps\jeepride_code::guy_back_attack;
	level.vehicle_aianimcheck[ "back_attack" ] = 						maps\jeepride_code::guy_hidetoback_check;
	
	level.vehicle_aianimthread[ "hide_attack_left" ] = 				 		maps\jeepride_code::guy_hide_attack_left;
	level.vehicle_aianimcheck[ "hide_attack_left" ] = 							maps\jeepride_code::guy_hidetoback_check;
	
	level.vehicle_aianimthread[ "hide_attack_left_standing" ] = 				 		maps\jeepride_code::guy_hide_attack_left_standing;
	level.vehicle_aianimcheck[ "hide_attack_left_standing" ] = 							maps\jeepride_code::guy_hidetoback_check;
	
	level.vehicle_aianimthread[ "hide_attack_back" ] = 			 			maps\jeepride_code::guy_hide_attack_back;
	level.vehicle_aianimcheck[ "hide_attack_back" ] = 						maps\jeepride_code::guy_hide_attack_back_check;
	
	level.vehicle_aianimthread[ "hide_starting_back" ] = 				maps\jeepride_code::guy_hide_starting_back;
	level.vehicle_aianimcheck[ "hide_starting_back" ] = 				maps\jeepride_code::guy_hidetoback_check;
	
	level.vehicle_aianimthread[ "hide_starting_left" ] = 				maps\jeepride_code::guy_hide_startingleft;
	level.vehicle_aianimcheck[ "hide_starting_left" ] = 				maps\jeepride_code::guy_backtohide_check;
	
	level.vehicle_aianimthread[ "backtohide" ] = 										maps\jeepride_code::guy_backtohide;
	level.vehicle_aianimcheck[ "backtohide" ] = 											maps\jeepride_code::guy_backtohide_check;

	if ( !isdefined( level.fxplay_model ) || getdvar( "jeepride_crashrepro" ) != "off" )
	{
		array_thread( getstructarray( "ghetto_tag", "targetname" ), ::ghetto_tag );
		array_thread( getvehiclenodearray( "sparks_on", "script_noteworthy" ), ::trigger_sparks_on );
		array_thread( getvehiclenodearray( "sparks_off", "script_noteworthy" ), ::trigger_sparks_off );
	}

	// asign heros when they spawn

	getent( "gaz", "script_noteworthy" ) add_spawn_function( ::setup_gaz );
	getent( "price", "script_noteworthy" ) add_spawn_function( ::setup_price );
	getent( "griggs", "script_noteworthy" ) add_spawn_function( ::setup_griggs );

	level.lock_on_player_ent = spawn( "script_model", level.player.origin + ( 0, 0, 24 ) );
	level.lock_on_player_ent setmodel( "fx" );
	level.lock_on_player_ent linkto( level.player );
	level.lock_on_player_ent hide();
	level.lock_on_player_ent.script_attackmetype = "missile";
	level.lock_on_player_ent.script_shotcount = 4;
	level.lock_on_player_ent.oldmissiletype = false;
	level.lock_on_player = false;

// 	battlechatter_off( "axis" );
	battlechatter_off( "allies" );

// 	delaythread( 2, ::exploder, 1 );

	thread objectives();
	setsaveddvar( "compassMaxRange", 30000 );
	maps\_compass::setupMiniMap( "compass_map_jeepride" );
// 	maps\_stinger::init();

	maps\jeepride_amb::main();

// 	thread monitorvehiclecounts();
	level.player allowprone( false );
	level.player AllowSprint( false );

// 	array_thread( getvehiclenodearray( "view_magnet", "script_noteworthy" ), ::view_magnet );
// 	array_thread( level.vehicle_spawners, ::all_god );

	array_thread( level.vehicle_spawners, ::process_vehicles_spawned );
 	array_thread( getentarray( "missile_offshoot", "targetname" ), ::missile_offshoot );

	array_thread( getstructarray( "fliptruck_ghettoanimate", "targetname" ), ::fliptruck_ghettoanimate );
	if(isdefined( level.fxplay_model ))
	{
		array_thread( getstructarray( "attack_dummy_path", "targetname" ), ::attack_dummy_path );
		array_thread( getstructarray( "vehicle_badplacer", "targetname" ), ::vehicle_badplacer );
		array_thread( getentarray( "exploder", "targetname" ), ::exploder_animate );
	}

	level.struct_remove = undefined;
	level.struct = [];
	level.struct_class_names = undefined;
	level.struct_class_names = [];
	level.struct_class_names[ "target" ] = [];
	level.struct_class_names[ "targetname" ] = [];
	level.struct_class_names[ "script_noteworthy" ] = [];	

	if(isdefined( level.fxplay_model ))
	{
		array_thread( getvehiclenodearray( "nodisconnectpaths", "script_noteworthy" ), ::nodisconnectpaths );
		array_thread( getvehiclenodearray( "crazy_bmp", "script_noteworthy" ), ::crazy_bmp );
		array_thread( getvehiclenodearray( "do_or_die", "script_noteworthy" ), ::do_or_die );
		array_thread( getvehiclenodearray( "hillbump", "script_noteworthy" ), ::hillbump );
	}
	
	array_thread( getvehiclenodearray( "attacknow", "script_noteworthy" ), ::attacknow );
	array_thread( getvehiclenodearray( "sideswipe", "script_noteworthy" ), ::sideswipe );
	array_thread( getvehiclenodearray( "destructible_assistance", "script_noteworthy" ), ::destructible_assistance );
	array_thread( getvehiclenodearray( "no_godmoderiders", "script_noteworthy" ), ::no_godmoderiders );
	array_thread( getvehiclenodearray( "jolter", "script_noteworthy" ), ::jolter );
	
	
	if(isdefined( level.fxplay_model ))
	{
		array_thread( getvehiclenodearray( "clouds_off", "script_noteworthy" ), ::clouds_off );
		array_thread( getvehiclenodearray( "clouds_on", "script_noteworthy" ), ::clouds_on );
	}
	
	array_thread( getentarray( "hindset", "script_noteworthy" ), ::hindset );
	getent( "end_hind_action", "script_noteworthy" ) thread end_hind_action();
	getvehiclenode( "end_bmp_action", "script_noteworthy" ) thread end_bmp_action();

	if(isdefined( level.fxplay_model ))
	{
		array_thread( getentarray( "magic_missileguy_spawner", "targetname" ), ::magic_missileguy_spawner );
	 	array_thread( getentarray( "stinger_me", "script_noteworthy" ), ::stinger_me );
	 	array_thread( getentarray( "stinger_me_nolock", "script_noteworthy" ), ::stinger_me, false );
		array_thread( getentarray( "all_allies_targetme", "script_noteworthy" ), ::all_allies_targetme );
		array_thread( getentarray( "heli_focusonplayer", "script_noteworthy" ), ::heli_focusonplayer );
		array_thread( getentarray( "exploder", "targetname" ), ::exploder_hack );
		array_thread( getentarray( "hidemeuntilflag", "script_noteworthy" ), ::hidemeuntilflag );
		array_thread( GetSpawnerArray(), ::spawners_setup );
	}
	else
	{
		level.createfxent = [];
		level.vehicle_truckjunk = [];
	}
	
	if ( getdvar( "jeepride_startgen" ) != "off" )
		array_thread( getvehiclenodearray( "startgen", "script_noteworthy" ), ::startgen );


	thread bridge_bumper();
	thread bridge_uaz_crash();

	flag_init( "rpg_taken" );
	flag_init( "cover_from_heli" );
	flag_init( "all_end_scene_guys_dead" );
//	flag_init( "attack_heli" );
	
	

	thread getplayersride();
	thread player_death();

	setsaveddvar( "sM_sunSampleSizeNear", .6 );

	thread music();
	thread jeepride_start_dumphandle();
	thread speedbumps_setup();
	thread end_ride();
	thread time_triggers();
	thread dialog_ride_price();
	thread dialog_ride_griggs();
	thread dialog_get_off_your_ass();

// 	thread can_cannon();
}


end_ride()
{
	flag_wait( "end_ride" );// set by script_flag_set in radiant
	setsaveddvar( "sm_sunsamplesizenear", "1" );
	if ( level.start_point == "bridge_combat" || level.start_point == "bridge_zak" )
		return;
	bridge_transition();
}


getplayersride()
{
	flag_init( "playersride_init" );
	level.playersride = waittill_vehiclespawn( "playersride" );
	level.playersride godon();
	level.lock_on_player_ent unlink();
	level.lock_on_player_ent.origin = level.playersride.origin + ( 0, 0, 24 );
	level.lock_on_player_ent linkto( level.playersride );
	flag_set( "playersride_init" );
}

ride_start()
{
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 44 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 46 );

	// players ride
	thread maps\_vehicle::scripted_spawn( 45 );

	flag_wait( "playersride_init" );
	level.playersride.target = "playerspath";
	level.playersride getonpath();
	thread gopath( level.playersride );
}

wip_start()
{
	array_thread( getvehiclenodearray( level.start_point, "script_noteworthy" ), ::sync_vehicle );
// 	array_thread( getvehiclenodearray( "dumpstart_node", "targetname" ), ::sync_vehicle );
	flag_wait( "playersride_init" );
}

music()
{
	flag_init( "music_bridge" );
	flag_init( "music_zak" );
	
	waittillframeend;
	music_flagged( "jeepride_chase_music", "music_bridge" );
	music_flagged( "jeepride_defend_music", "music_zak" );
	
	wait .2;
	musicplay( "jeepride_showdown_music", false );
}

music_flagged( music, flag )
{
	if ( level.flag[ flag ] )
		return;
	musicplay( music );
	flag_wait( flag );
	musicstop();
	wait .2;
}

music_defend()
{
	musicplay( "jeepride_defend_music" );
	shocktime = 43;
// 	level.player shellshock( "jeepride_action", shocktime );
	wait shocktime;
}


time_triggers()
{
	waittillframeend;
	waittillframeend;
	if ( getdvar( "start" ) != "wip" )
	{
		thread delaythread_loc( 57, ::autosave_by_name, "First Tunnel Exit" );
		thread delaythread_loc( 57, ::autosave_by_name, "Against Traffic" );
		thread delaythread_loc( 102, ::autosave_by_name, "Hind Chase" );
		thread delaythread_loc( 160, ::autosave_by_name, "Bridge Blown" );
	}
	thread delaythread_loc( 91, ::player_link_update, .3 );
}

dialog_ride_price()
{
	wait 1;
	level.price delaythread_loc( 17, ::anim_single_queue, level.price, "jeepride_pri_truckleft" );
	level.price delaythread_loc( 32, ::anim_single_queue, level.price, "jeepride_pri_truckleft" );
	level.price delaythread_loc( 48, ::anim_single_queue, level.price, "jeepride_pri_coverrear" );
	level.price delaythread_loc( 78, ::anim_single_queue, level.price, "jeepride_pri_company" );
	level.price delaythread_loc( 81, ::anim_single_queue, level.price, "jeepride_pri_takinghits" );
	level.price delaythread_loc( 88, ::anim_single_queue, level.price, "jeepride_pri_takeouttruck" );
	level.price delaythread_loc( 100, ::anim_single_queue, level.price, "jeepride_pri_hind6oclock" );

}

dialog_ride_griggs()
{
	wait 1;
	level.griggs delaythread_loc( 3, ::anim_single_queue, level.griggs, "jeepride_grg_truck6oclock" );
	level.griggs delaythread_loc( 9, ::anim_single_queue, level.griggs, "jeepride_grg_hangon" );
	level.griggs delaythread_loc( 107, ::anim_single_queue, level.griggs, "jeepride_grg_rpgfirehind" );
	level.griggs delaythread_loc( 122, ::anim_single_queue, level.griggs, "jeepride_grg_hind9oclock" );
	level.griggs delaythread_loc( 132, ::anim_single_queue, level.griggs, "jeepride_grg_rpgfirehind" );
	level.griggs delaythread_loc( 147, ::anim_single_queue, level.griggs, "jeepride_grg_hind12oclock" );


}

endprint()
{
	if ( !isdefined( level.fxplay_model ) )
		maps\jeepride_fx::playfx_write_all( level.recorded_fx );

	iprintlnbold( "End of level." );
	wait 3;
// 	missionsuccess( "credits", false );
}


blown_bridge( eTarget )
{
	while ( distance2d( self.origin, eTarget.origin ) > 350 && isdefined( self ) )
		wait 0.05;
	blow_bridge();
}

blow_bridge()
{
	if ( isdefined( level.bridgeblown ) )
		return;
	level.bridgeblown = true;
	exploder_loc( 3 );
}

setup_gaz()
{
	level.gaz = self;
	level.gaz.animname = "gaz";
	level.gaz magic_bullet_shield();
}

setup_price()
{
	level.price = self;
	level.price.animname = "price";
	level.price magic_bullet_shield();
}

setup_griggs()
{
	level.griggs = self;
	level.griggs.animname = "griggs";
	level.griggs magic_bullet_shield();
}
release_mefrome_vehicle()
{
	wait .2;
	self notify( "newanim" );
	if ( isdefined( self.ridingvehicle ) )// for / starts
		self.ridingvehicle thread whackamole( self );
}


dialog_get_off_your_ass()
{
	laststand_time = gettime();
	lasttold_time = gettime();

	telltimer = 10000;
	sittimer = 4000;

	level endon( "newrpg" );
	level endon( "bridge_sequence" );
	

	while ( 1 )
	{
		if ( level.player getstance() == "stand" )
			laststand_time = gettime();
		time = gettime();
		if ( time - laststand_time > sittimer && time - lasttold_time > telltimer )
		{
			lasttold_time = gettime();
			level.price anim_single_queue( level.price, "jeepride_pri_getoffyour" );
		}
		wait .05;
	}
}

allowallstances()
{
	self allowedstances( "stand", "crouch", "prone" );
}


bridge_transition()
{
	bridge_startspot = getent( "bridge_startspot", "targetname" );
	level.player FreezeControls( true );
	intime = 2;
	fullalphatime = .5;
	outtime = 2;

	thread smokey_transition( intime, outtime, fullalphatime );
	thread bridge_setupguys( intime );
	wait intime;
	exploder_loc( 71 );
	exploder_loc( 73 );
	array_thread( getaiarray( "allies" ), ::ClearEnemy_loc );

	clear_all_vehicles_but_heros_and_hind();

	level.player unlink();
	level.player setorigin( bridge_startspot.origin );
	level.player setplayerangles( bridge_startspot.angles );
	level.player ShellShock( "jeepride_bridgebang", 15 );
	flag_set( "objective_off_the_bridge" );
	wait fullalphatime;
	level.player allowstand( true );
	level.player allowprone( true );
	level.player allowsprint( true );
	thread play_sound_in_space( "bricks_crumbling", level.player.origin + ( 0, 54, 35 ) );
	wait outtime * .6;
	level.player FreezeControls( false );
	wait outtime * .4;
	flag_set( "bridge_sequence" );// some exploder motion paths wait on this to go
	exploder_loc( 72 );
	array_thread( getentarray( "bridge_triggers", "script_noteworthy" ), ::trigger_on );
	battlechatter_on( "allies" );
}

bridge_setupguys( intime )
{
	platform1 = getnode( "platform1", "targetname" );
	platform2 = getnode( "platform2", "targetname" );
	platform3 = getnode( "platform3", "targetname" );
	ai_spot1 = getent( "ai_spot1", "script_noteworthy" );
	ai_spot2 = getent( "ai_spot2", "script_noteworthy" );
	ai_spot3 = getent( "ai_spot3", "script_noteworthy" );
	ai_spot1 hide();
 	ai_spot2 hide();
	ai_spot3 hide();
	level.price unlink();
	
	guy_force_remove_from_vehicle( level.price.ridingvehicle, level.price, ai_spot1.origin );
	
	level.price linkto( ai_spot1, "polySurface1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.price teleport( ai_spot1.origin, ( 0, 0, 0 ) );
	level.price hide();

	guy_force_remove_from_vehicle( level.griggs.ridingvehicle, level.griggs, ai_spot2.origin );
	level.griggs unlink();
	level.griggs linkto( ai_spot2, "polySurface1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.griggs thread force_position( ai_spot2.origin );         
	level.griggs unlink();

	guy_force_remove_from_vehicle( level.gaz.ridingvehicle, level.gaz, ai_spot3.origin );
	level.gaz unlink();
	level.gaz linkto( ai_spot3, "polySurface1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.gaz thread force_position( ai_spot3.origin );         
	level.gaz unlink();


	ai = getaiarray( "allies" );
	for ( i = 0; i < ai.size; i++ )
	{
		
		if ( ai[ i ] ishero() )
			continue;
		if ( isdefined( ai[ i ].magic_bullet_shield ) && ai[ i ].magic_bullet_shield )
		{
			ai[ i ] stop_magic_bullet_shield();
			ai[ i ] delete();
		}
	}

	animtimebeforevisisible = intime - 1;
	wait animtimebeforevisisible;
	thread price_bridge_crawl_anims( ai_spot1 );
// 	ai_spot1 thread anim_single_solo( level.price, "wave_player_over" );
	wait intime - animtimebeforevisisible;
	level.price show();
	wait 6;
	level.griggs unlink();
	level.price unlink();
	wait 1;
	level.price thread maps\_spawner::go_to_node( platform1 );
	wait 2;
	level.price thread maps\_spawner::go_to_node( platform3 );
	flag_set( "music_bridge" );
	create_vehicle_from_spawngroup_and_gopath( 66 );
	wait 10;
	setup_bridge_defense();
}

bridge_explode_start()
{
	thread bridge_explode_onstart();
	wip_start();
}

bridge_explode_onstart()
{
	getvehiclenode( "bridge_explode_onstart", "script_noteworthy" ) waittill( "trigger" );
	blow_bridge();
}

setup_bridge_defense()
{
	node = getnode( "bridge_defendnode", "targetname" );


// 	array_thread( getaiarray( "allies" ), maps\_spawner::go_to_node, node );
// 	array_thread( getaiarray( "allies" ), ::gotoplace, node );

	array_thread( getaiarray(), ::allowallstances );// blah.

}

gotoplace( node )
{
	assert( isdefined( node.radius ) );

	self.goalradius = node.radius;
	x = -45 + randomint( 90 );
	y = -45 + randomint( 90 );
	z = node.origin[ 2 ];
	self setgoalpos( node.origin + ( x, y, z ) );
	self.goalradius = node.radius;
}

bridge_combat()
{
	level.startdelay = 250000;
	// just setting up a / start spot here.
	
	
	bridge_combat_price = getent( "bridge_combat_price", "targetname" );
	bridge_combat_griggs = getent( "bridge_combat_griggs", "targetname" );
	bridge_combat_player = getent( "bridge_combat_player", "targetname" );


	spawn_heros_for_start( bridge_combat_price.origin, bridge_combat_griggs.origin, bridge_combat_griggs.origin+(0,128,0) );

	level.player setorigin( bridge_combat_player.origin );


	create_vehicle_from_spawngroup_and_gopath( 66 );
	exploder_loc( 3, true );
	exploder_loc( 71, true );
	exploder_loc( 72, true );
	exploder_loc( 73 );

	array_thread( getentarray( "bridge_triggers", "script_noteworthy" ), ::trigger_on );

	battlechatter_on( "allies" );

	flag_set( "end_ride" );
	flag_set( "bridge_sequence" );


	level.player allowstand( true );
	level.player allowprone( true );
	level.player allowsprint( true );
	wait 1;
	setup_bridge_defense();
	musicstop();
	wait .1;
	flag_set( "objective_off_the_bridge" );

	music_defend();

}

spawn_heros_for_start( priceorg, griggsorg, gazorg )
{
	spawner = getent( "price", "script_noteworthy" );
	spawner.origin = priceorg;
	spawned = spawner stalingradspawn();
	assert(!spawn_failed(spawned));

	spawner = getent( "griggs", "script_noteworthy" );
	spawner.origin = griggsorg;
	spawned = spawner stalingradspawn();
	assert(!spawn_failed(spawned));
	
	spawner = getent( "gaz","script_noteworthy" );
	spawner.origin = gazorg;
	spawned = spawner stalingradspawn();
	assert(!spawn_failed(spawned));
}


bridge_zak()
{
	level.startdelay = 250000;

	bridge_combat_price = getent( "zak_price_spot", "targetname" );
	bridge_combat_griggs = getent( "zak_griggs_spot", "targetname" );
	bridge_combat_player = getent( "zak_player_spot", "targetname" );
	level.player setorigin( bridge_combat_player.origin );
	
	spawn_heros_for_start( bridge_combat_price.origin, bridge_combat_griggs.origin, bridge_combat_player.origin );
	
	
	flag_set( "end_ride" );
	flag_set( "bridge_sequence" );
	flag_set( "van_smash" );
	flag_set( "music_bridge" );
	flag_set( "music_zak" );
	

	thread spawn_vehiclegroup_and_go_to_end_node_quick_and_then_blow_up_boy_this_function_name_is_sure_going_to_make_mackey_smile( 66 );
	thread spawn_vehiclegroup_and_go_to_end_node_quick_and_then_blow_up_boy_this_function_name_is_sure_going_to_make_mackey_smile( 67 );
	thread spawn_vehiclegroup_and_go_to_end_node_quick_and_then_blow_up_boy_this_function_name_is_sure_going_to_make_mackey_smile( 68 );

	exploder_loc( 3, true );
	exploder_loc( 71, true );
	exploder_loc( 72, true );
	exploder_loc( 73, true );

	wait 4.5;
	ai = getaiarray();
	for ( i = 0; i < ai.size; i++ )
	{
		if ( ai[ i ] ishero() )
			continue;
		if ( isdefined( ai[ i ].magic_bullet_shield ) && ai[ i ].magic_bullet_shield )
			ai[ i ] stop_magic_bullet_shield();
		ai[ i ] delete();
	}
	flag_set( "objective_off_the_bridge" );
	flag_set( "objective_cover_on_the_bridge" );
	
	level.hind = create_vehicle_from_spawngroup_and_gopath( 70 )[ 0 ];

	bridge_zakhaev();
}

hindset()
{
	self waittill( "trigger", other );
	level.hind = self;
}


spawn_vehiclegroup_and_go_to_end_node_quick_and_then_blow_up_boy_this_function_name_is_sure_going_to_make_mackey_smile( group )
{
	vehicle_array = create_vehicle_from_spawngroup_and_gopath( group );
	for ( i = 0; i < vehicle_array.size; i++ )
	{
		vehicle_array[ i ] setspeed( 200, 200 );
		vehicle_array[ i ] thread blow_up_at_end_node();
	}
}

disable_bridge_triggers_for_zak_start()
{
	bridge_triggers = getentarray( "bridge_triggers", "script_noteworthy" );
	for ( i = 0; i < bridge_triggers.size; i++ )
	{
		if ( bridge_triggers[ i ].script_vehiclespawngroup == "67"
				 || bridge_triggers[ i ].script_vehiclespawngroup == "66" )
			bridge_triggers[ i ] trigger_off();

	}
}

blow_up_at_end_node()
{
	self waittill( "reached_end_node" );
	self notify( "death" );
}

switch_team_fordamage()
{
	if ( self.vehicletype == "hind" || self.vehicletype == "bmp" )
		return;
	self.script_team = "allies";// so hind can start blowing stuff up
	while ( 1 )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		if ( isdefined( attacker.vehicletype ) && attacker.vehicletype == "hind" && damage > 150 )
			break;
	}
	// they don't normally take damage from anything but the player.
	if ( !isDestructible() )
		return;
	self godoff();
	maps\_destructible::force_explosion();
}

destructible_crumble( attacker )
{
	destructibleparts = level.destructible_type[ self.destuctableInfo ].parts;
	for ( i = 1; i < destructibleparts.size; i++ )
	{
		states = destructibleparts[ i ];
		for ( j = 0; j < states.size; j++ )
		{
			if ( !isdefined( destructibleparts[ i ][ j ].v[ "tagName" ] ) || ! isdefined( destructibleparts[ i ][ j ].v[ "modelName" ] ) ) 
				continue;
			self notify( "damage", 300, attacker, self gettagangles( destructibleparts[ i ][ j ].v[ "tagName" ] ), self gettagorigin( destructibleparts[ i ][ j ].v[ "tagName" ] ), "bullet", destructibleparts[ i ][ j ].v[ "modelName" ], destructibleparts[ i ][ j ].v[ "tagName" ] );
			wait .05;
		}
	}
// 	level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "modelName" ] = modelName;
// 	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "tagName" ] = tagName;
}

end_hind_action()
{
	self waittill( "trigger", other );
	level.hind = other;
	other setlookatent( level.player );
	other setTurretTargetEnt( level.player );
	other SetHoverParams( 40, 20, 15 );

	level.lock_on_player_ent.script_attackmetype = "mg_burst";
	level.lock_on_player_ent unlink();
	level.lock_on_player_ent.origin = level.player geteye();
	level.lock_on_player_ent linkto( level.player );
	wait 3;
	other shootnearest_non_hero_friend();
	wait 3;
	other shootnearest_non_hero_friend();

	other thread shootEnemyTarget( level.lock_on_player_ent );


	lockent = level.lock_on_player_ent;
	lockent unlink();

	other thread refresh_burst( lockent );
	// make the hind get more and more accurate over time.

	accramptime = 12;
	accrampstart = 48;
	accrampend = 4;
	raterampstart = 150;
	raterampend = 250;

	basetime = gettime();
	currenttime = gettime();

	updatetime = .3;

	incs = int( accramptime / updatetime );
	rateinc = ( raterampend - raterampstart ) / incs;
	accinc = ( accrampend - accrampstart ) / incs;

	acc = accrampstart;
	rate = raterampstart;

	for ( i = 0; i < incs; i++ )
	{
		lockent thread movewithrate( random_around_player( acc ), level.player.angles, rate );
		wait updatetime;
		rate += rateinc;
		acc += accinc;
	}
	while ( 1 )
	{
		lockent thread movewithrate( random_around_player( acc ), level.player.angles, rate );
		wait updatetime;
	}
}

refresh_burst( lockent )
{
	lockent endon( "death" );
	self endon( "death" );
	while ( 1 )
	{
		lockent.script_attackmetype = "mg_burst";// hacks abound
		wait 2;
	}
}

random_around_player( offset )
{
	x = -1 * offset + randomfloat( 2 * offset );
	y = -1 * offset + randomfloat( 2 * offset );
	z = 0;
	return level.player.origin + ( x, y, z );
}

ignoreall_for_running_away()
{
	self endon( "death" );
	self.ignoreSuppression = true;
	self.ignoreall = true;

	wait 8;

	self.ignoreSuppression = false;
	self.ignoreall = false;

}

objectives()
{
	flag_init( "objective_off_the_bridge" );
	flag_init( "objective_cover_on_the_bridge" );
	flag_init( "objective_finishedthelevel" );
	objective_add( 1, "active", &"JEEPRIDE_SURVIVE_THE_ESCAPE" );
	objective_current( 1 );
// 	flag_wait( "objective_off_the_bridge" );

// 	objective_state( 1, "done" );
// 	objective_add( 2, "active", &"JEEPRIDE_GET_OFF_THE_BRIDGE", ( -35358, -13448, 473 )  );
// 	objective_current( 2 );

// 	flag_wait( "objective_cover_on_the_bridge" );

// 	objective_state( 1, "done" );
// 	objective_add( 2, "active", &"JEEPRIDE_TAKE_COVER_ON_THE_BRIDGE", ( -35874, -16266, 428 ) );
// 	objective_current( 2 );
	flag_wait( "objective_finishedthelevel" );
	objective_state( 1, "done" );
	
}

end_bmp_action()
{
	self waittill( "trigger", other );
	level.bmp = other;

	array_thread( getentarray( "script_vehicle", "classname" ), ::switch_team_fordamage );
	array_thread( getentarray( "bridge_triggers", "script_noteworthy" ), ::trigger_off );

	array_thread( getaiarray( "allies" ), ::ignoreall_for_running_away );
	flag_set( "objective_cover_on_the_bridge" );

	activate_trigger_with_targetname( "friends_fall_back" );
	thread add_dialogue_line( "Price", "Fall back!" );

	// todo, failsafe this. possible to sprint back and miss the trigger.( make trigger encompass more area )
	array_thread( getentarray( "bridge_triggers2", "script_noteworthy" ), ::trigger_on );

	ai = getaiarray();
	for ( i = 0; i < ai.size; i++ )
	{
		if ( ai[ i ] ishero() )
			continue;
		if ( isdefined( ai[ i ].magic_bullet_shield ) )
			ai[ i ] stop_magic_bullet_shield();
	}
	
	flag_set( "objective_cover_on_the_bridge" );

	thread bridge_blow_trigger();

	other attack_origin_with_targetname( "bmp_target1" );
	wait 2;
	other attack_origin_with_targetname( "bmp_target2" );

	other thread vehicle_turret_think();
}

bridge_blow_trigger()
{
	array_thread( getentarray( "cover_from_heli", "targetname" ), ::trigger_set_cover_from_heli );
	flag_wait( "cover_from_heli" );
	wait 3;
	bridge_zakhaev();
}

trigger_set_cover_from_heli()
{
	self endon( "cover_from_heli" );
	self waittill( "trigger" );
	thread flag_set( "cover_from_heli" );
}

attack_origin_with_targetname( targetname )
{
	origin = getent( targetname, "targetname" ).origin;
	BadPlace_Cylinder( "tanktarget", 4, origin, 750, 300, "allies", "axis" );
	self SetTurretTargetvec( origin );
	self waittill( "turret_on_target" );
	vehicle_fire_main_cannon( 24 );
}

#using_animtree( "generic_human" );

force_position( origin, angles )
{
	if ( !isdefined( angles ) )
		angles = ( 0, 0, 0 );

// 	while ( 1 )
// 	{                      
		self dontinterpolate();
		self animscripted( "forcemove", origin, ( 0, 88, 0 ), %dying_crawl );
// 		self waittillmatch( "forcemove", "end" );
		
// 	}
}

dying_crawl()
{
	self endon( "death" );
	self.holdingWeapon = false;
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
	while ( 1 )
	{
		self animscripted( "dieingcrawl", self.origin, ( 0, 88, 0 ), %dying_crawl );
		self waittillmatch( "dieingcrawl", "end" );
	}
}

angletoplayer()
{
	return vectortoangles( level.player.origin - self.origin );
}

bridge_zakhaev_shock()
{
	level.player ShellShock( "jeepride_zak", 60 );
	
}

create_overlay_element( shader_name, start_alpha )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ( shader_name, 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = start_alpha;
	return overlay;
}

escape_shellshock_heartbeat()
{
	
	level endon("stop_heartbeat_sound");
	interval = -.5;
	while(1)
	{
		level.player play_sound_on_entity("breathing_heartbeat");
		if(interval > 0)
			wait interval;
		interval += .1;
	}
}

blur_overlay( target, time )
{
	setblur( target, time );	
}

escape_shellshock( playerview )
{
	level.player shellshock("jeepride_zak", 20 );	
	playfx(level._effect["player_explode"],level.player geteye());
	
	thread escape_shellshock_vision();
	thread escape_shellshock_heartbeat();
	level.player PlayRumbleOnEntity( "tank_rumble" );
	level thread notify_delay("stop_heartbeat_sound", 18);
	
//	thread set_vision_set( "coup_sunblind", .5 );
	set_vision_set( "jeepride_zak", 1.5 );	
	thread smokey_transition( 1, 2.6, 3 );
	level.player freezecontrols(true);
	level.player takeallweapons();
	wait 1;
	level.player freezecontrols( false );
	level.player playerlinktoabsolute( playerview, "tag_player" );
	level.player PlayerLinkToDelta( playerview, "tag_player", 1, 5, 5, 5, 5 );
	wait 3;
	
}

exp_fade_overlay( target_alpha, fade_time )
{
	self notify("exp_fade_overlay");
	self endon("exp_fade_overlay");
	
	fade_steps = 4;
	step_angle = 90 / fade_steps;
	current_angle = 0;
	step_time = fade_time / fade_steps;

	current_alpha = self.alpha;
	alpha_dif = current_alpha - target_alpha;

	for ( i=0; i<fade_steps; i++ )
	{
		current_angle += step_angle;

		self fadeOverTime( step_time );
		if ( target_alpha > current_alpha )
		{
			fraction = 1 - cos( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}
		else
		{
			fraction = sin( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}

		wait step_time;
	}
}

escape_shellshock_vision()
{
	
//	black_overlay = create_overlay_element( "overlay_hunted_black", 0 );
//		
//	//blinking
//	black_overlay delayThread(1.5, ::exp_fade_overlay, 1, .5 );
//	black_overlay delayThread(2.25, ::exp_fade_overlay, 0, .5 );
//	
//	black_overlay delayThread(3, ::exp_fade_overlay, .5, .25 );
//	black_overlay delayThread(3.25, ::exp_fade_overlay, 0, .25 );	
//	
//	black_overlay delayThread(5, ::exp_fade_overlay, 1, .5 );
//	black_overlay delayThread(6, ::exp_fade_overlay, 0, .5 );
	                          
	//blurring
	delayThread(.75, ::blur_overlay, 4.8, .5);
	delayThread(1.25, ::blur_overlay, 0, 4);
	
	delayThread(4.25, ::blur_overlay, 4.8, 2);
	delayThread(4.45, ::blur_overlay, 0, 2);
	
	//breathing sounds
	level.player delayThread(1.5, ::play_sound_on_entity, "breathing_hurt_start");
	level.player delayThread(2.5, ::play_sound_on_entity, "breathing_hurt");
	level.player delayThread(4, ::play_sound_on_entity, "breathing_hurt");
	level.player delayThread(5, ::play_sound_on_entity, "breathing_hurt");
	
	level.player delayThread(13, ::play_sound_on_entity, "breathing_better");
	level.player delayThread(16, ::play_sound_on_entity, "breathing_better");
	
	wait 24;

//	black_overlay destroy();
}


bridge_zakhaev()
{
	if ( getdvar( "jeepride_nobridgefx" ) == "off" )
		exploder_loc( 142 );
		

	array_thread( getfxarraybyID( "hawks" ), ::pauseEffect );
	array_thread( getfxarraybyID( "cloud_bank_far" ), ::pauseEffect );

	remove_all_weapons();
	
	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	
	node = getent( "player_drag_node", "targetname" );
	node anim_first_frame_solo( playerview, "drag_player" );

	flag_set( "music_zak" );
	escape_shellshock( playerview ); //borrowed from cargoship
//	set_vision_set( "jeepride_zak", .5 );
	level.player ShellShock( "jeepride_zak", 60 );
	wait .5;
	
	ai = getaiarray();
	for ( i = 0; i < ai.size; i++ )
	{
		if ( ai[ i ] ishero() )
			continue;
		if ( isdefined( ai[ i ].magic_bullet_shield ) )
			ai[ i ] stop_magic_bullet_shield();
		ai[ i ] delete();
	}
	

	if ( level.start_point != "bridge_zak" )
	{
		level.hind notify( "gunner_new_target" );// stop shooting
		level.bmp notify( "stop_thinking" );
	}
	
	set_vision_set( "jeepride_zak", .5 );

	level.player SetDepthOfField( 6, 148, 3100, 19999, 4.4, 1.65 );
//	level.player takeallweapons();
	
	zak_price_spot = getent( "zak_price_spot", "targetname" );
	level.price thread force_teleport( zak_price_spot.origin, zak_price_spot.angles );

	

	setsaveddvar( "sM_sunSampleSizeNear", .16 );

	level.player allowcrouch( false );
	level.player allowprone( false );
	
	level.gaz stop_magic_bullet_shield();
	gazdummy = level.gaz maps\_vehicle_aianim::convert_guy_to_drone( level.gaz );
	gazdummy.origin = getent( "zak_gaz_spot" , "targetname" ).origin;
	gazdummy fakeout_donotetracks_animscripts();
	gazdummy.a.script = "griggsshootingandbeingcool";// mad hacks
	detach_models_with_substr( gazdummy, "weapon_" );

	level.griggs stop_magic_bullet_shield();
	griggsdummy = level.griggs maps\_vehicle_aianim::convert_guy_to_drone( level.griggs );
	griggsdummy.animname = "griggs";
	griggsdummy SetAnimTree();
	anim.fire_notetrack_functions[ "griggsshootingandbeingcool" ] = ::shoot_loc;
	griggsdummy fakeout_donotetracks_animscripts();
	griggsdummy.a.script = "griggsshootingandbeingcool";// mad hacks
	detach_models_with_substr( griggsdummy, "weapon_" );
	griggsdummy attach( "weapon_colt1911_white", "tag_weapon_right" );
	griggsdummy.scriptedweapon = "weapon_colt1911_white";
	
	
	level.price stop_magic_bullet_shield();
// 	weapon = level.price.primaryweapon;
	pricedummy = level.griggs maps\_vehicle_aianim::convert_guy_to_drone( level.price );
	pricedummy.animname = "price";
	pricedummy SetAnimTree();
	pricedummy fakeout_donotetracks_animscripts();
	pricedummy.a.script = "griggsshootingandbeingcool";// mad hacks
	detach_models_with_substr( pricedummy, "weapon_" );
	pricedummy attach( "weapon_colt1911_white", "tag_weapon_right" );

	endprice_actors[ 0 ] = pricedummy;
	

	enddrag_actors[ 0 ] = griggsdummy;
	enddrag_actors[ 1 ] = playerview;

	delaythread( 2, ::lerp_fov_overtime, 5, 55 );	
	thread bridge_zak_friendly_attack_heli();
	
	waittillframeend;

	node thread anim_single( enddrag_actors, "drag_player" );
	
	zak_price_spot thread anim_single( endprice_actors, "drag_player" );
	
	thread bridge_zak_slomo_script_timed( griggsdummy );

	playerview waittillmatch( "single anim", "start_price" );
	
	zak_price_spot thread anim_single( endprice_actors, "jeepride_ending_price01" );
	
	playerview waittillmatch( "single anim", "start_approach" );

	zakhaev = getent( "zakhaev", "targetname" ) stalingradspawn();
	assert( !spawn_failed( zakhaev ) );
	zakhaev.animname = "zakhaev";
	zakhaev.dropweapon = false;

	zakhaev_buddy1 = getent( "zakhaev_buddy1", "targetname" ) stalingradspawn();
	assert( !spawn_failed( zakhaev_buddy1 ) );
	zakhaev_buddy1.animname = "zakhaev_buddy1";

	zakhaev_buddy2 = getent( "zakhaev_buddy2", "targetname" ) stalingradspawn();
	assert( !spawn_failed( zakhaev_buddy2 ) );
	zakhaev_buddy2.animname = "zakhaev_buddy2";
	
	end_friend_1 =  gazdummy;
	end_friend_1.animname = "end_friend_1";
	
	end_scene_actors = [];
	end_scene_actors[ 0 ] = zakhaev;
	end_scene_actors[ 1 ] = zakhaev_buddy1;
	end_scene_actors[ 2 ] = zakhaev_buddy2;
	thread bridge_zak_guys_dead( end_scene_actors );
	for ( i = 0; i < end_scene_actors.size; i++ )
		end_scene_actors[ i ].health = 20;
		
	level.player thread one_hit_player_kill();
	
	end_scene_actors[ 3 ] = end_friend_1;
	level.attack_helidummy notsolid();
	node thread anim_single_solo( level.attack_helidummy, "end_scene_01" );
	node thread anim_single( end_scene_actors, "end_scene_01" );
	
	flag_set("attack_heli");
	
	

	playerview waittillmatch( "single anim", "start_price" );

	zak_price_spot thread anim_single( endprice_actors, "jeepride_ending_price02" );
	
	playerview waittillmatch( "single anim", "start_end" );

	level.player PlayerLinkToDelta( playerview, "tag_player", 1, 45, 45, 45, 45 );
	level.player giveWeapon( "colt45" );
	level.player giveMaxAmmo( "colt45" );
	level.player switchtoweapon( "colt45" );
	
	end_scene_actors = array_remove( end_scene_actors, end_friend_1 );
	
	node thread anim_single( end_scene_actors, "end_scene_02" );
	
	playerview waittillmatch( "single anim", "end" );
}

one_hit_player_kill()
{
	level.player waittill( "damage" );
	level.player enableHealthShield( false );
	radiusDamage( level.player.origin, 8, level.player.health + 5, level.player.health + 5 );
	level.player enableHealthShield( true );
	
}

bridge_zak_friendly_attack_heli()
{
	level.hind thread vehicle_paths( getent("hind_roll_in","script_noteworthy") );
	level.hind SetLookAtEnt(level.player);
	level.attack_heli = create_vehicle_from_spawngroup_and_gopath( 71 )[ 0 ];
//	level.attack_heli setspeed(0,60);
	level.attack_heli stopenginesound();
	level.attack_helidummy = level.attack_heli vehicle_to_dummy();
	level.attack_helidummy hide();
	level.attack_helidummy.animname = "mi28";
	level.attack_helidummy setanimtree();
	
	flag_wait("attack_heli");
	
	level.attack_helidummy show();

	wait 12.25;

//	level.attack_heli = create_vehicle_from_spawngroup_and_gopath( 71 )[ 0 ];
	assert( isdefined( level.hind ) );
	level.attack_heli SetLookAtEnt( level.hind );
	level.hind SetLookAtEnt( level.attack_heli );
	
	level.hind godoff();
	
	level.hind clearlookatent();
	
	attachment = spawn("script_origin",level.hind.origin+(0,0,-70));
	attachment linkto (level.hind);

	attachment.oldmissiletype = false;
	attachment.script_attackmetype = "missile";
	attachment.shotcount = 3;
	level.attack_heli thread shootEnemyTarget( attachment );
	
	wait 1.7;
	attachment delete();
	
// 	flag_set( "hind_killed" );
}


bridge_zak_guys_dead( guys )
{
	waittill_dead_or_dying( guys );
	flag_set( "all_end_scene_guys_dead" );
}

shot_in_the_head()
{
	// I don't know. 	
	org = self gettagorigin( "TAG_EYE" );
	angles = self gettagangles( "TAG_EYE" );
	PlayFX( level._effect[ "griggs_brains" ], org, vector_multiply( anglestoup( angles ), 1 ) );
// 	PlayFXOnTag( level._effect[ "griggs_brains" ], self, "TAG_EYE"  );
}

bridge_zak_slomo_script_timed( griggsdummy )
{
	maps\_cheat::slowmo_system_init();
	level.slowmo.speed_slow = 0.4;
	level.slowmo thread maps\_cheat::gamespeed_slowmo();

	wait 13.4;
	griggsdummy thread shot_in_the_head();
	
	level.slowmo.speed_slow = 0.25;
	level.slowmo thread maps\_cheat::gamespeed_slowmo();

	wait 1.2;

//	level.slowmo.lerp_time_in = 0.25;
//	level.slowmo.lerp_time_out = 0.5;

	//turn to price
	level.slowmo.speed_slow = 0.4;
	level.slowmo thread maps\_cheat::gamespeed_slowmo();

	wait 6.7;
	
	//now focused on enemies walking up
	level.slowmo.speed_slow = 0.8;
	level.slowmo thread maps\_cheat::gamespeed_slowmo();

	wait 11.2;

	//helicopter blows up, now panning back to price
	level.slowmo.speed_slow = 0.45;
	level.slowmo thread maps\_cheat::gamespeed_slowmo();
	
	wait 6.2;

	level.slowmo.speed_slow = 0.35;
	level.slowmo thread maps\_cheat::gamespeed_slowmo();
	
	wait 2.1;
	
	//player has gun;
	level.slowmo.speed_slow = 0.45;
	level.slowmo thread maps\_cheat::gamespeed_slowmo();
		
	flag_wait( "all_end_scene_guys_dead" );
	flag_set("rescue_choppers");

	level.slowmo.speed_slow = 0.25;
	level.slowmo thread maps\_cheat::gamespeed_slowmo();
	
	wait 10;
	
	level.slowmo.lerp_time_out = 3.5;
	level.slowmo thread maps\_cheat::gamespeed_reset();
	maps\_cheat::slowmo_system_init();// reset defaults

//	wait 1;	
//	level.player stopshellshock();
	
}

fakeout_donotetracks_animscripts()
{
	self.a = spawnstruct();// I just want to donotetracks on a dummy.. asdfaskdjfaksjdflisjdflkjl
	self.a.lastShootTime = gettime();
	self.a.bulletsinclip = 500;
	self.weapon = "colt45";
	self.primaryweapon = "colt45";
	self.secondaryweapon = "colt45";
	self.a.isSniper = false;
	self.a.misstime = false;
	self.weapon = "none";	
	// hahahaha. sigh. This seemed like it was going to be easy. in my defense. I'm delerious
}

shoot_loc()
{
// 	self shoot();
	// playfx? I don' know. guess best to ma
	// ganked from assman for colt45.. l33t hax
	if ( self.scriptedweapon == "weapon_colt1911_white" )
	{
		PlayFXOnTag( level._effect[ "griggs_pistol" ], self, "TAG_FLASH" );
		thread play_sound_on_tag( "weap_m1911colt45_fire_npc", "TAG_FLASH" );
	}
	else
	{
		PlayFXOnTag( level._effect[ "griggs_saw" ], self, "TAG_FLASH" );
		thread play_sound_on_tag( "weap_m249saw_fire_npc", "TAG_FLASH" );
	}
	
}

force_teleport( origin, angles )
{
	linker = spawn( "script_model", origin );
	linker setmodel( "fx" );
	self linkto( linker );
	self teleport( origin, angles );
	self unlink();
	linker delete();
}


price_bridge_crawl_anims( node )
{
	node anim_single_solo( level.price, "wave_player_over" );
	level.price animscripted( "animscripted", level.price.origin, level.price.angles, %stand2crouch_attack );
	level.price waittillmatch( "animscripted", "end" );
// 	level.price animscripted( "animscripted", level.price.origin, level.price.angles, %crouch_pain_holdstomach );
// 	level.price waittillmatch( "animscripted", "end" );
	level.price animscripted( "animscripted", level.price.origin, level.price.angles, %crouch2stand );
	level.price waittillmatch( "animscripted", "end" );
}

clouds_off()
{
	self waittill( "trigger" );
	array_thread( getfxarraybyID( "cloud_bank_far" ), ::pauseEffect );
}

clouds_on()
{
	self waittill( "trigger" );
	array_thread( getfxarraybyID( "cloud_bank_far" ), ::restartEffect );
}