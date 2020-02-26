#include maps\_utility;
#include common_scripts\utility;











main()
{
	

	
	level.strings["casino_data0_name"] = &"CASINO_DATA0_NAME";
	level.strings["casino_data0_body"] = &"CASINO_DATA0_BODY";

	level.strings["casino_data1_name"] = &"CASINO_DATA1_NAME";
	level.strings["casino_data1_body"] = &"CASINO_DATA1_BODY";

	level.strings["casino_data2_name"] = &"CASINO_DATA2_NAME";
	level.strings["casino_data2_body"] = &"CASINO_DATA2_BODY";

	level.spawnerCallbackThread = ::spawn_think;

	
	maps\casino_fx::main();
	maps\_securitycamera::init();

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

	

	maps\_load::main();
	maps\casino_amb::main();
	maps\casino_mus::main();

	array_thread(GetAIArray(), ::ai_think);

	
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading_idle");
	setWaterWadeFX("maps/Casino/casino_spa_wading");

	
	precacheShader( "compass_map_casino" );
	setminimap( "compass_map_casino", 496, 3072, -7680, 40 );
	maps\_phone::setup_phone();

	
	level.curr_visionset = "casino_01";
	Visionsetnaked( "casino_01" );



	
	
	
    SetSavedDVar("r_godraysColorTint",  "0.6 0.7 1.0");
    SetSavedDVar("r_godraysPosX2",  "0.0");
    SetSavedDVar("r_godraysPosY2",  "-1.0");

	
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}
	
	
	level.play_cutscenes = true;									

	
	runthread_func_setup();					
	array_thread( GetEntArray("runthread", "targetname"),		 maps\casino_util::runthread_start );	
	array_thread( GetEntArray("ctrig_ledge_lock", "targetname"), maps\casino_util::cover_lock );		
	setup_special_objects();		
	level thread maps\casino_util::reinforcement_controller( "none", "none" );

	

	
	
	
	
	level thread display_map();
	


	thread bond_location_monitor_start();		
	
	thread civilian_safety_monitor();

	
	flag_init( "obj_start" );



	flag_init( "obj_spa_exit_open" );


	flag_init( "obj_unlock_entrance_end" );
	flag_init( "obj_hack_door_start" );
	flag_init( "obj_hack_door_end" );
	thread objectives();
	
	checkpoints();						
	SetDVar("r_lodBias", -500);
}





