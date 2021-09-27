#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_audio;
#include maps\_audio_zone_manager;
#include maps\_audio_mix_manager;
#include maps\_audio_reverb;
#include maps\_audio_music;
#include maps\_audio_dynamic_ambi;
#include maps\_shg_fx;
#include maps\_audio_vehicles;
#include maps\_audio_stream_manager;
#include maps\_shg_common;



main()
{
	PrecacheMinimapSentryCodeAssets();
	SetSavedDVar("compassMaxRange", 4500); // default was 3500
	maps\createart\paris_ac130_art::main();
	maps\so_killspree_paris_a_precache::main();
	maps\_shg_common::so_mark_class( "trigger_multiple_visionset" );
	
	precachemodel( "viewhands_juggernaut_ally" );
	
	//PrecacheMinimapSentryCodeAssets();
	precacheitem ( "air_support_strobe" );
	precacheitem ( "ak47_acog" );
	precacheitem ( "ak47_grenadier" );
	precacheitem ( "iw5_riotshield_so" );

	//Strings
	PreCacheString( &"SO_KILLSPREE_PARIS_A_COLLECT_CHEMICAL_SAMPLES" );
	PreCacheString( &"SO_KILLSPREE_PARIS_A_FAILED_TO_COLLECT_SAMPLE" );
	PreCacheString( &"SO_KILLSPREE_PARIS_A_LEAVING_WARNING" );
	PreCacheString( &"SO_KILLSPREE_PARIS_A_SAMPLE" );
	
	maps\_shg_common::so_vfx_entity_fixup( "msg_fx" );
	flag_init( "flag_little_bird_landed" );
	maps\paris_a_fx::main();
	
	//Ambient Audio from SP
	maps\_shg_common::so_mark_class( "trigger_multiple_audio" );
	
	if( !flag_exist( "flag_ac130_moment_complete" ) )
	{
		flag_init( "flag_ac130_moment_complete" );
	}
	maps\paris_aud::main();
	
	level.enemy_air_support_marker_fx = LoadFx( "smoke/signal_smoke_air_support_enemy" );		
	level.enemy_air_support_trail_fx = LoadFx( "smoke/smoke_geotrail_air_support_enemy" );			
	
	so_delete_all_vehicles();
	so_delete_all_spawners();
	so_delete_all_triggers();
	
	maps\_load::main();
	//maps\paris_aud::main();
	maps\_air_support_strobe::main();
	maps\so_killspree_paris_a_vo::main();
	maps\_compass::setupMiniMap( "compass_map_paris_a" );
		
	//AC130 Strobe tuning values current gameplay is based on these values, 
  	level.strobe_cooldown_override = 60;
  	level.strobe_firedelay_override = 1;
	
	flag_init ( "main_street_dudes" );
	flag_init ( "samples_collected" );
	flag_init ( "sample_vo_line_good" );
	
	
	add_hint_string("air_support_hint", &"SO_KILLSPREE_PARIS_A_HINT_AIR_SUPPORT", ::using_strobe);
	
	setup();
	gameplay_logic();
	music();

}

