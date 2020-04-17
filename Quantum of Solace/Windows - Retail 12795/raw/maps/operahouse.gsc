#include maps\_utility;

//
//	Bregenz OperaHouse A : Photograph members of the Organization
//
//
main()
{
	// This stuff must come before _load::main().

	// String resource for Data Collection items (cell phones)
	level.strings["opera_data1_name"] = &"OPERAHOUSE_DATA_OPERA1_NAME";
	level.strings["opera_data1_body"] = &"OPERAHOUSE_DATA_OPERA1_BODY";

	level.strings["opera_data2_name"] = &"OPERAHOUSE_DATA_OPERA2_NAME";
	level.strings["opera_data2_body"] = &"OPERAHOUSE_DATA_OPERA2_BODY";

	level.strings["opera_data3_name"] = &"OPERAHOUSE_DATA_OPERA3_NAME";
	level.strings["opera_data3_body"] = &"OPERAHOUSE_DATA_OPERA3_BODY";

	// Precache scenes
	PrecacheCutScene( "OH_Intro" );
	PrecacheCutScene( "OH_Skybox" );
	PrecacheCutScene( "OH_Sniper" );
	PrecacheCutScene( "OH_StageFall" );

	maps\_vsedan::main( "v_sedan_clean_black_radiant" );
	precachemodel("p_lit_searchlight_dmg_head");
	
	precachemodel( "henchman_b1_h1_complete" ); // jeremyl add cache for thugs
	
	// 08/10/08 jeremyl added this for cooler effect when the playe fails the mission.
	PreCacheItem("flash_grenade");

	//### End of Precaching calls before _load::main()

	maps\_load::main();

	// Precache effects (after _load::main, so createfx is broken)
	maps\operahouse_fx::main();   
	
	// Set the maximum amount of corpses alive to 5 (optimization MikeA)
	setmaxcorpses( 5 );

	//Steve G
	thread maps\operahouse_snd::main();

	// External inits
	level maps\_securitycamera::init();
//	level maps\_sea::main();

	// Water FX
	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading");
	setWaterWadeFX("maps/Casino/casino_spa_wading");
	
	//Optimized buoyancy time settings foe Whites Estate
	//See MikeA if you have any questions
	SetSavedDVar("phys_maxFloatTime", 10000);
	SetSavedDVar("phys_floatTimeVariance", 3000);	

	// Phone setup
	precacheShader( "compass_map_operahouse" );
	precacheShader( "oh_camera_hud" );
	precacheShader( "sp_ig_ob_frame" );
	precacheShader( "sp_ig_ob_static1" );
	precacheShader( "sp_ig_ob_static2" );
	precacheShader( "sp_ig_ob_static3" );
	precacheShader( "sp_ig_ob_static4" );
	setminimap( "compass_map_operahouse", 7760, 3648, -288, -4424 );
	maps\_phone::setup_phone();

	// Other default equipment is assigned in _loadout
//	level.player GiveWeapon("phone");

	// Vision set
//	SetExpFog(13312, 37364, 0.375, 0.382813, 0.648438, 0);

	
	// Artist mode
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}

	// separate thread for dvars
	level thread set_DVars();

	// Level VARS
	level.play_cutscenes = true;		// Play or skip cutscenes
	level.broke_stealth = false;		// Did the player alert elites?
	level.kill_sniper_support_now = false; // used in sniper event to kill support troops after the stage falls.

	// Level Threads
	runthread_func_setup();					// Specify the "function lookup" function for the autothread utility
	array_thread( GetEntArray("runthread", "targetname"),		 maps\operahouse_util::runthread_start );	// look for auto thread entities!
	level thread setup_special_objects();		// Awareness, useable, 
	level thread maps\operahouse_util::reinforcement_controller( "none", "none" );
	
	level thread maps\operahouse_events::escape_jl();
	
	// BEN WANG 6/22/08: Removed sniper scope script calls, this is handled in code now
	//level thread maps\operahouse_util::sniper_scope();

	// Objectives
	flag_init("obj_start");
