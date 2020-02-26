// scripting by Bloodlust
// level design by BSouds

#include maps\_anim;
#include maps\_utility;
#include maps\ber1_util;
#include maps\pel2_util;
#include common_scripts\utility;

// main function for handeling Berlin 1 - "The Key to Berlin"
main()
{
	
	// setup skiptos
	// to run, type: +set start "area_name"
	add_start( "ruins", ::start_ruins, &"STARTS_BER1_RUINS" );
	add_start( "midruins", ::start_midruins, &"STARTS_BER1_RUINS_2" );
	add_start( "execution", ::start_execution, &"STARTS_BER1_SURRENDER" );
	add_start( "street", ::start_street, &"STARTS_BER1_STREET" );
	add_start( "asylum", ::start_asylum, &"STARTS_BER1_ASYLUM" );
	add_start( "tankride", ::start_tankride, &"STARTS_BER1_TANKRIDE" );
	
	//default_start( ::start_ruins );
	default_start( ::ber1_main );

	do_precacheing();

	maps\_aircraft::main( "vehicle_rus_airplane_il2", "stuka" );
	maps\_aircraft::main( "weapon_ger_panzershreck_rocket", "il2", undefined, 0 );
	maps\_t34::main( "vehicle_rus_tracked_t34_mg", "t34_ber1" );
	maps\_mganim::main();

	// MikeD (5/5/2008): Vehicle Destructible Support
	maps\_destructible_mercedesw136::init();	


	// 	for intro rail ambient drones to not outrun the tanks
	setup_drones();

	// load map defaults
	maps\ber1_fx::main();
	maps\_load::main();
	maps\ber1_amb::main();
	maps\ber1_status::main();
	maps\ber1_anim::main();
	
	setup_level();
	
	// start callback functions
	level thread maps\ber1_callbacks::onFirstPlayerConnect();
	level thread maps\ber1_callbacks::onPlayerConnect();
	
	setup_spawn_functions();
	//assign_allies_to_threatbiasgroup();

}

// default start for Berlin 1
ber1_main()
{
	
	// check whether to skip to a start point	
	level.startskip = undefined;
	
	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		start = getent( "player_train_start" + i, "targetname" );
		players[i] setOrigin( start.origin );
		players[i] setPlayerAngles( start.angles );
	}
	
	simple_spawn( "start_guys" );
	wait( 0.1 );
	level thread maps\ber1_event1::main();
	
}



//Skip to Event 1
start_ruins()
{
	
	level.startskip = "ruins";
	
	flag_set( "train_door_opened" );
	
	simple_spawn( "start_guys" );
	
	wait( 0.05 );
	
	warp_players_underworld();
    warp_friendlies( "ruins_start_ai", "targetname" );
    warp_players( "ruins_start_players", "targetname" );
	
	set_color_chain( "chain_ruins_start" );
		
	level thread maps\ber1_event1::event1_threads();

	wait( 0.2 );

	level thread maps\ber1_event1::intro_barrage();

	wait( 0.5 );
	
	maps\ber1_event1::spawn_tanks();

	wait( 0.05 );

	tank = getent( "ev1_tank2", "targetname" );
	vnode = getvehiclenode( "auto3484", "targetname" );
	tank attachpath( vnode );
	tank thread maps\_vehicle::vehicle_paths( vnode );

	tank = getent( "ev1_tank1", "targetname" );
	vnode = getvehiclenode( "auto3398", "targetname" );
	tank attachpath( vnode );
	tank thread maps\_vehicle::vehicle_paths( vnode );
	tank.rollingdeath = 1;
	tank thread maps\ber1_event1::tank_rolling_death();
	
	tank = getent( "tank_3", "targetname" );
	vnode = getvehiclenode( "auto3412", "targetname" );
	tank attachpath( vnode );
	tank thread maps\_vehicle::vehicle_paths( vnode );	

	maps\ber1_event1::ruins_split_color_squads();
	
}