setup()
{
	
	
	thread enable_challenge_timer( "so_killspree_paris_a_start", "so_killspree_paris_a_complete" );
	thread fade_challenge_in( 0, false );
	thread fade_challenge_out( "so_killspree_paris_a_complete" );
	
	//Blocking objects from SP
	blocker = getent("blocker_restaurant", "script_noteworthy");
	blocker	delete();
	
	blocker = getent ("blocker_rooftops", "script_noteworthy");
	blocker	delete();
	
	blocker = getent("blocker_bookstore_exit", "script_noteworthy");
    blocker  delete();

	blocker = getent( "book_store_path_blocker", "targetname" );
	blocker disconnectpaths();
	
	sample_collision = getentarray( "sample_collision", "targetname" );
	foreach( sample in sample_collision )
		sample disconnectpaths();
	
	//so the ai juggernaut script doesnt assert
	level.pmc_alljuggernauts = false;
	
	setsaveddvar("player_damageMultiplier", .5);			//default 1
	setsaveddvar("player_radiusdamageMultiplier", .1); 		//default is 1
	setsaveddvar("player_meleedamageMultiplier", .2); 		//default is .4
	setsaveddvar( "mantle_enable", 0 ); 					//disable mantles
	

	
	foreach(p in level.players)
	{
		p setweaponammostock ( "m320" , 6 ); 
		p makeJuggernaut();
	
		//how much damge to ignore when hit in front true_dmg = dmg * front_armor 
		p.juggernaut_front_armor = .85;
	
		//how much before we start taking damage.  does not regen
		p.bullet_armor = 500;
	
		//what our health has to be to allow death by grenade / explosion
		p.allowexplodedeath_health = 20;
	
		//p thread Handle_Juggernaut_Health();
		p.grenadeTimers[ "air_support_strobe_ai" ] = 0;
		
		p maps\_air_support_strobe::enable_strobes_for_player();
		
		p thread aud_monitor_player_impacts();
		
		p thread air_support_strobe_ready_dialogue();
		
		p.bonus_1 = 0;
		p.bonus_2 = 0;
		
		p setviewmodel( "viewhands_juggernaut_ally" );

	}
	
	//for xp bonus
	CONVERT_MIN_TO_MILLI_SEC = 60 * 1000;
	    
	level.so_mission_worst_time    = 15 * CONVERT_MIN_TO_MILLI_SEC;
	level.so_mission_min_time        = 2.5 * CONVERT_MIN_TO_MILLI_SEC;

	level.bonus_1_max = 50;
	level.bonus_2_max = 50;
	maps\_shg_common::so_eog_summary("@SO_KILLSPREE_PARIS_A_MELEE_KILLS", 100, level.bonus_1_max, "@SO_KILLSPREE_PARIS_A_AIRSTRIKE_KILLS", 100, level.bonus_2_max);
	array_thread ( level.players, ::enable_challenge_counter, 3, &"SO_KILLSPREE_PARIS_A_MELEE_KILLS_TICKER", "bonus1_count" );
	array_thread ( level.players, ::enable_challenge_counter, 4, &"SO_KILLSPREE_PARIS_A_AIRSTRIKE_KILL_TICKER", "bonus2_count" );
	//level.giveXp_kill_func = maps\so_killspree_paris_a::giveXp_kill_a;
	level.player1_melee_kills = 0;
	level.player2_melee_kills = 0;
	add_global_spawn_function( "axis", ::monitor_melee_death );
	add_global_spawn_function( "axis", ::monitor_airstrike_death );
	
	
	//Audio
	set_stringtable_mapname("shg");
	aud_set_occlusion("med_occlusion");
	aud_set_timescale();
	maps\paris_a_vo::prepare_dialogue();
	thread air_support_strobe_fired_dialogue();
		
	mm_add_submix("dubai_level_global_mix");
	mm_add_submix("dubai_mute_player_impact");

	add_global_spawn_function ( "axis", ::enemy_strobe_monitor );
	
	anim.grenadeTimers[ "AI_air_support_strobe_ai" ] = 0;
	
	//Player Containment 
	thread enable_escape_warning();
	thread enable_escape_failure();			
}

gameplay_logic()
{	
	sample_setup();
	crumb_setup();
	setup_vo();
	thread objectives();
	thread intro();
	thread air_support_strobe_hint();
	thread sewer_dudes4();
	thread sample1_dudes();
	thread sample2_dudes();
	thread main_street_dudes();
	thread explosion_scene();
	thread street_dudes3();
	thread alley_gaz();
	thread street_dudes2();
	thread down_stairs_dudes ();
	thread top_street_gaz ();
	thread kit_flood_dudes ();
	thread kit_sample_dudes ();
	thread backstreet_dudes ();
	thread juggernaut_back_alley ();
	thread bookstore_stairs_dudes ();
	thread bookstore_bottom_dudes ();
	thread bookstore_helispawn ();
	thread outsidebookstore_helispawn ();
	thread bookstore_courtyard_dudes ();
	thread hotel_stairs_dudes ();
	thread top_hotel_stairs_dudes ();
	thread top_hotel_stairs_dudesB ();
	thread littlebird_exit ();
	
	thread forced_magic_strobes( "strobe_org", "strobe_dest", "first_strobe" );
	thread forced_magic_strobes( "strobe_orgA", "strobe_destA", "first_strobeA" );
	thread forced_magic_strobes( "strobe_org2", "strobe_dest2", "kit_flood_dudes" );
	//thread forced_magic_strobes( "strobe_org3", "strobe_dest3", "backstreet_dudes" );
	thread forced_magic_strobes( "books_strobe_org", "books_strobe_dest", "outsidebookstore_gaz" );

}

music()
{
	AZM_start_zone("pars_ac130_strobe_street");
	
	//intro music
	MUS_play("so_pars_ledge_walk", 3);
	
	//climbing stairway music switch
 	flag_wait ( "stairwaytoheaven" );
	MUS_play ( "so_pars_first_contact", 2 );
	
	//back alley / bookstore switch
	flag_wait ( "bookstoretango" );
	MUS_play ( "so_pars_enter_book_store", 2 );
	
	//player is getting the sample at the top of the bookstore
	flag_wait ( "bookstore_sample_music" );
	MUS_play ( "so_pars_first_contact", 2 );
}