//	flag_init("obj_reach_backstage");			// This is performed on a flag_set trigger, so it's automagically initialized through that.
//	flag_init("obj_reach_top" );				// This is performed on a flag_set trigger, so it's automagically initialized through that.
	flag_init("obj_kill_snipers");				
	flag_init("obj_snipers_dead");
	flag_init("obj_leave_docks");				
//	flag_init("obj_stage_iris");				// This is performed on a flag_set trigger, so it's automagically initialized through that.
//	flag_init("obj_backstage_roof");			// This is performed on a flag_set trigger, so it's automagically initialized through that.
	flag_init("obj_escape");					
//	flag_init("obj_escaped");					// This is performed on a flag_set trigger, so it's automagically initialized through that.
	thread objectives();

	maps\_utility::timer_init();
	checkpoints();						// Skiptos / checkpoints

//	iPrintLnBold( "operahouse : Photograph Meeting" );
//	level thread tests();

	// DCS: added per bug 20348
	// ----- Balance Beam Cfg -----------
	SetSavedDVar("bal_move_speed", 80.0);
	SetSavedDVar("Bal_wobble_accel", 1.02);
	SetSavedDVar("Bal_wobble_decel", 1.05);
	SetSavedDVar("bal_wobble_sensitivity", 1);
	// ----------------------------------

	wait(0.05);
	Visionsetnaked( "operahouse_norays" );
}


// There is a separate thread for setting dvars.  I need to add a wait and I don't want it
//	to affect the timing of anything else.
set_DVars()
{
	wait( 1.0 );	// Delay to make sure _load::main is done
	// DVars

	setDVar( "cg_laserAiOn", 1 );		// default 0
//	setDVar( "cg_laserForceOn", 1 );	// default 0
 	setDVar( "cg_laserrange", 4500 );	// default 1500
	setDVar( "cg_laserradius", 0.2 );	// default 0.05
	setSavedDVar( "cg_laser_override_brightness", 0.5 );
}