checkpoints()
{
	
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
	
	else if ( skipto == "E3" ) 
	{
		start_pos = GetNode( "cn_e3_vent_start", "targetname" );	
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}
		level.curr_visionset = "casino_02";

		level thread checkpoint_e3_advance_objectives();
		wait(0.1);
		level thread maps\casino_follow::e3_main();
		
		
		wait(0.1);	
		trig = GetEnt("trig_e3_vent", "targetname" );
		trig notify( "trigger" );	
		
	}
	
	else if ( skipto == "E3B" ) 
	{
		start_pos = GetNode( "cn_e3_start", "targetname" );	
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}
		level.curr_visionset = "casino_02";

		level thread checkpoint_e3b_advance_objectives();
		level thread maps\casino_follow::e3_main();
	}
	
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

	
	else 
	{
		if ( skipto == "noIGC" )
		{
			level.play_cutscenes = false;
		}
		else {
			
			level.player freezecontrols(true);
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







checkpoint_e2_advance_objectives()
{
	flag_set( "obj_start" );
	flag_set( "obj_detour_start" );
}

checkpoint_e3_advance_objectives()
{
	checkpoint_e2_advance_objectives();

	flag_set( "obj_detour_end" );
	flag_set( "obj_detour2_start" );
}

checkpoint_e3b_advance_objectives()
{
	checkpoint_e3_advance_objectives();

}

checkpoint_e4_advance_objectives()
{
	checkpoint_e3b_advance_objectives();

	flag_set( "flag_in_spa_lobby");
	flag_set( "obj_spa_exit_open" );
}

checkpoint_e5_advance_objectives()
{
	checkpoint_e4_advance_objectives();

	flag_set( "cf_e4_alterpatrol");
	flag_set( "obj_detour2_end" );
}

checkpoint_e6_advance_objectives()
{
	checkpoint_e5_advance_objectives();

	flag_set( "obj_unlock_entrance_start" );
	flag_set( "obj_unlock_entrance_end" );		
}

checkpoint_e7_advance_objectives()
{
	checkpoint_e6_advance_objectives();

	flag_set( "obj_hack_door_start" );
	flag_set( "obj_hack_door_end" );
}






display_map()
{
	wait( 1 );
	setSavedDvar( "sf_compassmaplevel",  "level1" );
}





objectives( )
{
	
	flag_wait( "obj_start");

	
	objective_add(0, "active", &"CASINO_OBJ_FOLLOW_LECHIFFRE", (-264, 1656, 736), &"CASINO_OBJ_FOLLOW_LECHIFFRE_DETAIL" );
	objective_state(0, "current");
	flag_wait( "obj_detour_start");

	flag_wait( "obj_detour_end" );

	objective_state(0, "done" );
	
	objective_add(1, "active", &"CASINO_OBJ_SPA", (-669, 2233, 805), &"CASINO_OBJ_SPA_DETAIL" );
	objective_state(1, "current");

	flag_wait( "obj_detour2_start");
	objective_position( 1, (-752, 1584, 908) );

	flag_wait( "flag_in_spa_lobby");

	objective_state(1, "done" );
	
	objective_add(2, "active", &"CASINO_OBJ_CLEAR_SPA", (-1370, 1656, 748), &"CASINO_OBJ_CLEAR_SPA_DETAIL" );
	objective_state(2, "current");
	flag_wait( "obj_spa_exit_open" );

	objective_position( 2, (-2659, 1830, 756) );	
	flag_wait( "cf_e4_alterpatrol");

	objective_position( 2, (-4010, 1651, 780) );	
	flag_wait("obj_unlock_entrance_start");

	objective_state(2, "done" );

	objective_add(3, "active", &"CASINO_OBJ_BALLROOM", (-3696, 1796, 780), &"CASINO_OBJ_BALLROOM_DETAIL" );		
	objective_state(3, "current");
	flag_wait("obj_unlock_entrance_end");

	wait( 5.5 ); 
				
	objective_position( 3, (-4010, 1651, 780) );	
	

	trigger = getent("ctrig_e6_con_room_inside", "targetname");
	trigger waittill("trigger");

	objective_state(3, "done" );
	objective_add(4, "active", &"CASINO_OBJ_AMBUSH", (-4977.2, 1814.9, 676.2), &"CASINO_OBJ_AMBUSH_DETAIL" );		
	objective_state(4, "current");

	flag_wait("obj_hack_door_start");
	flag_wait("obj_hack_door_end");

	objective_state(4, "done" );
	objective_add(5, "active", &"CASINO_OBJ_SUITE", (-6060, 1800, 780.2), &"CASINO_OBJ_SUITE_DETAIL" );		
	objective_state(5, "current");
 
	trigger = getent("ctrig_e6_final_door", "targetname");
	trigger waittill("trigger");

	level waittill( "e7_start" );
	objective_state(5, "done" );

}


civilian_safety_monitor()
{
	trigCivile = GetEnt("civilianarea",			"targetname");
	trigPlayer = GetEnt("playercivilianarea",	"targetname");
		
	if( IsDefined(trigCivile)  &&  IsDefined(trigPlayer)  )
	{		
		count = 0;

		
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
		
		MissionFailed();	
	}
}



bond_location_monitor_start()
{
	ents = GetEntArray( "trig_on_floor", "targetname" );
	for ( i=0; i<ents.size; i++ )
	{
		ents[i] thread bond_location_monitor();
	}
}



bond_location_monitor( )
{
	while (1)
	{
		self waittill( "trigger" );

		level notify( "bond_on_floor_"+self.script_int );
		wait( 5.0 );
	}
}



setup_special_objects()
{
	
	lights = GetEntArray( "closetlight", "targetname" );
	for ( i=0; i<lights.size; i++ )
	{
		lights[i] thread maps\casino_util::casino_light_flicker();
	}

	
	maps\_playerawareness::setupArrayDamageOnly( 
		"mousetrap_falling",					
		maps\casino_util::falling_mousetrap,	
		false,									
		undefined,								
		level.awarenessMaterialNone,			
		true,									
		false );								

	
	push_cart_origins = GetEntArray( "push_cart_dest", "targetname" );
	for ( i=0; i<push_cart_origins.size; i++)
	{
		cart = GetEnt( push_cart_origins[i].target, "targetname" );

		
		cart.push_vec = push_cart_origins[i].origin - cart.origin;

		
		attachments = GetEntArray( cart.target, "targetname" );
		for ( j=0; j<attachments.size; j++ )
		{
			attachments[j] LinkTo(cart);
		}
		maps\_useableObjects::create_useable_object( 
			cart,							
			::use_push_cart,				

			"Move Cart",
			0,								
			"",								
			false,							
			true,							
			true );							
	}

	
	blocker = GetEnt("spa_exit_blocker", "targetname");
	blocker ConnectPaths();
	blocker trigger_off();

	
	cameras = GetEntArray( "view_cam", "targetname" );
	for ( i=0; i<cameras.size; i++ )
	{
		cameras[i] maps\_securitycamera::camera_start( undefined, false, undefined, undefined);
	}
	maps\_securitycamera::camera_tap_start( undefined, cameras );
}




use_push_cart( player )
{
	cart = self.entity;

	cart MoveTo( (cart.origin + cart.push_vec), 2.0, 0.1, 1.0 );
}






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
