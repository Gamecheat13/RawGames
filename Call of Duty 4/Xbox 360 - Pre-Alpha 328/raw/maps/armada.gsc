#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle_aianim;
#include maps\_hud_util;

main()
{
	precachemodel( "fastrope_arms" );
	// add the starts before _load because _load handles starts now
	
	default_start( ::ride_start );
	add_start( "ride", ::ride_start );
	add_start( "landed", ::landed_start );
	add_start( "hq2tv", ::hq2tv_start );
	add_start( "intel", ::intel_start );
	add_start( "tv", ::tv_start );
	add_start( "tank", ::tank_start );
	add_start( "end", ::end_start );
	
	
	precacheturret( "heli_minigun_noai" );
	precachemodel( "weapon_saw_MG_setup" );
	
	maps\_m1a1::main( "vehicle_m1a1_abrams" );
	maps\_m1a1::main( "defaultvehicle" );
	maps\_mig29::main( "vehicle_mig29_desert" );


	maps\_breach_hinges_left_armada::main(); 
	maps\_breach_explosive_left::main(); 
	maps\_breach::main();
	
	maps\_technical::main( "vehicle_pickup_technical" );
	//maps\_seaknight::main( "vehicle_ch46e" );
	maps\_blackhawk::main( "vehicle_blackhawk" );
	
	//when "snipe" event happens call this thread
	//level.vehicle_aianimthread["snipe"] = maps\armada_anim::guy_snipe; 
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_ak47_clip";
	level.weaponClipModels[1] = "weapon_ak74u_clip";
	level.weaponClipModels[2] = "weapon_m16_clip";
	level.weaponClipModels[3] = "weapon_dragunov_clip";
	level.weaponClipModels[4] = "weapon_saw_clip";
	
	maps\armada_fx::main();
	maps\_load::main();
	maps\createfx\armada_audio::main();
	maps\armada_anim::main();
	maps\_compass::setupMiniMap( "compass_map_armada" );
	thread maps\armada_amb::main();
	
	level.mortar_min_dist = 500;
	level thread maps\_mortar::bog_style_mortar();
	level.noMaxMortarDist = true;
	level.scr_sound[ "mortar" ][ "incomming" ]				= "mortar_incoming";
	level.scr_sound[ "mortar" ][ "dirt" ]					= "mortar_explosion_dirt";
	level.scr_sound[ "mortar" ][ "mud" ]					= "mortar_explosion_water";
	level._effect[ "mortar" ][ "dirt" ]						= loadfx( "explosions/grenadeExp_dirt" );
	
//	battlechatter_off( "allies" );
//	battlechatter_off( "axis" );
	
	//setExpFog( 400, 4000, .90625, 0.850225, 0.71311, 0 );
	//setExpFog( 400, 6000, 1, 1, 1, 0 );
	//setCullFog( 0, 10000, .583, .644 , .587, 0 );	
	//setExpFog( 800, 6000, .583, .644 , .587, 0 );
	maps\createart\armada_art::main();
	
	flag_init( "kill_rpgs" );
	flag_init ( "start_first_obj" );
	flag_init ( "slam_zoom_done" );
	flag_init( "hq_entered" );	
	flag_init( "end_water" );	
	flag_init( "snipefromheli" );
	//flag_init( "i_hear_him" );
	flag_init ( "breach_ready_flag" );
	
	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );
	
	thread circling_heli_turrets();
	//thread circling_helis_rpg_guy_spawner();
	
	thread razor_wire_setup();
	thread razor_wire_collision();
	thread hq_breach();
	thread tv_breach();
	thread objectives();
	thread hq_entered_wait();
	thread HQ_finished();
	thread on_ground();
	thread barbed_wire_dialog();
	thread on_me_to_building();
//	thread end_of_script();
//	thread enemy_mass();
	thread kill_rooftop_ignore_groups();
	thread tv_station_visionset();
	
	createThreatBiasGroup( "left_rooftop_enemies" ); 
	createThreatBiasGroup( "right_rooftop_enemies" ); 
	createThreatBiasGroup( "players_group" ); 
	level.player setthreatbiasgroup( "players_group" );
	ignoreEachOther( "left_rooftop_enemies", "players_group" );
	ignoreEachOther( "right_rooftop_enemies", "players_group" );
	
	
	final_breacher_right = getentarray( "final_breach_right", "script_noteworthy" );
	array_thread( final_breacher_right, ::add_spawn_function, ::final_breacher_right_think );
	
	final_breach_shotgun = getentarray( "final_breach_shotgun", "script_noteworthy" );
	array_thread( final_breach_shotgun, ::add_spawn_function, ::final_breacher_shotgun_think );
	
	price_spawner = getentarray( "price", "script_noteworthy" );
	array_thread( price_spawner, ::add_spawn_function, ::price_think );
	array_thread( price_spawner, ::add_spawn_function, ::set_threatbias_group, "players_group" );
	
	breacher_spawner = getentarray( "breacher", "script_noteworthy" );
	array_thread( breacher_spawner, ::add_spawn_function, ::breacher_think );
	array_thread( breacher_spawner, ::add_spawn_function, ::set_threatbias_group, "players_group" );
	
	hq_breachers = getentarray( "hq_breachers", "script_noteworthy" );
	array_thread( hq_breachers, ::add_spawn_function, ::hq_breachers_think );
	
	ride_in_sniper = getentarray( "ride_in_sniper", "script_noteworthy" );
	array_thread( ride_in_sniper, ::add_spawn_function, ::hq_breachers_think );
	array_thread( ride_in_sniper, ::add_spawn_function, ::ride_in_sniper_think );
	
	left_rooftop_enemies = getentarray( "left_rooftop_enemies", "script_noteworthy" );
	array_thread( left_rooftop_enemies, ::add_spawn_function, ::set_threatbias_group, "left_rooftop_enemies" );
	
	right_rooftop_enemies = getentarray( "right_rooftop_enemies", "script_noteworthy" );
	array_thread( right_rooftop_enemies, ::add_spawn_function, ::set_threatbias_group, "right_rooftop_enemies" );
	
	
	right_rooftop_enemies_d_trigger = getent( "right_rooftop_enemies_d_trigger", "targetname" );
	right_rooftop_enemies_d_trigger thread player_breaks_ignore( "right_rooftop_enemies" );
	
	left_rooftop_enemies_d_trigger = getent( "left_rooftop_enemies_d_trigger", "targetname" );
	left_rooftop_enemies_d_trigger thread player_breaks_ignore( "left_rooftop_enemies" );
	
	
	magic_grenade_trigger = getentarray( "magic_grenade_trigger", "targetname" );
	array_thread( magic_grenade_trigger, ::magic_grenade_trigger_think );
	
	purple_2_red_triggers = getentarray( "purple_2_red", "targetname" );
	array_thread( purple_2_red_triggers, ::purple_2_red );
	
	reinforcements_triggers = getentarray( "reinforcements_trigger", "targetname" );
	array_thread( reinforcements_triggers, ::reinforcements_think );
	
	thread one_red_to_orange();
	
	kill_enemies_triggers = getentarray( "kill_enemies", "targetname" );
	array_thread( kill_enemies_triggers, ::kill_enemies );
	
	turret_targets = getentarray ( "turret_target", "targetname" );
	array_thread( turret_targets, ::turret_target_think );
	
	//thread subtitle_test();
	
	hq_breach_enemies = getentarray( "hq_breach_enemies", "script_noteworthy" );
	array_thread( hq_breach_enemies, ::add_spawn_function, ::linked_deaths, hq_breach_enemies);
	
	thread refill_red_with_green();
	thread friendlies_coming_out();
	thread final_breach();
	//thread turn_off_primary_lights();
	
	
	second_wave_counters = getentarray( "second_wave_counters", "script_noteworthy" );
	array_thread( second_wave_counters, ::add_spawn_function, ::second_wave_counters );
	level.second_wave_count = 0;
	
	level.hint_text_size = 1.6;
	thread flashbang_hint();
	
	flickering_lights = getentarray( "flickering_lights", "targetname" );
	for(i = 0; i < flickering_lights.size; i++)
		flickering_lights[ i ] thread maps\_lights::flickerLightIntensity( .2, .6 );
		
	griggs_spawner = getentarray( "griggs", "script_noteworthy" );
	array_thread( griggs_spawner, ::add_spawn_function, ::griggs_think );
}

flashbang_hint()
{
	trigger = getent( "flashbang_hint", "targetname" );
	trigger waittill ( "trigger" );
	thread keyhint( &"ARMADA_HINT_FLASH", "flash", "+smoke", 10 );
}