start_midruins()
{

	level.startskip = "midruins";
	
	friendlies = simple_spawn( "start_guys" );
	thin_out_friendlies( friendlies );	
	
	wait( 0.05 );
	
	warp_players_underworld();
    warp_friendlies( "midruins_start_ai", "targetname" );
    warp_players( "midruins_start_players", "targetname" );	
	
	level thread maps\ber1_event1::spawn_ruins_pickup_weapons();
	level thread maps\ber1_event1::trig_clocktower_vo();
	
	set_color_chain( "colortrig_r3" );
	
	simple_floodspawn( "office_gunners", maps\ber1_event1::ruins_gunners_strat );
	simple_floodspawn( "office_defend_spawners" );
	
	objective_string( 2, &"BER1_CLEAR_CLOCKTOWER" );
	objective_position( 2, (944, -368, -229.6) );
	
	// TANKS
	/////////////////
	maps\ber1_event1::spawn_tanks();
	wait( 0.05 );	
	
	tank = getent( "ev1_tank1", "targetname" );
	vnode = getvehiclenode( "auto3988", "targetname" );
	tank attachpath( vnode );
	tank thread maps\_vehicle::vehicle_paths( vnode );	
	tank thread maps\_vehicle::mgoff();		
	level thread maps\ber1_event1::tank1_part2( tank );
	tank.rollingdeath = 1;
	tank thread maps\ber1_event1::tank_rolling_death();	
	
	tank = getent( "ev1_tank2", "targetname" );
	vnode = getvehiclenode( "auto3495", "targetname" );
	tank attachpath( vnode );
	tank thread maps\_vehicle::vehicle_paths( vnode );
	tank thread maps\_vehicle::mgoff();		
	level thread maps\ber1_event1::tank2_part2( tank );
	///////////////
	// end TANKS
	
	allies = getaiarray( "allies" );
	for( i  = 0; i < allies.size; i++ )
	{
		if( !isdefined( self.script_no_respawn ) )
		{
			allies[i] thread replace_on_death();
		}
		
		allies[i] set_force_color("r");
	}	
	
	level thread maps\ber1_event1::clock_tower_battle();	
	
}



//Skip to surrender vignette
start_execution()
{

	level.startskip = "execution";
	
	wait( 0.05 );
	
    warp_players( "execution_start_players", "targetname" );	
	
	wait( 0.05 );

	if( !is_german_build() )
	{
		level thread maps\ber1_event1::execution_vignette();
	}
	else
	{
		flag_set( "execution_over" );
		allies = simple_spawn( "execution_allies", maps\ber1_event1::execution_allies_german_safe_strat );	
	}
	
}



// start at the very beginning of the street
start_street()
{                      
	
	level.startskip = "street";
	
	friendlies = simple_spawn( "start_guys" );
	thin_out_friendlies( friendlies );	
	
	// crumble the wall so reinforcements can make it to the street
	/////////////
	pieces = getEntArray("tank_wall", "targetname");
	for (i = 0; i < pieces.size; i++)
	{
		pieces[i] notsolid();
		pieces[i] connectpaths();
	}	
	getent("delete_chunk","targetname") connectpaths();
	getent("delete_chunk","targetname") delete();
	//////////////

	allies = getaiarray( "allies" );
	for( i  = 0; i < allies.size; i++ )
	{
		if( !isdefined( self.script_no_respawn ) )
		{
			allies[i] thread replace_on_death();
		}
	}
	
	level thread maps\ber1_event2::event2_split_squad();
	
	// get reinforcements going
	friendly_trig = getent( "auto3595", "target" );
	friendly_trig notify( "trigger" );
	
	simple_floodspawn( "street_right_spawners_1" );
	
	wait( 0.05 );

	set_color_chain( "courtyard_squad_split" );

	// start ambient drones
	drone_trig = getent( "street_drones_1", "script_noteworthy" );
	drone_trig notify( "trigger" );

	level thread maps\ber1_event2::street_first_floodspawners();
	level thread maps\ber1_event2::street_battle();

    warp_players_underworld();
    warp_friendlies( "street_start_ai", "targetname" );
    warp_players( "street_start_players", "targetname" );


}