objectives()
{
	thread monitor_samples();
	
	objective_add( obj( "obj_pick_up_samples" ), "current", &"SO_KILLSPREE_PARIS_A_COLLECT_CHEMICAL_SAMPLES" );
	objective_string_nomessage( obj( "obj_pick_up_samples" ), &"SO_KILLSPREE_PARIS_A_COLLECT_CHEMICAL_SAMPLES_REMAINING", level.samples_left );
	objective_current( obj( "obj_pick_up_samples" ) );
	
	obj_samples(0);
	obj_crumb(0);
	obj_samples(1);
	obj_crumb(1);
	obj_samples(2);
	
	objective_complete ( obj("obj_pick_up_samples" ) );
	flag_set ( "samples_collected" );
	
	thread obj_escape();
	
	radio_dialogue ( "so_parisa_hqr_inboundforexfil" );
	
	lines = [];
	lines [ lines.size ] = "so_parisa_hqr_gettorooftop";
	lines [ lines.size ] = "so_parisa_hqr_exfilwaiting";
	thread dialogue_reminder ( "radio", "so_killspree_paris_a_complete", lines );
	
	
}

sample_setup()
{	
	assert(!isdefined(level.triggers));
	level.triggers = getentarray ( "trigger_sample", "targetname" );
	
	assert(!isdefined(level.samples_total));
	level.samples_total = level.triggers.size;
	level.samples_left = level.triggers.size;
	
	for ( i = 0; i < level.triggers.size; i++ )
	{
		//to make sure we have set up all our triggers correctly
		//add (key) script_index (value) some_number to make the assert go away
		//assert(isdefined(level.triggers[i].script_index));
		level.triggers [ i ] sethintstring ( &"SO_KILLSPREE_PARIS_A_SAMPLE" );
		level.triggers [ i ] thread sample_monitor();
	}
}

crumb_setup()
{
	assert(!isdefined(level.crumbs));
	level.crumbs = getentarray ( "trigger_crumb", "targetname" );
	
	for ( i = 0; i < level.crumbs.size; i++ )
	{
	//assert(isdefined(level.crumbs[i].script_index));
		level.crumbs [ i ] trigger_off();
		level.crumbs [ i ] thread crumb_monitor();
	}
	
}

obj_crumb(script_idx)
{
	triggers_this_group = 0;
	foreach( t in level.crumbs )
	{
		if(isdefined(t.script_index) &&t.script_index == script_idx)
		{
			t trigger_on();
			objective_additionalposition ( obj("obj_pick_up_samples" ), triggers_this_group, t.origin );
			t.obj_idx = triggers_this_group;
			triggers_this_group++;
			//wait 0.1;
		}
	}

	crumbs_left_this_group = triggers_this_group;
	while ( crumbs_left_this_group > 0 )
	{
		level waittill ( "crumb_reached", from );
		crumbs_left_this_group--;
		
		assert(isdefined(from.obj_idx));
		objective_additionalposition ( obj("obj_pick_up_samples" ), from.obj_idx, (0,0,0) );
	}
	
}

obj_samples(script_idx)
{	
	

	//global samples left for now
	delete_escape_warning_when_group_complete = [
		[0, "escape_trigger_1"],
		[1, "escape_trigger_2"],
		[2, "escape_trigger_3"]
	];
	
	triggers_this_group = 0;
	foreach( t in level.triggers )
	{
		if(isdefined(t.script_index) && t.script_index == script_idx)
		{
			objective_additionalposition ( obj("obj_pick_up_samples" ), triggers_this_group, t.origin );
			t.obj_idx = triggers_this_group;
			triggers_this_group++;
			wait 0.1;
		}
	}

	samples_left_this_group = triggers_this_group;
	while ( samples_left_this_group > 0 )
	{
		level waittill ( "sample_pickedup", who );
		level.samples_left--;
		level notify( "sample_pickedup_updated" );
		//update objective number
		
		samples_left_this_group--;
		
		assert(isdefined(who.obj_idx));
		objective_additionalposition ( obj("obj_pick_up_samples" ), who.obj_idx, (0,0,0) );	
	}
	
	//disable triggers for failure on group complete only
	disable_escape_triggers(delete_escape_warning_when_group_complete, script_idx);
}


monitor_samples()
{	
	//level.jugg_player endon ("death");
	
	level.ieds_defused = 0;
	
	level.ieds_title = so_create_hud_item( -3, so_hud_ypos(), &"SO_KILLSPREE_PARIS_A_SAMPLES_REMAINING" );
	level.ieds_count = so_create_hud_item( -3, so_hud_ypos(), undefined );
	level.ieds_count.alignx = "left";
	level.ieds_count SetValue( level.samples_total );
	while ( true )
	{
		level waittill ( "sample_pickedup_updated" );
		
		level.ieds_title thread so_hud_pulse_success();
		level.ieds_count thread so_hud_pulse_success();
		
		level.ieds_count SetValue( level.samples_left );
		objective_string_nomessage( obj( "obj_pick_up_samples" ), &"SO_KILLSPREE_PARIS_A_COLLECT_CHEMICAL_SAMPLES_REMAINING", level.samples_left );
	}
}