hint( text, timeOut )
{
	level.hintElem = createFontString( "default", level.hint_text_size );
	level.hintElem setPoint( "TOP", undefined, 0, 30 );

	level.hintElem setText( text );
	level.hintElem endon ( "death" );

	if ( isDefined( timeOut ) )
		wait ( timeOut );
	else
		return;

	level.hintElem fadeOverTime( 0.5 );
	level.hintElem.alpha = 0;
	wait ( 0.5 );
}

clear_hints()
{
	level notify ( "clearing_hints" );
	if ( isDefined( level.hintElem ) )
		level.hintElem destroy();
	if ( isDefined( level.iconElem ) )
		level.iconElem destroy();
	if ( isDefined( level.iconElem2 ) )
		level.iconElem2 destroy();
	if ( isDefined( level.iconElem3 ) )
		level.iconElem3 destroy();
}

keyHint( text, actionName, command, timeOut )
{
	clear_hints();

	level.hintElem = createFontString( "default", level.hint_text_size );
	level.hintElem setPoint( "TOP", undefined, 0, 30 );

	level.hintElem setText( text );
	level.hintElem endon ( "death" );

	notifyName = "did_action_" + actionName;
	level.player notifyOnCommand( notifyName, command );


	if ( isDefined( timeOut ) )
		thread notifyOnTimeout( notifyName, timeOut );
	level.player waittill( notifyName );

	level.hintElem fadeOverTime( 0.5 );
	level.hintElem.alpha = 0;

	wait ( 0.5 );
	
	clear_hints();
}

notifyOnTimeout( finishedNotify, timeOut )
{
	level.player endon( finishedNotify );
	wait timeOut;
	level.player notify( finishedNotify );
}

second_wave_counters()
{
	self waittill ( "death" );
	level.second_wave_count++;
	if ( level.second_wave_count > 3 )
	{
		wait 9;
		trigger = getent ( "second_wave", "script_noteworthy" );
		trigger notify ( "trigger" );	
	}
	if ( level.second_wave_count > 6 )
	{
		wait 9;
		trigger = getent ( "third_wave", "script_noteworthy" );
		trigger notify ( "trigger" );	
	}
}



turn_off_primary_lights()
{
	wait 1;
	tv_primary_lights = getentarray ( "tv_primary_light", "targetname" );
	hq_primary_lights = getentarray ( "hq_primary_light", "targetname" );
	
	for(i = 0; i < tv_primary_lights.size; i++)
		tv_primary_lights[ i ] setLightIntensity( 0 );

	for(i = 0; i < hq_primary_lights.size; i++)
		hq_primary_lights[ i ] setLightIntensity( 0 );
}

friendlies_coming_out()
{
	friendlies_coming_out = getent( "friendlies_coming_out", "targetname" );
	friendlies_coming_out waittill( "trigger" );
	
	griggs_squad = getentarray( "griggs_squad", "targetname" );
	array_thread( griggs_squad, ::add_spawn_function, ::enable_cqbwalk );
	
	
	array_thread( griggs_squad, ::spawn_ai ); 

	waittillframeend; // need to wait for the _spawner to run on the spawned guys	
	
	level.griggs anim_single_queue( level.griggs, "hold_fire" );//Hold your fire! Friendlies coming out!
	
	/*
	griggs_squad = get_force_color_guys( "allies", "c" );
	for(i = 0; i < griggs_squad.size; i++)
		griggs_squad[ i ].disableArrivals = true;
	*/
	
	door = getent( "griggs_door","targetname");
	attachments = getentarray (door.target, "targetname");
	for(i = 0; i < attachments.size; i++)
	{
	    attachments[i] linkto (door);
	}
	door rotateto( door.angles + (0,-130,0), .6, 0, 0 );
	door connectpaths();
	door waittill( "rotatedone");
	
	
	griggs_come_out = getent( "griggs_come_out", "targetname" );
	griggs_come_out notify ( "trigger" );
	
	wait 2;
	
	level.griggs anim_single_queue( level.griggs, "no_sign" );//No sign of Al-Asad sir.
	
	thread fall_in_dialog();
	
	wait 2;
	
	
	
	fall_in = getent( "fall_in", "targetname" );
	fall_in notify ( "trigger" );
	
	wait 3;
	
	cyans = get_force_color_guys( "allies", "c" );
	for( i=0;i<cyans.size;i++ )
		cyans[ i ] set_force_color( "o" );
	
	/*
	for(i = 0; i < griggs_squad.size; i++)
		griggs_squad[ i ].disableArrivals = false;
	*/
}

fall_in_dialog()
{
	level.price anim_single_queue( level.price, "fall_in" );//All right. Fall in Marines. Stay frosty.
}

exit_news_room_door()
{
	flag_wait("news_room_clear");    
	
	
	anim_ent = getnode( "opener_stack_node", "script_noteworthy" );
	anim_ent anim_reach_solo( level.price, "hunted_open_barndoor" );
	anim_ent anim_single_solo( level.price, "hunted_open_barndoor_stop" );
	anim_ent thread anim_loop_solo( level.price, "hunted_open_barndoor_idle", undefined, "stop_idle" );

	open_door = getent( "open_door", "targetname" );
	open_door waittill ( "trigger" );
	
	anim_ent notify( "stop_idle" );
	anim_ent thread anim_single_solo( level.price, "hunted_open_barndoor" );

	
	battlechatter_off( "allies" );

	door = getent( "news_room_exit_door","targetname");
	attachments = getentarray (door.target, "targetname");
	for(i = 0; i < attachments.size; i++)
	{
	    attachments[i] linkto (door);
	}
	door hunted_style_door_open();
	//door waittill( "rotatedone");
	//flag_set("");
	level.price enable_ai_color();
	thread atrium_path_start();
	
	
	setdvar("scr_fog_exp_halfplane", "20000");
	setExpFog(800, 20000, 0.583, 0.631569, 0.553078, 0);
}

atrium_path_start()
{
	enter_atrium_trigger = getent( "enter_atrium_trigger", "targetname" );
	enter_atrium_trigger notify ( "trigger" );
	
	tank_trigger = getent( "tank_trigger", "targetname" );
	tank_trigger notify ( "trigger" );
	
	wait 2;
	
	excluders = [];
	excluders[0] = level.price;
	
	soldier = get_closest_ai_exclude( level.player.origin, "allies", excluders );
	soldier.animname = "generic";
	soldier thread anim_single_queue( soldier, "goesourboys" );
	
	//iprintlnbold( "There goes the cavalry" );
	wait 1;
	
	flag_wait ( "player_in_atrium" );
	
	atrium_nodes = getnodearray ( "atrium_nodes", "targetname" );
	o_guys = get_force_color_guys( "allies", "o" );
	for(i = 0; i < o_guys.size; i++)
	{
		closest = getclosest ( o_guys[ i ].origin, atrium_nodes );
		path = getnode ( closest.script_noteworthy, "targetname" );
	    o_guys[ i ] thread maps\_spawner::go_to_node( path );
	}
}

