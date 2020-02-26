/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
Level: 		Blackout
Campaign: 	SAS
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */ 

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_stealth_logic;
#include maps\blackout_code;
#using_animtree( "generic_human" );

main()
{
	setsaveddvar( "r_specularColorScale", "1.6" );
	maps\createart\blackout_art::main();
	level thread maps\blackout_fx::main();

	precacheModel( "weapon_saw_MG_setup" );
	precacheModel( "weapon_rpd_MG_setup" );
	precacheModel( "com_folding_chair" );

	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();
	maps\_breach::main();

	maps\_bm21::main( "vehicle_bm21_mobile" );
//	maps\_truck::main( "vehicle_pickup_4door" );
	maps\_bmp::main( "vehicle_bmp_woodland" );
	maps\_mi17::main( "vehicle_mi17_woodland_fly", undefined, true );
//	maps\_bmp::main( "vehicle_bmp" );
	default_start( ::start_normal );
	add_start( "rappeltest", ::rappel_test );
	add_start( "field", ::start_field );
	add_start( "overlook", ::start_overlook );
	add_start( "cliff", ::start_cliff );
	add_start( "farmhouse", ::start_farmhouse );
	add_start( "blackout", ::start_blackout );

	maps\blackout_anim::main();
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_mp5_clip";
	level.weaponClipModels[1] = "weapon_ak47_clip";
	level.weaponClipModels[2] = "weapon_dragunov_clip";
	level.weaponClipModels[3] = "weapon_g36_clip";
	level.weaponClipModels[4] = "weapon_g3_clip";
	level.weaponClipModels[5] = "weapon_m16_clip";
	
	maps\_load::main();
	maps\_load::set_player_viewhand_model( "viewhands_player_marines" );
	level thread maps\blackout_amb::main();	

	flag_init( "high_alert" );
	flag_init( "second_shacks" );
	flag_init( "russians_stand_up" );
	flag_init( "go_up_hill" );
	flag_init( "go_to_overlook" );
	flag_init( "overlook_attack_begins" );
	flag_init( "overlook_attention" );
	flag_init( "hut_cleared" );
	flag_init( "cliff_fighting" );
	flag_init( "cliff_moveup" );
	flag_init( "on_to_the_farm" );
	flag_init( "player_rappels" );
	flag_init( "head_to_rappel_spot" );
	flag_init( "farm_complete" );
		
	thread set_high_alert();
	thread hut_cleared();


	battlechatter_off( "allies" );
	
	thread AA_town_init();
	run_thread_on_targetname( "no_prone", ::no_prone_think );
	run_thread_on_targetname( "no_crouch_or_prone", ::no_crouch_or_prone_think );
	run_thread_on_targetname( "second_shack_trigger", ::second_shack_trigger );
	run_thread_on_targetname( "physics_launch", ::physics_launch_think );
	run_thread_on_targetname( "prep_for_rappel", ::prep_for_rappel_think );
	run_thread_on_targetname( "price_finishes_farm", ::price_finishes_farm );

	run_thread_on_noteworthy( "shack_sleeper", ::add_spawn_function, ::shack_sleeper );
	run_thread_on_noteworthy( "power_plant_spawner", ::add_spawn_function, ::power_plant_spawner );
	run_thread_on_noteworthy( "clear_target_radius", ::clear_target_radius );
	
//	shack_guys = getentarray( "shack_guy", "targetname" );
//	array_thread( shack_guys, ::spawn_ai );
	
	thread descriptions();
	thread blackout_stealth_settings();
	
	level.respawn_spawner = getent( "ally_respawn", "targetname" );
	flag_set( "respawn_friendlies" );

	assault_spawners = getentarray( "assault_spawner", "targetname" );
	array_thread( assault_spawners, ::add_spawn_function, ::replace_on_death );
	array_thread( assault_spawners, ::add_spawn_function, ::ground_allied_forces );

	assault_second_waves = getentarray( "assault_second_wave", "targetname" );
	array_thread( assault_second_waves, ::add_spawn_function, ::replace_on_death );
	array_thread( assault_second_waves, ::add_spawn_function, ::ground_allied_forces );

	color_spawners = getentarray( "color_spawner", "targetname" );
	array_thread( color_spawners, ::add_spawn_function, ::ground_allied_forces );

	wait( 5 );
	setsaveddvar( "cg_cinematicFullScreen", "0" );
	for ( ;; )
	{
		flag_wait( "tv_movie" );
		CinematicInGame( "attract" );
		flag_waitopen( "tv_movie" );
		CinematicInGame( "fade_bog_a" );
	}
}