disable_escape_triggers(data_arr, idx)
{
	foreach(d in data_arr)
	{
		if(d[0] == idx)
		{
			disable_arr = getentarray(d[1], "targetname");
			array_thread(disable_arr, ::trigger_off);
			break;
		}
	}
}

obj_escape()
{
	flag_wait ( "samples_collected" );
	//wait 2;
	
	objective_number = 2;
 	objective_add( objective_number, "active", &"SO_KILLSPREE_PARIS_A_EXTRACTION" );
 	objective_current( objective_number );
 	objective_position( objective_number, getstruct( "crumb1", "targetname" ).origin );
	
	flag_wait ( "breadcrumbA" );
	//wait ( .1 );
	objective_position( objective_number, getstruct( "crumb2", "targetname" ).origin );
	
	flag_wait ( "breadcrumbB" );
	//wait ( .1 );
	objective_position( objective_number, getstruct( "crumb3", "targetname" ).origin );
	
	flag_wait ( "breadcrumbC" );
	//wait ( .1 );
	objective_position( objective_number, getstruct( "crumb4", "targetname" ).origin );
	
	flag_wait ( "breadcrumbD" );
	//wait ( .1 );
	objective_position( objective_number, getstruct( "crumb5", "targetname" ).origin );
	
	flag_wait ( "breadcrumbE" );
	//wait ( .1 );
	objective_position( objective_number, getstruct( "crumb6", "targetname" ).origin );
	
	flag_wait ( "end_level" );
	objective_complete ( objective_number );
		
	if( !flag( "missionfailed" ) )
		flag_set ( "so_killspree_paris_a_complete" );
}

sample_monitor()
{
	collected = false;
	while ( !collected )
	{		
		self waittill ( "trigger", triggerer );
	
		collect_time = 3;
		collected = self maps\_shg_common::progress_bar( triggerer, ::sample_collected, collect_time, &"SO_KILLSPREE_PARIS_A_COLLECTING", &"SO_KILLSPREE_PARIS_A_SAMPLE_COLLECTED", undefined, &"SO_KILLSPREE_PARIS_A_SAMPLE_NOT_COLLECTED" );
	}
	
	self Delete();
}

crumb_monitor()
{
	self waittill ( "trigger", triggerer );

	level notify("crumb_reached", self);
}

sample_collected()
{
	level notify( "sample_pickedup", self );			
	self trigger_off();
}


//Juggernaut Functions
makeJuggernaut()
{
	assert(isplayer(self));
	
	//health regen
	//self.gs.playerHealth_RegularRegenDelay = ( 50 );
	//self.gs.longregentime = ( 50 );
	self blend_MoveSpeedscale_Percent( 65 );
	self setviewkickscale ( .6 );

	//movement restrictions
	self AllowJump( false );
	//self AllowSprint( false );
	self AllowProne ( false );
	//self AllowCrouch ( false );

	//visuals
	SetHUDLighting( true );
	self.juggernautOverlay = newClientHudElem( self );
	self.juggernautOverlay.x = 0;
	self.juggernautOverlay.y = 0;
	self.juggernautOverlay.alignX = "left";
	self.juggernautOverlay.alignY = "top";
	self.juggernautOverlay.horzAlign = "fullscreen";
	self.juggernautOverlay.vertAlign = "fullscreen";
	self.juggernautOverlay setshader ( "juggernaut_overlay", 640, 480 );
	self.juggernautOverlay.sort = -10;
	self.juggernautOverlay.archived = true;
	self.juggernautOverlay.hidein3rdperson = true;

	self setViewmodel( "viewmodel_base_viewhands" );
	self setmodelfunc( ::make_jug_model );
}

make_jug_model()
{
	self setModel("mp_fullbody_ally_juggernaut");
}

explosion_scene()
{
	flag_wait ( "bomber_start" );
	wait 8;
	DoExplosion("expo_1");
	wait (0.1);
	
	DoExplosion("expo_2");
	wait (0.2);

	DoExplosion("expo_3");
	wait (0.3);
	
	DoExplosion("expo_4");
	wait (0.1);
	
	DoExplosion("expo_4b");
	wait (0.1);
	
	DoExplosion("expo_4c");
	wait (0.2);
	
	DoExplosion("expo_5");
	wait (0.2);
	
	DoExplosion("expo_6");
	wait (0.2);

	DoExplosion("expo_7");
}