news_room_clear()
{
	flag_wait ( "news_room_clear" );
	
	maps\_spawner::kill_spawnerNum( 3 );
	maps\_spawner::kill_spawnerNum( 4 );
	maps\_spawner::kill_spawnerNum( 8 );
	maps\_spawner::kill_spawnerNum( 9 );
	
	enemies = getaiarray ( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
		enemies[ i ] dodamage( enemies[ i ].health + 100 , enemies[ i ].origin );
	
	wait 2.5;
	
	level.price anim_single_queue( level.price, "room_clear" );
	
	wait .5;
	
	move_up_trigger = getent( "move_up_trigger", "targetname" );
	move_up_trigger notify ( "trigger" );
}

#using_animtree( "generic_human" );
ride_in_sniper_think()
{
	wait .1;
	self.get_out_override = %armada_blackhawk_sniper_drop;
	self.vehicle_idle_override = %armada_blackhawk_sniper_idle_loop;
	//self.vehicle_idle_override = %armada_blackhawk_sniper_idle;
}

linked_deaths( hq_breach_enemies )
{
	self waittill ( "death" );
	hq_breach_enemies = getentarray( "hq_breach_enemies", "script_noteworthy" );
	for( i = 0 ; i < hq_breach_enemies.size ; i++ )
	{
		if ( isalive ( hq_breach_enemies[ i ] ) )
		{
			target = hq_breach_enemies[ i ];
			wait .3;
			allies = getaiarray( "allies" );
			friendly = getclosest( target.origin, allies );
			aim_spot = target geteye();
			for( i = 0 ; i < 3 ; i++ )
			{
				MagicBullet( level.price.weapon, friendly gettagorigin( "tag_flash" ), aim_spot );
				wait .05;
			}
			//target dodamage ( target.health + 100, level.player.origin  );
		}
	}
}


turret_target_think()
{
	tank = maps\_vehicle::waittill_vehiclespawn( self.target );
	self linkto( tank );
	tank setturrettargetent( self );
}


subtitle_test()
{
	wait 3;
	level.player playsound 	( "armada_reinforcements1" );
	iprintlnbold ( "subtitle should play" );
}

kill_enemies()
{
	self waittill( "trigger" );
	
	enemies = getaiarray ( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
		enemies[ i ] dodamage( enemies[ i ].health + 100 , enemies[ i ].origin );
}

tv_station_visionset()
{
	flag_wait( "tvstation_entered" );

	set_vision_set( "armada_tvs", 3 );
}

reinforcements_think()
{
	self waittill( "trigger" );
	
	
	guys = get_force_color_guys( "allies", "r" );
	reinforcements_needed =( 5 - guys.size );
	
	if( reinforcements_needed < 2 )
	{
		soldier = get_closest_ai( level.player getOrigin(), "allies" );
		soldier custom_battlechatter( "move_generic" );
		return;
	}
	
	reinforcement_dialog = [];
	reinforcement_dialog[ 0 ] = "armada_gm1_reinforcements"; //"Friendly reinforcements coming up!"
	reinforcement_dialog[ 1 ] = "armada_gm2_friendliesmovinup"; //"Friendlies coming up!"
	reinforcement_dialog[ 2 ] = "armada_gm3_checkfire"; //"Check your fire! Friendlies at your six!"
	reinforcement_dialog[ 3 ] = "armada_gm4_headsup"; //"Heads up! Friendlies on your six!"
	reinforcement_dialog[ 4 ] = "armada_gm5_watchyourfire"; //"Watch your fire! Friendlies coming up!"
	
	selection = reinforcement_dialog[ randomint( reinforcement_dialog.size ) ];
	
	soldier = get_closest_ai( level.player getOrigin(), "allies" );
	soldier playsound( selection );
		
	spawners = getentarray( self.target, "targetname" );
	for( i=0;i<reinforcements_needed;i++ )
		guy = spawners[ i ] spawn_ai();
}

refill_red_with_green()
{	
	flag_wait ( "tv_station_locked_down" );
	greens = get_force_color_guys( "allies", "g" );
	
	if( greens.size > 0 )
	{
		reds = get_force_color_guys( "allies", "r" );
		reinforcements_needed =( 5 - reds.size );
	
		for( i=0;i<reinforcements_needed;i++ )
		{
			if ( isalive ( greens[ i ] ) )
				greens[ i ] set_force_color( "r" );
		}
	}
}


purple_2_red()
{
	self waittill( "trigger" );
	
	purples = get_force_color_guys( "allies", "p" );
	array_thread( purples, ::set_force_color, "r" );
}

one_red_to_orange()
{
	one_red_to_orange = getent( "one_red_to_orange", "targetname" );
	one_red_to_orange waittill( "trigger" );
	
	reds = get_force_color_guys( "allies", "r" );
	third_guy = reds[ 0 ];
	third_guy set_force_color( "o" );
	
	third_guy thread replace_on_death();
}

kill_rooftop_ignore_groups()
{
	flag_wait( "regrouped" );
	
	setThreatBias( "players_group", "left_rooftop_enemies", 0 );
	setThreatBias( "players_group", "right_rooftop_enemies", 0 );
	
	road_friendly = getentarray( "road_friendly", "script_noteworthy" );
	for( i=0;i<road_friendly.size;i++ )
		road_friendly[ i ] delete();	
}

enemy_mass()
{
	enemy_mass_trigger = getent( "enemy_mass_trigger", "targetname" );
	enemy_mass_trigger waittill( "trigger" );
	
	
}

magic_grenade_trigger_think()
{
	self waittill( "trigger" );
	
	magic_grenades_orgs = getentarray( self.target , "targetname" );
	for( i=0;i<magic_grenades_orgs.size;i++ )
	{
		level.price magicgrenade( magic_grenades_orgs[ i ].origin +( 0, 0, 50 ), magic_grenades_orgs[ i ].origin, randomfloatrange( 1, 2 )  );
	}
}

player_breaks_ignore( threat_bias_group )
{
	for( ;; )
	{
		self waittill( "trigger", other );
		
		if( other == level.player )
		{
			setThreatBias( "players_group", threat_bias_group, 0 );
			break;
		}
	}
}


sit_rep_dialog()
{
	//sit_rep_dialog = getent( "sit_rep_dialog", "targetname" );
	//sit_rep_dialog waittill( "trigger" );	
	
	flag_wait ( "hq_cleared" );
	
	/*
	level.price playsound( "armada_pri_onetwentyonesitrep" );
	wait 2.5;
	level.player playsound( "armada_gm1_rightsideclear" );
	wait 3;
	level.price playsound( "armada_pri_onethreeonecheckin" );
	wait 2;
	level.player playsound( "armada_gm2_centerclear" );
	wait 3;
	*/
	
	hq_cleared_move_up = getent( "hq_cleared_move_up", "targetname" );
	hq_cleared_move_up notify( "trigger" );	
	
	wait 2;
	
	//level.price playsound( "armada_pri_allteamsstanddown" );
	level.price anim_single_queue( level.price, "stand_down" );
	wait 2;
	//level.price playsound( "armada_pri_rogerhq" );
	level.price anim_single_queue( level.price, "roger_hq" );
	//wait 2;
	//level.price playsound( "armada_pri_headsup" );
	level.price anim_single_queue( level.price, "heads_up" );
}

tank_start()
{
	tank_start = getent( "tank_start", "targetname" );
	level.player setOrigin( tank_start.origin );
	level.player setPlayerAngles( tank_start.angles );
	tank_start_spawners = getentarray( "tank_start_spawners", "targetname" );
	array_thread( tank_start_spawners, ::spawn_ai ); 
	
	array_thread( tank_start_spawners, ::add_spawn_function, ::enable_cqbwalk );	

	waittillframeend; // need to wait for the _spawner to run on the spawned guys	
		
	flag_set ( "start_first_obj" );
	flag_set( "hq_entered" );
	flag_set( "hq_cleared" );
	flag_set( "on_ground" );
	flag_set( "regrouped" );
	flag_set( "tvstation_entered" );
	flag_set( "news_room_clear" );
	
	
	thread exit_news_room_door();
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 9 );
}

intel_start()
{
	level.player setOrigin(( 3622, 29958, -168 ) );
}

tv_start()
{
	tv_start = getent( "tv_start", "targetname" );
	level.player setOrigin( tv_start.origin );
	level.player setPlayerAngles( tv_start.angles );
	tv_start_spawners = getentarray( "tv_start_spawners", "targetname" );
	array_thread( tv_start_spawners, ::spawn_ai ); 
	
	flag_set ( "start_first_obj" );
	flag_set( "hq_entered" );
	flag_set( "hq_cleared" );
	flag_set( "on_ground" );
	flag_set( "regrouped" );
	
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 9 );
}

hq2tv_start()
{
	hq2tv_start = getent( "hq2tv_start", "targetname" );
	level.player setOrigin( hq2tv_start.origin );
	level.player setPlayerAngles( hq2tv_start.angles );
	hq2tv_start_spawners = getentarray( "hq2tv_start_spawners", "targetname" );
	array_thread( hq2tv_start_spawners, ::spawn_ai ); 
	
//	hq2tv_red_starts = getent( "hq2tv_red_starts", "targetname" );
//	hq2tv_red_starts notify( "trigger" );
	
	flag_set ( "start_first_obj" );
	flag_set( "hq_entered" );
	flag_set( "hq_cleared" );
	flag_set( "on_ground" );
	
	//thread maps\_vehicle::scripted_spawn( 9 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 9 );
}

end_of_script()
{
	end_of_scripting = getent( "end_of_scripting", "targetname" );
	end_of_scripting waittill( "trigger" );
	
	iprintlnbold( &"SCRIPT_DEBUG_LEVEL_END" );
}


objectives()
{
	flag_wait ( "start_first_obj" );
	obj = getent( "outside_hq_obj", "targetname" );
	objective_add( 1, "active", "Get into position to breach the HQ building.", obj.origin );
	objective_current( 1 );	
	
	flag_wait( "hq_entered" ); 
	
	obj2 = getent( "inside_hq_obj", "targetname" );
	objective_state( 1, "done" );
	objective_add( 2, "active", "Search the HQ building for Al Asad.", obj2.origin );
	objective_current( 2 );	
	
	flag_wait( "hq_cleared" ); 
	wait 2;
	
	regroup_obj = getent( "regroup_obj", "targetname" );
	objective_state( 2, "done" );
	objective_add( 3, "active", "Regroup with first squad.", regroup_obj.origin );
	objective_current( 3 );	
	
	flag_wait( "regrouped" );
	
	//entered_tvstation = getent( "entered_tvstation", "targetname" );
	objective_state( 3, "done" );
	objective_add( 4, "active", "Make your way to the TV Station.", ( 2808, 23672, -24 ) );
	objective_current( 4 );	
	
	flag_wait( "tvstation_entered" );
	//entered_tvstation waittill( "trigger" );
	
	second_floor_obj = getent( "second_floor_obj", "targetname" );
	objective_state( 4, "done" );
	objective_add( 5, "active", "Make your way to the second floor.", second_floor_obj.origin );
	objective_current( 5 );	
	
	second_floor_obj waittill( "trigger" );
	thread autosave_by_name( "second_floor" );
	objective_state( 5, "done" );
	
	final_room_obj = getent( "final_room_obj", "targetname" );
	objective_add( 6, "active", "Search the TV Station for Al Asad.", final_room_obj.origin );
	objective_current( 6 );	
	
	final_room_obj waittill( "trigger" );
	objective_state( 6, "done" );
}