start_normal()
{
	setup_sas_buddies();
	setup_player();
	walking_the_stream();
}


start_chess()
{
	player_org = getent( "player_chess_org", "targetname" );
	level.player setorigin( player_org.origin );
}


walking_the_stream()
{
	thread outpost_objectives();
	
	thread field_meeting();

	allies = getaiarray( "allies" );
//	array_thread( allies, ::stealth_ai );
	array_thread( allies, ::friendly_think );
	
	thread hut_tv();
	
	run_thread_on_targetname( "signal_stop", ::signal_stop );
	
	hut_sentry = getent( "hut_sentry", "script_noteworthy" );
	hut_sentry thread reach_and_idle_relative_to_target( "smoke", "smoke_idle", "bored_alert" );

//	run_thread_on_targetname( "pier_trigger", ::pier_trigger_think );

	bored_guys = getentarray( "bored_guy", "script_noteworthy" );
	array_thread( bored_guys, ::reach_and_idle_relative_to_target, "bored_idle_reach", "bored_idle", "bored_alert" );

	bored_guys = getentarray( "hut_hanger", "script_noteworthy" );
	array_thread( bored_guys, ::reach_and_idle_relative_to_target, "bored_idle_reach", "bored_cell_loop", "bored_alert" );
	
	flag_wait( "pier_guys" );
	
	if ( !flag( "high_alert" ) )
	{
		// the sentry died quietly so we can sneak up to the hut
		array_thread( allies, ::set_force_color, "o" );
	}
	
	flag_wait( "hut_cleared" );
	if ( !getaiarray( "axis" ).size )
		flag_clear( "high_alert" );
		
	array_thread( allies, ::set_force_color, "y" );
	activate_trigger_with_targetname( "move_to_bridge" );
	
	flag_wait_either( "chess_cleared", "high_alert" );
	
	if ( flag( "high_alert" ) )
		activate_trigger_with_targetname( "hide_from_shack" );
	else
		activate_trigger_with_targetname( "sneak_up_on_shack" );
	
	flag_wait( "shack_cleared" );
	
	activate_trigger_with_targetname( "meet_at_field" );
	
	
}

start_field()
{
	setup_sas_buddies();
	setup_player();
	
	axis = getaiarray( "axis" );
	array_levelthread( axis, ::deleteent );
	
	allies = getaiarray( "allies" );
	flag_set( "second_shacks" );
	thread field_meeting();
		
	player_org = getent( "player_field_org", "targetname" );
	
	level.player setorigin( player_org.origin + (0,0,-27000) );
	ally_orgs = getentarray( "friendly_field_org", "targetname" );
	
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] teleport( ally_orgs[ i ].origin, ally_orgs[ i ].angles );
	}

	level.player setorigin( player_org.origin );
	activate_trigger_with_targetname( "meet_at_field" );
	
	array_thread( allies, ::set_force_color, "y" );
}