// start at the very beginning of the asylum
start_asylum()
{                      
	
	level.startskip = "asylum";
	
	friendlies = simple_spawn( "start_guys" );
	thin_out_friendlies( friendlies );
	
	wait( 0.05 );

    warp_players_underworld();
    warp_friendlies( "asylum_start_ai", "targetname" );
    warp_players( "asylum_start_players", "targetname" );


	allies = getaiarray( "allies" );
	for( i  = 0; i < allies.size; i++ )
	{
		if( !isdefined( self.script_no_respawn ) )
		{
			allies[i] thread replace_on_death();
		}
		
		allies[i] set_force_color("r");
	}
	
	maps\ber1_asylum::main();

}



//Skip to Event 3
start_tankride()
{

	level.startskip = "tankride";
	
	friendlies = simple_spawn( "start_guys" );
	thin_out_friendlies( friendlies );	
	
	allies = getaiarray( "allies" );
	for( i  = 0; i < allies.size; i++ )
	{
		if( !isdefined( self.script_no_respawn ) )
		{
			allies[i] thread replace_on_death();
		}
		
	}	
	
	wait( 0.05 );

    warp_players_underworld();
    warp_friendlies( "tankride_start_ai", "targetname" );
    warp_players( "tankride_start_players", "targetname" );

//// TEMP! VO TEST
//	battlechatter_off();
//	wait( 2 );
//	maps\ber1_tankride::tankride_vo();
/////////////

	level thread maps\ber1_tankride::main();
	
	wait( 0.05 );
	
	tank = getent( "street_tank_1", "targetname" );
	vnode = getvehiclenode( "auto3894", "targetname" );
	tank attachpath( vnode );
	tank thread maps\_vehicle::vehicle_paths( vnode );	
	
	tank = getent( "street_tank_2", "targetname" );
	vnode = getvehiclenode( "auto3933", "targetname" );
	tank attachpath( vnode );
	tank thread maps\_vehicle::vehicle_paths( vnode );	
	
}



///////////////////
//
// sets up the heroes
//
///////////////////////////////

setup_heroes()
{

	level.heroes = [];
	
	level.reznov = getent( "sarge", "script_noteworthy" );
	level.chernov = getent( "chernov", "script_noteworthy" );
	level.commissar = getent( "commissar", "script_noteworthy" );

	level.heroes[0] = level.reznov;
	level.heroes[1] = level.chernov;
	level.heroes[2] = level.commissar;
	
	array_thread( level.heroes, ::hero_setup_thread );

}



hero_setup_thread()
{

	self.animname = "russian";
	self thread magic_bullet_shield();
	self.goalradius = 512;
		
}