hq_entered_wait()
{
	trigger = getent( "trigger_volume_room01", "targetname" );
	trigger waittill( "trigger" );
	flag_set( "hq_entered" );	
	
	barbed_wire_guys = getentarray( "barbed_wire_guys", "script_noteworthy" );
	for( i=0;i<barbed_wire_guys.size;i++ )
		barbed_wire_guys[ i ] delete();
}

HQ_finished()
{
	flag_wait( "hq_cleared" ); 
	
	battlechatter_on( "allies" );
	
	exit = getent( "hq_building_exit_door", "targetname" );
	exit connectpaths();
	exit delete();
	
	hq_breachers = getentarray( "hq_breachers", "script_noteworthy" );
	for( i=0;i<hq_breachers.size;i++ )
	{
		if( isalive( hq_breachers[ i ] ) )
			hq_breachers[ i ] doDamage( hq_breachers[ i ].health + 100, hq_breachers[ i ].origin );
	}
	ride_in_sniper = getentarray( "ride_in_sniper", "script_noteworthy" );
	for( i=0;i<ride_in_sniper.size;i++ )
	{
		if( isalive( ride_in_sniper[ i ] ) )
			ride_in_sniper[ i ] doDamage( ride_in_sniper[ i ].health + 100, ride_in_sniper[ i ].origin );
	}
		
	small_gate1 = getent( "small_gate1", "targetname" );
	small_gate1 rotateyaw( -90 , .1 );
	small_gate1 connectpaths();
	//small_gate1 delete();
	
	small_gate2 = getent( "small_gate2", "targetname" );
	small_gate2 rotateyaw( 90 , .1 );
	small_gate2 connectpaths();
	//small_gate2 delete();
	
	return_path_clip = getent( "return_path_clip", "targetname" );
	return_path_clip delete();
}

get_abarbed_wire_ai()
{
	array = getentarray( "barbed_wire_guys", "script_noteworthy" );
	for(i=0;i<array.size;i++)
		if(isai(array[i]))
			return array[i];
}

razor_wire_setup()
{
	trigger = getent( "first_fly_away_trigger", "targetname" );

	node = getnode("barbed_wire_node","targetname");
	barbed_wire_long = getent( "barbed_wire_long", "targetname" );
	barbed_wire_long.animname = "barbed_wire_long";
	barbed_wire_long SetAnimTree();
	
	node thread anim_single_solo( barbed_wire_long, "razor_idle",undefined, node );

//	anim_loop( guys, anime, tag, ender, entity )
	flag_wait("on_ground");
	
	if (flag("hq_cleared"))
		return;

	guy = get_abarbed_wire_ai();
	guy.animname = "razorwire_guy";
	
	assert(isdefined(guy));
	assert(isdefined(barbed_wire_long));
	
	sceneobjects = [];
	sceneobjects[0] = guy;
	sceneobjects[1] = barbed_wire_long;

//	node anim_reach_solo( guy, "razor_setup", undefined, undefined, barbed_wire_long );

	node thread anim_single( sceneobjects, "razor_idle",undefined, node );


	trigger waittill ("trigger");


	node anim_single( sceneobjects, "razor_setup",undefined, node );
//	node anim_single( sceneobjects, "razor_endidle",undefined, node );
}

razor_wire_collision()
{
	barbed_wire_scrunched = getent( "barbed_wire_scrunched", "targetname" );
	barbed_wire_scrunched hide();
	
	razorwire_scrunched_clip = getent( "razorwire_scrunched_clip", "targetname" );
	razorwire_scrunched_clip notsolid();
	razorwire_scrunched_clip connectpaths();
	
	flag_wait( "hq_cleared" ); 
	
	barbed_wire_scrunched show();
	razorwire_scrunched_clip solid();
	razorwire_scrunched_clip disconnectpaths();

//	node = getnode("barbed_wire_node","targetname");
	barbed_wire_long = getent( "barbed_wire_long", "targetname" );
	barbed_wire_long delete();
//	barbed_wire_long.animname = "barbed_wire_long";
//	barbed_wire_long SetAnimTree();
//	node thread anim_single_solo( barbed_wire_long, "razor_idle",undefined, node );
		
	barbed_wire_clip = getent( "barbed_wire_clip", "targetname" );
	barbed_wire_clip connectpaths();
	barbed_wire_clip delete();
}

slam_zoom_sound()
{
	wait( 0.05 );
	level.player playsound( "ui_camera_whoosh_in" );
	//setsaveddvar( "compass", 0 );
	//SetSavedDvar( "ammoCounterHide", "1" );
}

slam_zoom_intro()
{
	thread slam_zoom_sound();
	maps\_cheat::slowmo_system_init();
	level.slowmo.lerp_time_in = 0.25;
	level.slowmo.lerp_time_out = 0.25;
	
	level.player freezeControls( true );
	level.player disableweapons();
	level.player setplayerangles( ( 0, 0, 0 ) );
	
	setSavedDvar( "hud_drawhud", "0" );	

	lines = [];

	cinematicingame("fade_bog_b");
	lines[ lines.size ] = &"ARMADA_INTRO";	//
	lines[ "date" ] = "Day 2 - 13:45:";	//
	//lines[ "date" ] = &"ARMADA_DATE";	//
	lines[ lines.size ] = &"ARMADA_PLACE";	//"Sgt. Paul Jackson"
	lines[ lines.size ] = &"ARMADA_INFO";	//"1st Bn, 7th Marine Regiment"
	
	
	zoomHeight = 80000;
	
	maps\_introscreen::introscreen_feed_lines( lines );
	/*
	for ( i=0; i < lines.size; i++ )
	{
		interval = 1;
		time = ( i * interval ) + 1;
		delayThread( time, maps\_introscreen::introscreen_corner_line, lines[ i ], ( lines.size - i - 1 ), interval );
	}
	*/

	origin = (970.23, -10403.9, -217.093);
	level.player.origin = origin + ( 0, 0, zoomHeight );
	ent = spawn( "script_model", (69,69,69) );
	ent.origin = level.player.origin;
	
	ent setmodel( "tag_origin" );
	ent.angles = level.player.angles;
	level.player linkto( ent );//, "tag_player", 1 );
	ent.angles = ( ent.angles[ 0 ] + 89, ent.angles[ 1 ] + 29.7492, 0 );
	
	time = 2;
	
	ent moveto ( origin + (0,0,0), time, 0, time );
	wait 1.25;
	level.slowmo thread maps\_cheat::gamespeed_slowmo();
	wait .25;
	ent rotateto( ( 0, 29.7492, 0 ), .5, 0.25, 0.25 );
	wait .15;
	level.slowmo thread maps\_cheat::gamespeed_reset();
	maps\_cheat::slowmo_system_init();//reset defaults
	wait .25;
	
	level.player notify ( "attach_to_heli" );
	
	flag_set( "pullup_weapon" );

	wait( 0.2 );
	//level.player unlink();
	//level.player freezeControls( false );
	
	flag_set ( "slam_zoom_done" );
	//println ( "origin goal: " + level.piggyback_guy.origin );
	
	thread play_sound_in_space( "ui_screen_trans_in", level.player.origin );
	
	wait( 0.2 );
	
    level.player EnableWeapons();
	
	thread play_sound_in_space( "ui_screen_trans_out", level.player.origin );
	
	wait( 0.2 );
	
	level notify("introscreen_complete"); // Do final notify when player controls have been restored
		
	wait( 2 );
	level notify( "destroy_hud_elements" );
	//setsaveddvar( "compass", 1 );
	//SetSavedDvar( "ammoCounterHide", "0" );
	
	ent delete();
	
	autosave_by_name( "levelstart" );
	wait 5;
	
	flag_set ( "start_first_obj" );
}