field_meeting()
{
	flag_wait( "second_shacks" );
	thread overlook_sniping();

	field_russians = getentarray( "field_russian", "targetname" );
	array_thread( field_russians, ::add_spawn_function, ::field_russian_think );
	array_thread( field_russians, ::spawn_ai );

	russian_leader = getent( "russian_leader", "targetname" );
	russian_leader thread add_spawn_function( ::russian_leader_think );
	russian_leader thread spawn_ai();

	
	wait_for_targetname_trigger( "field_trigger" );

	node = getnode( "field_leader_node", "targetname" );
	level.kamarov allowedstances( "stand" );
	russian_path = getent( "russian_path", "targetname" );
	level.kamarov.disableexits = true;
	level.kamarov.disablearrivals = true;
	
	level.kamarov maps\_spawner::go_to_node( russian_path, 1 );
	thread add_dialogue_line( kamarov(), "It's ok, it is the SAS." );
	level.kamarov anim_generic( level.kamarov, "stop_cqb" );
	
	level.kamarov.disableexits = false;
	level.kamarov.disablearrivals = false;

	flag_set( "russians_stand_up" );

	wait( 3 );
	thread add_dialogue_line( kamarov(), "These are my men. We will commence the attack momentarily." );
	objective_complete( 2 );
	wait( 3 );

	// What's the target Kamarov? We've got an informant to recover.                                     
	level.price dialogue_queue( "whats_the_target" );
	
	thread add_dialogue_line( kamarov(), "We will put a stop to the BM21s that are inflicting grevious damage on Nakhchivan City." );
	wait( 3 );
	thread add_dialogue_line( kamarov(), "You will provide us with sniper support." );
	wait( 3 );
	thread add_dialogue_line( kamarov(), "In return, we will help you get your informant, if he is here." );
	wait( 4 );

	// Then let's get to it.                                                                                
	level.price dialogue_queue( "lets_get_to_it" );
	
	thread add_dialogue_line( kamarov(), "Now, follow me." );
	autosave_by_name( "follow_me" );

	level.hilltop_mortar_team_1 = [];
	level.hilltop_mortar_team_2 = [];
	
	flag_set( "go_up_hill" );
	ai = getaiarray( "allies" );
	array_thread( ai, ::set_ignoreall, true );
	array_thread( ai, ::set_ignoreme, true );

	leader_hilltop_org = getent( "leader_hilltop_org", "targetname" );
	leader_hilltop_org anim_generic_reach( level.kamarov, "stop_cqb" );
	leader_hilltop_org thread anim_generic( level.kamarov, "stop_cqb" );

//	thread add_dialogue_line( kamarov(), "Volsky, Pavlov, set up your mortar here. Petra, Brekov, down there." );
//	wait( 4 );
	thread add_dialogue_line( kamarov(), "Cpt Price, you will find a nice vantage point down that path. Go. Be ready." );
	wait( 4 );
	thread add_dialogue_line( kamarov(), "The rest of you head down and wait for my signal." );
	wait( 4 );

	flag_set( "go_to_overlook" );
	Objective_Add( 3, "current", "Provide sniper support from the road.", ( -7587, -2233, 857 ) );

	
	hilltop_russian_leader_hangout = getent( "hilltop_russian_leader_hangout", "targetname" );
	level.kamarov setgoalpos( hilltop_russian_leader_hangout.origin );
	level.kamarov.goalradius = 32;
	
}



start_overlook()
{
	flag_set( "go_up_hill" );

	setup_sas_buddies();
	setup_player();
	
	axis = getaiarray( "axis" );
	array_levelthread( axis, ::deleteent );
	
	allies = getaiarray( "allies" );
	player_org = getent( "player_overlook_org", "targetname" );
	level.player setorigin( player_org.origin + (0,0,-27000) );

	ally_orgs = getentarray( "friendly_overlook_org", "targetname" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] teleport( ally_orgs[ i ].origin, ally_orgs[ i ].angles );
	}

	level.player setorigin( player_org.origin );
	
	flag_set( "second_shacks" );
	flag_set( "go_to_overlook" );
	thread overlook_sniping();
}


