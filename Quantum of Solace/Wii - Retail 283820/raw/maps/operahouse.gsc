#include maps\_utility;





main()
{
	

	
	level.strings["opera_data1_name"] = &"OPERAHOUSE_DATA_OPERA1_NAME";
	level.strings["opera_data1_body"] = &"OPERAHOUSE_DATA_OPERA1_BODY";

	level.strings["opera_data2_name"] = &"OPERAHOUSE_DATA_OPERA2_NAME";
	level.strings["opera_data2_body"] = &"OPERAHOUSE_DATA_OPERA2_BODY";

	level.strings["opera_data3_name"] = &"OPERAHOUSE_DATA_OPERA3_NAME";
	level.strings["opera_data3_body"] = &"OPERAHOUSE_DATA_OPERA3_BODY";

	
	maps\operahouse_fx::main();

	
	PrecacheCutScene( "OH_Intro" );
	PrecacheCutScene( "OH_Skybox" );
	PrecacheCutScene( "OH_Sniper" );
	PrecacheCutScene( "OH_StageFall" );

	maps\_vsedan::main( "v_sedan_clean_black_radiant" );
	precachemodel("p_lit_searchlight_dmg_head");
	
	precachemodel( "henchman_b1_h1_complete" ); 
	
	
	PreCacheItem("flash_grenade");

	

	maps\_load::main();

	
	thread maps\operahouse_snd::main();

	
	level maps\_securitycamera::init();


	
	
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading");
	setWaterWadeFX("maps/Casino/casino_spa_wading");
	
	
	
	
	
	
	

	
	
	precacheShader("overlay_hunted_black");
	
	
	precacheShader( "compass_map_operahouse" );
	precacheShader( "oh_camera_hud" );
	precacheShader( "sp_ig_ob_frame" );
	precacheShader( "sp_ig_ob_static1" );
	precacheShader( "sp_ig_ob_static2" );
	precacheShader( "sp_ig_ob_static3" );
	precacheShader( "sp_ig_ob_static4" );
	setminimap( "compass_map_operahouse", 7760, 3648, -288, -4424 );
	maps\_phone::setup_phone();

	


	


	Visionsetnaked( "operahouse" );

	
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}

	
	level thread set_DVars();

	
	level.play_cutscenes = true;		
	level.broke_stealth = false;		

	
	runthread_func_setup();					
	array_thread( GetEntArray("runthread", "targetname"),		 maps\operahouse_util::runthread_start );	
	level thread setup_special_objects();		
	level thread maps\operahouse_util::reinforcement_controller( "none", "none" );
	
	level thread maps\operahouse_events::escape_jl();
	
	
	

	
	flag_init("obj_start");


	flag_init("obj_kill_snipers");				
	flag_init("obj_snipers_dead");
	flag_init("obj_leave_docks");				


	flag_init("obj_escape");					

	thread objectives();

	maps\_utility::timer_init();
	checkpoints();						



}




set_DVars()
{
	wait( 1.0 );	
	

	setDVar( "cg_laserAiOn", 1 );		

 	setDVar( "cg_laserrange", 4500 );	
 	setDVar( "cg_laserradius", 1.0 );	
}