loadplayer( position, animfudgetime )
{
	if ( getdvar( "fastrope_arms" ) == "" )
		setdvar( "fastrope_arms", "0" );
	if ( !isdefined( animfudgetime ) )
		animfudgetime = 0; 
	assert( isdefined( self.riders ) );
	assert( self.riders.size );
	guy = undefined; 
	for ( i = 0; i < self.riders.size; i++ )
	{
		if ( self.riders[ i ].pos == position )
		{
			guy = self.riders[ i ]; 
			guy.drone_delete_on_unload = true; 
			guy.playerpiggyback = true; 
			break; 
		}
	}
	//level.piggyback_guy = guy;//temp debug thing -z
	assertex( !isai( guy ), "guy in position of player needs to have script_drone set, use script_startingposition ans script drone in your map" );
	assert( isdefined( guy ) );
	animpos = maps\_vehicle_aianim::anim_pos( self, position );

// 	guy stopanimscripted();
// 	guy stopuseanimtree();
	guy notify( "newanim" );
	guy detachall();
// 	guy setmodel( "" );
	guy setmodel( "fastrope_arms" );
	guy useanimtree( animpos.player_animtree );
	thread maps\_vehicle_aianim::guy_idle( guy, position );
	
	level.player waittill ( "attach_to_heli" );
	level.player unlink();
	
	dummy = spawn( "script_model",  get_player_feet_from_view() );
	dummy.angles = level.player getplayerangles();
	dummy setmodel( "fastrope_arms" );
	dummy hide();
	
	level.player playerlinkto( dummy, "tag_player", 1 );
	player_viewshift_lock( dummy, guy, 1 );
	
	// playerlinktodelta( <linkto entity> , <tag> , <viewpercentag fraction> , <right arc> , <left arc> , <top arc> , <bottom arc> )
	level.player playerlinktodelta( guy, "tag_player", 1.0, 40, 18, 30, 30 );
	//guy thread maps\_debug::drawtagforever( "tag_player", (1,0,0) );

	level.player freezecontrols(false);
	
	dummy delete();
	
	guy hide();

	animtime = getanimlength( animpos.getout );
	animtime -= animfudgetime; 
	self waittill( "unload" );

	if ( getdvar( "fastrope_arms" ) != "0" )
		guy show();
	level.player disableweapons();
// 	guy waittill( "jumpedout" );

	guy notsolid();

	wait animtime; 

	level.player unlink();
	level.player enableweapons();
	setSavedDvar( "hud_drawhud", "1" );	
}

player_viewshift_lock( dummy, camera, time )
{				
	goalangles = camera gettagangles( "tag_player" );
	goalorigin = camera gettagorigin( "tag_player" );
	
	dummy rotateto(goalangles, time, time * .5, time * .5);
	dummy rotateto( goalorigin, time, time* .5, time* .5 );
	
	num = int(time * 20);
	numtotal = num;
	
	while(num)
	{
		num--;
		
		if(num > (numtotal * .5) )
			continue;
		if( num%2 )
			continue;
		if(!num)
			break;
		
		goalangles = camera gettagangles( "tag_player" );
		goalorigin = camera gettagorigin( "tag_player" );
		
		dummy rotateto(goalangles, (time * ( num/numtotal )) );
		dummy moveto(goalorigin, (time * ( num/numtotal )) );
		
		wait .05;
	}
		
	dummy.origin = camera gettagangles( "tag_player" );
	dummy.angles = camera gettagorigin( "tag_player" );
}	

ride_start()
{
	thread start_helicopters();
	thread slam_zoom_intro();
	//level thread maps\_introscreen::introscreen_delay( &"ARMADA_INTRO", &"ARMADA_DATE", &"ARMADA_PLACE", &"ARMADA_INFO", .5, 0, 1 );

	level.player_heli = maps\_vehicle::waittill_vehiclespawn_noteworthy( "players_helicopter" );
	//level.player_heli = getent( "players_helicopter", "script_noteworthy" );

	level.player_heli thread maps\armada_anim::player_heli_ropeanimoverride();
	//level.player playerlinktodelta( <linkto entity>, <tag>, <viewpercentag fraction>, <right arc>, <left arc>, <top arc>, <bottom arc> )
	//level.player playerlinktodelta( level.player_heli, "tag_playerride", 1, 45, 45, 30, 30 );
	//level.player playerlinktodelta( level.player_heli, "tag_playerride", 1 );
	
	level.player_heli thread loadplayer( 3 );
	
	flag_wait ( "slam_zoom_done" );
	

	thread player_control_during_ride();


	set_vision_set( "armada_water" );
	musicPlay( "music_armada_ride" ); 
	
	
	setsaveddvar( "sm_sunSampleSizeNear", 2 );
	//&"Charlie Don't Surf", &"Nov 23, 2008", &"The Persian Gulf"
	thread technical_setup();
	thread end_water_visionset();
	
	battlechatter_off( "allies" );

	thread feet_dry();
	thread taking_fire();
	thread was_close();
	thread target_in_view();
	thread five_seconds();
	thread down_ropes();
	thread turn_off_cull();
	flag_set_delayed( "kill_rpgs", 40 );
	
	//nate 
	waittillframeend;
	flag_set ( "snipefromheli" );
	wait 6;
	
	level.player playsound( "armada_hp1_shorelineinview" );
	wait 1.5;
	level.player playsound( "armada_fhp_copystrikersixfour" );
}


turn_off_cull()
{
	wait 42;
	setsaveddvar( "sm_sunSampleSizeNear", .25 );
}

feet_dry()
{
	wait 10;
	level.player playsound( "armada_hp1_feetdrytenseconds" );
	wait 1.5;
	level.player playsound( "armada_fhp_copy" );
}

taking_fire()
{
	wait 17;
	level.player playsound( "armada_hp1_takingfirehere" );
	wait 1.5;
	level.player playsound( "armada_fhp_rogerthat" );
}

was_close()
{
	wait 31;
	level.player playsound( "armada_hp1_thatwasclose" );
}

target_in_view()
{
	wait 35;
	level.player playsound( "armada_fhp_gotvisual" );
	//wait 1.5;
	//level.player playsound( "armada_fhp_copy" );
}

five_seconds()
{
	wait 43;
	level.player playsound( "armada_hp1_fiveseconds" );
	wait 5;
	level.player playsound( "armada_hp1_standbygreenlight" );
}

down_ropes()
{
	flag_wait( "end_water" );	
	level.player_heli waittill( "unload" );
	level.price playsound( "armada_pri_downtheropes" );
	wait 5;
	level.breacher playsound( "armada_gm1_gogogo" );
}


on_ground()
{
	flag_wait( "on_ground" );
	
	//battlechatter_on( "allies" );
	
	set_vision_set( "armada_ground", 3 );
	setsaveddvar( "sm_sunSampleSizeNear", .25 );
	//setculldist( 11000 );
}

barbed_wire_dialog()
{
	barbed_wire_dialog = getent( "barbed_wire_dialog", "targetname" );

	barbed_wire_dialog waittill( "trigger" );

	
	
	barbed_wire_dialog playsound( "armada_gm2_moveitmoveit" );
	wait 2;
	barbed_wire_dialog playsound( "armada_gm3_blockingpositions" );
}

on_me_to_building()
{	
	on_me_to_building = getent( "on_me_to_building", "targetname" );
	on_me_to_building waittill( "trigger" );
	level.price playsound( "armada_pri_secondsquadonme" );
}

end_water_visionset()
{
	end_water_visionset = getent( "end_water_visionset", "targetname" );
	end_water_visionset waittill( "trigger" );
	
	flag_set( "end_water" );	
	set_vision_set( "armada", 3 );
}

start_helicopters()
{
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 0 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 2 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 3 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 4 );
	
	

	wait 1; 
	
	level.helis = getentarray( "heli", "targetname" );
	first_fly_away_trigger = getent( "first_fly_away_trigger", "targetname" );
	fly_away_trigger = getent( "fly_away_trigger", "targetname" );
	
	thread rpg_guys();
	
	for( i=0;i<level.helis.size;i++ )
	{
		level.helis[ i ].repulser = Missile_CreateRepulsorEnt( level.helis[ i ], 5000, 100 );
		level.helis[ i ].exitpoint = level.helis[ i ].origin;
		//level.helis[ i ] thread debug();
		level.helis[ i ] thread maps\_vehicle::godon();
		if( isdefined( level.helis[ i ].script_noteworthy ) )
		{
			if( level.helis[ i ].script_noteworthy == "ai_dropper" || level.helis[ i ].script_noteworthy == "players_helicopter" )
			{
				level.helis[ i ] thread helicopters_fly_away( fly_away_trigger );
			}
			if( level.helis[ i ].script_noteworthy == "first_fly_away" )
			{
				level.helis[ i ] thread helicopters_fly_away( first_fly_away_trigger );
			}
			/*
			if( level.helis[ i ].script_noteworthy == "unload_late" )
			{
				unload_node = getent( level.helis[ i ].script_parameters, "targetname" );
				level.helis[ i ] thread unload_late( unload_node );
			}
			*/
		}
	}
	
	delete_heli_nodes = getentarray( "delete_heli", "script_noteworthy" );