// GUZZO
setup_level()
{
	
	setup_guzzo_hud();
	
	// Ruins
	flag_init( "tank_3_shot_failsafe" );
	flag_init( "tank_3_ready_to_die" );
	flag_init( "ruins_tank_at_end" );
	flag_init( "chimney_collapsed" );
	flag_init( "spawn_tanks" );
	flag_init( "move_tanks_3" );
	flag_init( "move_tanks_1" );
	flag_init( "clock_tower_battle_timeout" );
	flag_init( "tank1_disabled" );
	flag_init( "tank1_destroyed" );
	flag_init( "tank_ambush" );
	flag_init( "ruins_charge" );
	flag_init( "calling_intro_barrage" );
	flag_init( "train_door_opened" );
	flag_init( "train_has_stopped" );
	flag_init( "start_office_building" );
	flag_init( "intro_barrage_complete" );
	flag_init( "office_wall_done" );
	// EXECUTION/STREETS
	flag_init( "execution_left_over" );
	flag_init( "execution_right_over" );
	flag_init( "last_yard_floodspawners" );
	flag_init( "roof_shreks" );
	flag_init( "execution_over" );
	flag_init( "bookcase_push_starting" );
	flag_init( "bookcase_pushed_over" );
	flag_init( "surrender_begin" );
	flag_init( "chain_street_left_1" );
	flag_init( "chain_street_right_1" );
	// ASYLUM
	flag_init( "kill_staircase_spawn_trig" );
	flag_init( "kill_wave2_trig" );	
	flag_init( "fly_crow_fly" );
	flag_init( "indoor_crow_fly" );
	flag_init( "indoor_chain" );
	flag_init( "atrium_color_chain" );
	flag_init( "flag_indoor_chain" );
	flag_init( "stair_vo_override" );
	flag_init( "creepy_vo_trig" );
	flag_init( "override_balcony_vo" );
	// TANKRIDE
	flag_init( "outro_tank_riders_safe" );
	flag_init( "player_mounted_on_tank" );
	flag_init( "tank_1_cant_mount" );
	flag_init( "tank_2_cant_mount" );
	
	
	// OBJECTIVES
	flag_init( "objective_end" );
	flag_init( "objective_surrender" );
	flag_init( "objective_ruins" );
//	flag_init( "objective_office" );
	flag_init( "objective_office_2" );
	

	level.exit_train_pathing_num = 0;
	level.playing_reznov_yes_vo = false;
	level.nextmission_cleanup = maps\ber1_tankride::cleanupFadeoutHud;
	
	// Create a new threat bias group. If it already exists, do nothing
	createthreatbiasgroup( "panzershreck_threat" );
	createthreatbiasgroup( "office_gunner_threat" );
	createthreatbiasgroup( "outro_blue_guys" );
	createthreatbiasgroup( "outro_blue_targeters" );
	//createthreatbiasgroup( "squad" );	
	createthreatbiasgroup( "players" );	
	
	setup_heroes();
	
	level thread objectives();
	
	// do objective skip if using a start
	if( GetDvar( "start" ) != "" )
	{
		setup_objectives_skip();
	}
	
	/#
	//setsaveddvar( "loc_warnings", 0 );
	setdvar( "debug_character_count", "on" );
	setdvar( "debug_triggers", "1" ); // james' code-side debug dvar
	level thread debug_script_flag_trigs_print();
	level thread draw_goal_radius();
	//level debug_ai_health();
	#/		
	
	if(NumRemoteClients())
	{
		if(NumRemoteClients() > 1)	// 3 or 4 player coop
		{
			level.max_drones["axis"] = 7;
		}
		else												// 2 player coop
		{
			level.max_drones["axis"] = 12;
		}
	}
	
}



// precache anything that needs it
do_precacheing()
{
	
	precachemodel( "mounted_ger_mg42_bipod_mg" );
	precacheModel("anim_berlin_house_collapse");
	precacheModel("anim_berlin_office_exit");
	precacheModel("anim_berlin_officewall");
	precacheModel("anim_berlin_ruins_chimney");
	precacheModel("katyusha_rocket");
	//precacheModel("projectile_us_smoke_grenade");
	precacheModel("weapon_ger_panzershreck_rocket");
	precacheModel("anim_berlin_tank_wall");	
	
	precacheModel( "vehicle_rus_tracked_t34_seta_body" );
	precacheModel( "vehicle_rus_tracked_t34_seta_turret" );
	precacheModel( "vehicle_rus_tracked_t34_setb_body" );
	precacheModel( "vehicle_rus_tracked_t34_setb_turret" );
	precacheModel( "vehicle_rus_tracked_t34_setc_body" );
	precacheModel( "vehicle_rus_tracked_t34_setc_turret" );
	
	precacheModel( "anim_berlin_crow" ); 

	precacheShellShock("teargas");
	precacheShader("black");

	PrecacheRumble( "grenade_rumble" );
	PrecacheRumble( "ber1_train" ); 
	PrecacheRumble( "ber1_barrage" ); 
	
	PrecacheItem( "napalmblob" );
	precacheItem( "napalmbloblight" );                                

}