overlook_sniping()
{
	flag_wait( "go_up_hill" );
//	thread haunted_sniping();

	thread price_tells_player_to_come_over();
	
	village_blocker = getent( "village_blocker", "targetname" );
	village_blocker connectpaths();
	village_blocker notsolid();
	
	overlook_runners = getentarray( "overlook_runner", "script_noteworthy" );
	array_thread( overlook_runners, ::add_spawn_function, ::overlook_runner_think );

	smoker_spawners = getentarray( "smoker_spawner", "targetname" );
	array_thread4( smoker_spawners, ::add_spawn_function, ::reach_and_idle_relative_to_target, "smoking_reach", "smoking", "smoking_react" );
	array_thread( smoker_spawners, ::spawn_ai );

	bored_guys = getentarray( "wall_idler", "targetname" );
	array_thread4( bored_guys, ::add_spawn_function, ::reach_and_idle_relative_to_target, "bored_idle_reach", "bored_cell_loop", "bored_alert" );
	array_thread( bored_guys, ::spawn_ai );

	street_walkers = getentarray( "street_walker", "targetname" );
	array_thread( street_walkers, ::add_spawn_function, ::street_walker_think );
	array_thread( street_walkers, ::spawn_ai );
	
	
	
	flag_wait( "player_at_overlook" );
	autosave_by_name( "overlook" );
	level.player.threatbias = -350;
	
	thread turn_off_stealth();

	thread hilltop_sniper();
	
	delaythread( 12, ::exploder, 60 );
	delaythread( 13, ::flag_set, "overlook_attack_begins" );
	
	thread overlook_player_mortarvision();
	flag_wait( "overlook_attack_begins" );
	ai = getaiarray( "allies" );
	array_thread( ai, ::set_ignoreme, false );
	
	activate_trigger_with_targetname( "overlook_charge" );

	assault_spawners = getentarray( "assault_spawner", "targetname" );
	array_thread( assault_spawners, ::spawn_ai );


	first_mg_guys = getentarray( "first_mg_guys", "targetname" );
	array_thread( first_mg_guys, ::add_spawn_function, ::overlook_turret_think );
	array_thread( first_mg_guys, ::spawn_ai );
	
	thread overlook_price_tells_you_to_shoot_mgs();

	thread overlook_badguys_pour_in();


	flag_wait( "mgs_cleared" );
	Objective_complete( 3 );

	thread breach_first_building();	
	thread spawn_vehicles_from_targetname_and_drive( "enemy_heli" );
	
//	flag_wait_or_timeout( "breach_complete", 10 );
	flag_wait( "breach_complete" );

	// Not a problem. We'll take care of it. Soap, Gaz, let's go!                                        
	level.price dialogue_queue( "not_a_problem" );
	
	Objective_Add( 4, "current", "Cut off enemy reinforcements at the Power Station.", power_plant_org() );

	// the axis fall back!	
//	axis = getaiarray( "axis" );
//	arraY_thread( axis, ::fall_back_to_defensive_position );
	
	wait( 1.2 );
	
	level.price set_force_color( "r" );
	level.gaz set_force_color( "o" );
	level.bob set_force_color( "y" );
	
	level.price.ignoreall = true;
	level.gaz.ignoreall = true;
	level.bob.ignoreall = true;
	
	activate_trigger_with_targetname( "to_the_cliff" );
	//flag_set( "breach_complete" );
	autosave_by_name( "to_the_cliff" );
	
//	iprintlnbold( "End of current mission" );

	village_blocker disconnectpaths();
	village_blocker solid();

	wait( 10 );
	
	flag_wait( "player_reaches_cliff_area" );

	// Sir, we've got company! Helicopter troops closing in fast!                                       
	level.gaz delaythread( 1.5, ::dialogue_queue, "helicopter_troops" );

	activate_trigger_with_targetname( "cliff_ground_forces" );
	level.price.ignoreall = false;
	level.gaz.ignoreall = false;
	level.bob.ignoreall = false;
//	missionsuccess( "armada", false );
	
	// enemies fall back
	
//	first_breach_org
	
	thread cliff_sniping();

	flag_wait( "power_plant_cleared" );	
	Objective_complete( 4 );
	Objective_Add( 5, "current", "Provide sniper support from the cliff above town.", cliff_org() );
}