//	array_thread( delete_heli_nodes, ::delete_heli_think );
}

unload_late( unload_node )
{
	flag_wait( "on_ground" ); 
	self vehicle_detachfrompath(); 
	self vehicle_dynamicpath( unload_node, false ); 
}

helicopters_fly_away( trigger )
{
	thread wait_for_unload();
	
	flag_wait( "on_ground" ); 	
	//trigger waittill( "trigger" );
	trigger wait_for_trigger_or_timeout( 12 );
	
	if( !isdefined( self.armada_unloaded ) )
		self waittill( "unloaded" );
	
	self vehicle_detachfrompath(); 
	Missile_DeleteAttractor( self.repulser );
	self cleargoalyaw(); //clear this thing
	self clearlookatent(); //clear that other thing
	self cleartargetyaw(); //clear the stuff
	self setvehgoalpos( self.exitpoint, 1 ); //1= stop
	//add delete
}

wait_for_unload()
{
	self waittill( "unloaded" );
	self.armada_unloaded = true;
}

delete_heli_think()
{
	self waittill( "trigger" , vehicle );
	vehicle delete();
}


player_control_during_ride()
{
	//setSavedDvar( "hud_drawhud", "0" );	
	setsavedDvar("g_friendlyNameDist", 0 );
	setsavedDvar("g_friendlyfireDist", 0 );
    //level.player DisableWeapons();
	
	
	level.player allowprone( false );
	level.player allowstand( false );
	level.player EnableInvulnerability();
	level.player.ignoreme = true;
	wait .5;
	level.player setplayerangles(( 0, 35, 0 ) );
	
	
	level.player_heli waittill( "unload" );
	//level.player disableweapons();
	//level.player_heli setgoalyaw( 180 );
	//level.player unlink();
	//level.player_heli thread maps\_vehicle::loadplayer( 7, 2.4 );  
	// 7 here is the position, 3 is time to subtract from the animation before detaching the player
	wait 6;	
	autosave_by_name( "on_the_ground" );
	level.player allowprone( false );
	level.player allowstand( true );
	level.player allowcrouch( false ); // bounce the player out of crouch
	wait .05;
	level.player allowprone( true );
	level.player allowcrouch( true );
	level.player DisableInvulnerability();
	level.player.ignoreme = false;
	
	wait 4;
	//setSavedDvar( "hud_drawhud", "1" );	
	setsavedDvar("g_friendlyNameDist", 15000 );
	setsavedDvar("g_friendlyfireDist", 128 );
    //level.player EnableWeapons();
	
	
	/*
	level.player_heli waittill( "reached_stop_node" );
	level.player_heli setgoalyaw( 270 );
	
	wait 1;
	
	level.player unlink();
	player_fudge_moveto(( 927, 31690, 10 ) );
	autosave_by_name( "on_the_ground" );
	
	wait 12;
	
	e = getent( "exit_point", "targetname" );
	level.player_heli setvehgoalpos( e.origin );
	*/
}


landed_start()
{
	street_start = getent( "street_start", "targetname" );
	level.player setOrigin( street_start.origin );
	level.player setPlayerAngles( street_start.angles );
	streets_start_spawners = getentarray( "streets_start_spawners", "targetname" );
	array_thread( streets_start_spawners, ::spawn_ai );
	flag_set ( "start_first_obj" );
	flag_set( "on_ground" );
	
	battlechatter_off( "allies" );
	
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 9 );
}

al_asad_recording()
{
	recording = getent( "al_assad_recording", "targetname" );
	
	speach = [];
	speach[ 0 ] = "armada_kaa_takeuparms";
	speach[ 1 ] = "armada_kaa_infidelblood";
	speach[ 2 ] = "armada_kaa_dawnofvictory"; 
	speach[ 3 ] = "armada_kaa_swiftandfinal"; 
	
	recording.stop = false;
	i=0;
	
	for(;;)
	{
		recording playsound ( speach[i], "sounddone" );
		recording waittill ("sounddone");
		if ( recording.stop )
			break;
		i++;
		if ( i == speach.size )
			i = 0;
	}
}


griggs_plays_music()
{
	level.griggs anim_single_queue( level.griggs, "roger_that" );//Roger that Master Sergeant!
	//level.scr_sound[ "griggs" ][ "roger_that" ] = "armada_grg_rogerMS"; //Roger that Master Sergeant!
	
	wait 3.5;
	
	recording = getent( "al_assad_recording", "targetname" );
	recording.stop = true;
	recording StopSounds();
	
	//iprintlnbold ( "music plays" );
	musicPlay( "armada_end_music" ); 
	
	wait 4;
	
	level.griggs anim_single_queue( level.griggs, "yeahhh" );//Yeahhhh. Oooo-rahhh…
	//level.scr_sound[ "griggs" ][ "yeahhh" ] = "armada_grg_yeahoorah"; //Yeahhhh. Oooo-rahhh…
}

end_dialog_sequence()
{	
	wait 7;
	level.griggs anim_single_queue( level.griggs, "score_one" );//Yeah…(snicker). Score one for mil-i-ta-ry intelligence!
	//level.scr_sound[ "griggs" ][ "score_one" ] = "armada_grg_scoreone"; //Yeah…(snicker). Score one for mil-i-ta-ry intelligence!
	
	
	level.price anim_single_queue( level.price, "grigs_music" );//Griggs... music.
	//level.scr_sound[ "price" ][ "grigs_music" ] = "armada_vsq_griggsmusic"; //Griggs... music.
	
	thread griggs_plays_music();
	
	wait 4;
	
	level.price anim_single_queue( level.price, "recording" );//Command this is Red Dog. TV station secure. No sign of Al-Asad. The broadcast is a recording, over.
	//level.scr_sound[ "price" ][ "recording" ] = "armada_vsq_recording"; //Command this is Red Dog. TV station secure. No sign of Al-Asad. The broadcast is a recording, over.
	
	wait 2;
	
	level.price anim_single_queue( level.price, "roger_command" );//Roger that Command. Out.
	//level.scr_sound[ "price" ][ "roger_command" ] = "armada_vsq_rogercommand"; //Roger that Command. Out.
	
	wait 2;
	
	level notify ( "rally_up" );
	//rally_final_room = getent( "rally_final_room", "targetname" );
	//rally_final_room notify ( "trigger" );
	level.price anim_single_queue( level.price, "new_assign" );//Marines! Rally up! We got a new assignment. Get your gear, and get ready to move out! Let's go!
	//level.scr_sound[ "price" ][ "new_assign" ] = "armada_vsq_rallyup"; //Marines! Rally up! We got a new assignment. Get your gear, and get ready to move out! Let's go!
	
	wait 4;
	
	//iprintlnbold ( "mission end" );
	missionsuccess( "bog_a", false );
}

flag_on_notify ( flag_name, notify_name )
{
	self waittill ( notify_name );
	flag_set ( flag_name );
}


final_breach()
{
	end_positions = getent( "end_positions", "targetname" );
	trigger_start_final_breach = getent( "trigger_start_final_breach", "targetname" );
	eVolume = getent( "final_volume", "targetname" );
	node = getent ( "final_breach_node", "script_noteworthy" );
	enter_final_room = getent( "enter_final_room", "targetname" );
	door = getent( "door_final", "targetname" );
	attachments = getentarray (door.script_noteworthy, "targetname");
	for(i = 0; i < attachments.size; i++)
	{
	    attachments[i] linkto (door);
	}
	
	end_positions waittill( "trigger" );
	
	eVolume thread flag_on_notify ( "breach_ready_flag", "ready_to_breach" );
	
	aBreachers = [];
	level.final_breacher_shotgun.firstBreacher = true;
	aBreachers = add_to_array( aBreachers, level.final_breacher_shotgun );
	aBreachers = add_to_array( aBreachers, level.final_breacher_right );
	sBreachType = "shotgunhinges_breach_left";
	eVolume thread maps\_breach::breach_think( aBreachers, sBreachType );
	
	level.griggs set_force_color ( "p" );
	level.price set_force_color ( "g" );
	
	excluders = [];
	excluders[excluders.size] = level.price;
	excluders[excluders.size] = level.griggs;
	excluders[excluders.size] = level.final_breacher_shotgun;
	excluders[excluders.size] = level.final_breacher_right;
	second_guy = get_closest_ai_exclude( level.player.origin, "allies", excluders );
	second_guy set_force_color ( "b" );
	
	excluders[excluders.size] = second_guy;
	fourth_guy = get_closest_ai_exclude( level.player.origin, "allies", excluders );
	
	
	trigger_start_final_breach waittill( "trigger" );
	
	level.miniguns_firing = false;
	thread al_asad_recording();
	
	flag_wait ( "breach_ready_flag" );
	
	level.griggs anim_single_queue( level.griggs, "I_hear_him" );//I think he's in there. I hear him.
	//level.griggs playsound ( "armada_grg_ihearhim" );
	
	wait .5;
	
	flag_set( "i_hear_him" );//turns on the breach execute trigger
    
    eVolume waittill ("execute_the_breach");
    
	level.price thread anim_single_queue( level.price, "do_it" );//Do it!
	
	wait 10;
	
	second_guy thread room_clear ( getnode ( "room_clear2_node", "script_noteworthy" ), "Clear!" );
	
	wait 2;
	
	fourth_guy thread room_clear ( getnode ( "room_clear4_node", "script_noteworthy" ), "He's not here." );
	
	wait 2;
	
	thread add_dialogue_line( "Marine", "The broadcast is a recording." );
	
	trigger_price_n_griggs( node, eVolume );
}