//############################################################################
//	Checkpoint resolver
//
checkpoints()
{
	// Teleport player
	skipto = GetDVar( "skipto" );
	start_pos = "n_e1_start";
	poison_skipto = false;

	if ( skipto == "test" )
	{
		start_pos = GetEnt( "temp_player_position", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}
	}
	// Start at the beginning of operahouse
	else if ( skipto == "E1A" ) 
	{
		level.play_cutscenes = false;
		start_pos = GetNode( "n_e1_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		if ( skipto == "noIGC" )
		{
			level.play_cutscenes = false;
		}
		level thread maps\operahouse_events::e1_main();
	}
	else if ( skipto == "E1B" ) 
	{
		start_pos = GetEnt( "so_obj_understage", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		flag_set( "obj_start" );
		level thread maps\operahouse_events::stage_arm_up( 0.05 );
		level thread maps\operahouse_events::e1b_main();
		wait(0.05);
		flag_set( "obj_reach_understage" );
	}
	// E2 Backstage
	else if ( skipto == "E2" ) 
	{
		start_pos = GetEnt( "so_obj_backstage", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level thread checkpoint_e2_advance_objectives();
		level thread maps\operahouse_events::stage_arm_up( 0.05 );
		level thread maps\operahouse_events::e2_main();
	}
	// E2 Backstage
	else if ( skipto == "E2B" ) 
	{
		start_pos = GetEnt( "so_e2_stage_sniper_aim", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level thread checkpoint_e2_advance_objectives();
		level thread maps\operahouse_events::e2b_main();
	}
	// E3 Snipers
	else if ( skipto == "E3" ) 
	{
		start_pos = GetNode( "n_e3_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level thread checkpoint_e3_advance_objectives();

		level maps\operahouse_events::e2_spawn_quantum();

		level.roof_sniper = maps\operahouse_util::spawn_guys("ai_e3_wave1", true, "e3_ai", "thug" );

		flag_wait( "obj_reach_top" );
		level thread maps\operahouse_events::e3_main();
	}
	// E3 Snipers
	else if ( skipto == "E3B" ) 
	{
		level.play_cutscenes = false;
		start_pos = GetNode( "n_e3_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level thread checkpoint_e3_advance_objectives();
		level.roof_sniper = maps\operahouse_util::spawn_guys("ai_e3_wave1", true, "e3_ai", "thug" );

		flag_wait( "obj_reach_top" );
		level thread maps\operahouse_events::e3_main();
	}
	// E4 Exit Stage Right
	else if ( skipto == "E4" )
	{
		start_pos = GetNode( "n_e4_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level thread checkpoint_e4_advance_objectives();
//		maps\operahouse_events::stage_collapse( 0.05 );
		level thread maps\operahouse_events::e4_main();
	}
	// E5 Interceptor
	else if ( skipto == "E5" )
	{
		start_pos = GetNode( "n_e5_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level thread checkpoint_e5_advance_objectives();
		level thread maps\operahouse_events::stage_collapse( 0.05 );

		wait(0.5);	// wait for the guys that spawn to hit the ground
		level thread maps\operahouse_events::e5_main();
	}
	// Start at the beginning of operahouse
	else 
	{
		start_pos = GetNode( "n_e1_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		if ( skipto == "noIGC" )
		{
			level.play_cutscenes = false;
		}
		level thread maps\operahouse_events::e1_main();
	}

}


//
//	Funcs to advance the objectives
//

// Start of e2
checkpoint_e2_advance_objectives()
{
	flag_set( "obj_start" );
	flag_set( "obj_reach_understage" );
	flag_set( "obj_reach_backstage" );

	VisionSetNaked( "Operahouse_top", 0.05 );
	level.player GiveWeapon( "SAF45_Opera" ); // just for skipto
}
// Start of e3
checkpoint_e3_advance_objectives()
{
	checkpoint_e2_advance_objectives();
	level.player GiveWeapon("VTAK31_Opera");

	// sniper DVars
	setDVar( "cg_laserrange", 4500 );	// default 1500
	setDVar( "cg_laserradius", 0.2 );	// default 0.05
	setSavedDVar( "cg_laser_override_brightness", 0.7 );
}
// Start of e4
checkpoint_e4_advance_objectives()
{
	checkpoint_e3_advance_objectives();

	flag_set( "obj_reach_top" );
	flag_set( "obj_kill_snipers" );
	flag_set( "obj_snipers_dead");
}
// Start of e5
checkpoint_e5_advance_objectives()
{
	checkpoint_e4_advance_objectives();

	flag_set("obj_stage_iris");
	flag_set("obj_backstage_roof");
}


display_map()
{
	wait( 1 );
	setSavedDvar( "sf_compassmaplevel",  "level1" );
}


//############################################################################
// Handles objective progression
//
objectives( )
{
	// Start objectives
	flag_wait( "obj_start" );

	// Backstage
	obj_pos = GetEnt("so_obj_understage", "targetname" );
	objective_add(0, "active", &"OPERAHOUSE_OBJ_BACKSTAGE", obj_pos.origin, &"OPERAHOUSE_OBJ_BACKSTAGE_DETAIL" );
	objective_state(0, "current");
	flag_wait( "obj_reach_understage" );

	obj_pos = GetEnt("so_obj_backstage", "targetname" );
	objective_position( 0, obj_pos.origin );
	flag_wait( "obj_reach_backstage");

	// Get to the top-pa
	objective_state(0, "done" );
	obj_pos = GetNode("n_e4_start", "targetname" );
	objective_add(1, "active", &"OPERAHOUSE_OBJ_TOPSTAGE", obj_pos.origin, &"OPERAHOUSE_OBJ_TOPSTAGE_DETAIL" );
	objective_state(1, "current");
//	objective_position( 1, obj_pos.origin );
	flag_wait( "obj_reach_top" );

	objective_state(1, "done" );
	flag_wait( "obj_kill_snipers");

	// Kill the snipers
	objective_add(2, "active", &"OPERAHOUSE_OBJ_SNIPERS", obj_pos.origin, &"OPERAHOUSE_OBJ_SNIPERS_DETAIL" );
	objective_state(2, "current");
	flag_wait( "obj_snipers_dead");

	objective_state(2, "done" );
	flag_wait("obj_leave_docks");

	// Get to the docks
	obj_pos = GetEnt("so_e5_eye", "targetname" );
	objective_add(3, "active", &"OPERAHOUSE_OBJ_DOCKS", obj_pos.origin, &"OPERAHOUSE_OBJ_DOCKS_DETAIL" );
	objective_state(3, "current");
	flag_wait("obj_stage_iris");

	obj_pos = GetNode("n_e5_start", "targetname" );
	objective_position( 3, obj_pos.origin );
	flag_wait("obj_backstage_roof");

	obj_pos = GetNode("n_e5_end", "targetname" );
	objective_position( 3, obj_pos.origin );
	flag_wait("obj_escape");

	// Get the hell out!
	objective_state(3, "done" );
	obj_pos = GetNode("n_e5_end", "targetname" );
	objective_add(4, "active", &"OPERAHOUSE_OBJ_ESCAPE", obj_pos.origin, &"OPERAHOUSE_OBJ_ESCAPE_DETAIL" );
	objective_state(4, "current");
	flag_wait("obj_escaped");

	objective_state(4, "done" );
}


//############################################################################
// Setup for objects with special behaviors
setup_special_objects()
{
	level thread patrol_boat_init();

	level thread maps\operahouse_events::stage_controller();

//	thread explosive_tank_setup();
/*
	if ( GetDVar( "skipto" ) != "E5" )
	{
		// temp hack to put gate in the right spot
		gate = GetEnt( "sbm_e5_backstage_gate", "targetname" );
		gate MoveX( -184, 0.05 );
	}
*/

	
	// Light flicker
	for ( i=1; i<10; i++ )
	{
		flicker_light = GetEnt( "flicker_LHT0"+i, "targetname" );
		if ( IsDefined( flicker_light ) )
		{
			//Steve G - added light sounds and redirected flicker script
			flicker_light thread maps\operahouse_snd::snd_light_flicker(true, 0.4, 1.0, "light_flicker", 0.25, 0.8);
		}
	}

	// spotlights
	// jeremy l make these rotate back and forth to add something to the level.
	spotlights = GetEntArray( "sm_spotlight", "targetname" );
	array_thread( spotlights, ::spotlight_controller );

	// Forklift
	triga_dmg_forklift = getent( "trg_dmg_forklift", "targetname" );
	triga_dmg_forklift thread forklift_explosion();

	// Dynamic lighting
	level.light_bottom	= GetEnt( "light_bottom", "targetname" );
	level.light_top		= GetEnt( "light_top",    "targetname" );
	level.light_bottom SetLightIntensity(0.0);
	level.light_top    SetLightIntensity(0.0);
	if ( !level.ps3 && !level.bx )
	{
		level.light_ground	= GetEnt( "light_ground", "targetname" );
		level.light_ground SetLightIntensity(0.0);
	}
}


//############################################################################
// Patrol Boat setup
patrol_boat_init()
{
	// special init for the sbm boat so it faces the right way.
	level.patrol_boat = GetEnt( "sm_patrol_boat", "targetname" );
	level.patrol_boat.start_origin = level.patrol_boat.origin;	// save this for later
	level.patrol_boat.start_angles = level.patrol_boat.angles;	// save this for later

// 	sm_boat = GetEnt( "sm_patrol_boat", "targetname" );
// 	level.patrol_boat = GetEnt( sm_boat.target, "targetname" );
// 	sm_boat linkto(level.patrol_boat);

	level.patrol_sailors = maps\operahouse_util::spawn_guys( "ai_sailors", true, "e5_ai", "thug_red" );
	wait( 0.1 );	// wait for them to spawn (and hit the ground...maybe)
	for ( i=0; i<level.patrol_sailors.size; i++ )
	{
		if ( IsAlive(level.patrol_sailors[i]) )
		{
			level.patrol_sailors[i] LinkTo(level.patrol_boat, "tag_body");
			level.patrol_sailors[i] SetEnableSense(false);
//			level.patrol_sailors[i] AllowedStances( "crouch" );
			level.patrol_sailors[i] Hide();
			level.patrol_sailors[i] SetDeathEnable(false);
		}
	}

	wait_so = GetEnt( "so_e1_boat_path", "targetname" );
	level.patrol_boat MoveTo( wait_so.origin, 0.05 );
	level.patrol_boat RotateTo( wait_so.angles, 0.05 );
}


//
//	Shootable searchlights
//
spotlight_controller()
{
	// spawn spotlight cone
	ent_tag = Spawn("script_model", self.origin);
	ent_tag SetModel("tag_origin");
	ent_tag.angles = self.angles;
		
	PlayFxOnTag(level._effect["opera_spotlight1"], ent_tag, "tag_origin");
	
	if ( !IsDefined(self.script_noteworthy) || self.script_noteworthy != "dont_move" )
	{
		ent_tag thread rotate_spotlights();
	}
	
	self SetCanDamage( true );
	self waittill( "damage" );

	// swap out with a destroyed version and blow up!
	self SetModel( "p_lit_searchlight_dmg_head" );
	
	//Steve G
	self playsound("searchlight_shatter");
	
	ent_tag Delete();
	self radiusdamage(self.origin, 200, 60, 50, level.player, "MOD_COLLATERAL"  );
	PlayFx( level._effect["opera_stage_sparks_r"], self.origin, self.angles );
	PlayFx( level._effect["spark"], self.origin, self.angles );
	wait( RandomFloatRange(0.2, 0.5) );
	PlayFx( level._effect["spark"], self.origin, self.angles );
	wait( RandomFloatRange(0.2, 0.5) );
	PlayFx( level._effect["spark"], self.origin, self.angles );
	wait( RandomFloatRange(0.2, 0.5) );
	PlayFx( level._effect["spark"], self.origin, self.angles );
}

rotate_spotlights()
{
	self endon( "death" );

	while(1)
	{
		//iprintlnbold("rotate now lights");
		self rotateyaw( 13, 5, 0.1, 0.8);
		self waittill ("rotatedone");
		self rotateyaw(-13, 5, 0.1, 0.8);
		self waittill ("rotatedone");
	}
}


// ---------------------//
// MMaestas - lifted from airport
// wwilliams 11-9-07
// temp forklift explosion
// wwilliams 11-26-07
// changing func to work with an indivdual piece from the array of forklifts
// will run on the forklift
forklift_explosion()
{
	// endon

	// stuff
	forklift_model = getent( self.target, "targetname" );
	forklift_model_dmg = getent( forklift_model.target, "targetname" );

	// hide the destroyed version of the forklift
	forklift_model_dmg hide();

	// 03-28-08
	// wwilliams
	// while loop will continue until the damage is from teh player
	while( 1 )
	{
		// trig hit
		// self waittill( "trigger" );
		self waittill( "damage", amount, attacker, direction_vec, point, type );

		// check to see if attacker = level.player
		if( attacker == level.player )
		{
			// kick out of this function
			break;
		}
		else
		{
			// quick wait
			wait( 0.5 );
		}
	}

	// explosion FX
	forklift_explo = playfx( level._effect[ "bigbang" ], forklift_model.origin );

	// explosion SFX, forklift explodes
	self playsound( "AIR_forklift_explo_sound" );

	// damage radius to the area
	radiusdamage( forklift_model.origin, 300, 600, 50 );

	// earthquake
	earthquake( 0.5, 2.0, forklift_model.origin, 850 );

	// controller rumble
//	level thread maps\airport_util::air_ctrl_rumble_timer( 1 );

	// quick wait for the effect to fill the area
	wait( 0.08 );

	// swap out for the destroyed model of the forklift
	forklift_model hide();
	forklift_model_dmg show();
}


//############################################################################
// Helium tanks setup
// explosive_tank_setup()
// {
//     tank = GetEntArray ( "pipe_shootable", "targetname" );
//     for ( i = 0; i<tank.size; i++ )
//     {
// 		tank[i].health = 150;
// 		tank[i] thread explosive_tank();
//     }
// }

//############################################################################
// Helium tanks wait for damage then explode
// explosive_tank()
// {
// 	self setcandamage(true);
// 	self waittill ( "damage" );
// //	self playsound( "CAS_helium_tanks" );
// 	wait( 2 );
// 
// 	self hide();
// 	fx = playfx (level._effect["tank_explosion"], self.origin);
// 	physicsExplosionSphere( self.origin, 300, 100, 5 );
// 	radiusdamage( self.origin + ( 0, 0, 36 ), 300, 150, 200 );
// 	earthquake( 0.3, 1, self.origin, 400 );
// }


tests()
{
// 	fx = [];
// 	fx[0] = "cloud_bank";
// 	fx[1] = "cloud_bank_a";
// 	fx[2] = "fog_bog_a";
// 	fx[3] = "fog_bog_b";
// 	fx[4] = "fogbank_small_duhoc";
// 
// 	fx_origins = GetEntArray( "play_fx", "targetname" );
// 	for ( i=0; i<fx_origins.size; i++ )
// 	{
// 		playfx( level._effect["cloud_bank_a"], fx_origins[i].origin, AnglesToUp(fx_origins[i].angles), AnglesToForward(fx_origins[i].angles) );
// 		
// 	}

/*
	for ( i=0; i<fx.size; i++ )
	{
		fx_spawn = spawnfx( level._effect[ fx[i] ], fx_origin.origin );
		triggerFx( fx_spawn );

		iPrintLnBold( "spawn fx: " +fx[i] );
		wait( 10 );

		fx_spawn delete();
	}
*/
}


//
//	This is a lookup table that should contain a reference to any function you would like to "auto thread" when 
//	an AI is spawned via the spawn_guys utility function
//
runthread_func_setup( func_name )
{
	level.runthread_func[ "delete_on_goal" ]			= maps\operahouse_util::delete_on_goal;
	level.runthread_func[ "door_kick" ]					= maps\operahouse_util::door_kick;
	level.runthread_func[ "holster_weapons" ]			= maps\operahouse_util::trig_holster_weapons;
	level.runthread_func[ "map_change" ]				= maps\operahouse_util::map_change;
	level.runthread_func[ "reinforcement_update" ]		= maps\operahouse_util::trig_reinforcement_update;
	level.runthread_func[ "tether_on_goal" ]			= maps\operahouse_util::tether_on_goal;
	level.runthread_func[ "sniper" ]					= maps\operahouse_util::sniper;
	level.runthread_func[ "trigger_spawn_guys" ]		= maps\operahouse_util::trigger_spawn_guys;
	level.runthread_func[ "tutorial_message" ]			= maps\operahouse_util::trig_tutorial_message;
	level.runthread_func[ "unholster_weapons" ]			= maps\operahouse_util::trig_unholster_weapons;
	level.runthread_func[ "visionset" ]					= maps\operahouse_util::set_visionset;
	level.runthread_func[ "wait_action" ]				= maps\operahouse_util::wait_action;
}