overlook_badguys_pour_in()
{
	level endon( "breach_complete" );
	flag_assert( "breach_complete" );
	flag_wait_or_timeout( "overlook_attention", 20 );
	east_spawners = getentarray( "east_spawner", "targetname" );
	array_thread( east_spawners, ::add_spawn_function, ::fall_back_to_defensive_position );
	array_thread( east_spawners, ::spawn_ai );

	wait( 15 );
	mid_spawners = getentarray( "mid_spawner", "targetname" );
	array_thread( mid_spawners, ::add_spawn_function, ::fall_back_to_defensive_position );
	array_thread( mid_spawners, ::spawn_ai );

	thread spawn_replacement_baddies();

	assault_second_waves = getentarray( "assault_second_wave", "targetname" );
	array_thread( assault_second_waves, ::spawn_ai );
}


haunted_sniping()
{
	trigger = getent( "bmp_trigger", "targetname" );
	trigger waittill( "trigger" );
	bmp = spawn_vehicle_from_targetname_and_drive( "bmp" );
}

start_cliff()
{
	flag_set( "go_up_hill" );
	flag_set( "go_to_overlook" );
	flag_set( "overlook_attack_begins" );
	flag_set( "breach_complete" );
	delayThread( 1, ::flag_set, "power_plant_cleared" );
	
	allies = getaiarray( "allies" );
	setup_sas_buddies();
	setup_player();
	
	axis = getaiarray( "axis" );
	array_levelthread( axis, ::deleteent );
	
	thread cliff_sniping();
	
	guys = get_guys_with_targetname_from_spawner( "assault_spawner" );
	otherguys = get_guys_with_targetname_from_spawner( "assault_second_wave" );
	
	guys = array_combine( guys, otherguys );
	wait( 0.05 );
	starts = getentarray( "ally_cliff_start_org", "targetname" );
	
	for ( i = 0; i < guys.size; i++ )
	{
		guys[ i ] teleport( starts[ i ].origin );
	}

	flag_set( "player_reaches_cliff_area" );
	wait( 0.5 );
	player_org = getent( "player_cliff_org", "targetname" );
	level.player setorigin( player_org.origin + (0,0,-27000) );

/*
	guy = get_guy_with_targetname_from_spawner( "blackout_spawner" );
	org = getent( guy.target, "targetname" );
	guy.ignoreall = true;
*/
	ally_orgs = getentarray( "friendly_cliff_org", "targetname" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] teleport( ally_orgs[ i ].origin, ally_orgs[ i ].angles );
	}
	level.player setorigin( player_org.origin );
	
}

cliff_sniping()
{
	activate_trigger_with_targetname( "cliff_trigger" );

	level.respawn_spawner = getent( "ally_cliff_spawner", "targetname" );
	flag_set( "cliff_fighting" );	
	thread spawn_replacement_cliff_baddies();
//	friendly_bmp = spawn_vehicle_from_targetname_and_drive( "friendly_bmp" );
	level.enemy_bmp = spawn_vehicle_from_targetname_and_drive( "enemy_bmp" );

	level.defenders_killed = 0;
	thread cliff_bm21_blows_up();
	
	flag_wait( "cliff_look" );
	thread do_in_order( ::flag_wait, "power_plant_cleared", ::autosave_by_name, "power_plant_cleared" );
	flag_set( "cliff_tanks_move" );

	level.player.ignoreme = true;
	
	flag_wait( "cliff_moveup" ); // gets set by defenders dying
	
	activate_trigger_with_targetname( "cliff_allies_advance" );
	wait( 10 );

	flag_set( "cliff_tanks_shift" );

	roof_sniper_spawners = getentarray( "roof_sniper_spawner", "targetname" );
	array_thread( roof_sniper_spawners, ::add_spawn_function, ::roof_spawner_think );
	array_thread( roof_sniper_spawners, ::spawn_ai );

	flag_wait( "cliff_roof_snipers_cleared" );
	flag_set( "cliff_complete" );
	Objective_complete( 5 );
	Objective_Add( 6, "current", "Rappel down from the Power Station.", rappel_org() );
	
	thread player_rappel_think();
	flag_set( "head_to_rappel_spot" );
	flag_wait( "player_rappels" );

	Objective_Complete( 6 );
	Objective_Add( 7, "current", "Rescue the informant.", informant_org() );
	autosave_by_name( "attack_farmhouse" );
	thread raid_farmhouse();
}
	
	
//	iprintlnbold( "End of current mission" );
//	wait( 10 );
//	missionsuccess( "armada", false );

