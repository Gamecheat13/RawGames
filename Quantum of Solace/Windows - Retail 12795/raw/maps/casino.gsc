#include maps\_utility;
#include common_scripts\utility;
//#include maps\casino_util;
//#include maps\casino_floor2;


//
//	Montenegro Casino 2 : Follow Le Chiffre
//
//	A note on targetnames:  Most of the targenames start with "c".  This was done
//	to differentiate "casino" entities from "casino_poison" entities (before the 
//	levels were split).
//
main()
{
	// This stuff must come before _load::main().

	// Data collection item strings.
	level.strings["casino_data0_name"] = &"CASINO_DATA0_NAME";
	level.strings["casino_data0_body"] = &"CASINO_DATA0_BODY";

	level.strings["casino_data1_name"] = &"CASINO_DATA1_NAME";
	level.strings["casino_data1_body"] = &"CASINO_DATA1_BODY";

	level.strings["casino_data2_name"] = &"CASINO_DATA2_NAME";
	level.strings["casino_data2_body"] = &"CASINO_DATA2_BODY";

	level.spawnerCallbackThread = ::spawn_think;

	// Need one of these for each vehicle
	maps\casino_fx::main();
	maps\_securitycamera::init();
//	maps\_trap_extinguisher::init();
	maps\_vsedan::main( "v_sedan_blue_radiant" );
	maps\_vsedan::main( "v_sedan_silver_radiant" );

	PrecacheCutScene("LeChiffre");
	PrecacheCutScene("two_thug_death");
	PreCacheShader("black");
	precachemodel("w_t_machette");
	PrecacheCutScene("Obano_Fight_Vesper_01");
	PrecacheCutScene("Obanno_Fight_Final_Success");
	PrecacheCutScene("Obanno_Fight_Intro");
	PrecacheCutScene("Obanno_Fight_Fail");
	
	// Define blackout HUD element
	if (!IsDefined(level.hud_black))
	{
		level.hud_black = newHudElem();
		level.hud_black.x = 0;
		level.hud_black.y = 0;
		level.hud_black.horzAlign = "fullscreen";
		level.hud_black.vertAlign = "fullscreen";
		level.hud_black SetShader("black", 640, 480);
		level.hud_black.alpha = 0;
	}

	// End Precache calls

	maps\_load::main();
	maps\casino_amb::main();
	maps\casino_mus::main();

	array_thread(GetAIArray(), ::ai_think);

	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading_idle");
	setWaterWadeFX("maps/Casino/casino_spa_wading");

	// Phone setup
	precacheShader( "compass_map_casino" );
	setminimap( "compass_map_casino", 496, 3072, -7680, 40 );
	maps\_phone::setup_phone();

	// Vision set
	level.curr_visionset = "casino_01";
	Visionsetnaked( "casino_01" );
	setExpFog(5700,26117,0.36,0.414,0.555,0.711);

//  fog now in casino_fx
	//setExpFog(level.fognearplane, level.fogexphalfplane, level.fogred, level.foggreen, level.fogblue, 0, level.fogmax);
	
	
    SetSavedDVar("r_godraysColorTint",  "0.6 0.7 1.0");
    SetSavedDVar("r_godraysPosX2",  "0.0");
    SetSavedDVar("r_godraysPosY2",  "-1.0");
	SetDVar("sm_sunShadowEnable", "0" );

	// Artist mode
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}
	
	// Level VARS
	level.play_cutscenes = true;									// Play or skip cutscenes

	// Level Threads
	runthread_func_setup();					// Specify the "function lookup" function for the runthread utility
	array_thread( GetEntArray("runthread", "targetname"),		 maps\casino_util::runthread_start );	// look for auto thread entities!
	array_thread( GetEntArray("ctrig_ledge_lock", "targetname"), maps\casino_util::cover_lock );		// cover locking for ledges
	setup_special_objects();		// Awareness, useable, 
	level thread maps\casino_util::reinforcement_controller( "none", "none" );

	//level thread handleTraversalNotify(); // should be automatically handled by _utility::ledge_fail

	/////////////////////////////////////////
	//avulaj
	//added this to dispaly the level map
	//03/29/08
	level thread display_map();
	/////////////////////////////////////////

/*
	// Delete the monster clips around the pool (I need these here during connectpaths so nodes
	//	don't connect across the pool )
	clips = GetEntArray( "csbm_e3_pool_clips", "targetname" );
	for ( i=0; i<clips.size; i++ )
	{
		clips[i] trigger_off();
	}
*/
	thread bond_location_monitor_start();		// Keep track of what area bond is in
	
	thread civilian_safety_monitor();

	// Objectives
	flag_init( "obj_start" );