DoExplosion( tname )
{
	obj_loc = GetEnt( tname, "targetname" );
	assert(isdefined(obj_loc));
	
	//where, radius, max_dmg, min_dmg
	radiusdamage(obj_loc.origin, 128, 512, 512);
	wait(.1);
	radiusdamage(obj_loc.origin, 128, 512, 512);
	wait(.1);
	radiusdamage(obj_loc.origin, 128, 512, 512);
	wait(.1);
	radiusdamage(obj_loc.origin, 128, 512, 512);
}

playerBreathingSound()
{
	level.healthOverlayCutoff = .55;
	assert(isdefined(level.healthOverlayCutoff));

	wait( 2 );

	for ( ;; )
	{
		wait( 0.2 );
		if ( self.health <= 0 )
			return;

		// Player still has a lot of health so no breathing sound
		ratio = self.health / self.maxHealth;
		if ( ratio > level.healthOverlayCutoff )
			continue;

		level.player play_sound_on_entity( "breathing_hurt" );
		wait( 0.1 + randomfloat( 0.8 ) );
	}
}

//Strobe Related
forced_magic_strobes( org, dest, wait_flag )
{
	flag_wait ( wait_flag );
	strobe_org = getent ( org, "targetname" );
	assert(isdefined(strobe_org));
	strobe_dest = getent ( dest, "targetname" );
	assert(isdefined(strobe_dest));
	strobe = magicgrenade ( "air_support_strobe", strobe_org.origin, strobe_dest.origin );
	wait .05;
	strobe thread maps\_air_support_strobe::strobe_think( true );
}

enemy_strobe_monitor()
{
	self endon ( "death" );
	
	while ( true )
	{
		self waittill("grenade_fire", strobe, weaponName);
		if ( weaponName == "air_support_strobe_ai" )
		{
			strobe thread maps\_air_support_strobe::strobe_think( true );
		}
	}
}

// All AI that are not spawned from a vehicle

flood_spawner_scripted_on_flag( waitfor, spawner_arr_tname, killspawner_num )
{
	flag_wait( waitfor );
	spawners = getentarray ( spawner_arr_tname, "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
	
	if(isdefined(killspawner_num))
		maps\_spawner::killspawner(killspawner_num);
}

intro ()
{
	littlebird = spawn_vehicle_from_targetname_and_drive ( "bird1" );
	littlebird thread monitor_friendly_helicopter();
	
}

monitor_friendly_helicopter()
{
	level endon( "end_level" );
	while( isdefined( self ) )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, dFlags, weaponName );
		if( weaponName == level.air_support_weapon )
		{
			self notify( "death" );
			wait 2;
			maps\_specialops_code::so_special_failure_hint_set( "@DEADQUOTE_SO_FRIENDLY_FIRE_KILL", "ui_ff_death" );
			missionfailedwrapper();
		}
		wait .05;
	}
}


air_support_strobe_hint()
{
	wait 3;
	foreach(p in level.players)
	{
		p thread show_air_support_hint();
	}
}

littlebird_exit ()
{
	flag_wait ( "littlebird_exit" );
	littlebird = spawn_vehicle_from_targetname_and_drive ( "bird2" );
	
	littlebird thread monitor_friendly_helicopter();
}