room_clear( node, dialog )
{
	self setgoalnode ( node );
	self waittill ( "goal" );
	
	if (isdefined ( dialog ) )
		thread add_dialogue_line( "Marine", dialog );
	
	wait 2;
	
	second_node = getnode( node.target, "targetname" );
	self setgoalnode ( second_node );
	self waittill ( "goal" );
	
	level waittill ( "rally_up" );
	
	wait ( randomfloatrange ( .2, 1.5 ) );
	self walk_to( getnode( second_node.target, "targetname" ) );
	//self setgoalnode ( getnode( node.target, "targetname" ) );
	self waittill ( "goal" );
}

final_breacher_right_think()
{	
	level.final_breacher_right = self;	
	self thread magic_bullet_shield();
	//self.interval = 50;
	
	self waittill ( "breach_complete" );
	
	self room_clear ( getnode ( "room_clear1_node", "script_noteworthy" ), "clear" );
	
	/*
	self waittill ( "breach_complete" );
	
	self.animname = "final_breacher_right";
	self anim_single_solo ( self, "react" );
	*/
}

final_breacher_shotgun_think()
{
	level.final_breacher_shotgun = self;	
	self thread magic_bullet_shield();
	//self.interval = 50;
	
	self waittill ( "breach_complete" );
	
	self room_clear ( getnode( "room_clear3_node", "script_noteworthy" ), "Room Clear!" );
	
	/*
	self waittill ( "breach_complete" );
	
	self.animname = "final_breacher_shotgun";
	self anim_single_solo ( self, "react" );
	*/
}

walk_to( goal )
{
	self disable_cqbwalk();
	self set_generic_run_anim( "walk", true );
	//self.walk_combatanim = level.scr_anim[ "generic" ][ "walk" ];
	//self.walk_noncombatanim = level.scr_anim[ "generic" ][ "walk" ];
	self.disablearrivals = true;
	self.disableexits = true;
	
	self.goalradius = 32;
	self setgoalnode ( goal );
	self waittill ( "goal" );
	self anim_generic( self, "patrol_stop" );
	self setgoalpos ( self.origin );
}

trigger_price_n_griggs( node, eVolume )
{
	thread final_griggs( node, eVolume );
	wait 5;
	thread final_price( node, eVolume );
}
	
final_price( node, eVolume )
{	
	node anim_reach_solo ( level.price, "enter" );
	node anim_single_solo ( level.price, "enter" );
	node anim_single_solo ( level.price, "finish" );
	level.price setgoalpos ( level.price.origin );
}

final_griggs( node, eVolume )
{	
	
	node anim_reach_solo ( level.griggs, "enter" );
	
	thread end_dialog_sequence(); //starts with "score one"
	
	node anim_single_solo ( level.griggs, "enter" );
	node anim_loop_solo ( level.griggs, "end_idle" );
}

end_start()
{
	end_start = getent( "end_start", "targetname" );
	level.player setOrigin( end_start.origin );
	level.player setPlayerAngles( end_start.angles );
	end_spawners = getentarray( "end_spawners", "targetname" );
	array_thread( end_spawners, ::spawn_ai ); 
	
	array_thread( end_spawners, ::add_spawn_function, ::enable_cqbwalk );	

	waittillframeend; // need to wait for the _spawner to run on the spawned guys	
		
	flag_set ( "start_first_obj" );
	flag_set( "hq_entered" );
	flag_set( "hq_cleared" );
	flag_set( "on_ground" );
	flag_set( "regrouped" );
	flag_set( "tvstation_entered" );
	flag_set( "news_room_clear" );
	
	//thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 9 );
	wait .2;
	trigger = getent( "end_positions", "targetname" );
	trigger notify ( "trigger" );
}

tv_breach_dialog( eVolume )
{
	eVolume waittill( "detpack_about_to_blow" );
	
	wait 1;
	
	//level.price anim_single_queue( level.price, "do_it" );//Do it!
	level.price playsound( "armada_usl_doit" );
	
	wait 2;
	
	//level.scr_sound[ "generic" ][ "breaching_breaching" ] = "armada_gm1_breachingbreaching"; //Breaching breaching!
	level.tv_breacher playsound( "armada_gm1_breachingbreaching" );
	
	wait 1;
	
	level.price playsound( "armada_usl_gogogo2" );
}

tv_breach()
{
	trigger = getent( "trigger_tv_breach", "targetname" );
	trigger waittill( "trigger" );
	
	thread news_room_clear();
	thread exit_news_room_door();
	
	tv_station_locked_down();
	
	breach_positions = getent( "breach_positions", "targetname" );
	breach_positions notify( "trigger" );
	
	
	eVolume = getent( "tv_volume", "targetname" );
	
	level.price set_force_color( "o" );
	
	
	reds = get_force_color_guys( "allies", "r" );
	level.tv_breacher = reds[ 0 ];
	level.tv_breacher set_force_color( "o" );
	level.tv_breacher thread replace_on_death();
	level.tv_breacher thread magic_bullet_shield();
	
	thread tv_breach_dialog( eVolume );
	
	aBreachers = [];
	aBreachers = add_to_array( aBreachers, level.price );
	aBreachers = add_to_array( aBreachers, level.tv_breacher );
	for(i=0;i<aBreachers.size;i++)
		aBreachers[i].usebreachapproach = false;

	sBreachType = "explosive_breach_left";
	eVolume thread maps\_breach::breach_think( aBreachers, sBreachType );
	
	while( !eVolume.breached )
            wait( 0.05 );
	
	for(i=0;i<aBreachers.size;i++)
		aBreachers[i].usebreachapproach = true;
	level.price enable_ai_color();
	level.tv_breacher enable_ai_color();
	level.tv_breacher stop_magic_bullet_shield();
}


tv_station_locked_down()
{	
	
	excluders = [];
	excluders[0] = level.price;
	
	soldier = get_closest_ai_exclude( level.player.origin, "allies", excluders );
	soldier.animname = "generic";
	
	while ( ( distance ( soldier.origin, level.price.origin ) ) > 800 )
		wait .5;
	
	soldier anim_single_queue( soldier, "tvstation" );
	//soldier playsound( "armada_gm1_tvstation" );
	//iprintlnbold( "MARINE: We've got the TV Station locked down sir." );
	
	wait .5;
	
	//iprintlnbold( "PRICE: Good. Get in position to breach." );
	//level.price playsound( "armada_usl_getintoposition" );
	level.price anim_single_queue( level.price, "get_into_pos" );
}

hq_breach()
{
	trigger = getent( "start_breach", "targetname" );
	trigger waittill( "trigger" );
	
	thread sit_rep_dialog();
	
	eVolume = getent( "volume_room01", "targetname" );
	thread breach_dialog( eVolume );
	
	aBreachers = [];
	aBreachers = add_to_array( aBreachers, level.price );
	aBreachers = add_to_array( aBreachers, level.breacher );
	sBreachType = "explosive_breach_left";
	eVolume thread maps\_breach::breach_think( aBreachers, sBreachType );
	
	//eVolume waittill ("execute_the_breach");
    
    breach_enemy_trigger = getent( "breach_enemy_trigger", "script_noteworthy" ); 
    breach_enemy_trigger notify( "trigger" );
	
	eVolume waittill ("detpack_detonated");
	//while( !eVolume.breached )
	//	wait( 0.05 );
    
	level.price enable_ai_color();
	level.breacher enable_ai_color();
	
	level endon ( "on_stairs" );
	
	vasquez_in_pos = getent ( "vasquez_in_pos", "targetname" );
	vasquez_in_pos waittill ("trigger" );
	
	wait 2; 
	//level.price thread 
	add_dialogue_line( "Vasquez", "Take point Jackson." );
	
}