//	flag_init( "obj_detour_start" );			// This is performed on a flag_set trigger, so it's automagically initialized through that.
//	flag_init( "obj_detour_end" );				// This is performed on a flag_set trigger, so it's automagically initialized through that.
//	flag_init( "obj_detour2_start" );			// This is performed on a flag_set trigger, so it's automagically initialized through that.
	flag_init( "obj_spa_exit_open" );
//	flag_init( "obj_detour2_end" );				// This is performed on a flag_set trigger, so it's automagically initialized through that.
//	flag_init( "obj_unlock_entrance_start" );	// This is performed on a flag_set trigger, so it's automagically initialized through that.
	flag_init( "obj_unlock_entrance_end" );
	flag_init( "obj_hack_door_start" );
	flag_init( "obj_hack_door_end" );
	thread objectives();
	
	checkpoints();						// Skiptos / checkpoints
	SetDVar("r_lodBias", -500);
}


//############################################################################
//	Checkpoint resolver
//
checkpoints()
{
	// Teleport player
	skipto = GetDVar( "skipto" );
	start_pos = "";
	level.curr_visionset = "casino_01";
	
	if ( skipto == "test" )
	{
		start_pos = GetEnt( "temp_player_position", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}
	}
	// E2 Entrance suite
	else if ( skipto == "E2" ) 
	{
		level thread maps\casino_pip::intro_pip();

		start_pos = GetNode( "cn_e2_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level.curr_visionset = "casino_07";
		level thread checkpoint_e2_advance_objectives();

		trig = GetEnt("ctrig_e2_outer_suite", "targetname" );
		trig waittill( "trigger" );

		level thread maps\casino_follow::e2_main();
	}
	// E3 Spa
	else if ( skipto == "E3" ) 
	{
		start_pos = GetNode( "cn_e3_vent_start", "targetname" );	// start in the vent
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}
		level.curr_visionset = "casino_02";

		level thread checkpoint_e3_advance_objectives();
		wait(0.1);
		level thread maps\casino_follow::e3_main();
		
		//this trigger is behind you -jc
		wait(0.1);	//just in case
		trig = GetEnt("trig_e3_vent", "targetname" );
		trig notify( "trigger" );	//trigger it here
		
	}
	// E3b inside locker room
	else if ( skipto == "E3B" ) 
	{
		start_pos = GetNode( "cn_e3_start", "targetname" );	// Start in the locker room
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}
		level.curr_visionset = "casino_02";

		level thread checkpoint_e3b_advance_objectives();
		level thread maps\casino_follow::e3_main();
	}
	// E4 Courtyard
	else if ( skipto == "E4" )
	{
		start_pos = GetNode( "cn_e4_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level.curr_visionset = "casino_03";
		level thread checkpoint_e4_advance_objectives();
		level thread maps\casino_follow::e4_main();
	}
	// E5 ?
	else if ( skipto == "E5" )
	{
		start_pos = GetNode( "cn_e5_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level.curr_visionset = "casino_05";
		flag_set("cf_e5_patrol" );
		level thread checkpoint_e5_advance_objectives();
		level thread maps\casino_follow::e5_main();
	}
	// E6 Conference room
	else if ( skipto == "E6" )
	{
		start_pos = GetNode( "cn_e6_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level.curr_visionset = "casino_05";
		level thread checkpoint_e6_advance_objectives();
		level thread maps\casino_follow::e6_main();
	}
	// E7 Obanno
	else if ( skipto == "E7" )
	{
		start_pos = GetNode( "cn_e7_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level.curr_visionset = "casino_06";
		level thread checkpoint_e7_advance_objectives();
		level thread maps\casino_follow::e7_main();
	}

	// Start at the beginning of casino
	else 
	{
		if ( skipto == "noIGC" )
		{
			level.play_cutscenes = false;
		}

		start_pos = GetEnt( "casino_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}
		level thread maps\casino_follow::e1_main();
	}

	Visionsetnaked( level.curr_visionset );
}


//
//	Funcs to advance the objectives
//

// Start of e2
checkpoint_e2_advance_objectives()
{
	flag_set( "obj_start" );
	flag_set( "obj_detour_start" );
}
// Start of e3
checkpoint_e3_advance_objectives()
{
	checkpoint_e2_advance_objectives();

	flag_set( "obj_detour_end" );
	flag_set( "obj_detour2_start" );
}
// Start of e3b
checkpoint_e3b_advance_objectives()
{
	checkpoint_e3_advance_objectives();

}
// Start of e4
checkpoint_e4_advance_objectives()
{
	checkpoint_e3b_advance_objectives();

	flag_set( "flag_in_spa_lobby");
	flag_set( "obj_spa_exit_open" );
}
// Start of e5
checkpoint_e5_advance_objectives()
{
	checkpoint_e4_advance_objectives();

	flag_set( "cf_e4_alterpatrol");
	flag_set( "obj_detour2_end" );
}
// Just before E6
checkpoint_e6_advance_objectives()
{
	checkpoint_e5_advance_objectives();

	flag_set( "obj_unlock_entrance_start" );
	flag_set( "obj_unlock_entrance_end" );		// unlock the doors
}
// Just before E7
checkpoint_e7_advance_objectives()
{
	checkpoint_e6_advance_objectives();

	flag_set( "obj_hack_door_start" );
	flag_set( "obj_hack_door_end" );
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//avulaj
//03/29/08
//added this to dispaly the level map
//this will display the first area map including the 1st hall the 1st ledge the suite leading to the vent
display_map()
{
	wait( 1 );
	setSavedDvar( "sf_compassmaplevel",  "level1" );
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////

//############################################################################
// Handles objective progression
//
objectives( )
{
	// Start objectives
	flag_wait( "obj_start");

	// Follow Le Chiffre
	objective_add(0, "active", &"CASINO_OBJ_FOLLOW_LECHIFFRE", (-264, 1656, 736), &"CASINO_OBJ_FOLLOW_LECHIFFRE_DETAIL" );
	objective_state(0, "current");
	flag_wait( "obj_detour_start");

	flag_wait( "obj_detour_end" );

	objective_state(0, "done" );
	// Find a way into the spa
	objective_add(1, "active", &"CASINO_OBJ_SPA", (-669, 2233, 805), &"CASINO_OBJ_SPA_DETAIL" );
	objective_state(1, "current");

	flag_wait( "obj_detour2_start");
	objective_position( 1, (-752, 1584, 908) );

	flag_wait( "flag_in_spa_lobby");

	objective_state(1, "done" );
	// Clear the spa
	objective_add(2, "active", &"CASINO_OBJ_CLEAR_SPA", (-1370, 1656, 748), &"CASINO_OBJ_CLEAR_SPA_DETAIL" );
	objective_state(2, "current");
	flag_wait( "obj_spa_exit_open" );

	objective_position( 2, (-2659, 1830, 756) );	// courtyard
	flag_wait( "cf_e4_alterpatrol");

	objective_position( 2, (-4010, 1651, 780) );	// across to the ballroom
	flag_wait("obj_unlock_entrance_start");

	objective_state(2, "done" );

	objective_add(3, "active", &"CASINO_OBJ_BALLROOM", (-3696, 1796, 780), &"CASINO_OBJ_BALLROOM_DETAIL" );		// Unlock the doors
	objective_state(3, "current");
	flag_wait("obj_unlock_entrance_end");

	wait( 5.5 ); //	Need a wait here to let the hack menu disappear, then we can clear the objective 
				// and have the "completed" text show up
	objective_position( 3, (-4010, 1651, 780) );	// across to the ballroom
	

	trigger = getent("ctrig_e6_con_room_inside", "targetname");
	trigger waittill("trigger");

	objective_state(3, "done" );
	objective_add(4, "active", &"CASINO_OBJ_AMBUSH", (-4977.2, 1814.9, 676.2), &"CASINO_OBJ_AMBUSH_DETAIL" );		// Unlock the doors
	objective_state(4, "current");

	flag_wait("obj_hack_door_start");
	flag_wait("obj_hack_door_end");

	objective_state(4, "done" );
    objective_add(5, "active", &"CASINO_OBJ_SUITE", (-6060, 1800, 780.2), &"CASINO_OBJ_SUITE_DETAIL" );		// Unlock the doors
	objective_state(5, "current");
 
	trigger = getent("ctrig_e6_final_door", "targetname");
	trigger waittill("trigger");

	level waittill( "e7_start" );

	objective_state(5, "done" );
}

//############################################################################
civilian_safety_monitor()
{
	trigCivile = GetEnt("civilianarea",			"targetname");
	trigPlayer = GetEnt("playercivilianarea",	"targetname");
		
	if( IsDefined(trigCivile)  &&  IsDefined(trigPlayer)  )
	{		
		count = 0;

		//Give few chance to the player
		while( count < 3 )
		{
			trigCivile waittill("damage", amount, attacker);
			
			if( attacker == level.player )
			{				
				if( level.player isTouching( trigPlayer ) )
				{			
					count++;
				}
			}
		}
		
		MissionFailedWrapper();	
	}
}


//############################################################################
bond_location_monitor_start()
{
	ents = GetEntArray( "trig_on_floor", "targetname" );
	for ( i=0; i<ents.size; i++ )
	{
		ents[i] thread bond_location_monitor();
	}
}


//############################################################################
bond_location_monitor( )
{
	while (1)
	{
		self waittill( "trigger" );

		level notify( "bond_on_floor_"+self.script_int );
		wait( 5.0 );
	}
}


//############################################################################
setup_special_objects()
{
	// Flickering lights
	lights = GetEntArray( "closetlight", "targetname" );
	for ( i=0; i<lights.size; i++ )
	{
		lights[i] thread maps\casino_util::casino_light_flicker();
	}

	// Falling Mousetraps
	maps\_playerawareness::setupArrayDamageOnly( 
		"mousetrap_falling",					//	awareness_entity_name, 
		maps\casino_util::falling_mousetrap,	//	damage_event_to_call, 
		false,									//	allow_aim_assist, 
		undefined,								//	filter_to_call, 
		level.awarenessMaterialNone,			//	awareness_material, 
		true,									//	awareness_glow, 
		false );								//	awareness_shine )

	// Setup Push Carts
	push_cart_origins = GetEntArray( "push_cart_dest", "targetname" );
	for ( i=0; i<push_cart_origins.size; i++)
	{
		cart = GetEnt( push_cart_origins[i].target, "targetname" );

		// calculate how far and in which direction this will move.
		cart.push_vec = push_cart_origins[i].origin - cart.origin;

		// link all connected objects to the parent
		attachments = GetEntArray( cart.target, "targetname" );
		for ( j=0; j<attachments.size; j++ )
		{
			attachments[j] LinkTo(cart);
		}
		maps\_useableObjects::create_useable_object( 
			cart,							//	entities, 
			::use_push_cart,				//	use_event_to_call
//			&"CASINO_HINT_MOVE_CART",		//	hint_string
			"Move Cart",
			0,								//	use_time
			"",								//	use_text
			false,							//	single_use
			true,							//	require_lookat
			true );							//	initially_active
	}

	// spa blocker - _brian_b_ added monster clip to help control the spa guys
	blocker = GetEnt("spa_exit_blocker", "targetname");
	blocker ConnectPaths();
	blocker trigger_off();

	// Cameras
	cameras = GetEntArray( "view_cam", "targetname" );
	for ( i=0; i<cameras.size; i++ )
	{
		cameras[i] maps\_securitycamera::camera_start( undefined, false, undefined, undefined);
	}
	maps\_securitycamera::camera_tap_start( undefined, cameras );
}


//############################################################################
// Use Push cart callback
use_push_cart( player )
{
	cart = self.entity;

	cart MoveTo( (cart.origin + cart.push_vec), 2.0, 0.1, 1.0 );
}


//
//	This is a lookup table that should contain a reference to any function you would like to "auto thread" when 
//	an AI is spawned via the spawn_guys utility function
//
runthread_func_setup( func_name )
{
	level.runthread_func[ "delete_on_goal" ]			= maps\casino_util::delete_on_goal;
	level.runthread_func[ "holster_weapons" ]			= maps\casino_util::trig_holster_weapons;
	level.runthread_func[ "patrol" ]					= maps\casino_util::patrol;
	level.runthread_func[ "reinforcement_update" ]		= maps\casino_util::trig_reinforcement_update;
	level.runthread_func[ "tether_on_goal" ]			= maps\casino_util::tether_on_goal;
	level.runthread_func[ "trigger_spawn_guys" ]		= maps\casino_util::trigger_spawn_guys;
	level.runthread_func[ "unholster_weapons" ]			= maps\casino_util::trig_unholster_weapons;
	level.runthread_func[ "visionset" ]					= maps\casino_util::set_visionset;
	level.runthread_func[ "wait_action" ]				= maps\casino_util::wait_action;
	level.runthread_func[ "intro_speaker" ]				= maps\casino_util::intro_speaker;
}


//############################################################################
//	Function to handle getting shot while on the ledge.
//
//handleTraversalNotify()
//{
//	fell = 0;
//	while ( 1 )
//	{
//		level.player waittill( "ledge", notice );
//
//		if ( notice == "begin" )
//		{
//			fell = 0;
////			iprintlnbold( "player on beam" );
//		}
//
//		if ( notice == "fall" )
//		{
////			iprintlnbold( "player falls off beam!" );
//			fell = 1;
//		}
//
//		if ( notice == "end" )
//		{
////			iprintlnbold( "player off beam" );
//			if ( fell == 1 )
//			{
//				level.player takeallweapons();	// Hide weapon so it doesn't show when you fall
//				level.player DoDamage( 500, ( 0, 0, 0 ) );
//				//level.player startragdoll();
//				fell = 0;
//			}
//		}
//	}
//}

spawn_think(spawn)
{
	if (!spawn_failed(spawn))
	{
		spawn ai_think();
	}
}

ai_think()
{
	if (IsDefined(self.targetname))
	{
		if (self.targetname == "vesper")
		{
			self gun_remove();
		}

		if (self.targetname == "obanno")
		{
			self gun_remove();
		}
	}
}