sewer_dudes4()
{
	flag_wait( "so_killspree_paris_a_bt1" );
	spawners = getentarray( "spawner04", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

sample1_dudes()
{
	flag_wait( "sample1_dudes" );
	spawners = getentarray( "sample1_dudes", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

sample2_dudes()
{
	flag_wait( "sample2_dudes" );
	spawners = getentarray( "sample2_dudes", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

main_street_dudes ()
{	
 	flag_wait ( "main_street_dudes" );
	spawners = getentarray ( "spawner04a", "targetname" );
	/*
	foreach (spawner in spawners)
	{
		spawner.count = 1;
	}
	*/
	maps\_spawner::flood_spawner_scripted( spawners );
	/*
	while (1)
	{
		if ( !flag ("main_street_dudes" ))
		{
		 	foreach (spawner in spawners)
		 	{
		 	spawner.count = 0;
		 	}
		 	thread main_street_dudes();
		 	break;
		}
		wait 10;
	}*/
}

street_dudes3()
{
	flag_wait ( "street_dudes3" );
	spawners = getentarray ( "spawner03", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

alley_gaz()
{
	flag_wait ( "alley_gaz" );
	spawn_vehicle_from_targetname_and_drive ( "gaz01" );
}

street_dudes2()
{
	flag_wait ( "alley_dudes" );
	spawners = getentarray ( "spawner02", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

down_stairs_dudes ()
{
	flag_wait ( "down_stairs_dudes" );
	spawners = getentarray ( "spawner01", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

top_street_gaz ()
{
	flag_wait ( "top_street_gaz" );
	spawn_vehicle_from_targetname_and_drive ( "gaz03" );
}

kit_flood_dudes ()
{
	flag_wait ( "kit_flood_dudes" );
	spawners = getentarray ( "spawner00", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

kit_sample_dudes ()
{
	flag_wait ( "kit_sample_dudes" );
	spawners = getentarray ( "sample5_dudes", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

backstreet_dudes ()
{
	flag_wait ( "backstreet_dudes" );
	spawners = getent ( "spawnerA", "targetname" );
	spawners spawn_ai( true );
}

juggernaut_back_alley ()
{
	flag_wait ( "Juggernaut_Back_Alley" );
	spawners = getent ( "Juggernaut_BA", "targetname" );
	juggernaut = spawners spawn_ai( true );
	juggernaut thread jugg_givexp();
	
}

bookstore_stairs_dudes ()
{
	flag_wait ( "bookstore_stairs_dudes" );
	spawners = getentarray ( "spawnerStairsB", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

bookstore_bottom_dudes ()
{
	flag_wait ( "bookstore_bottom_dudes" );
	spawners = getentarray ( "spawnerB", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

bookstore_helispawn ()
{
	//Roof Fast Rope Gag
	flag_wait ( "bookstore_helispawn" );

	DoExplosion( "bsexpo_1" );
	wait ( .1 );
	
	DoExplosion( "bsexpo_2" );
	wait ( .1 );
	
	DoExplosion( "bsexpo_3" );
	wait ( .1 );
	
	DoExplosion( "bsexpo_4" );
	wait ( .1 );
	
	bookstore_heli = spawn_vehicle_from_targetname_and_drive ( "chopperspawn" );
	
	
	//Side Windows FrameRateRepairMethodDelta remove glass.
	DoExplosion( "bsexpo_5" );
	wait ( .1 );
	
	DoExplosion( "bsexpo_6" );
	wait ( .1 );
	
	DoExplosion( "bsexpo_7" );
	wait ( .1 );
	
	DoExplosion( "bsexpo_8" );
	wait ( .1 );
	
	DoExplosion( "bsexpo_9" );
	wait ( .1 );
	
	DoExplosion( "bsexpo_10" );
	wait ( .1 );
	
	DoExplosion( "bsexpo_11" );
	wait ( .1 );
	
	DoExplosion( "bsexpo_12" );
	wait ( .1 );
	
	DoExplosion( "bsexpo_13" );
	wait ( .1 );

}

outsidebookstore_helispawn ()
{
	flag_wait ( "outsidebookstore_helispawn" );
	bookstore_heli = spawn_vehicle_from_targetname_and_drive ( "chopperspawn2" );
}

bookstore_courtyard_dudes ()
{
	flag_wait ( "bookstore_courtyard_dudes" );
	spawners = getentarray ( "spawnerC", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

hotel_stairs_dudes ()
{
	flag_wait ( "hotel_stairs_dudes" );
	spawners = getentarray ( "spawnerD", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

top_hotel_stairs_dudes ()
{
	flag_wait ( "top_hotel_stairs_dudes" );
	spawners = getentarray ( "spawnerE", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

top_hotel_stairs_dudesB ()
{
	flag_wait ( "top_hotel_stairs_dudesB" );
	spawners = getentarray ( "spawnerF", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

exit ()
{
	spawn_vehicle_from_targetname_and_drive ( "bird2" );
}

Handle_Juggernaut_Health()
{
	self endon("death");
	self.currenthealth = self.health;
	//self thread jugg_explosion_deathshield();
	
	while ( 1 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
		
		mod_amount = 0;
		if ( self jugg_hit_bullet_armor( type ) )
		{
			self.health = self.currenthealth;
			self.bullet_armor -= amount;
			mod_amount = amount;
		}
		// regen health for tanks with armor in the front
		else if ( self jugg_has_frontarmor() ) 
		{
			mod_amount = self.health;
			self jugg_mod_front_armor( attacker, amount );
			self.currenthealth = self.health;
			
			mod_amount -= self.health; //to see how it was effected
		}
		
		if(self == level.player)
		{
			iprintln ( "health:" + self.health + " armor:" + self.bullet_armor + " dmg change: " + mod_amount);
		}		
		
		amount = undefined;
		attacker = undefined;
		direction_vec = undefined;
		point = undefined;
		modelName = undefined;
		tagName = undefined;
		type = undefined;
	}
}

jugg_explosion_deathshield()
{
	self EnableDeathShield( true );
	
	while ( 1 )
	{
		self waittill( "deathshield", damage, attacker, direction, point, type, modelName, tagName, partName, dflags, weaponName );
		
		shouldReallyDie = true;
		if ( IsSubStr( type, "GRENADE" ) || IsSubStr( type, "EXPLOSIVE" ))
		{
			//if we would die from an explosion / grenade 
			assert(isdefined(self.allowexplodedeath_health));
			if(self.currenthealth > self.allowexplodedeath_health)
			{	
				shouldReallyDie = false;			
				self.health = self.allowexplodedeath_health - 1; 
			}
		}
		
		if(shouldReallyDie)
		{
			self EnableDeathShield( false );
			self kill();			
		}
		
	}
}

//self.juggernaut_front_armor (0-1) what percentage of damage to take if we are hit from the front
//so if level.juggernaut_front_armor = .75 and we are hit from the front for 10 points of damage 
//it will be reduced to 10 * .75 = 7.5
jugg_has_frontarmor()
{
	return( IsDefined( self.juggernaut_front_armor ) );
}

jugg_mod_front_armor( attacker, amount )
{
	forwardvec = AnglesToForward( self.angles );
	othervec = VectorNormalize( attacker.origin - self.origin );
//	if ( VectorDot( forwardvec, othervec ) > 0.86 )
		self.health += Int( amount * self.juggernaut_front_armor );
}

jugg_hit_bullet_armor( type )
{
	if ( self.bullet_armor <= 0 )
		return false;
	if ( !( IsDefined( type ) ) )
		return false;
	if ( ! IsSubStr( type, "BULLET" ) )
		return false;
	else
		return true;
}

show_air_support_hint()
{
	if(!IsAlive(self)) return;
	self endon( "death" );
	self endon( "stop_air_support_hint" );
	wait 2.0;

	self ent_flag_wait( "flag_strobe_ready" );

	self.stop_air_support_hint = false;
	if(!using_strobe())
	{
		timeout = 10;
		self thread stop_air_support_hint_on_notify( timeout );
		display_hint_timeout( "air_support_hint", timeout );
	}
}

stop_air_support_hint_on_notify( timeout )
{
	self endon( "death" );
	self endon( "stop_air_support_hint_timeout" );
	
	thread stop_air_support_hint_timeout( timeout );
	
	self waittill( "stop_air_support_hint" );
	self.stop_air_support_hint = true;
	}

stop_air_support_hint_timeout( timeout )
{
	self endon( "death" );
	self endon( "stop_air_support_hint" );
	wait timeout;
	self notify( "stop_air_support_hint_timeout" );
}

using_strobe()
{
	return ( self.stop_air_support_hint || self GetCurrentWeapon() == "air_support_strobe" );
}

aud_monitor_player_impacts()
{
	level endon("aud_stop_player_impacts");
	
	while(true)
	{
		level.player waittill( "damage", amount, attacker, direction, point, damage_type );
		level.player playsound("armor_impact");
		// play armor impact sound that is *not* on impact_plr volmod
	}
}

setup_vo()
{
	//overlord
	add_radio([
		"so_parisa_hqr_chemicalattack",		//Metal 0-4, The chemical attack is over but we still need proof of contamination. Grab some samples of the  agent and return to H-Q.
		"so_parisa_hqr_airsupport",			//Enemies are throwing air support markers.  Steer clear metal 0-4.
		"so_parisa_hqr_samplesecured",		//Sample secure.
		"so_parisa_hqr_sampleretrieved",	//Sample retrieved.
		"so_parisa_hqr_samplerecovered",	//Sample recovered.
		"so_parisa_hqr_sampleisgood",		//Sample is good metal 0-4.
		"so_parisa_hqr_threemore",			//3 more samples remain Metal 0-4.
		"so_parisa_hqr_twotogo",			//2 to go.  Repeat 2 more samples remain.
		"so_parisa_hqr_gettorooftop",		//Littlebird is ready, get to the rooftop.
		"so_parisa_hqr_inboundforexfil",	//Samples have been collected at all sites.  Littlebird inbound for exfil.  Head to high ground for exfil Metal 0-4.
		"so_parisa_hqr_exfilwaiting"		//Metal 0-4 your exfil is waiting, get to the roof.
	]);
	thread vo();
	thread vo_samples();
}

vo()
{
	wait 1;
	thread radio_dialogue ( "so_parisa_hqr_chemicalattack" );
	wait 25;
	thread radio_dialogue ( "so_parisa_hqr_airsupport" );
}

vo_samples()
{
	level endon ( "samples_collected" );
	
	lines = [];
	lines [ lines.size ] = "so_parisa_hqr_samplesecured";
	lines [ lines.size ] = "so_parisa_hqr_sampleretrieved";
	lines [ lines.size ] = "so_parisa_hqr_samplerecovered";
	lines [ lines.size ] = "so_parisa_hqr_sampleisgood";
	last_line = undefined;
	
	while ( true )
	{
		level waittill ( "sample_pickedup" );
		while ( !flag ( "sample_vo_line_good" ) )
		{
			line = random ( lines );
			
			if ( isdefined ( last_line) && last_line == line )
				continue;
			else
			{
				radio_dialogue ( line );
				last_line = line;
				if ( level.samples_left == 3 )
					radio_dialogue ( "so_parisa_hqr_threemore" );
				if ( level.samples_left == 2 )
					radio_dialogue ( "so_parisa_hqr_twotogo" );
										
				flag_set ( "sample_vo_line_good" );
			}
			
			wait 0.05;
		}
		
		flag_clear ( "sample_vo_line_good" );
		
	}
	
}

add_radio(lines)
{
	foreach(line in lines)
	{
		level.scr_radio[line] = line;	
	}	
}



air_support_strobe_ready_dialogue()
{
	self endon( "death" );
	
	last_ready_line = undefined;
	last_fired_upon_line = undefined;
	wait 8;
	while(1)
	{
		self ent_flag_wait( "flag_strobe_ready" );
		while(true)
		{
			line = random([
				"paris_plt_orbitreestablished",
				"paris_plt_sensorsback",
				"paris_plt_calltargets",
				"paris_plt_readyformark",
				"paris_plt_readyfortargets"
			]);
			if(!IsDefined(last_ready_line) || line != last_ready_line)
			{
				last_ready_line = line;
				break;
			}					
		}
		self playlocalsound(line);
		
		while( self ent_flag( "flag_strobe_ready" ) )
		{
			wait .1;
		}
	}		
}

air_support_strobe_fired_dialogue()
{
	last_ready_line = undefined;
	last_fired_upon_line = undefined;
	
	while(1)
	{
		level waittill( "air_suport_strobe_fired_upon", strobe );		
	
		if( isDefined( strobe.isEnemyStrobe) )
						break;
		while(true)
		{
			line = random([
				"paris_plt_goinghot", 
				"paris_plt_engaging", 
				"paris_plt_targetconfirmed", 
				"paris_plt_rogerspot",
				"paris_plt_ontheway",
				"paris_plt_engaging2",
				"paris_plt_goodmark",
				"paris_plt_roundsondeck",
				"paris_plt_shotoutdangerclose",
				"paris_plt_firing",
				"paris_plt_rogermark"
			]);
			if(!IsDefined(last_fired_upon_line) || line != last_fired_upon_line)
			{
				last_fired_upon_line = line;
				break;
			}
		}
		strobe.owner playlocalsound(line);
	}
}

monitor_melee_death()
{
	
	XP_type = "kill";
	self waittill( "death", attacker, type, weaponName );
	
	if( isdefined( type ) && type == "MOD_MELEE" )
	{
		if( attacker_is_p1( attacker ))
		{
			if( level.player.bonus_1 < level.bonus_1_max )
			{
				level.player.bonus_1 ++;
				level.player notify ( "bonus1_count", level.player.bonus_1 );
			}
		}
		if( attacker_is_p2( attacker ))
		{
			if( level.player2.bonus_1 < level.bonus_1_max )
			{
				level.player2.bonus_1 ++;
				level.player2 notify ( "bonus1_count", level.player2.bonus_1 );
			}
		}
	}
}

monitor_airstrike_death()
{
	self waittill( "death", attacker, type, weaponName );
	
	if( isdefined( weaponName ) && weaponName == level.air_support_weapon )
	{
		if( attacker_is_p1( attacker ))
		{
			if( level.player.bonus_2 < level.bonus_2_max )
			{
				level.player.bonus_2 ++;
				level.player notify ( "bonus2_count", level.player.bonus_2 );
			}
		}
		if( attacker_is_p2( attacker ))
		{
			if( level.player2.bonus_2 < level.bonus_2_max )
			{
				level.player2.bonus_2 ++;
				level.player2 notify ( "bonus2_count", level.player2.bonus_2 );
			}
		}
	}
}

giveXp_kill_a( victim, XP_mod )
{
	XP_bonus = 0;
	melee_kill_bonus = 25;
	juggernaut_kill_bonus = 400;
	
	assertex( isPlayer( self ), "Trying to give XP to non Player" );
	assertex( isdefined( victim ), "Trying to give XP reward on something that is not defined" );
	
	XP_type = "kill";
	if( isdefined( victim.classname ) && issubstr( victim.classname, "juggernaut" ) )
		XP_bonus += juggernaut_kill_bonus;
	
	if( isdefined( victim.damagemod ) && victim.damagemod == "MOD_MELEE" )
		XP_bonus += melee_kill_bonus;
	
	value = undefined;

	reward = maps\_rank::getScoreInfoValue( XP_type );
	if ( isdefined( reward ) )
		value = reward + XP_bonus;

	
	self givexp( XP_type, value );
}

jugg_givexp()
{
	self waittill ( "death", attacker );
	
	if ( isdefined ( attacker ) && isplayer ( attacker ) )
		attacker givexp ( "jugg", 400 );
			
}
	