breach_dialog( eVolume )
{
	level.price playsound( "armada_pri_targetbuildingleftbreach" );
	//wait 3;
	//level.breacher playsound( "armada_gm4_withyou" );
	
	//trigger_volume_room01 waittill( "trigger" );
	eVolume waittill( "detpack_about_to_blow" );
	
	wait 1;
	
	level.price playsound( "armada_pri_blowcharge" );
	wait 2;
	level.breacher playsound( "armada_gm1_breaching" );
	wait 1;
	level.price playsound( "armada_pri_gogogo" );
}


price_think()
{
	level.price = self;	
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price.interval = 50;
}

griggs_think()
{
	level.griggs = self;	
	level.griggs.animname = "griggs";
	level.griggs thread magic_bullet_shield();
}

breacher_think()
{	
	level.breacher = self;
	level.breacher thread magic_bullet_shield();
	level.breacher.interval = 50;
	
	flag_wait( "hq_cleared" ); 
	wait .1;
	
	level.breacher thread stop_magic_bullet_shield();
}

hq_breachers_think()
{	
	self.interval = 50;
}

technical_setup()
{
	trigger = getent( "technical_setup", "targetname" );
	trigger waittill( "trigger" );
	
	wait 1;
	
	technical = getEnt( "canal_technical", "targetname" );	
	//technical.mgturret[ 0 ].accuracy = 0;
	technical.mgturret[ 0 ] setmode( "manual_ai" ); // auto, auto_ai, manual
	technical.mgturret[ 0 ] settargetentity( level.player_heli );
	
	technical waittill( "start_vehiclepath" );
	technical.mgturret[ 0 ] startfiring();
	wait 8;
	//technical doDamage( technical.health + 100, technical.origin );
	technical delete();
}



rpg_guys()
{
    rpg_guys = getentarray( "rpg_guy", "script_noteworthy" );

    for( i=0;i<rpg_guys.size;i++ )
        rpg_guys[ i ].pacifist = true;

    for( ;; )
    {
        rpg_guys = getentarray( "rpg_guy", "script_noteworthy" );

		for( i = 0; i < rpg_guys.size; i++ )
        {
            if( !isalive( rpg_guys[ i ] ) )
                    continue;

            closest = getClosest( rpg_guys[ i ].origin, level.helis );
            dist = distance( closest.origin , rpg_guys[ i ].origin );

            if( dist < 2500 && rpg_guys[ i ].pacifist )
            {
                rpg_guys[ i ] setEntityTarget( closest );
                rpg_guys[ i ].pacifist = false;
                rpg_guys[ i ] thread kill_in_ten();
            }

            wait( .05 );
        }
        
        wait( .05 );
    }
}

kill_in_ten()
{
	flag_wait_or_timeout( "kill_rpgs", 10 );
	if( isalive( self ) )
		self doDamage( self.health + 100, self.origin );
}


helis_move()
{
	thread maps\_vehicle::gopath( self );
}


helis_move2()
{
	pathpoint = undefined;
	if( isdefined( self.target ) )
		pathpoint = getent( self.target, "targetname" );
	else 
		assertmsg( "helicopter without target" );
	arraycount = 0;
	pathpoints = [];
	while( isdefined( pathpoint ) )
	{
		pathpoints[ arraycount ] = pathpoint;
		arraycount++;
		if( isdefined( pathpoint.target ) )
			pathpoint = getent( pathpoint.target, "targetname" );
		else
			break;
	}

	radius = 512;	
	for( i=0;i<pathpoints.size;i++ )
	{
		if( isdefined( pathpoints[ i ].radius ) )
			radius = pathpoints[ i ].radius;
		self setNearGoalNotifyDist( 400 );
			
		stop = false;
		if( isdefined( pathpoints[ i ].script_stopnode ) ) //z: stop at nodes if there is a script_stopnode = 1 value
			stop = pathpoints[ i ].script_stopnode;
			
		self setvehgoalpos( pathpoints[ i ].origin, stop );
		self waittill( "near_goal" );
	}
}

debug( num )
{
	while( isdefined( self.script_parameters ) )
	{
		print3d( self.origin+( 0, 0, 128 ), self.script_parameters, ( 1, 1, 1 ), 1, 2, 1 );
		wait .05;
	}
}


set_threatbias_group( group )
{
	assert( threatbiasgroupexists( group ) );
	self setthreatbiasgroup( group );
}

circling_heli_turrets()
{
	flag_wait( "hq_cleared" ); 
	
	thread turret_target_finder();
	wait 1;
	//h = maps\_vehicle::waittill_vehiclespawn_noteworthy( "circling_heli" );
	circling_helis = get_vehiclearray( "circling_heli", "script_noteworthy" );
	//for( i = 0; i < circling_helis.size; i++ )
	//	circling_helis[ i ] notsolid();
	
	//circling_helis[ 0 ] thread setup_circling_heli_turret();
	array_thread( circling_helis, ::setup_circling_heli_turret );
}

setup_circling_heli_turret()
{
	tag = "tag_gun_l";
	//tag = "tag_turret";
    turret = spawnturret( "misc_turret", self gettagorigin( tag ), "heli_minigun_noai" );
    turret setmodel( "weapon_saw_MG_setup" );
    turret linkto( self, tag, ( 0, 0, -24 ), ( 0, 90, 0 ) );
    turret maketurretunusable();
    turret setmode( "manual" );
    turret setturretteam( "allies" );
    turret setconvergencetime( 0, "yaw" );
    turret setconvergencetime( 0, "pitch" );

    default_target = spawn( "script_model", self gettagorigin( tag ) );
    default_target linkto( self, tag, ( 300, 0, 0 ), self.angles );

    turret thread heli_minigun_firethread( default_target, self ); 
    turret thread heli_minigun_targetthread( default_target, self );
}

heli_minigun_firethread( default_target, helicopter ) 
{
    self endon( "stop_firing" );
	level.miniguns_firing = true;

    while( level.miniguns_firing )
	{
        burst = randomintrange( 3, 7 );
        for( i = 0; i < burst; i++ )
        {
            self shootturret();
            wait( 0.1 );
        }
        
		if( randomint( 3 ) == 0 )
		{
			wait randomintrange( 5, 8 );
		}
		
		wait randomfloat( 0.5, 2 );
		
    }
}

heli_minigun_targetthread( default_target, helicopter ) 
{
    self endon( "stop_firing" );    
    target = getent( "minigun_target", "targetname" );
    self settargetentity( target );
	
	
    while( true )
	{
        wait 10;
		num_guys = level.enemies.size;
		if( num_guys > 0 )
		{
			target = level.enemies[ randomint( num_guys ) ];
			if( isalive( target ) )
	    	    self settargetentity( target );
    	}
    }
    
}

turret_target_finder()
{
	flag_wait( "hq_cleared" ); 
	
	while( true )
	{
		level.enemies = getaiarray( "axis" );
		wait 4;
	}
}

get_vehiclearray( key1, key2 )
{
	vehicle_array = getentarray( key1, key2 );
	
	j = 0;
	new_vehicle_array = [];
	for( i = 0; i < vehicle_array.size; i++ )
	{
		if( vehicle_array[ i ].classname == "script_vehicle" )
		{
			new_vehicle_array[ j ] = vehicle_array[ i ];
			j++;
		}
	}
			
	return new_vehicle_array;
}

circling_helis_rpg_guy_spawner()
{
	circling_heli_rpg_spawners = getentarray( "circling_heli_rpg_guy", "script_noteworthy" );
	total_spawners = circling_heli_rpg_spawners.size;
	circling_heli_rpg_spawners = array_randomize( circling_heli_rpg_spawners );
	array_thread( circling_heli_rpg_spawners, ::add_spawn_function, ::circling_helis_rpg_guy_think );
	//array_thread( circling_heli_rpg_spawners, ::add_spawn_function, ::kill_in_ten );
	
	flag_wait( "hq_cleared" ); 
	wait 1;
	level.circling_helis = get_vehiclearray( "circling_heli", "script_noteworthy" );
	
	i = 0;
	//while( ! flag( "some_flag" ) )
	while( 1 )
	{
		living_rpg_guys = getentarray( "circling_heli_rpg_guy", "script_noteworthy" );
		level.living_rpg_guys = get_living( living_rpg_guys );
		
		spawner = circling_heli_rpg_spawners[ i ];
		spawner.count = 1;
		if( level.living_rpg_guys.size < 4 )
		{
			guy = spawner spawn_ai();
			i++;
		}
		if( i >= total_spawners )
		{
			i = 0;
		}
		wait 1;
    }
}


get_living( array )
{
	
	j = 0;
	living = [];
	for( i = 0; i < array.size; i++ )
	{
		if( isalive( array[ i ] ) )
		{
			living[ j ] = array[ i ];
			j++;
		}
	}
			
	return living;
}

    
circling_helis_rpg_guy_think()
{
	while( isalive( self ) )
	{
		closest = getClosest( self.origin, level.circling_helis );
		self setEntityTarget( closest );
		wait 1;
	}
}