start_farmhouse()
{
	flag_set( "go_up_hill" );
	flag_set( "go_to_overlook" );
	flag_set( "overlook_attack_begins" );
	flag_set( "breach_complete" );
	flag_set( "on_to_the_farm" );
	flag_set( "power_plant_cleared" );
	
	allies = getaiarray( "allies" );
	setup_sas_buddies();
	setup_player();
	
	axis = getaiarray( "axis" );
	array_levelthread( axis, ::deleteent );
	
	flag_set( "player_reaches_cliff_area" );

	wait( 0.5 );
	player_org = getent( "player_farmhouse_org", "targetname" );
	level.player setorigin( player_org.origin + (0,0,-27000) );

	ally_orgs = getentarray( "ally_farmhouse_org", "targetname" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] teleport( ally_orgs[ i ].origin, ally_orgs[ i ].angles );
	}
	level.player setorigin( player_org.origin );

	thread raid_farmhouse();	
}
	
raid_farmhouse()
{
	activate_trigger_with_targetname( "friendlies_charge_farmhouse" );
	ally_forced_farm_spawners = getentarray( "ally_forced_farm_spawner", "targetname" );
	array_thread( ally_forced_farm_spawners, ::add_spawn_function, ::replace_on_death );
	array_thread( ally_forced_farm_spawners, ::spawn_ai );
	ally_farm_spawner = getent( "ally_farm_spawner", "targetname" );
	level.respawn_spawner = ally_farm_spawner;
	clear_promotion_order();
	set_promotion_order( "c", "r" );
	instantly_promote_nearest_friendly( "r", "c" );
	instantly_promote_nearest_friendly( "r", "c" );
	instantly_promote_nearest_friendly( "r", "c" );

	wait( 5 );
	farm_rpg_spawner = getent( "farm_rpg_spawner", "targetname" );
	farm_rpg_spawner thread add_spawn_function( ::farm_rpg_guy_attacks_bm21s );
	farm_rpg_spawner spawn_ai();
	
	flag_wait( "farm_complete" );

	// Kamarov, we've completed our end of the bargain. Now where is the informant?                      
	level.price dialogue_queue( "where_is_informant" );

	// Bloody hell let's move. He may still be alive.                                                  
	level.price dialogue_queue( "lets_move" );

	// May be alive?? I hate bargaining with Kamarov. There's always a bloody catch.                    
	level.gaz dialogue_queue( "hate_bargaining" );

	level.price set_force_color( "y" );	
	level.gaz set_force_color( "y" );	
	level.bob set_force_color( "y" );	
	thread blackout_house();
}