///////////////////
//
// Setup drones
//
///////////////////////////////

setup_drones()
{

	level.drone_run_speed = 90;
	
	character\char_rus_r_rifle::precache();
	character\char_ger_wrmcht_k98::precache();
	
	level.drone_spawnFunction["allies"] = character\char_rus_r_rifle::main;
	level.drone_spawnFunction["axis"] = character\char_ger_wrmcht_k98::main;
	
	maps\_drones::init();	
	
}


objectives()
{
	
	flag_wait( "train_has_stopped" );
	
	
	objective_add( 1, "current", &"BER1_REGROUP_BERM", (-30, -5519, -511.7) );
	// flag set on trigger
	flag_wait( "calling_intro_barrage" );
	
	
	objective_state ( 1, "done" );
	flag_wait( "objective_ruins" );


	objective_add( 2, "current", &"BER1_CLEAR_RUINS", (930, -1985, -423.2) );
	
	flag_wait( "move_tanks_3" );
	
	objective_state( 2, "done" );



	flag_wait( "start_office_building" );

	objective_add( 3, "current", &"BER1_CLEAR_OFFICE", (1338, -106, -168) );
	
	// flag set on trigger
	flag_wait( "objective_office_2" );
	
	objective_state( 3, "done" );
	
	flag_wait( "objective_surrender" );
	
	objective_add( 4, "current", &"BER1_ENTER_ASYLUM", (4590, 2762, -288) );

	// flag set on trigger
	flag_wait( "entered_asylum" );
	
	objective_state( 4, "done" );
	
	
	objective_add( 5, "current", &"BER1_CLEAR_ASYLUM", (2608, 4386, -126) );

	// flag set on trigger	
	flag_wait( "asylum_exit" );

	objective_state( 5, "done" );


	objective_add( 6, "current", &"BER1_PUSH_GERMANS", ( 1519.5, 7789.5, -413 ) );

	flag_wait( "objective_end" );

	objective_state( 6, "done" );
	
}



///////////////////
//
// Sets up objectives when used with starts
//
///////////////////////////////

setup_objectives_skip()
{
	
	wait ( 0.01 );
	
	obj_complete = 0;
	
	start_string = GetDvar( "start" );
	
	// determine how far to skip
	switch( start_string )
	{
		
		case "ruins":
			
			obj_complete = 1;
			break;
		
		case "midruins":

			obj_complete = 2;
			break;
		
		case "surrender":
		
			obj_complete = 3;
			break;		

		case "street":
			
			obj_complete = 4;
			break;
		
		case "asylum":
			
			obj_complete = 4;
			break;
		
		case "tankride":
			
			obj_complete = 5;
			break;		
		
		default:
			return;
					
	}	
	
	obj_index = 1;
	
	
	// actually send out notifies that the setup_objectives() thread will receive so it can skip objectives
	while( obj_index <= obj_complete )
	{

		if( obj_index == 1 )
		{
			flag_set( "train_has_stopped" );
		}
		else if( obj_index == 2 )
		{
			flag_set( "calling_intro_barrage" );
			flag_set( "objective_ruins" );
		}
		else if( obj_index == 3 )
		{
			flag_set( "start_office_building" );
			flag_set( "objective_office_2" );
		}	
		else if( obj_index == 4 )
		{
			flag_set( "objective_surrender" );
		}			
		else if( obj_index == 5 )
		{
			flag_set( "entered_asylum" );
			flag_set( "asylum_exit" );
		}	
		else if( obj_index == 6 )
		{
			//level notify( "obj_building_complete" );
		}	
		else if( obj_index == 7 )
		{
			//level notify( "obj_airfield_tanks_complete" );
		}			
		else if( obj_index == 8 )
		{
			//level notify( "obj_airfield_complete" );
		}	
		
		obj_index++;
		wait ( 0.05 );
		
	}
	
}