checkpoints()
{
	
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
	
	else if ( skipto == "E2" ) 
	{
		start_pos = GetEnt( "so_obj_backtage", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level thread checkpoint_e2_advance_objectives();
		level thread maps\operahouse_events::stage_arm_up( 0.05 );
		level thread maps\operahouse_events::e2_main();
	}
	
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
	
	else if ( skipto == "E4" )
	{
		start_pos = GetNode( "n_e4_start", "targetname" );
		if ( IsDefined(start_pos) )
		{
			level.player setorigin( start_pos.origin );
			level.player setplayerangles( start_pos.angles );
		}

		level thread checkpoint_e4_advance_objectives();

		level thread maps\operahouse_events::e4_main();
	}
	
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

		wait(0.5);	
		level thread maps\operahouse_events::e5_main();
	}
	
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







checkpoint_e2_advance_objectives()
{
	flag_set( "obj_start" );
	flag_set( "obj_reach_understage" );
	flag_set( "obj_reach_backstage" );

	VisionSetNaked( "Operahouse_top", 0.05 );
	level.player GiveWeapon( "SAF45_Opera" ); 
}

checkpoint_e3_advance_objectives()
{
	checkpoint_e2_advance_objectives();
	level.player GiveWeapon("VTAK31_Opera");

	
	setDVar( "cg_laserrange", 4500 );	
	setDVar( "cg_laserradius", 0.5 );	
}

checkpoint_e4_advance_objectives()
{
	checkpoint_e3_advance_objectives();

	flag_set( "obj_reach_top" );
	flag_set( "obj_kill_snipers" );
	flag_set( "obj_snipers_dead");
}

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





objectives( )
{
	
	flag_wait( "obj_start" );

	
	obj_pos = GetEnt("so_obj_understage", "targetname" );
	objective_add(0, "current", &"OPERAHOUSE_OBJ_BACKSTAGE", obj_pos.origin, &"OPERAHOUSE_OBJ_BACKSTAGE_DETAIL" );
	flag_wait( "obj_reach_understage" );

	obj_pos = GetEnt("so_obj_backtage", "targetname" );
	objective_position( 0, obj_pos.origin );
	flag_wait( "obj_reach_backstage");

	
	objective_state(0, "done" );
	obj_pos = GetNode("n_e4_start", "targetname" );
	objective_add(1, "current", &"OPERAHOUSE_OBJ_TOPSTAGE", obj_pos.origin, &"OPERAHOUSE_OBJ_TOPSTAGE_DETAIL" );
	objective_position( 1, obj_pos.origin );

	flag_wait( "obj_reach_top" );

	objective_state(1, "done" );
	flag_wait( "obj_kill_snipers");

	
	objective_add(2, "current", &"OPERAHOUSE_OBJ_SNIPERS", obj_pos.origin, &"OPERAHOUSE_OBJ_SNIPERS_DETAIL" );
	flag_wait( "obj_snipers_dead");

	objective_state(2, "done" );
	flag_wait("obj_leave_docks");

	
	obj_pos = GetEnt("so_e5_eye", "targetname" );
	objective_add(3, "current", &"OPERAHOUSE_OBJ_DOCKS", obj_pos.origin, &"OPERAHOUSE_OBJ_DOCKS_DETAIL" );
	flag_wait("obj_stage_iris");

	obj_pos = GetNode("n_e5_start", "targetname" );
	objective_position( 3, obj_pos.origin );
	flag_wait("obj_backstage_roof");

	obj_pos = GetNode("n_e5_end", "targetname" );
	objective_position( 3, obj_pos.origin );
	flag_wait("obj_escape");

	
	objective_state(3, "done" );
	obj_pos = GetNode("n_e5_end", "targetname" );
	objective_add(4, "current", &"OPERAHOUSE_OBJ_ESCAPE", obj_pos.origin, &"OPERAHOUSE_OBJ_ESCAPE_DETAIL" );
	flag_wait("obj_escaped");

	objective_state(4, "done" );
}




setup_special_objects()
{
	level thread patrol_boat_init();

	level thread maps\operahouse_events::stage_controller();




	
	
	for ( i=1; i<10; i++ )
	{
		flicker_light = GetEnt( "flicker_LHT0"+i, "targetname" );
		if ( IsDefined( flicker_light ) )
		{
			
			flicker_light thread maps\operahouse_snd::snd_light_flicker(true, 0.4, 1.0, "light_flicker", 0.25, 0.8);
		}
	}

	
	spotlights = GetEntArray( "sm_spotlight", "targetname" );
	array_thread( spotlights, ::spotlight_controller );
}




patrol_boat_init()
{
	
	level.patrol_boat = GetEnt( "sm_patrol_boat", "targetname" );
	level.patrol_boat.start_origin = level.patrol_boat.origin;	
	level.patrol_boat.start_angles = level.patrol_boat.angles;	





	level.patrol_sailors = maps\operahouse_util::spawn_guys( "ai_sailors", true, "e5_ai", "thug_red" );
	wait( 0.1 );	
	for ( i=0; i<level.patrol_sailors.size; i++ )
	{
		if ( IsAlive(level.patrol_sailors[i]) )
		{
			level.patrol_sailors[i] LinkTo(level.patrol_boat, "tag_body");
			level.patrol_sailors[i] SetEnableSense(false);

			level.patrol_sailors[i] Hide();
		}
	}

	wait_so = GetEnt( "so_e1_boat_path", "targetname" );
	level.patrol_boat MoveTo( wait_so.origin, 0.05 );
	level.patrol_boat RotateTo( wait_so.angles, 0.05 );
}





spotlight_controller()
{
	
	ent_tag = Spawn("script_model", self.origin);
	ent_tag SetModel("tag_origin");
	ent_tag.angles = self.angles;
		
	PlayFxOnTag(level._effect["opera_spotlight1"], ent_tag, "tag_origin");
	self SetCanDamage( true );
	self waittill( "damage" );

	
	self SetModel( "p_lit_searchlight_dmg_head" );
	ent_tag Delete();
	self radiusdamage(self.origin, 100, 60, 50, level.player, "MOD_COLLATERAL"  );
	PlayFx( level._effect["opera_stage_sparks_r"], self.origin, self.angles );
	PlayFx( level._effect["spark"], self.origin, self.angles );
	wait( RandomFloatRange(0.2, 0.5) );
	PlayFx( level._effect["spark"], self.origin, self.angles );
	wait( RandomFloatRange(0.2, 0.5) );
	PlayFx( level._effect["spark"], self.origin, self.angles );
	wait( RandomFloatRange(0.2, 0.5) );
	PlayFx( level._effect["spark"], self.origin, self.angles );
}































tests()
{
	fx = [];
	fx[0] = "cloud_bank";
	fx[1] = "cloud_bank_a";
	fx[2] = "fog_bog_a";
	fx[3] = "fog_bog_b";
	fx[4] = "fogbank_small_duhoc";

	fx_origins = GetEntArray( "play_fx", "targetname" );
	for ( i=0; i<fx_origins.size; i++ )
	{
		playfx( level._effect["cloud_bank_a"], fx_origins[i].origin, AnglesToUp(fx_origins[i].angles), AnglesToForward(fx_origins[i].angles) );
		
	}


}






runthread_func_setup( func_name )
{
	level.runthread_func[ "delete_on_goal" ]			= maps\operahouse_util::delete_on_goal;
	level.runthread_func[ "door_kick" ]					= maps\operahouse_util::door_kick;
	level.runthread_func[ "holster_weapons" ]			= maps\operahouse_util::trig_holster_weapons;
	level.runthread_func[ "reinforcement_update" ]		= maps\operahouse_util::trig_reinforcement_update;
	level.runthread_func[ "tether_on_goal" ]			= maps\operahouse_util::tether_on_goal;
	level.runthread_func[ "sniper" ]					= maps\operahouse_util::sniper;
	level.runthread_func[ "trigger_spawn_guys" ]		= maps\operahouse_util::trigger_spawn_guys;
	level.runthread_func[ "tutorial_message" ]			= maps\operahouse_util::trig_tutorial_message;
	level.runthread_func[ "unholster_weapons" ]			= maps\operahouse_util::trig_unholster_weapons;
	level.runthread_func[ "visionset" ]					= maps\operahouse_util::set_visionset;
	level.runthread_func[ "wait_action" ]				= maps\operahouse_util::wait_action;
}