start_blackout()
{
	flag_set( "go_up_hill" );
	flag_set( "go_to_overlook" );
	flag_set( "overlook_attack_begins" );
	flag_set( "farm_complete" );
	
	setup_sas_buddies();
	setup_player();
	
	axis = getaiarray( "axis" );
	array_levelthread( axis, ::deleteent );
	
	player_org = getent( "player_blackout_org", "targetname" );
	level.player setorigin( player_org.origin + (0,0,-27000) );

/*
	guy = get_guy_with_targetname_from_spawner( "blackout_spawner" );
	org = getent( guy.target, "targetname" );
	guy.ignoreall = true;
*/
	allies = getaiarray( "allies" );
	ally_orgs = getentarray( "ally_blackout_org", "targetname" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] teleport( ally_orgs[ i ].origin, ally_orgs[ i ].angles );
	}

	level.player setorigin( player_org.origin );
	
	/*
	wait( 2 );
	anims = [];
	anims[ anims.size ] = "blind_fire_pistol";	// corner guy aiming with pistol
	anims[ anims.size ] = "blind_fire_pistol_death";
	anims[ anims.size ] = "blind_hide_fire";		// pop up from behind cover spray area
	anims[ anims.size ] = "blind_hide_fire_death";
	anims[ anims.size ] = "blind_lightswitch";
	anims[ anims.size ] = "blind_lightswitch_death";
	anims[ anims.size ] = "blind_wall_feel";
	anims[ anims.size ] = "blind_wall_feel_death";
	
	anims[ anims.size ] = "close";
	anims[ anims.size ] = "death_1";
	anims[ anims.size ] = "death_2";
	anims[ anims.size ] = "fire_1";
	anims[ anims.size ] = "fire_2";
	anims[ anims.size ] = "fire_3";
	anims[ anims.size ] = "grenade";
	anims[ anims.size ] = "idle";
	anims[ anims.size ] = "jump";
	anims[ anims.size ] = "kick";
	anims[ anims.size ] = "open";

	door = spawn_anim_model( "door" );	
	
	guy.animname = "generic";
	guys = [];
	guys[ guys.size ] = guy;
	guys[ guys.size ] = door;

	guy.noback = true;

	for ( i=0; i < anims.size; i++ )
	{
		anime = anims[ i ];
		iprintlnbold( "about to play: " + anime );
		wait( 2 );
//		guy animscripts\shared::placeWeaponOn( guy.sidearm, "right" );
//		org anim_generic( guy, anime );
		org anim_single( guys, anime );
		wait( 1 );
	}	
	*/
	
	thread blackout_house();
}

blackout_house()
{
	Objective_Position( 7, informant_org() );
	Objective_Ring( 7 );

	flag_wait( "blackout_house_begins" );
	
	// Gaz, go around the back and cut the power. Everyone else, get ready!                                
	level.price dialogue_queue( "cut_the_power" );

	node = getnode( "power_node", "targetname" );
	level.gaz setgoalnode( node );
	level.gaz.goalradius = 32;
	
	blackout_defend_node = getnode( "blackout_defend_node", "targetname" );
	level.bob setgoalnode( blackout_defend_node );
	level.bob.goalradius = 32;
	
	level.price disable_ai_color();
	level.gaz disable_ai_color();
	level.bob disable_ai_color();
	
	
	blackout_door = getent( "blackout_door", "targetname" );
	blackout_door anim_reach_and_approach_solo( level.price, "smooth_door_open" );
	level.price.grenadeammo = 0; // bad when he throws them indoors
	level.price.baseaccuracy = 1000;
	level.price.noreload = true;
	
	thread price_hunts_house();
	thread blackout_guy_animates( "lightswitch_spawner", "blind_lightswitch", "switch_guy_goes", 8 );
	thread blackout_guy_animates( "wall_spawner", "blind_wall_feel", "wall_guy_goes", 5 );
	thread blackout_guy_animates_loop( "corner_spawner", "blind_fire_pistol", "corner" );
	
	autosave_by_name( "blackout" );
	door = getent( "slow_door", "targetname" );
	door thread hunted_style_door_open();
	
	flag_set( "switch_guy_goes" );
	level.price cqb_walk( "on" );
	level.price.disablearrivals = true;
	blackout_door thread anim_single_solo( level.price, "smooth_door_open" );
	
	flag_wait( "upstairs_guys_spawn" );
	thread blackout_guy_animates( "hide_spawner", "blind_hide_fire", "came_upstairs", 2.9 );
	thread blackout_door_guy();
	
	flag_wait( "door" );
	level.price set_force_color( "o" );
}
