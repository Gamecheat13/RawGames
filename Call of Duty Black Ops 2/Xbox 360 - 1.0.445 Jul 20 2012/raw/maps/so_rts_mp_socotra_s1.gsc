#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_scene;
#include maps\_audio;
#include maps\_music;
#include maps\_anim;
#include maps\_statemachine;

#insert raw\maps\_so_rts.gsh;
#insert raw\maps\_scene.gsh;
#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_statemachine.gsh;

#define TIME_TO_UNTIL_ENEMY_REINFORCEMENTS		2
#define TIME_TO_WAIT_FOR_VTOL					1
#define TIME_TO_REACH_VTOL						3
#define TIME_TO_SWITCH_OBJTO_VTOL				(TIME_TO_REACH_VTOL-0.5)

#define MAX_DEAD_BODIES							20
#define KARMA_DIST_ATVTOL_THRESHHOLD 250
#define KARMA_DIST_THRESHOLD 300
#define KARMA_DISTVTOL_THRESHOLD 480
#define KARMA_DISTVTOL_SQ_THRESHOLD (KARMA_DISTVTOL_THRESHOLD * KARMA_DISTVTOL_THRESHOLD)
#define KARMA_DIST_SQ_THRESHOLD (KARMA_DIST_THRESHOLD * KARMA_DIST_THRESHOLD )
#define KARMA_DIST_SQ_ATVTOL_THRESHHOLD (KARMA_DIST_ATVTOL_THRESHHOLD * KARMA_DIST_ATVTOL_THRESHHOLD )

//////////////////////////////////////////////////////////////////////////////////////////////////
///SCENARIO 1
//////////////////////////////////////////////////////////////////////////////////////////////////

precache()
{
	PrecacheString( &"rts_karma_squad" );
	PrecacheString( &"SO_RTS_OBJ3D_RESCUE");
	PrecacheString( &"SO_RTS_OBJ3D_PROTECT");
	PrecacheString( &"SO_RTS_MP_SOCOTRA_ENEMY_REINFORCEMENTS");
	PrecacheString( &"SO_RTS_MP_SOCOTRA_TIME_TO_VTOL");
	PrecacheString( &"SO_RTS_MP_SOCOTRA_VTOL_LEAVE");



	PrecacheShader( "hud_compass_vtol" );
	PrecacheItem( "m1911_sp" );
	PrecacheItem( "stinger_rts_sp");
	level._effect[ "sniper_glint" ] 		= LoadFX( "misc/fx_misc_sniper_scope_glint" );
	level._effect["signal_smoke"]			= loadFX("smoke/fx_pak_smk_signal_dist");	// 850
	level._effect["nanoglove_impact"]		= loadFX("dirt/fx_mon_dust_nano_glove");
	level._effect["gas_canister_trail"]		= loadFX("trail/fx_war_trail_gas_canister");
	level._effect["fx_vtol_explo"]			= loadFX("explosions/fx_exp_bomb_huge");	// 850
	level._effect["fx_vtol_smoke"]			= loadFX("explosions/fx_exp_bomb_huge");	// 850
	level._effect[ "fx_dead_mortar" ] = LoadFX( "explosions/fx_mortarexp_sand" );
	level._effect[ "fx_mortar_explode" ] = LoadFX( "explosions/fx_mortarexp_sand" );

	PrecacheRumble( "monsoon_gloves_impact" );
	
	PrecacheModel( "projectile_hellfire_missile" );
	PrecacheModel( "p6_sf_socotra_bldg_08" );
	PrecacheModel( "p6_sf_socotra_bldg_09" );
	PrecacheModel( "p6_sf_socotra_bldg_13" );
	PrecacheModel( "p6_sf_socotra_bldg_15" );
	PrecacheModel( "artillery_mortar_81mm_static");
	
    maps\_quadrotor::init();
}
//////////////////////////////////////////////////////////////////////////////////////////////////

socotra_level_scenario_one()
{
	//overrides default introscreen function
	level.custom_introscreen = maps\_so_rts_support::custom_introscreen;
	flag_init("intro_done");
	flag_init("karma_died");

	flag_init("vtol_on_route");
	flag_init("vtol_start_anim");
	flag_init("vtol_arrived");
	flag_init("vtol_clearout");
	flag_init("vtol_died");
	flag_init("vtol_attack_go");
	flag_init("vtol_objective_switch");
	
	flag_init("outro_done");
	flag_set("block_input");
	maps\_so_rts_rules::set_GameMode("socotra1");
	
	setup_scenes();
	
	socotra_geo_changes();
	flag_wait( "start_rts" );
	
	socotra_level_scenario_one_registerEvents();
	
/#
	socotra_setup_devgui();
#/
	
	maps\_so_rts_catalog::spawn_package("infantry_ally_reg_pkg", "allies",true, ::socotra_level_player_startFPS);
	maps\_so_rts_catalog::spawn_package("infantry_ally_heavy_pkg", "allies",true, ::socotra_level_ally_squad);
	maps\_so_rts_catalog::setPkgDelivery("infantry_ally_reg_pkg","CODE");
	maps\_so_rts_catalog::setPkgDelivery("infantry_ally_heavy_pkg","CODE");
	maps\_so_rts_catalog::setPkgDelivery("infantry_enemy_elite_pkg","CODE");
	maps\_so_rts_catalog::setPkgDelivery("infantry_enemy_reg_pkg","CODE");
	
	maps\_so_rts_catalog::setPkgQty("infantry_enemy_elite_pkg","axis",0);
	maps\_so_rts_catalog::setPkgQty("infantry_enemy_reg_pkg","axis",0);

	pkg_ref = maps\_so_rts_catalog::package_GetPackageByType("quadrotor_pkg");
	pkg_ref.min_axis = 3;
	pkg_ref.max_axis = 8;


	level.rts.codeSpawnCB = ::socotraCodeSpawner;
	level.rts.game_rules.num_nag_squads = 5;

	socotra_pick_safehouses();
	enemySpawnInit();
	setup_objectives();
	level.rts.outroLoc = GetStruct("outro_loc","targetname");
	
	level thread socotra_AI_TakeOver_ON();
	level thread socotra_AI_TakeOver_OFF();
	level thread socotra_player_oobWatch();
	level thread maps\_so_rts_support::flag_set_inNSeconds("start_rts_enemy",8);
	level thread socotra_karama_spawnWatch();
	level thread socotraAirSuperioritySpawn();
	level thread socotraSafeHouseHighlightWatch();
	level waittill ("socotra_karma_rescued");
	level thread socotra_SpawnMortraCrews();
	level thread socotra_outroLocPOI();
	level thread socotra_vtol_watch();
	level thread socotra_rooftopInit();
	level thread socotra_karma_deathWatch();
	level socotra_karma_hackAllMechs();
	//level thread socotraEnemyBTRSpawn();
	level thread socotra_karma_damageWatch();
	maps\_so_rts_poi::deleteAllPoi("rts_poi_search");
	maps\_so_rts_support::show_player_hud();
	maps\_so_rts_enemy::create_units_from_AllSquads();
	
	flag_wait("vtol_on_route");
	socotra_defendKarma();

}


socotraSafeHouseHighlightWatch()
{
	level endon ("socotra_karma_rescued");
	while(1)
	{
		level waittill("rts_ON");
		foreach(spot in level.rts.safehouses)
		{
			spot.bldg = Spawn( "script_model", spot.site.origin );
			spot.bldg.angles = (isDefined(spot.site.angles)?spot.site.angles:(0,0,0));
			spot.bldg SetModel( spot.modelname );
		}
		level waittill("rts_OFF");
		foreach(spot in level.rts.safehouses)
		{
			spot.bldg Delete();
		}
	}
}

socotra_outroLocPOI()
{
	level waittill_any("karmaAtSmoke","vtol_has_arrived");
	poiEnt = Spawn( "script_origin", level.rts.outroLoc.origin );
	maps\_so_rts_poi::add_poi("rts_poi_outro",poiEnt,"axis",false);
}

//////////////////////////////////////////////////////////////////////////////////////////////
socotra_player_oobWatch()
{
	level endon("karma_outro_begin");
	level endon("socotra_mission_complete");
	while(1)
	{
		if ( level.rts.player maps\_so_rts_support::isEntBelowMap() )
		{
			level.rts.player doDamage(level.rts.player.health+99,level.rts.player.origin);
		}
		wait 0.15;
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////
socotra_defendKarma()
{
	if(!isDefined(level.rts.karma))
		return;
	/#
	println("socotra_defendKarma started");
	#/

	//DEFEND SEQUENCE;  We probably have to free up some dudes to attack Karma
	level waittill("karmaAtSmoke");
	maps\_so_rts_catalog::setPkgQty("infantry_ally_reg_pkg","allies",0);
	squad = getSquadByPkg( "infantry_ally_reg_pkg", "allies");
	level thread maps\_so_rts_squad::removeSquadMarker(squad.id, true);
	maps\_so_rts_catalog::setPkgQty("infantry_ally_heavy_pkg","allies",0);
	squad = getSquadByPkg( "infantry_ally_heavy_pkg", "allies");
	level thread maps\_so_rts_squad::removeSquadMarker(squad.id, true);
	
	level waittill("vtol_disabled");
}


//////////////////////////////////////////////////////////////////////////////////////////////////
setup_scenes()
{
	// INTRO
	add_scene( "intro_climbup_player", "intro_loc" );	
	add_player_anim( "player_body", %player::p_sacotra_intro_player, true, 0, undefined, true, 1, 15, 15, 15, 15 );		
	add_notetrack_custom_function( "player_body", "start_fade_in", ::level_fade_in );
	add_notetrack_custom_function( "player_body", "start_civs_choking", ::intro_start_civ_anims );
	add_notetrack_custom_function( "player_body", "left_hand_plant", ::nanoglove_left_hand_plant );
	add_notetrack_custom_function( "player_body", "right_hand_plant", ::nanoglove_left_hand_plant );
	
	add_scene( "intro_climbup_squad_1", "intro_loc" );	
	add_actor_anim( "guy0", %generic_human::ch_sacotra_intro_sqd1, false, false, false, true );
	
	add_scene( "intro_climbup_squad_2", "intro_loc" );	
	add_actor_anim( "guy1", %generic_human::ch_sacotra_intro_sqd2, false, false, false, true );
	
	add_scene( "intro_climbup_civs", "intro_loc" );	
	add_actor_model_anim("intro_climbup_civ1", %generic_human::ch_sacotra_intro_chk_civ1, undefined, false, undefined, undefined, "male_civ_spawner");
	add_actor_model_anim("intro_climbup_civ2", %generic_human::ch_sacotra_intro_chk_civ2, undefined, false, undefined, undefined, "male_civ_spawner");
	add_actor_model_anim("intro_climbup_civ3", %generic_human::ch_sacotra_intro_chk_civ3, undefined, false, undefined, undefined, "male_civ_spawner");
	add_actor_model_anim("intro_climbup_civ4", %generic_human::ch_sacotra_intro_chk_civ4, undefined, false, undefined, undefined, "male_civ_spawner");
	add_actor_model_anim("intro_climbup_civ5", %generic_human::ch_sacotra_intro_chk_civ5, undefined, false, undefined, undefined, "male_civ_spawner");
	add_actor_model_anim("intro_climbup_civ6", %generic_human::ch_sacotra_intro_chk_civ6, undefined, false, undefined, undefined, "male_civ_spawner");
	add_actor_model_anim("intro_climbup_civ7", %generic_human::ch_sacotra_intro_chk_civ7, undefined, false, undefined, undefined, "male_civ_spawner");
	
	add_scene( "intro_zodiac_seals", "intro_loc" );	
	add_actor_model_anim("intro_zodiac_seal1", %generic_human::ch_sacotra_intro_seal1, undefined, false, undefined, undefined, "ai_spawner_ally_assault");
	add_actor_model_anim("intro_zodiac_seal2", %generic_human::ch_sacotra_intro_seal2, undefined, false, undefined, undefined, "ai_spawner_ally_assault");
	add_actor_model_anim("intro_zodiac_seal3", %generic_human::ch_sacotra_intro_seal3, undefined, false, undefined, undefined, "ai_spawner_ally_assault");
	add_actor_model_anim("intro_zodiac_seal4", %generic_human::ch_sacotra_intro_seal4, undefined, false, undefined, undefined, "ai_spawner_ally_assault");
	add_actor_model_anim("intro_zodiac_seal5", %generic_human::ch_sacotra_intro_seal5, undefined, false, undefined, undefined, "ai_spawner_ally_assault");
	
	add_scene( "intro_canisters", "intro_loc" );
	
	add_prop_anim( "bomb1", %animated_props::w_sacotra_intro_bomb1 );
	add_prop_anim( "bomb2", %animated_props::w_sacotra_intro_bomb2 );
	add_prop_anim( "bomb3", %animated_props::w_sacotra_intro_bomb3 );
	
	//add_notetrack_exploder( "bomb1", "bomb_launch1", 33 );
	//add_notetrack_exploder( "bomb1", "bomb_launch2", 33 );
	//add_notetrack_exploder( "bomb1", "bomb_launch3", 33 );
	add_notetrack_custom_function( "bomb1", "fog_town", ::intro_fog_town );
	add_notetrack_custom_function( "bomb1", "bomb_launch1", ::gas_canister_attach_trail );
	add_notetrack_custom_function( "bomb1", "bomb_launch2", ::gas_canister_attach_trail );
	add_notetrack_custom_function( "bomb1", "bomb_launch3", ::gas_canister_attach_trail );
	
	add_scene( "intro_zodiacs", "intro_loc" );
	add_prop_anim( "zodiac1", %animated_props::v_sacotra_intro_zodiac, "veh_iw_zodiac" );
	add_prop_anim( "zodiac2", %animated_props::v_sacotra_intro_zodiac1, "veh_iw_zodiac" );
	add_prop_anim( "zodiac3", %animated_props::v_sacotra_intro_zodiac2, "veh_iw_zodiac" );
	
	// OUTRO
	add_scene( "outro_player", "intro_loc" );	
	
	add_player_anim( "player_body", %player::p_sacotra_outro_player, true, 0, undefined, true, 1, 15, 15, 15, 15 );
	add_notetrack_custom_function( "player_body", "start_static", ::static_transition );
	
	add_scene( "outro_actors", "intro_loc" );	
	
	add_actor_anim( "karma", %generic_human::ch_sacotra_outro_karma, false, false, false, true );
	add_actor_model_anim("outro_guy0", %generic_human::ch_sacotra_outro_sqd1, undefined, false, undefined, undefined, "ai_spawner_ally_assault");
	add_actor_model_anim("outro_guy1", %generic_human::ch_sacotra_outro_sqd2, undefined, false, undefined, undefined, "ai_spawner_ally_assault");
	add_actor_model_anim("heli_guy", %generic_human::ch_sacotra_outro_vtol_guy, undefined, true, undefined, undefined, "ai_spawner_ally_assault");
	
	add_prop_anim( "outro_heli", %animated_props::v_sacotra_outro_blackhawk );
	
	add_scene( "outro_heli_flyin", "intro_loc" );
	add_prop_anim( "outro_heli", %animated_props::v_sacotra_outro_vtol_flyin );
	
	// KARMA RESCUE
	add_scene( "karma_rescue_player", "karma_loc" );	
	add_player_anim( "player_body", %player::p_sacotra_karma_rescue_player, true, 0, undefined, true, 1, 15, 15, 15, 15 );
	
	add_scene( "karma_rescue_karma", "karma_loc" );	
	add_actor_anim( "karma", %generic_human::ch_sacotra_karma_rescue_karma, false, false, false, true );

	add_scene( "vtol_dustoff", "intro_loc" );	
	add_prop_anim( "outro_heli", %animated_props::v_sacotra_outro_blackhawk );

	add_scene( "btr_intro", "war_tank_intro" );	
	add_vehicle_anim( "btr", %vehicles::v_sacotra_btr_intro_btr );

	add_scene( "infantry_reg_pkg_intro_0", "intro_loc" );	
	add_actor_anim("ally_intro_0", %generic_human::ch_sacotra_intro_cavalry1);

	add_scene( "infantry_reg_pkg_intro_1", "intro_loc" );	
	add_actor_anim("ally_intro_1", %generic_human::ch_sacotra_intro_cavalry2);

	add_scene( "infantry_reg_pkg_intro_2", "intro_loc" );	
	add_actor_anim("ally_intro_2", %generic_human::ch_sacotra_intro_cavalry3);

	precache_assets();
}
//////////////////////////////////////////////////////////////////////////////////////////////////
level_fade_in( player )
{
	screen_fade_in(0.5);
}
//////////////////////////////////////////////////////////////////////////////////////////////////
nanoglove_left_hand_plant( player )
{
	level.player PlayRumbleOnEntity( "monsoon_gloves_impact" );
                
    // play fx on both hands
    player play_fx( "nanoglove_impact", player.origin, player.angles, 1, true, "j_index_le_1" );
}
//////////////////////////////////////////////////////////////////////////////////////////////////
nanoglove_right_hand_plant( player )
{
	level.player PlayRumbleOnEntity( "monsoon_gloves_impact" );
                
    // play fx on both hands
    player play_fx( "nanoglove_impact", player.origin, player.angles, 1, true, "j_index_ri_1" );
}
//////////////////////////////////////////////////////////////////////////////////////////////////
intro_fog_town( bomb )
{	
	exploder( 44 );
	
	delay_thread( 30, ::stop_exploder, 44 );
}
//////////////////////////////////////////////////////////////////////////////////////////////////
gas_canister_attach_trail( bomb )
{
	canister = level.rts.canisters[ level.rts.canisterIndex ];
	canister SetForceNoCull();
	PlayFXOnTag( level._effect["gas_canister_trail"], canister, "tag_fx" );
	level.rts.canisterIndex++;
}
//////////////////////////////////////////////////////////////////////////////////////////////////
socotra_climbup_intro() 
{
	maps\_so_rts_squad::removeDeadFromSquad(0);
	assert(level.rts.squads[0].members.size>=2,"Not enough guys around");
	
	// set up the ai for animation and ending cover nodes
	for ( i = 0; i < level.rts.squads[0].members.size; i++ )
	{
		guy = level.rts.squads[0].members[i];
		
		guy.animname		= "guy" + i;
		guy.rts_unloaded 	= 0;
		guy.ignoreme		= true;
		
		coverNodeName = guy.animname;
		coverNode = GetNode( coverNodeName, "targetname" );
		
		if( IsDefined( coverNode ) )
		{
			// force them to stay at the goal nodes
			guy.fixedNode		= true;
			
			// kill the aiGoalEntity thread cause we want these guys to just take cover at first
			guy notify( "new_squad_orders" );
			guy.selectable = false;
		
			guy SetGoalNode( coverNode );
		}
	}
	
	level.rts.player.ignoreme 	= true;
	level.rts.player.takedamage = false;
	level.rts.player EnableInvulnerability(); // so the player doesn't get killed by the hurt trigger in mp maps
	
	// set up the canisters
	level.rts.canisterIndex = 0;
	level.rts.canisters = [];
	for( i=0; i < 3; i++ )
	{
		c = Spawn( "script_model", (0,0,0) );
		c SetModel( "projectile_hellfire_missile" );
		c.animname = "bomb" + (i+1);
		
		level.rts.canisters[ i ] = c;
	}

	flag_set("rts_event_ready");
	maps\_so_Rts_event::trigger_event("dlg_intro_01");

	level thread run_scene( "intro_climbup_player" );
	level thread run_scene( "intro_climbup_squad_1" );
	level thread run_scene( "intro_climbup_squad_2" );
	level thread run_scene( "intro_canisters" );
	level thread run_scene( "intro_zodiacs" );
	level thread run_scene( "intro_zodiac_seals" );
	
	level thread intro_delete_canisters( level.rts.canisters );
	
	scene_wait( "intro_climbup_player" );
		
	level.rts.player.ignoreme 	= false;
	level.rts.player.takedamage = true;
	level.rts.player DisableInvulnerability(); // so the player doesn't get killed by the hurt trigger in mp maps
	for ( i = 0; i < level.rts.squads[0].members.size; i++ )
	{
		level.rts.squads[0].members[i].animname 	= undefined;
		level.rts.squads[0].members[i].rts_unloaded = 1;
		level.rts.squads[0].members[i].ignoreme		= false;
	}
	
	thread resume_normal_ai( level.rts.squads[0].members );
}
//////////////////////////////////////////////////////////////////////////////////////////////////
intro_start_civ_anims( player )
{
	level thread run_scene( "intro_climbup_civs" );
}
//////////////////////////////////////////////////////////////////////////////////////////////////
intro_delete_canisters( canisters )
{
	scene_wait( "intro_canisters" );
	
	foreach( c in canisters )
	{
		c Delete();
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////
// keep the AI at their intro nodes at least for a bit
resume_normal_ai( introSquad )
{
	wait( 5 );
	
	foreach( guy in introSquad )
	{
		if( IsAlive(guy) && guy.fixedNode )
		{
			guy.fixedNode = false;
			guy thread maps\_so_rts_squad::moveWithPlayer();
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////
setup_objectives()
{
	level thread maps\_objectives::init();
	
	level.OBJ_FIND 		= register_objective( &"SO_RTS_MP_SOCOTRA_OBJ_RESCUE" );
	level.OBJ_PROTECT 	= register_objective( &"SO_RTS_MP_SOCOTRA_OBJ_PROTECT" );
	level.OBJ_ESCORT 	= register_objective( &"SO_RTS_MP_SOCOTRA_OBJ_ESCORT" );
	
	level thread socotra_objective_karma_watch();

}
socotra_objective_karma_watch()
{
	level endon("socotra_mission_complete");
	
	set_objective( level.OBJ_FIND ); 
	curObj = level.OBJ_FIND;
	level waittill ("socotra_karma_rescued");
	
	while(isDefined(level.rts.karma) && !flag("vtol_objective_switch"))
	{
		if(isDefined(level.rts.karma.guyToFollow))
		{
			if ( curObj != level.OBJ_PROTECT )
			{
				set_objective( curObj, undefined, "done" );
				set_objective( level.OBJ_PROTECT, level.rts.karma,"*" ); 
				curObj = level.OBJ_PROTECT;
			}
		}
		else
		{
			if ( curObj != level.OBJ_FIND )
			{
				set_objective( curObj, undefined, "done" );
				set_objective( level.OBJ_FIND, level.rts.karma, "*" ); 
				curObj = level.OBJ_FIND;
			}
		}
		wait 1;
	}

	set_objective( level.OBJ_FIND, undefined, "done" );
	set_objective( level.OBJ_PROTECT, undefined, "done" );
	curObj = level.OBJ_FIND;
	while(isDefined(level.rts.karma) && !IS_TRUE(self.at_vtol) )
	{
		if(isDefined(level.rts.karma.guyToFollow))
		{
			if ( curObj != level.OBJ_ESCORT )
			{
				set_objective( curObj, undefined, "done" );
				set_objective( level.OBJ_ESCORT, level.rts.outroLoc.origin ); 
				curObj = level.OBJ_ESCORT;
			}
		}
		else
		{
			if ( curObj != level.OBJ_PROTECT )
			{
				set_objective( curObj, undefined, "done" );
				set_objective( level.OBJ_PROTECT, level.rts.karma,"*" ); 
				curObj = level.OBJ_PROTECT;
			}
		}
		wait 1;
	}
	
	set_objective( level.OBJ_ESCORT, undefined, "done" );
	set_objective( level.OBJ_PROTECT, level.rts.karma, "*" ); 
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
enemySpawnInit()
{

	maps\_so_rts_catalog::spawn_package( "quadrotor_pkg", "axis", true,::socotra_quad_spawn );
	maps\_so_rts_catalog::spawn_package( "quadrotor_pkg", "axis", true,::socotra_quad_spawn );
	maps\_so_rts_catalog::spawn_package( "quadrotor_pkg", "axis", true,::socotra_quad_spawn );
	maps\_so_rts_catalog::spawn_package( "quadrotor_pkg", "axis", true,::socotra_quad_spawn );
	maps\_so_rts_catalog::spawn_package( "quadrotor_pkg", "axis", true,::socotra_quad_spawn );
	
	maps\_so_rts_catalog::setPkgQty("infantry_enemy_reg_pkg","axis",level.rts.safehouses.size);
	pkg 	= maps\_so_rts_catalog::package_GetPackageByType("infantry_enemy_reg_pkg");
	foreach(loc in level.rts.safehouses )
	{
		maps\_so_rts_ai::spawn_ai_package_standard(pkg, "axis", ::socotra_poi_Inf_spawn, loc.origin);
		squad 	= getSquadByPkg( "infantry_enemy_reg_pkg", "axis" );
		unit 	= maps\_so_rts_enemy::create_units_from_squad(squad.id);
		level thread maps\_so_rts_enemy::unitThink(unit,maps\_so_rts_poi::getPOIByRef(loc.poi_ref) );
	}
	
	level.rts.enemySpawnLocs = GetEntArray("enemy_spawn_loc","targetname");
	foreach(loc in level.rts.enemySpawnLocs)
	{
		loc.timestamp = 0;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

socotraAirSuperiorityTakeOverWatch()
{
	self endon("death");
	level endon( "rts_terminated" );
	while(1)
	{
		//player is assuming control
		self waittill("taken_control_over");
		rpc( "clientscripts/_so_rts", "holdSwitchStatic",1 );

		// If I have a gunner
		if ( IsDefined( self.gunner ) )
		{
			// delete him
			self.gunner Delete();
		}
		self waittill( "enter_vehicle" );
		wait .1;
		rpc( "clientscripts/_so_rts", "holdSwitchStatic",0 );
		
		self thread socotraAirSuperiorityPlayerMove();
		self thread socotraAirSuperiorityPlayerRotate();
		
		self waittill("player_exited");
		//player is releaseing control
		//:
		//do some shit
		
		// Put a gunner back on the turret
		if ( !IsDefined( self.gunner ) )
		{
			self.gunner = simple_spawn_single( "ai_spawner_ally_assault" );
			if(isDefined(self.gunner))
			{
				self.gunner.ignoreme = true;
				self.gunner magic_bullet_shield();
				self.gunner maps\_vehicle_aianim::vehicle_enter( self, "tag_gunner1" );
			}
			
			self thread maps\_turret::enable_turret( 1, true );			
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

socotraAirHeightClamp(squadId)
{
	origin	= GetEnt("air_support_start","targetname").origin;
	squad 	= maps\_so_rts_squad::getSquad( squadID );
	squad.centerPoint = (squad.centerPoint[0],squad.centerPoint[1],origin[2]);
	ret 	= true;	
	switch(squad.nextstate)
	{
		case SQUAD_STATE_PATROL:
		case SQUAD_STATE_ATTACK:
		case SQUAD_STATE_MOVEWITHPLAYER:
		case SQUAD_STATE_MANAGED:
			ret = false;
	}
	if ( ret == false )
	{
		maps\_so_rts_squad::ReIssueSquadLastOrders(squad.id);
	}
	return ret;
}
socotraAirNada(squadID)
{
	return false;
}
socotraAirAttackLoc(loc)
{
	self endon ("vtol_disabled");
	while(!flag("vtol_attack_go"))
	{	//see if the player is looking in our general direction
		forward = AnglesToForward(level.rts.player.angles);
		dot = VectorDot(forward, VectorNormalize(loc.origin - level.rts.player.origin));
		if(dot > 0.92)//if so, lets do it.
			break;
		dot = VectorDot(forward, VectorNormalize(self.origin - level.rts.player.origin));//player looking at the VTOL?
		if(dot > 0.92)//if so, lets do it.
			break;
		wait 0.2;
	}
	while(1)
	{
		stinger = MagicBullet( "stinger_rts_sp", loc.origin, self.origin + ( 0,0, 12) );
		stinger maps\_so_rts_support::set_gpr(maps\_so_rts_support::make_gpr_opcode(GPR_OP_CODE_SET_TEAM) + 0 ); //for sonar coloration

		wait RandomFloatRange(7,16);
	}
}
socotraAirSuperiorityAutoKill()
{
	level endon( "rts_terminated" );
	self endon("death");
	self.takedamage = false;
	flag_wait("vtol_on_route");//set when karma is rescued(This is the rescue VTOL, not the vtol the player can use..i.e. self)
	secondsUntilRescue = TIME_TO_REACH_VTOL*60;

	wait (secondsUntilRescue/2);
	self thread maps\_so_rts_support::notifyMeInNSec("damage",25,100,level,self.origin,"tag_origin","MOD_EXPLOSIVE");
	level thread maps\_so_rts_support::flag_set_inNSeconds("vtol_attack_go",8);

	self.takedamage = true;
	locs = GetStructArray("vtol_attack_loc","targetname");
	foreach(loc in locs)
	{
		self thread socotraAirAttackLoc(loc);
	}
	while(1)
	{
		self waittill("damage", amount, attacker, vec, p, type);
		if ( !( type == "MOD_EXPLOSIVE" || type == "MOD_EXPLOSIVE_SPLASH" || type == "MOD_PROJECTILE" ) )
			continue;
		self notify("vtol_disabled");
		level notify("vtol_disabled");
		self.selectable = false;
		self.rts_unloaded = false;
		level.rts.squads[self.squadID].selectable = false;
		if ( isDefined(level.rts.player.ally) && isDefined(level.rts.player.ally.vehicle) && level.rts.player.ally.vehicle == self )//kick the player out if he is in the vtol
		{
			level thread maps\_so_rts_main::player_nextAvailUnit(undefined,false);
		}
		// If I have a gunner
		if ( IsDefined( self.gunner ) )
		{
			// delete him
			self.gunner Delete();
		}
		
		dest = GetStruct("vtol_outro_dest","targetname").origin;
		dest = (dest[0],dest[1],self.origin[2]);
		maps\_so_rts_event::trigger_event("fx_vtol_explode",self.origin);
		maps\_so_rts_event::trigger_event("fx_vtol_smoke",self);
		maps\_so_rts_event::trigger_event("dlg_vtol_damage");
		LUINotifyEvent( &"rts_remove_squad", 1, self.squadID);
		wait 1;
		
		level.rts.squads[self.squadID].squad_execute_cb = ::socotraAirNada;					//just in case, probably not needed but this will block any squadorders(though having it non selectable ought to do this)
		maps\_so_rts_event::trigger_event("dlg_vtol_quads");
		pkg_ref = maps\_so_rts_catalog::package_GetPackageByType( "quadrotor_pkg" );
		pkg_ref.max_friendly = 10;	
		
		self ClearVehGoalPos();
		maps\_so_rts_catalog::spawn_package( "quadrotor_pkg", "allies" );		//toss out a bunch of quads
		level waittill("unloaded_quadrotor_pkg");
		self SetVehGoalPos(dest,1,0);
		self SetSpeed( 5, 1, 1 );
		maps\_so_rts_catalog::spawn_package( "quadrotor_pkg", "allies" );
		level waittill("unloaded_quadrotor_pkg");
	
		maps\_so_rts_catalog::setPkgQty("quadrotor_pkg","allies",0);
		level thread socotraGetAllQuadsToKarma();
//		maps\_so_rts_catalog::setPkgDelivery("quadrotor_pkg","STANDARD");
///		pkg_ref.max_friendly = 1;	
//		pkg_ref.min_friendly = 1;	
		self SetSpeed( 20, 4, 1 );
		return;
	}
}

getToKarma()
{
	if(isDefineD(level.rts.karma))
	{
		self.rts_unloaded = false;
		self thread maps\_vehicle::move_to(level.rts.karma.origin);
		self waittill("goal");
		self.rts_unloaded = true;
	}
}
socotraGetAllQuadsToKarma()
{
	squad 	= maps\_so_rts_squad::getSquadByPkg( "quadrotor_pkg", "allies" );
	foreach(quad in squad.members)
	{
		quad thread getToKarma();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotraAirSuperiorityThink(squadId)
{
	level endon( "rts_terminated" );
	squad 	= maps\_so_rts_squad::getSquad( squadID );
	squad.no_nag = true;
	
	level.rts.vtol 	= squad.members[0];
	vtol = level.rts.vtol;
	assert (isDefined(vtol));
	vtol endon("death");
	vtol SetNearGoalNotifyDist( 300 );
	vtol SetSpeed( 60, 25, 5 );
//	vtol thread socotraAirSuperiorityAutoKill();
	vtol thread socotraAirSuperiorityTakeOverWatch();
	vtol maps\_turret::set_turret_burst_parameters( 2, 3, 12, 20, 1 );
	vtol.squadId = squadId;

	//create an AI gunner
	vtol.gunner = simple_spawn_single( "ai_spawner_ally_assault" );
	vtol.gunner.ignoreme = true;
	vtol.gunner magic_bullet_shield();
	//put gunner on vtol
	vtol.gunner maps\_vehicle_aianim::vehicle_enter( vtol, "tag_gunner1" );
	vtol.no_takeover = true;
	squad.squad_execute_cb = ::socotraAirHeightClamp;
	flag_wait("intro_done");
	maps\_so_rts_squad::OrderSquadDefend( GetStruct("vtol_initial_dest","targetname").origin + (0,0,1000),squad.id,true);
	wait 1;
	squad.squad_execute_cb = ::socotraAirNada;
	vtol waittill_any( "goal", "near_goal" );
	vtol.no_takeover = undefined;
	vtol SetSpeed( 20, 15, 5 );
	//rock and roll
	vtol thread maps\_turret::enable_turret( 1, true );
	squad.squad_execute_cb = ::socotraAirHeightClamp;
	
	while(1)
	{
		level waittill("new_squad_orders"+squadID);
		//:
		//:		
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotraAirSuperiorityPlayerMove()
{
	self endon("death");
	self endon( "player_exited" );
	
	level endon( "rts_terminated" );	
	
	squad 	= maps\_so_rts_squad::getSquad( self.squadID );	
	
	while ( 1 )
	{
		controller = level.player GetNormalizedMovement();
	
		angles = self GetTagAngles( "tag_gunner_turret1" );
		VEC_SET_X( angles, 0 );
		VEC_SET_Y( angles, AngleClamp180( angles[1] ) );
		VEC_SET_Z( angles, 0 );		
		
		forward = AnglesToForward( angles );
		right = AnglesToRight( angles );
		
		if ( Length( controller ) > 0.1 )
		{
			point = self.origin + forward * ( controller[0] * 1000 );			
			point = point + right * ( controller[1] * 1000 );
	
			result = maps\_so_rts_support::clampOriginToMapBoundary(point);
			maps\_so_rts_squad::OrderSquadDefend(result.origin,self.squadId,true);			
		}
		wait( 0.25 );
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define MAX_VTOL_YAW_SPEED 45
socotraAirSuperiorityPlayerRotate()
{
	self endon("death");
	self endon( "player_exited" );
	
	level endon( "rts_terminated" );	

	while( 1 )
	{
		controller = level.player GetNormalizedCameraMovement();		

		turret_angles = self GetTagAngles( "tag_gunner_turret1" );
		VEC_SET_X( turret_angles, 0 );
		VEC_SET_Y( turret_angles, AngleClamp180( turret_angles[1] ) );
		VEC_SET_Z( turret_angles, 0 );		
		
		forward = AnglesToForward( turret_angles );
		
		heli_angles = self.angles;
		VEC_SET_X( heli_angles, 0 );
		VEC_SET_Y( heli_angles, AngleClamp180( heli_angles[1] ) );
		VEC_SET_Z( heli_angles, 0 );		
		
		right = AnglesToRight( heli_angles );
		
		dot = VectorDot( forward, right );
		dot = Clamp( dot, -1, 1 );
		angle = ACos( dot );

		avel = self GetAngularVelocity();
		
		desired_yaw_speed = 0;
		if ( angle >= 65 )
		{
			desired_yaw_speed = -controller[1] * MAX_VTOL_YAW_SPEED;
		}
		
		yaw_speed = DiffTrack( desired_yaw_speed, avel[1], 2.5, 0.05 );
		
		VEC_SET_Y( avel, yaw_speed );
		self SetAngularVelocity( avel );		
		
		wait( 0.05 );
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotraAirSuperiorityHandleGunnerTarget()
{
	self notify( "handle_target" );
	self endon( "handle_target" );


	Target_Set( self, ( 0, 0, 32 ) );
	self waittill( "death" );
	
	targets = Target_GetArray();
	
	if ( IsDefined( self ) )
		Target_Remove( self );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotraAirSuperioritySpawn()
{
	maps\_so_rts_catalog::setPkgQty("airsuperiority_pkg","allies",1);
	maps\_so_rts_catalog::spawn_package( "airsuperiority_pkg", "allies", false,::socotraAirSuperiorityThink );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotraEnemyBTRSpawn()
{
	flag_wait("vtol_on_route");
	maps\_so_rts_catalog::setPkgQty("btr_enemy_pkg","axis",1);
	maps\_so_rts_catalog::spawn_package( "btr_enemy_pkg", "axis", false,::socotraBTRThink );
}
socotraBTRWeapon()
{
	self endon( "death" );
	self endon( "stop_attack" );
	self thread maps\_turret::enable_turret( 1 );			

	while( 1 )
	{
		a_guys = (getAIArray("allies"));
		if ( a_guys.size <= 2 )
		{
			a_guys = array_randomize(ArrayCombine(getAIArray("allies"),GetVehicleArray("allies"), false, false));
		}
		
		for ( i = 0; i < a_guys.size; i++ )
		{
			candidate = a_guys[ i ];
			if ( IS_TRUE(candidate.ignoreme))
			{
				continue;
			}
			if ( Distance2DSquared( self.origin, candidate.origin ) < ( 2000 * 2000 ) && self thread maps\_turret::can_turret_hit_target( candidate, 1 ) )
			{
				e_target = candidate;
				break;
			}
		}
		
		if ( flag("fps_mode") )
		{
			if ( self thread maps\_turret::can_turret_hit_target( level.rts.player, 1 ) )
			{
				e_target = level.rts.player;
			}
			else
			if ( RandomInt( 4 ) == 0 && isdefined(level.rts.karma) && self thread maps\_turret::can_turret_hit_target( level.rts.karma, 1 ) )
			{
				e_target = level.rts.karma;
			}
		}
		if ( IsDefined( e_target ) )
		{
			self thread shoot_turret_at_target( e_target, -1, ( RandomIntRange( -80, 80 ), RandomIntRange( -80, 80 ), RandomIntRange( -80, 80 ) ), 1 );
			
			wait RandomFloatRange( 3.0, 5.0 );
			
			self stop_turret( 1 );
		}
		
		wait RandomFloatRange( 3.0, 5.0 );
	}
}
socotraBTRDamage()
{
	self endon("death");
	self.takedamage = 1;
	while(1)
	{
		self waittill("damage", amount, attacker, vec, p, type);
		if ( !( type == "MOD_EXPLOSIVE" || type == "MOD_EXPLOSIVE_SPLASH" || type == "MOD_PROJECTILE" ) )
		{
			self.health += amount;
			continue;
		}
		/#
			println("BTR Took damage - " + amount + " Health Left: " + self.health	);
		#/			
	}
}	
socotraBTRThink(squadID)
{
	level endon( "rts_terminated" );
	squad 	= maps\_so_rts_squad::getSquad( squadID );
	
	vtolTimer 	= TIME_TO_REACH_VTOL * 60;
	btrTimeOut 	= vtolTimer * 0.6;

	level.rts.btr 	= squad.members[0];
	assert (isDefined(level.rts.btr));
	level.rts.btr endon("death");
	level.rts.btr.allow_OOB = true;
	level.rts.btr.animname = "btr";
	maps\_so_rts_squad::OrderSquadManaged(squadID);
	wait 0.05;
	level.rts.btr ClearVehGoalPos();
	level.rts.btr CancelAIMove();
	level thread run_scene_first_frame( "btr_intro" );
	level waittill_any("karmaAtSmoke","vtol_has_arrived");
	assert(isDefineD(level.rts.btr));
	level.rts.btr ClearVehGoalPos();
	level.rts.btr CancelAIMove();

	level thread run_scene( "btr_intro" );
	scene_wait("btr_intro");
	//put the BTR on a vehicle spline.	
	level.rts.btr SetNearGoalNotifyDist( 300 );
	level.rts.btr SetSpeed( 6, 60, 2 );
	level.rts.btr.drivepath = true;
	level.rts.btr thread go_path(GetVehicleNode("btr60_start","targetname"));
	level.rts.btr thread socotraBTRWeapon();
	level.rts.btr thread socotraBTRDamage();
	level.rts.btr waittill( "reached_end_node" );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define SPAWN_LOC_COOLDOWN 6000
largestCompareFunc( e1, e2, val)
{
	return e1.score > e2.score;
}

socotraCodeSpawner(pkg_ref, team, callback, squadID)
{
	allies = GetAIArray("allies");
	
	if ( team == "axis" )
	{
		if ( pkg_ref.ref == "quadrotor_pkg" )
		{
			squadID = maps\_so_rts_squad::createSquad(level.rts.enemy_center.origin,team,pkg_ref); 
			squad = level.rts.squads[squadID];
			if(squad.members.size >= pkg_ref.max_axis )
				return -1;

			ai_ref = level.rts.ai["ai_spawner_quadrotor"];
			maps\_so_rts_squad::removeDeadFromSquad(squadID);
			
			loc 		= GetStruct("quadrotor_spawn","targetname");
			ai 			= maps\_so_rts_support::placeVehicle( ai_ref.ref, loc.origin, team );
			ai.ai_ref 	= ai_ref;
			ai.goalpos 	= level.rts.enemy_center.origin;
			ai maps\_so_rts_squad::addAIToSquad(squadID);
			maps\_so_rts_catalog::units_delivered(team,squadID);

			return squadID;
		}
	
		time = GetTime();
		acceptable = [];
		locs 	= sortArrayByFurthest(level.rts.player.origin, level.rts.enemySpawnLocs,700*700 );
		for(i=0;i<locs.size;i++)
		{
			if ( time > locs[i].timestamp )
				acceptable[acceptable.size] = locs[i];
		}
		if (acceptable.size == 0 )
			return -1;
		
		foreach(loc in acceptable)
		{
			loc.distScore = (loc.lastDistCalc/(1024*1024))*2;
			loc.timeScore = (time-loc.timestamp)/6000;
			loc.allyScore = 0;
			loc.poiScore  = 0;
			foreach(poi in level.rts.poi)
			{
				if (!isDefined(poi.entity))
					continue;
					
				distSQ = distancesquared(loc.origin,poi.entity.origin);
				if(distSQ < 512*512)
				{
					loc.poiScore = -1;
				}
			}
			foreach(guy in allies)
			{
				distSQ = distancesquared(loc.origin,guy.origin);
				if(distSQ < 600*600)
					loc.allyScore -= 1;
			}
			if (isDefined(level.rts.player.ally))
			{
				distSQ = distancesquared(loc.origin,level.rts.player.origin);
				if(distSQ < 600*600)
					loc.allyScore -= 2;
			}
			loc.score =  (loc.poiScore == -1?0:(loc.distScore + loc.timeScore + loc.allyScore)); 
		}
		
		spots = maps\_utility_code::mergesort( acceptable, ::largestCompareFunc);
		spot 	= spots[0];
		spot.timestamp = time + SPAWN_LOC_COOLDOWN;
		squadID = maps\_so_rts_ai::spawn_ai_package_standard(pkg_ref, team, undefined, spot.origin);
		
		if (pkg_ref.ref == "infantry_enemy_rpg_pkg" && level.rts.squads[squadID].members.size > 0  )
		{
			guy = level.rts.squads[squadID].members[RandomInt(level.rts.squads[squadID].members.size)];
			if(isDefineD(guy))
				guy.favoriteenemy = level.rts.vtol;
		}

		foreach(guy in level.rts.squads[squadID].members)
		{
			guy thread socotraAirSuperiorityHandleGunnerTarget();
			guy.dofiringdeath = false;
		}
	}
	else
	{
		if (pkg_ref.ref == "airsuperiority_pkg" )
		{
			origin	= GetEnt("air_support_start","targetname").origin;
		
			ai_ref = level.rts.ai["vtol_air_support_spawner"];
			squadID = maps\_so_rts_squad::createSquad(origin,team,pkg_ref); 
			if (team=="allies" && isDefined(pkg_ref.hot_key_takeover) )
			{
				LUINotifyEvent( &"rts_add_squad", 3, squadID, pkg_ref.idx, 0 );
			}
			ai = maps\_so_rts_support::placeVehicle( ai_ref.ref, origin, team );
			ai.ai_ref = ai_ref;
			ai.allow_OOB = true;
			ai maps\_so_rts_squad::addAIToSquad(squadID);
			maps\_so_rts_catalog::units_delivered(team,squadID);
		}
		else
		if ( pkg_ref.ref == "infantry_ally_reg_pkg")
		{
			if (IS_TRUE(pkg_ref.inCodeSpawn))
				return -1;

			pkg_ref.inCodeSpawn = true;
			squad   = isSquadAlreadyCreated("allies",pkg_ref);
			if(isDefined(squad))
			{
				foreach(guy in squad.members)
				{
					if(isDefined(guy))
					guy.alreadyInSquad = true;
				}
			}
			origin	= GetStruct("rts_ally_squad_reg_spawnLoc","targetname").origin;
			squadID = maps\_so_rts_ai::spawn_ai_package_standard(pkg_ref, team, undefined, origin);

			newGuys = [];
			if(isDefined(squad))
			{
				foreach(guy in squad.members)
				{
					if(isDefined(guy))
					{
						if (!IS_TRUE(guy.alreadyInSquad))
						{
							newGuys[newGuys.size] = guy;
						}
					}
				}
			}
			for(i=0;i<newGuys.size;i++)
			{
				newGuys[i].rts_unloaded = false;
				newGuys[i].animname = "ally_intro_"+i;
				level thread run_scene( "infantry_reg_pkg_intro_"+i );
				newGuys[i] thread intro_wait("infantry_reg_pkg_intro_"+i);
				newGuys[i].rts_unloaded = true;
			}
	
			maps\_so_rts_squad::ReIssueSquadLastOrders(squadID);
			pkg_ref.inCodeSpawn = undefined;

		}
		else
		if ( pkg_ref.ref == "infantry_ally_heavy_pkg")
		{
			origin	= GetStruct("rts_ally_squad_heavy_spawnLoc","targetname").origin;
			squadID = maps\_so_rts_ai::spawn_ai_package_standard(pkg_ref, team, undefined, origin);
			maps\_so_rts_squad::ReIssueSquadLastOrders(squadID);
		}
		else
		if ( pkg_ref.ref == "quadrotor_pkg" )
		{
			if (!isDefined(level.rts.vtol) )
				return -1;
				
			squad 	= maps\_so_rts_squad::getSquadByPkg( "quadrotor_pkg", "allies" );
			maps\_so_rts_squad::removeDeadFromSquad(squad.id);
			
			if(squad.members.size >= pkg_ref.max_friendly )
				return -1;
			
			squadID = squad.id;
			level.rts.vtol thread maps\_so_rts_ai::chopper_unload_cargo_quad( pkg_ref, team, squadID, maps\_so_Rts_squad::squad_unloaded);
		}
	}
	
	// finish spawning callback
	if( IsDefined( callback ) )
		thread [[ callback ]]( squadID );
	return squadID;
}

intro_wait(flag)
{
	scene_wait(flag);
	self.animname = undefined;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotra_AI_TakeOver_OFF()
{
	level endon( "rts_terminated" );

	trigger = GetEnt("rts_takeover_OFF","targetname");
	while(isDefined(trigger))
	{
		trigger waittill("trigger",who);
		who.no_takeover = true;
		who.ignoreme = true;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotra_AI_TakeOver_ON()
{
	level endon( "rts_terminated" );

	trigger = GetEnt("rts_takeover_ON","targetname");
	while(isDefined(trigger))
	{
		trigger waittill("trigger",who);
		who.no_takeover = undefined;
		who.ignoreme = false;
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotra_heavy_guy_unload(point,radius)
{
	self.rts_unloaded 	= false;
	oldradius			= self.goalradius;
	self.goalradius 	= radius;
	self SetGoalPos(point);
	self waittill("goal");
	self.rts_unloaded 	= true;
	self.goalradius 	= oldradius;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotra_heavy_squad_spawned(squadID)
{
	origin	= GetStruct("rts_ally_squad_heavy","targetname").origin;
	done 	= false;
	array_thread(level.rts.squads[squadID].members, ::socotra_heavy_guy_unload, origin, 128);
	while(!done)
	{
		wait .5;
		done = true;
		foreach (guy in level.rts.squads[squadID].members)
		{
			if(!IS_TRUE(guy.rts_unloaded))
				done = false;
		}
	}

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
vtol_magicBullet()
{
	self endon("death");
	level endon("karma_at_vtol");
	while(!flag("vtol_died"))
	{
		wait 8;
		spots = GetEntArray("vtol_attack_loc","targetname");
		spot  = spots[RandomInt(spots.size)];
		e_rpg = MagicBullet( "rpg_sp", spot.origin, self.origin + ( 0,0, 12) );
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
vtol_deathWatch()
{	
	level endon("karma_at_vtol");
	nagInterval = (TIME_TO_WAIT_FOR_VTOL*60)/4;

	//Trigger Audio
	//The area is too hot.. we can hold position, but not for long...
	//
	wait (nagInterval); //25% nag

	wait (nagInterval); //25% nag
	
	wait (nagInterval); //25% nag
	
	flag_wait("vtol_clearout");
	set_objective( level.OBJ_ESCORT, undefined, "failed" );
	set_objective( level.OBJ_PROTECT, undefined, "failed" );

	level thread run_scene( "vtol_dustoff" );

	//RPGs on the roof.. pull out pull out

	self.takedamage = 1;
	self.health = 100;
	
	self thread vtol_magicBullet();//failsafe
	
	spots 	= GetEntArray("vtol_attack_loc","targetname");
	guys  = [];
	foreach (spot in spots)
	{
		guy = simple_spawn_single( "ai_spawner_enemy_rpg", undefined, undefined, undefined, undefined, undefined, undefined, true);
		if(isDefined(guy))
		{
			guys[guys.size] = guy;
			guy ForceTeleport(spot.origin,spot.angles);
		}
	}
	badGuys = GetAIArray("axis");
	foreach (guy in badGuys)
	{
		guy.favoriteenemy = self;
	}

	while(1)
	{
		self waittill("damage", amount, attacker, vec, p, type);
		if ( !( type == "MOD_EXPLOSIVE" || type == "MOD_EXPLOSIVE_SPLASH" || type == "MOD_PROJECTILE" ) )
			continue;
			
		flag_set("vtol_died");
			//destroy event..
			//boom
			//boom
			//boom
		maps\_so_rts_event::trigger_event("fx_vtol_explode",self.origin);
		maps\_so_rts_event::trigger_event("fx_vtol_smoke",self);
		//crash path.....
		//:
		
		socotra_mission_complete_s1(false, true);

		wait 10;
		break;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotra_vtol_watch()
{
	level endon("socotra_mission_complete");
	
	flag_set("vtol_on_route");
	//spawn a vtol
	//fly it up
	assert( IsDefined( level.rts.outroLoc ) );

	//Pop Smoke FX at outro loc
	nodes = GetNodesInRadius( level.rts.outroLoc.origin, 100, 0, 128 );
	if(nodes.size>0)
	{
		spot = nodes[RandomInt(nodes.size)].origin;
	}
	else
	{
		spot = level.rts.outroLoc.origin;
	}
	maps\_so_rts_event::trigger_event("fx_signal_smoke",spot);
	
	
	flag_Wait("vtol_objective_switch");
	// create the anim start trigger for the player
	//set up some proximity trigger
	trigger = Spawn( "trigger_radius", level.rts.outroLoc.origin, 0, KARMA_DISTVTOL_THRESHOLD+32, 64 );	


	flag_wait("vtol_arrived");
	
	while( isDefined(level.rts.karma) && !flag("vtol_clearout") )
	{
		if( trigger IsTouching( level.rts.karma ) )
		{
			break;
		}
		wait 0.1;
	
	}
	if(!isDefined(level.rts.karma) || flag("vtol_clearout") )
		return;
	//KARMA/player in right location, play outro
	level notify("karma_at_vtol");
	
	entnum = level.rts.karma GetEntityNumber();
	LUINotifyEvent( &"rts_del_poi", 1, entnum );
	
	maps\_so_rts_support::time_countdown_delete();
	maps\_so_rts_catalog::setPkgQty("quadrotor_pkg","allies",0);
	set_objective( level.OBJ_FIND, undefined, "done" );
	set_objective( level.OBJ_ESCORT, undefined, "done" );
	set_objective( level.OBJ_PROTECT, undefined, "done" );
	level thread socotra_StartOutro( level.rts.outroLoc );
	level thread socotra_RPG_TargetVtolInOutro();
	flag_wait("outro_done");
	level thread socotra_mission_complete_s1(true, true);
}
socotra_RPG_TargetVtolInOutro()
{
	level waittill_any_timeout(8,"vtol_up");
	socotra_rooftopInit(true,level.rts.player);
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotra_karma_damageWatch()
{
	level endon("socotra_mission_complete");
	while(isDefined(level.rts.karma ))
	{
		level.rts.karma waittill("damage");
		/#
			println("###$ KARMA Health:" + level.rts.karma.health);
		#/
	}
}

socotra_karma_deathWatch()
{
	level endon("socotra_mission_complete");
	level.rts.karma endon("taken_control_over");
	
	entNum = level.rts.karma GetEntityNumber();
	level.rts.karma.deathFunction = ::socotra_karma_death_camera;
	
	level.rts.karma waittill("death");
	
	LUINotifyEvent( &"rts_del_poi", 1, entNum );
	flag_clear("rts_mode");
	flag_clear("fps_mode");
	wait 6;
	flag_set("fps_mode");
	level thread socotra_mission_complete_s1(false, true);	
}

socotra_karma_death_camera()
{
	flag_set("block_input");
	level.rts.player EnableInvulnerability();
	if (isDefined(level.rts.player.ally) && isDefineD(level.rts.player.ally.vehicle) )
	{
		level.rts.player.ally.vehicle veh_magic_bullet_shield(true);
	}
	level.rts.player.ignoreMe = true;
	level.rts.player DisableWeapons();
	level.rts.player DisableOffhandWeapons();
	level.rts.player HideViewModel();			
	maps\_so_rts_support::toggle_damage_indicators(false);
	SetDvar("lui_enabled",0);
	
	// third person over karma's dead body
	level.rts.player SetClientFlag( FLAG_CLIENT_FLAG_THIRD_PERSON_CAM );
	
	//level.rts.player StartCameraTween( 0.3 );
	
	thread screen_fade_out( 0.5 );
	
	// wait for the camera to switch so we can see the body
	while( GetDvarInt( "cg_thirdperson" ) == 0 )
		wait( 0.05 );
	
	maps\_so_rts_support::show_player_hud();
	LUINotifyEvent( &"rts_hud_visibility", 1, 0 );
	level clientnotify( "rts_OFF" );
	wait( 0.5 );
	
	thread screen_fade_in( 0.5 );
	level.rts.player ClearClientFlag( FLAG_CLIENT_FLAG_RETICLE );//incase we were in rts view
	
	// look down at the corpse
	viewAngles = (30,0,0);
	
	// spawn the link object
	cameraTarget = Spawn( "script_model", self.origin );
	cameraTarget.angles = viewAngles;
	
	level.rts.player Unlink();
	level.rts.player SetOrigin( cameraTarget.origin );
	level.rts.player PlayerLinkToAbsolute( cameraTarget );
	level.rts.player SetContents( 0 );
	level.rts.player FreezeControls( true );
	
	allAI = GetAIArray();
	foreach( guy in allAI )
		guy PushPlayer( false );




	flag_clear("rts_event_ready"); //don't allow any more dialog in the queue

	// let the death animscript do its thing
	return false;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

socotra_karama_spawnWatch()
{
	level endon("socotra_mission_complete");

	level waittill("poi_captured_allies");
	socotra_karma_spawn();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotra_karma_roomSpawnInit(karma)
{
	squad = getSquadByPkg( "infantry_ally_reg_pkg", "allies");
	
	maps\_so_rts_squad::OrderSquadDefend(level.rts.karma.origin,squad.id);
	
	i = 0;
	nodes = GetNodesInRadiusSorted( level.rts.karma.origin, 512, 0, 128,"cover" );
	foreach(guy in squad.members)
	{
		if(!isDefined(guy))
			continue;
			
		guy forceteleport(nodes[i].origin);
		guy setGoalNode(nodes[i]);
		i++;
		if (i>=nodes.size)
			i = 0;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotra_karma_magic_circle()//studio notes: Karma to be safe until she is on the move
{
	self endon("death");
	trigger = spawn("trigger_radius", self.origin, 0, 200, 64);
	
	while( isDefined(self) )
	{
		if( (self IsTouching( trigger )) == false )
		{
			break;
		}
		self.takedamage = false;
		wait 0.05;
	}
	self.takedamage = true;
	trigger Delete();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

socotra_karma_spawn()
{
	/#
		println(GetTime()+" karma_spawn");
	#/

	level.rts.karma = simple_spawn_single( "ai_spawner_karma", undefined, undefined, undefined, undefined, undefined, undefined, true);
	level.rts.karma.animname 	= "karma";
	
	level.rts.karma.state_machine = create_state_machine( "brain", level.rts.karma  );
	level.rts.karma.state_machine add_state( "hostage", undefined, undefined, ::karma_hostage, undefined, undefined );
	level.rts.karma.state_machine add_state( "idle", undefined, undefined, ::karma_idle, undefined, undefined );
	level.rts.karma.state_machine add_state( "follow", undefined, undefined, ::karma_follow, undefined, undefined );
	level.rts.karma.state_machine add_state( "vtol", undefined, undefined, ::karma_vtol, undefined, undefined );

	// start the update
	level.rts.karma.state_machine set_state( "hostage" );
	level.rts.karma.state_machine update_state_machine( 0.05 );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

karma_helpMe(origin,radius)
{
	trigger = spawn("trigger_radius", origin, 0, radius, 64);
	trigger waittill("trigger");
 	entNum = self getEntityNumber();
	LUINotifyEvent( &"rts_add_poi", 1, entNum );
    LUINotifyEvent( &"rts_protect_poi", 5, entNum, istring("SO_RTS_OBJ3D_RESCUE"),0,0,72 );
}

karma_hostage()
{
	/#
		println(GetTime()+" karma_hostage");
	#/
	playerStart = GetEnt("rts_player_start","targetname");
	pois = [];
	foreach(poi in level.rts.poi)
	{
		if ( issubstr(poi.ref,"poi_search"))
			pois[pois.size] = poi;
	}
	level.rts.karma_poi = pois[RandomInt(pois.size)];//furthest away from vtol return spot
	level.rts.karma_poi.karma = true;
	
	pkg_ref = package_GetPackageByType("karma_pkg");
	squadID = maps\_so_rts_squad::createSquad(level.rts.karma_poi.origin,"allies",pkg_ref); //every PACKAGE spawned should have a unique identifyer
	level.rts.squads[squadID].no_nag = true;
	self maps\_so_rts_squad::addAIToSquad(squadID);
	//level.rts.nag_targets[level.rts.nag_targets.size] = squadID;
	level.rts.squads[squadID].selectable = false;
	
	self.team			= "neutral";
	self.ignoreme 		= true;
	self.ignoreall 		= true;
	self.goalradius 	= 4;
	self.takedamage 	= false;
	self.selectable		= false;
	self.rts_unloaded	= false;
	self.no_takeover 	= true;
	self DisableAimAssist();
	oldGrenadeAwareness = self.grenadeawareness;
	self.grenadeawareness 	= 0;
	
	self forceteleport( level.rts.karma_poi.origin,level.rts.karma_poi.angles);
	level.rts.karma_poi.karma_trigger = spawn("trigger_radius", level.rts.karma_poi.origin, 0, 48, 64);
	self.ai_ref = level.rts.ai["ai_spawner_karma"];
	self gun_remove();
	self allowedstances( "crouch" );
	level.rts.karma thread socotra_karma_magic_circle();
	
	// get karma ready for the rescue anim
	animAlignNode = Spawn( "script_origin", self.origin );
	animAlignNode.angles = self.angles;
	animAlignNode.targetname = "karma_loc";
	level thread run_scene_first_frame( "karma_rescue_karma" );

	// wait for the player to use the rescue trigger
	self thread karma_helpMe(self.origin,200);

	level thread maps\_so_rts_support::trigger_use(level.rts.karma_poi.karma_trigger,&"SO_RTS_MP_SOCOTRA_FREE_KARMA","socotra_karma_rescued");
	level waittill ("socotra_karma_rescued");

	level.rts.karma_poi.karma_trigger delete();	
	flag_set("block_input");
	maps\_so_rts_support::hide_player_hud();
	SetDvar("lui_enabled",0);
	level.rts.player EnableInvulnerability();
	level.rts.player.ignoreme = true;
	// play the karma rescue anim	
	level thread run_scene( "karma_rescue_player" );
	level thread run_scene( "karma_rescue_karma" );
	killzone = maps\_so_rts_support::createKillzone(level.rts.karma_poi.origin, 200, 64,"axis"); //I want to kill any motherF'kr who trys to get up on me while in this scene...
	
	// player's anim ends before karma's so free him sooner
	scene_wait( "karma_rescue_player" );
	flag_clear("block_input");
	
	scene_wait( "karma_rescue_karma" );
	animAlignNode Delete();
	maps\_so_rts_support::show_player_hud();
	SetDvar("lui_enabled",1);
	level.rts.player DisableInvulnerability();
	level.rts.player.ignoreme = false;
	killzone delete();
	
	pkg_ref = package_GetPackageByType("karma_pkg");
	ai_ref  = level.rts.ai["ai_spawner_karma"];
	level.rts.squads[squadID].no_nag = undefined;
	
	self.ai_ref			= ai_ref;
	self.health_max 	= ai_ref.health;
	self.goalradius 	= 512;
	self.accuracy 		= ai_ref.accuracy;
	self.pkg_ref		= pkg_ref;
	self maps\_so_rts_ai::set_actor_damage_override();
	self SetTeam("allies");
	self thread maps\_so_rts_ai::ai_DeathMonitor();
	self.initialized = true;
	self maps\_so_rts_ai::ai_postInitialize();
	
	self allowedstances( "crouch", "stand" );

	self.fixednode			= 0;
	self.goalradius 		= 128;
	self.grenadeawareness 	= oldGrenadeAwareness;
	self.ignoreme 			= true;
//	self.ignoreall 			= true;
	self.takedamage 		= true;
	self.health				= self.health_max;
	self.rts_unloaded		= false;
	self.selectable			= false;
    self.canFlank 			= false;     // The AI will attempt to move to flanking positions around the player
    self.aggressiveMode		= false;     // The AI will approach the player’s position, especially if he’s hiding.
    self.pathenemyfightdist = 0;
	self.dontmelee			= true;
	self.dontmeleeme		= true;
   	self.a.coverIdleOnly	= true;
   	self.maxsightdistsqrd	= 128*128;
   	self.ignoreSuppression	= true;
   	
	self gun_recall();
	self.state_machine thread set_state( "idle" );
	level notify ("KarmaUnderAIControl");
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

karma_idle()
{
	self endon( "death" );
	self endon( "change_state" );
 	self notify( "aiGoalEntity" );
    LUINotifyEvent( &"rts_protect_poi", 5, self getEntityNumber(), istring("SO_RTS_OBJ3D_RESCUE"),0,0,72 );
	wait 0.05;

	/#
		println(GetTime()+" karma_idle");
	#/



	self.fixednode 			= false;
   	self.maxsightdistsqrd	= 1024*1024;
	self.goalradius 		= 256;
	self.guyToFollow 		= undefined;
	node = self FindBestCoverNode();
	if (isDefineD(node))
	{
		self SetGoalNode(node);
	}

	while(1)
	{
		/#
			thread maps\_so_rts_support::debug_circle( self.origin, KARMA_DIST_THRESHOLD, (1,1,1), 20 );
		#/
	
		if(flag("fps_mode"))
		{
			distSQ = DistanceSquared(level.rts.player.origin,self.origin);
			if ( distSQ < KARMA_DIST_SQ_THRESHOLD )
			{
				self.guyToFollow = level.rts.player;
				break;
			}
			if (self canSee(level.rts.player) )
			{
				self.guyToFollow = level.rts.player;
				break;
			}
		}
	
		if(flag("rts_mode"))
		{
			squads = maps\_so_Rts_squad::getSquadsByType( "infantry", "allies" );
			foreach(squad in squads)
			{
				foreach (guy in squad.members)
				{
					if (!isDefined(guy))
						continue;
					if (guy == self )
						continue;
						
					distSQ = DistanceSquared(guy.origin,self.origin);
					if ( distSQ < KARMA_DIST_SQ_THRESHOLD )
					{
						self.guyToFollow = guy;
						break;
					}
				}
				
	
				if (isDefined(self.guyToFollow))
					break;
			}
			if (!isDefined(self.guyToFollow))
			{	
				foreach(squad in squads)
				{
					foreach (guy in squad.members)
					{
						if (!isDefined(guy))
							continue;
						if (guy == self )
							continue;
						if (self canSee(guy) )
						{
							self.guyToFollow = guy;
							break;
						}
					}
					if (isDefined(self.guyToFollow))
						break;
				}
			}
		}
		
		
		if (isDefined(self.guyToFollow))
			break;
			
		wait 1;
	}
	
	if( isDefined(self.guyToFollow))
	{
		self.state_machine thread set_state( "follow" );
	}
	else
	{
		self.state_machine thread set_state( "idle" );
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

karma_vtol()
{
	self endon( "death" );
	self endon( "change_state" );
	wait 0.05;
	self notify( "aiGoalEntity" );
	level notify("karmaAtSmoke");
	/#
		println(GetTime()+" karma_vtol");
	#/

   	self.maxsightdistsqrd	= 400*400;
	self.goalradius 		= 64;
	self.ignoreme			= 0;
	self.at_vtol			= 1;
	self setGoalPos(level.rts.outroLoc.origin);
	self waittill("goal");
	self setGoalPos(GetEnt("karma_smoke_hiding_spot","targetname").origin);
	self waittill("goal");
	self.fixednode 			= true;
	self allowedstances( "crouch" );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

karma_nearVtol()
{
	self endon("death");
	self endon( "change_state" );
	while(1)
	{
		if(isDefined(level.rts.outroLoc) )
		{
			distSQ = DistanceSquared(level.rts.outroLoc.origin,self.origin);
			if ( distSQ < KARMA_DISTVTOL_SQ_THRESHOLD )
			{
				break;
			}
		}
		/#
			thread maps\_so_rts_support::debug_circle( self.origin, KARMA_DISTVTOL_THRESHOLD, (1,1,0), 20 );
		#/
		wait 1;
	}
	self.state_machine thread set_state( "vtol" );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
karma_followPlayerWatcher()
{
	self endon( "death" );
	self endon( "change_state" );
	self notify("karma_followWatcher");
	self endon("karma_followWatcher");
	level waittill_any("switch_and_takeover","eye_in_the_sky","player_in_control");
	self.guyToFollow = undefined;
	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

karma_followAIWatcher()
{
	self endon( "death" );
	self endon( "change_state" );
	self notify("karma_followWatcher");
	self endon("karma_followWatcher");
	self.guyToFollow waittill_any("death","taken_control_over");
	self.guyToFollow = undefined;

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

karma_follow()
{
	self endon( "death" );
	self endon( "change_state" );
	self notify( "aiGoalEntity" );
	LUINotifyEvent( &"rts_protect_poi",5, self getEntityNumber(),istring("SO_RTS_OBJ3D_PROTECT"),0,0,72 );
	wait 0.05;

	self.fixednode = true;
	/#
		println(GetTime()+" karma_follow");
	#/

 
	if (!isDefined(self.guyToFollow))
	{
		self.state_machine thread set_state( "idle" );
		return;
	}
	
 	if ( self.guyToFollow == level.rts.player )
	{
		if(isDefined(level.rts.player.ally))
		{
			self.followSquadID = level.rts.player.ally.squadID;
			self thread karma_followPlayerWatcher();
		}
		else
		{
			self.state_machine thread set_state( "idle" );
			return;
		}
	}
	else
	{
		self.followSquadID = self.guyToFollow.squadID;
		self thread karma_followAIWatcher();
	}

	LUINotifyEvent( &"rts_karma_squad", 1, self.followSquadID );
	self thread karma_nearVtol();
	while(isDefined(self.guyToFollow))
	{
		distSQ = DistanceSquared(self.guyToFollow.origin,self.origin);//make a list of all the allies in my squad that are closeby
		if ( distSQ < KARMA_DIST_SQ_THRESHOLD )//if i am too far from who i am following, ignore everything and book it.
		{
			self.ignoreall = true;
		}
		else
		{
	 	 	self.maxsightdistsqrd	= 128*128;
			self.goalradius 		= 164;
			self.ignoreall			= false;
		}
		if(flag("fps_mode") && self.guyToFollow != level.rts.player )
		{
			distSQ = DistanceSquared(level.rts.player.origin,self.origin);//make a list of all the allies in my squad that are closeby
			if ( distSQ < KARMA_DIST_SQ_THRESHOLD || self canSee(level.rts.player) )
			{
				self.guyToFollow 	= level.rts.player;
				self.followSquadID 	= level.rts.player.ally.squadID;
				LUINotifyEvent( &"rts_karma_squad", 1, self.followSquadID );
				self thread karma_followPlayerWatcher();
			}
		}
		/#
			thread maps\_so_rts_support::debug_circle( self.origin, KARMA_DIST_THRESHOLD, (0,1,0), 3 );
			thread maps\_so_rts_support::debugLine( self.origin, self.guyToFollow.origin, (0,1,0), 3 );
		#/
		self SetGoalPos(self.guyToFollow.origin);
		self waittill_any_timeout(4,"goal");
/*
		if (isDefined(self.guyToFollow))
		{
			distSQ = DistanceSquared(self.guyToFollow.origin,self.origin);
			if ( distSQ >= (KARMA_DIST_SQ_THRESHOLD/2) )
			{
			  	self.maxsightdistsqrd	= 1;
			  	self.goalradius = 64;
				self SetGoalPos(self.guyToFollow.origin);
				self waittill_any_timeout(6,"goal");
			}
		}
		if (isDefined(self.guyToFollow))
		{
			distSQ = DistanceSquared(self.guyToFollow.origin,self.origin);
			if ( distSQ >= KARMA_DIST_SQ_THRESHOLD )
			{
			  	self.maxsightdistsqrd	= 1;
			  	self.goalradius = 64;
				self SetGoalPos(self.guyToFollow.origin);
				self waittill_any_timeout(6,"goal");
				self.guyToFollow = undefined;
			}
		}
*/		
		
		if (!isDefined(self.guyToFollow))
			break;
	}

	self.state_machine thread set_state( "idle" );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

socotra_karma_hackAllMechs()
{
	//maps\_so_rts_catalog::setPkgQty("quadrotor_pkg","axis",0);

	enemyMechs = maps\_so_rts_squad::getSquadsByType( "mechanized", "axis" );
	foreach(squad in enemyMechs)
	{
		ref = squad.pkg_ref.ref;

		if (ref == "btr_enemy_pkg")
			continue;
			
		newSquad = maps\_so_rts_squad::getSquadByPkg( ref, "allies" );
		if(!isDefined(newSquad))
		{
			maps\_so_rts_squad::createSquad(level.rts.karma.origin,"allies",	maps\_so_rts_catalog::package_GetPackageByType(ref) );
			newSquad = maps\_so_rts_squad::getSquadByPkg( ref, "allies" );
		}

		if (isDefined(newSquad.pkg_ref.hot_key_takeover) )
		{
			LUINotifyEvent( &"rts_add_squad", 3, newSquad.id, newSquad.pkg_ref.idx, 0 );
		}
		foreach(mech in squad.members)
		{
			mech maps\_so_rts_enemy::removeMeFromUnit();
			mech vehicle_set_team("allies");
			mech maps\_so_rts_squad::swapSquads(mech.squadID,newSquad.id);

			LUINotifyEvent( &"rts_add_friendly_ai", 3, mech GetEntityNumber(), newSquad.id, 0 );
			mech.grenadeawareness 	= 0;
			mech.fixedNode 			= false;
			mech.rts_unloaded 		= true;
			mech.selectable 		= true;
			mech.ignoreall			= false;
			mech.ignoreme			= false;
			mech.takedamage			= true;
			mech veh_magic_bullet_shield(false);
			mech maps\_vehicle::defend( mech.origin, 600 );
		}
		squad.members = [];
	}
	maps\_so_rts_catalog::setPkgQty("quadrotor_pkg","axis",0);
	maps\_so_rts_catalog::setPkgQty("quadrotor_pkg","allies",-1);
	squad = maps\_so_rts_squad::getSquadByPkg( "quadrotor_pkg", "allies" );
	maps\_so_rts_squad::OrderSquadDefend(level.rts.karma.origin,squad.id,true);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

socotra_rooftopCleanup()
{
	self endon("death");
	self.takedamage = false;
	level waittill ("KarmaUnderAIControl");
	self.takedamage = true;
	level waittill ("karmaAtSmoke");
	self thread maps\_so_rts_support::delay_kill(RandomInt(8));
}

socotra_rooftopDeath()
{
	forward = AnglesToForward(self.angles);
	self StartRagdoll();
	self LaunchRagdoll( VectorScale( forward, RandomIntRange(25,35) ), "tag_eye" );

	// make sure the AI gets killed
	self ragdoll_death();
}


socotra_rooftopInit(allRPG=false,favEnemy=undefined)
{
	rooftopLocs = array_randomize(GetStructArray("roofTopLoc","targetname"));
	enemyCount  = GetAIArray("axis");
	toSpawn 	= 12;
	locs  		= sortArrayByClosest(level.rts.karma.origin, rooftopLocs,2000*2000 );
	
	idx 		= -1;
	for(i = 0; i<toSpawn;i++)
	{
		idx++;
		if (idx>=locs.size)
			idx = 0;

		loc 	= locs[idx];
		
		if(allRPG == false )
		{
			roll 	= RandomInt(100);
			
			if ( roll<30 )
			{
				spawner = "ai_spawner_enemy_assault";
				ref 	= "infantry_enemy_reg_pkg";
			}
			else
			{
				spawner = "ai_spawner_enemy_rpg";
				ref 	= "infantry_enemy_rpg_pkg";
			}
		}
		else
		{
			spawner = "ai_spawner_enemy_rpg";
			ref 	= "infantry_enemy_rpg_pkg";
		}
		ai = simple_spawn_single( spawner, undefined, undefined, undefined, undefined, undefined, undefined, true);
		if (isDefined(ai))
		{
			ai maps\_so_rts_ai::ai_preInitialize(level.rts.ai[spawner],package_GetPackageByType(ref),ai.team,undefined);
			ai maps\_so_rts_ai::ai_initialize(level.rts.ai[spawner],ai.team,ai.origin,undefined,ai.angles,package_GetPackageByType(ref),ai.health);
			ai maps\_so_rts_ai::ai_postInitialize();
			ai forceteleport(loc.origin+(0,0,12),loc.angles);
			ai.goalradius 	= 64;
			ai.rts_unloaded = true;
			ai.deathFunction = ::socotra_rooftopDeath;
			ai maps\_so_rts_support::set_gpr(maps\_so_rts_support::make_gpr_opcode(GPR_OP_CODE_SET_TEAM) + (ai.team=="allies"?1:0) ); //for sonar coloration
			ai thread socotra_rooftopCleanup();
			if(isDefined(favEnemy))
			{
				ai SetTargetEntity(favEnemy);
				ai.favoriteenemy = favEnemy;
			}
			if(allRPG)
			{
				ai.secondaryweapon = "none";
				ai.secondaryweaponclass = "none";
			}
			/#
			println("#### Rooftop guy ("+ai.classname+") spawned in at " + loc.origin);
			#/
		}
	}

	maps\_so_rts_catalog::setPkgQty("infantry_enemy_elite_pkg","axis",-1); 
	maps\_so_rts_catalog::setPkgQty("infantry_enemy_reg_pkg","axis",-1);
	maps\_so_rts_catalog::setPkgQty("infantry_enemy_rpg_pkg","axis",-1);
	
	pkg_ref = maps\_so_rts_catalog::package_GetPackageByType("infantry_enemy_reg_pkg");
	pkg_ref.min_axis = 4;
	pkg_ref.max_axis = 7;
	pkg_ref = maps\_so_rts_catalog::package_GetPackageByType("infantry_enemy_elite_pkg");
	pkg_ref.min_axis = 3;
	pkg_ref.max_axis = 5;
	pkg_ref = maps\_so_rts_catalog::package_GetPackageByType("infantry_enemy_rpg_pkg");
	pkg_ref.min_axis = 2;
	pkg_ref.max_axis = 2;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

socotra_quad_spawn(squadID)
{
	i 			= 0;
	spawnLoc 	= ArrayCombine(GetStructArray("quad_spawn_loc","targetname"),GetStructArray("asd_spawn_loc","targetname"),false,false);
 	squad 		= level.rts.squads[squadID];
	foreach(quad in squad.members)
	{
		if (isDefined(quad))
		{
			quad.origin	 = spawnLoc[i].origin + (0,0,12);
			quad maps\_vehicle::defend( quad.origin, 128 );
			i++;
			if (i >= spawnLoc.size )
				i = 0;
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

enemy_proximityWatch()
{
	self endon("death");
	self endon("squad_unlock");
	while(1)
	{
		enemy = maps\_so_rts_support::getClosestAI(self.origin, "axis",256*256);
		if (isDefined(enemy))
		{
			self notify("squad_unlock");
			return;
		}
		wait 1;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

socotra_ally_release()
{
	self endon("death");
	wait 0.1;
	self.goalradius = 64;
	self.ignoreme	= true;
	self.ignoreall	= true;
	self.fixednode  = true;
	self allowedstances( "crouch" );
	self thread enemy_proximityWatch();
	
	msg = self waittill_any_array_return( array("new_squad_orders","damage","taken_control_over","squad_unlock"));
	self.goalradius = 512;
	self.ignoreme	= false;
	self.ignoreall	= false;
	self.fixednode	= false;
	self allowedstances( "crouch", "stand" );
	foreach(guy in level.rts.squads[self.squadID].members)
	{
		guy notify("squad_unlock");
	}
	if ( msg == "damage" )
	{
		level notify("rts_ally_damaged");
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


socotra_clock_expireWatch(expireNote)
{
	level endon("socotra_mission_complete");
	self waittill(expireNote);
	socotra_mission_complete_s1(false, true);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

socotra_reinforcementsKarmaFailSafe()
{
	level endon("socotra_mission_complete");
	level waittill_any("socotra_karma_rescued","reinforce_enemy"); 
	maps\_so_rts_catalog::setPkgQty("infantry_enemy_elite_pkg","axis",-1); //call in enemy troops
	maps\_so_rts_catalog::setPkgQty("infantry_enemy_reg_pkg","axis",-1);
	maps\_so_rts_catalog::setPkgQty("infantry_enemy_rpg_pkg","axis",-1);
	level.rts.game_rules.num_nag_squads = 5;
	maps\_so_RtS_support::time_countdown_delete();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotra_clock_think()
{
	level endon("socotra_mission_complete");
	animLen=GetAnimLength( %animated_props::v_sacotra_outro_vtol_flyin );
	
	level thread socotra_reinforcementsKarmaFailSafe();//in case, on the remote chance player rescues karma before taking damage....
	maps\_so_rts_support::time_countdown_delete();
	level thread maps\_so_rts_support::time_countdown(TIME_TO_UNTIL_ENEMY_REINFORCEMENTS,level,"kill_countdown","rts_time_left","reinforce_enemy","SO_RTS_MP_SOCOTRA_ENEMY_REINFORCEMENTS");//find Karma 2 minute timer
	flag_wait("vtol_on_route");

	/#
	println("VTOL Countdown starting at:"+GetTime()+" Fly up animlength:"+animLen);
	#/
	maps\_so_rts_support::time_countdown_delete();
	level thread maps\_so_rts_support::time_countdown(TIME_TO_REACH_VTOL,level,"kill_countdown","rts_time_left",undefined,"SO_RTS_MP_SOCOTRA_TIME_TO_VTOL");//defend Karma 90 second
	level thread maps\_so_rts_support::setFlagInNSec("vtol_start_anim",(TIME_TO_REACH_VTOL*60)-animLen);
	level thread maps\_so_rts_support::setFlagInNSec("vtol_objective_switch",(TIME_TO_SWITCH_OBJTO_VTOL*60));
	level thread socotra_outro_anim_prep( level.rts.outroLoc );
	
	flag_wait("vtol_arrived");
	level notify("vtol_has_arrived");
	maps\_so_rts_support::time_countdown_delete();
	level thread maps\_so_rts_support::time_countdown(TIME_TO_WAIT_FOR_VTOL,level,"kill_countdown","rts_time_left",undefined,"SO_RTS_MP_SOCOTRA_VTOL_LEAVE");//defend Karma 90 second
	wait (TIME_TO_WAIT_FOR_VTOL*60);
	flag_set("vtol_clearout");
	maps\_so_rts_support::time_countdown_delete();
}
//////////////////////////////////////////////////////////////////////////////////////////////////

socotra_level_ally_squad()
{
	allyStart = GetStruct("rts_ally_squad_heavy","targetname");
	assert(isDefineD(allyStart));

	squad = getSquadByPkg( "infantry_ally_heavy_pkg", "allies" );
	assert(isDefined(squad));
	maps\_so_rts_squad::OrderSquadDefend(allyStart.origin,squad.id,true);
	wait 1;
	
	i = 0;
	nodes = GetNodesInRadius( allyStart.origin, 800, 0, 128,"cover" );
	if(nodes.size>0)
	{
		foreach(guy in squad.members)
		{
			guy forceteleport(nodes[i].origin);
			guy setGoalNode(nodes[i]);
			guy thread socotra_ally_release();
			i++;
		}
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////
socotra_level_player_startFPS()
{
	playerStart = GetEnt("rts_player_start","targetname");
	assert(isDefineD(playerStart));
	nextSquad = maps\_so_rts_squad::getNextValidSquad(undefined);
	assert(nextSquad != -1, "should not be -1, player squad should be created");
	foreach(guy in level.rts.squads[nextSquad].members)
	{
		if (isDefined(guy))
		{
			guy.allow_OOB = true;
		}
	}
	
	level.rts.targetTeamMate =level.rts.squads[nextSquad].members[0];
	level.rts.targetTeamMate forceteleport(playerStart.origin,playerStart.angles);
	level thread maps\_so_rts_main::player_in_control();

	level waittill("switch_complete");
	level.rts.player setOrigin( playerStart.origin );
	level.rts.player setPlayerAngles( playerStart.angles );
	
//	maps\_so_rts_squad::OrderSquadDefend(playerStart.origin,nextSquad);
	flag_set("block_input");
	
	socotra_startIntro();
	flag_wait("intro_done");
	foreach(guy in level.rts.squads[nextSquad].members)
	{
		if (isDefined(guy))
		{
			guy.allow_OOB = undefined;
		}
	}

	level thread socotra_clock_think();

	level.rts.player.ignoreme = false;
	level.rts.player DisableInvulnerability();

	
	flag_clear("block_input");
}
//////////////////////////////////////////////////////////////////////////////////////////////////
socotra_startIntro()
{
	SetDvar("lui_enabled",0);
	level thread socotra_climbup_intro();	
	scene_wait( "intro_climbup_player" );
	SetDvar("lui_enabled",1);
	
	flag_set("intro_done");
}
//////////////////////////////////////////////////////////////////////////////////////////////////
socotra_startOutro( outroLoc )
{
	/*
	maps\_so_rts_catalog::setPkgQty("infantry_ally_outro_pkg","allies",1);
	maps\_so_rts_catalog::spawn_package("infantry_ally_outro_pkg", "allies",true, ::socotra_outro_guysSetup);
	wait 0.1;
	*/
	

	socotra_outro_anim( outroLoc );
	
	flag_set("outro_done");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

socotra_mission_complete_s1(success, goRTS,origin)
{
	level notify("socotra_mission_complete");

	Objective_State( level.OBJ_ESCORT, (success?"done":"failed") );

	if ( IS_TRUE(success))
	{
	}
	else
	{
		while(IS_TRUE(level.rts.switch_trans))
		{
			wait 0.05;
		}
		if ( flag("fps_mode") && goRTS )
		{
			if (isDefined(origin))
				level.rts.lastFPSpoint = origin;
			else
				level.rts.lastFPSpoint = level.rts.player.origin;
				
			level thread player_eyeInTheSky();
		}
		delay_thread( 1, maps\_so_rts_support::missionCompleteMsg, success );
		wait 10;
		level notify( "fade_mission_complete" );
	}
	
	//fade out the sound
	level clientnotify ("rts_fd");
	wait 1;
	screen_fade_out( 1 );
	SetDvar("lui_enabled","1");
	maps\_so_rts_support::toggle_damage_indicators(true);
	nextmission();
}
//////////////////////////////////////////////////////////////////////////////////////////////////
socotra_geo_changes()
{
	level thread populate_dying_bodies();
	level thread populate_dead_bodies();
}
//////////////////////////////////////////////////////////////////////////////////////////////////
populate_dying_bodies()
{
	dead_body_locs = GetStructArray( "dying_body", "targetname" );
	
	wait_for_first_player();
	
	// find the spawners
	male_spawner = GetEnt( "male_civ_spawner", "targetname" );
	assert( IsDefined( male_spawner ) );
	
	// set up the anim array
	level.scr_anim["male"]["death_anim"] 	= array( %generic_human::ai_gas_death_a,
	                                              	 %generic_human::ai_gas_death_b,
	                                              	 %generic_human::ai_gas_death_c,	                                              	 
	                                              	 %generic_human::ai_gas_death_d,
	                                              	 %generic_human::ai_gas_death_e,
	                                              	 %generic_human::ai_gas_death_f,
	                                              	 %generic_human::ai_gas_death_g,
	                                              	 %generic_human::ai_gas_death_h
	                                             	);
	
	level.rts.dying_civs = [];
	
	for( i=0; i < dead_body_locs.size; i++ )
	{
		loc = dead_body_locs[ i ];
		
		dead_civ = male_spawner spawn_drone();
		assert( IsDefined( dead_civ ) );
		
		dead_civ.animname = "male";
		dead_civ.origin = loc.origin;
		dead_civ.angles = loc.angles;
		
		/#
			RecordEnt( dead_civ );
		RecordLine( loc.origin, level.player.origin, (0,1,0), "Script" );
		#/
		
		// play a death pose anim
		dead_civ thread play_anim_on_civ( "death_anim" );
		
		level.rts.dying_civs[ level.rts.dying_civs.size ] = dead_civ;
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic_human" );
play_anim_on_civ( animName )
{
	death_anim = self get_anim( animName, self.animname);
	self AnimScripted( "anim_is_over", self.origin, self.angles, death_anim, "normal", %root, 1.0 );
	
	animLength = GetAnimLength( death_anim );
	wait( animLength * 0.9 );
	
	//self StartRagdoll();
}

//////////////////////////////////////////////////////////////////////////////////////////////////
populate_dead_bodies()
{
	dead_body_locs = GetStructArray( "dead_body", "targetname" );
	
	// find the spawners
	male_spawner = GetEnt( "male_civ_spawner", "targetname" );
	assert( IsDefined( male_spawner ) );
	
	female_spawner = GetEnt( "female_civ_spawner", "targetname" );
	assert( IsDefined( female_spawner ) );
	
	// set up the anim array
	level.scr_anim["male"]["death_pose"] 	= array( %generic_human::ch_gen_m_floor_armdown_legspread_onback_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armdown_onback_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armdown_onfront_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armrelaxed_onleftside_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armsopen_onback_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armspread_legaskew_onback_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armspread_legspread_onback_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armspreadwide_legspread_onback_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armstomach_onback_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armstomach_onrightside_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armstretched_onleftside_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armstretched_onrightside_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armup_legaskew_onfront_faceleft_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armup_legaskew_onfront_faceright_deathpose,
	                                              	 %generic_human::ch_gen_m_floor_armup_onfront_deathpose
	                                             	);
	
	level.scr_anim["female"]["death_pose"] 	= array( %generic_human::ch_gen_f_floor_onback_armstomach_legcurled_deathpose,
	                                              	 %generic_human::ch_gen_f_floor_onback_armup_legcurled_deathpose,
	                                              	 %generic_human::ch_gen_f_floor_onfront_armdown_legstraight_deathpose,
	                                              	 
	                                              	 %generic_human::ch_gen_f_floor_onfront_armup_legcurled_deathpose,
	                                              	 %generic_human::ch_gen_f_floor_onfront_armup_legstraight_deathpose,
	                                              	 %generic_human::ch_gen_f_floor_onleftside_armcurled_legcurled_deathpose,
	                                              	 %generic_human::ch_gen_f_floor_onleftside_armstretched_legcurled_deathpose,
	                                              	 %generic_human::ch_gen_f_floor_onrightside_armstomach_legcurled_deathpose,
	                                              	 %generic_human::ch_gen_f_floor_onrightside_armstretched_legcurled_deathpose
	                                             	);
	
	level.rts.dead_civs = [];
	
	for( i=0; i < dead_body_locs.size && i < MAX_DEAD_BODIES; i++ )
	{
		loc = dead_body_locs[ i ];
		
		dead_civ = undefined;
		male = RandomFloat(1) > 0.5;
		
		// spawn the model
		if( male )
		{
			dead_civ = male_spawner spawn_drone();
			assert( IsDefined( dead_civ ) );
			dead_civ.animname = "male";
		}
		else
		{
			dead_civ = female_spawner spawn_drone();
			assert( IsDefined( dead_civ ) );
			dead_civ.animname = "female";
		}
		
		dead_civ.origin = loc.origin;
		dead_civ.angles = loc.angles;
		
		// play a death pose anim
		// dead_civ thread anim_first_frame( dead_civ, "death_pose" );
		dead_civ thread play_anim_on_civ( "death_pose" );
		
		level.rts.dead_civs[ level.rts.dead_civs.size ] = dead_civ;
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////
socotra_level_scenario_one_registerEvents()
{
}
//////////////////////////////////////////////////////////////////////////////////////////////////
socotra_pick_safehouses()
{
	level.rts.max_poi_infantry = 5;
	closeSafeHouses 	= GetEntArray("safe_house_a","targetname");
	safeloc1			= closeSafeHouses[RandomInt(closeSafeHouses.size)];
	ArrayRemoveValue(closeSafeHouses,safeloc1);
	farSafeHouses		= GetEntArray("safe_house_b","targetname");
	safeloc2			= farSafeHouses[RandomInt(farSafeHouses.size)];
	ArrayRemoveValue(farSafeHouses,safeloc2);
	allSafeHouses		= ArrayCombine(closeSafeHouses,farSafeHouses, false, false);
	safeloc3			= allSafeHouses[RandomInt(allSafeHouses.size)];
	poiNames 			= array_randomize(array("rts_poi_search1","rts_poi_search2","rts_poi_search3"));

	safehouse1 			= Spawn( "script_model", safeloc1.origin, 1); // spawnflag for dynamicpath
	safehouse1.angles 	= safeloc1.angles;
	safehouse1.targetname = safeloc1.targetname;
	safehouse1.poi_ref	= poiNames[0];
	safehouse1.bldgID 	= safeloc1.script_parameters;
	
	safehouse2 			= Spawn( "script_model", safeloc2.origin, 1); // spawnflag for dynamicpath
	safehouse2.angles 	= safeloc2.angles;
	safehouse2.targetname = safeloc2.targetname;
	safehouse2.poi_ref	= poiNames[1];
	safehouse2.bldgID	= safeloc2.script_parameters;

	safehouse3 			= Spawn( "script_model", safeloc3.origin, 1); // spawnflag for dynamicpath
	safehouse3.angles 	= safeloc3.angles;
	safehouse3.targetname = safeloc3.targetname;
	safehouse3.poi_ref	= poiNames[2];
	safehouse3.bldgID 	= safeloc3.script_parameters;

	level.rts.safehouses= array(safehouse1,safehouse2,safehouse3);
	
	maps\_so_rts_poi::add_poi(poiNames[0],safehouse1,"axis",false);
	maps\_so_rts_poi::add_poi(poiNames[1],safehouse2,"axis",false);
	maps\_so_rts_poi::add_poi(poiNames[2],safehouse3,"axis",false);
	
	foreach(spot in level.rts.safehouses)
	{
		target 			= "mp_socotra_bldg_0"+spot.bldgID;
		spot.site  		= GetStruct(target,"targetname");
		spot.modelname 	= "p6_sf_socotra_bldg_"+spot.bldgID;
	}
	
	foreach(house in level.rts.safehouses)
	{
		house thread safehouse_CaptureWatch();
	}
}
safehouse_CaptureWatch()
{
	self waittill("taken_perm");
	ArrayRemoveValue(level.rts.safehouses,self);
	if(isDefined(self.bldg))
		self.bldg Delete();

	self Delete();
}


//////////////////////////////////////////////////////////////////////////////////////////////////
socotra_poi_Inf_spawn(squadID)
{
	foreach(guy in level.rts.squads[squadID].members)
	{
		guy.goalradius = 128;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
vehicle_set_team(team)
{
	self SetTeam(team);
	if (self.vehicleType == "heli_quadrotor_rts")
		self maps\_quadrotor::quadrotor_set_team( team );
	else
		self.vteam = team;
}
//////////////////////////////////////////////////////////////////////////////////////////////////
static_transition( player )
{
	level.player SetClientFlag( FLAG_CLIENT_FLAG_ALLY_SWITCH );
}
//////////////////////////////////////////////////////////////////////////////////////////////////
socotra_outro_anim_prep( alignNode )
{
	assert( IsDefined( alignNode ) );
	
	flag_wait("vtol_start_anim");
	/#
	println("VTOL animation starting at:"+GetTime());
	#/

	level.rts.heliModel = create_veh_model( level.rts.player.origin, "veh_t6_air_v78_vtol", "outro_heli" );
	level.rts.heliModel Show();
	
	level.rts.heliModel thread vtol_deathWatch();

	// temp until there's a ride in anim for the heli
	level thread run_scene( "outro_heli_flyin" );
	
	scene_wait( "outro_heli_flyin" );
	/#
	println("VTOL animation finished at:"+GetTime());
	#/
	flag_set("vtol_arrived");
}
//////////////////////////////////////////////////////////////////////////////////////////////////
socotra_outro_guysSetup(squadID)
{
	assert(level.rts.squads[squadID].members.size == 3); //add more spawners to pkg in .csv if more guys needed..
	level.rts.outro_squad = squadID;

	level.rts.outro_targetEnt 	= level.rts.squads[squadID].members[0];
	level.rts.outro_guy_1 		= level.rts.squads[squadID].members[1];
	level.rts.outro_guy_1.animname = "outro_guy1";
	level.rts.outro_guy_0 		= level.rts.squads[squadID].members[2];
	level.rts.outro_guy_0.animname = "outro_guy0";
	
	foreach(guy in level.rts.squads[squadID].members)
	{
		guy.takedamage = false;
		guy.ignoreme   = true;
		guy.ignoreall  = true;
		guy.allow_OOB  = true;
	}
	
	
	//move the guys to the right location/////
	
}
//////////////////////////////////////////////////////////////////////////////////////////////////
socotra_outro_anim( alignNode )
{
	level notify("karma_outro_begin");
	
	flag_set("block_input");
	SetDvar("lui_enabled",0);
	thread screen_fade_out( 0.2 );
	level.rts.player ClearClientFlag( FLAG_CLIENT_FLAG_RETICLE );
	level.rts.player maps\_so_rts_ai::restoreReplacement();	//unlink player if he's in vehicle
	//plahyer taking over a dude..
	level.rts.player EnableInvulnerability(); // so the player doesn't get killed by the hurt trigger in mp maps
	
	/*
	level clientnotify( "chr_swtch_start" );
	level.rts.player thread maps\_so_rts_support::do_switch_transition();
	level.rts.outro_targetEnt notify("taken_control_over");
	level waittill("switch_nearfullstatic");
	level.rts.player maps\_so_rts_ai::restoreReplacement(); 
	level.rts.targetTeamMate = level.rts.outro_targetEnt;
	level.rts.player unlink();
	level.rts.player maps\_so_rts_ai::takeOverSelected(level.rts.outro_targetEnt);
	level.rts.player showViewModel();
	level.rts.player enableweapons();
	*/
	
	level thread run_scene( "outro_player" );
	level thread run_scene( "outro_actors" );
	
	wait( 0.5 );
	thread screen_fade_in( 0.5 );

	scene_wait( "outro_player" );
//	level.rts.heliModel UseVehicle( level.rts.player, 1 );
//	origin	= GetEnt("air_support_start","targetname").origin;
//  level.rts.heliModel SetVehGoalPos(origin,true);
//	wait 10;

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

create_anim_model( pos, model_name, animname )
{
	model = Spawn( "script_model", pos );
	model SetModel( model_name );
	model.animname = animname;
	model Hide();
	return model;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#using_animtree( "player" );
create_player_model( pos, model_name, animname )
{
	model = create_anim_model( pos, model_name, animname );
	model UseAnimTree( #animtree );
	return model;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#using_animtree( "animated_props" );
create_prop_model( pos, model_name, animname )
{
	model = create_anim_model( pos, model_name, animname );
	model UseAnimTree( #animtree );
	return model;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#using_animtree( "vehicles" );
create_veh_model( pos, model_name, animname )
{
	model = create_anim_model( pos, model_name, animname );
	model UseAnimTree( #animtree );
	return model;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/#
socotra_setup_devgui()
{
	SetDvar( "cmd_skipto",				"" );
	
	AddDebugCommand( "devgui_cmd \"|RTS|/Socotra:10/Skipto:1/Defend:1\" \"cmd_skipto defend\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Socotra:10/Skipto:1/VTOL:2\" \"cmd_skipto vtol\"\n" );
	AddDebugCommand( "devgui_cmd \"|RTS|/Socotra:10/Skipto:1/Kill Karma:3\" \"cmd_skipto kill_karma\"\n" );
	
	level thread socotra_watch_devgui();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

socotra_watch_devgui()
{
	while(1)
	{
		cmd_skipto = GetDvar("cmd_skipto");
		
		if( cmd_skipto == "defend" )
		{
			level notify( "rts_player_damaged" );
			wait( 0.05 );
			level notify( "poi_captured_allies" );
			wait( 0.05 );
			level notify( "socotra_karma_rescued" );

			SetDvar( "cmd_skipto", "" );
		}
		else if( cmd_skipto == "vtol" )
		{
			level notify( "rts_player_damaged" );
			wait( 0.05 );
			level notify( "poi_captured_allies" );
			wait( 0.05 );
			level notify( "socotra_karma_rescued" );
			
			scene_wait( "karma_rescue_karma" );
			
			wait( 0.2 );
			
			level.player SetOrigin( level.rts.outroLoc.origin );
			forward = AnglesToForward( level.player.angles );
			level.rts.karma ForceTeleport( level.player.origin + VectorScale( forward, 20 ) );
			
			flag_wait("vtol_on_route");			
			wait( 2 );
			level notify("socotra_outro_anim_prep");

			SetDvar( "cmd_skipto", "" );
		}		
		else if( cmd_skipto == "kill_karma" )
		{
			if( IsDefined( level.rts.karma ) )
			{
				level.rts.karma DoDamage( 99999, level.rts.karma.origin );
			}
			else
			{
				allAI = GetAIArray( "allies" );
				if( allAI.size > 0 )
				{
					allAI[ 0 ].deathFunction = ::socotra_karma_death_camera;
					allAI[ 0 ] DoDamage( 99999, allAI[ 0 ].origin );
				}
			}
			
			SetDvar( "cmd_skipto", "" );
		}
		
		wait( 0.05 );
	}
}
#/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
socotra_SpawnMortraCrews()
{
	spots = array_randomize(GetStructArray("mortar_loc","targetname"));
	level.rts.mortars = [];
	
	foreach(spot in spots)
	{
		mortar = spawnstruct();
		level.rts.mortars[level.rts.mortars.size] = mortar;
		mortar.weapon = Spawn( "script_model", spot.origin );
		mortar.link   = Spawn( "script_model", spot.origin );
		mortar.weapon.angles = spot.angles;
		mortar.weapon SetModel("artillery_mortar_81mm_static");
		mortar.link SetModel("tag_origin");
		mortar.weapon maps\_so_rts_support::set_gpr(maps\_so_rts_support::make_gpr_opcode(GPR_OP_CODE_SET_TEAM) + 0 ); //for sonar coloration
		mortar.crew = [];
		numGuys = RandomIntRange(2,3);
		while(numGuys)
		{
			crewGuy = simple_spawn_single( "ai_spawner_enemy_assault", undefined, undefined, undefined, undefined, undefined, undefined, true);
			if(isDefined(crewGuy))
			{
				crewGuy.ignoreme = true;
				crewGuy.ignoreAll = true;
				crewGuy allowedstances( "crouch" );
				crewGuy LinkTo( mortar.link , "tag_origin", (RandomIntRange(32,64),RandomIntRange(32,64),0), ( 0, 0, 0 ) );
				//crewGuy ForceTeleport(spot.origin + );
				crewGuy maps\_so_rts_support::set_gpr(maps\_so_rts_support::make_gpr_opcode(GPR_OP_CODE_SET_TEAM) + 0 ); //for sonar coloration
				mortar.crew[mortar.crew.size] = crewGuy;
			}
			numGuys--;
		}
	
		level thread socotra_MortarThink(mortar);
	}
}
socotra_MortarThink(mortar)
{
	level endon("karma_outro_begin");
	level endon("socotra_mission_complete");
	level endon( "rts_terminated" );
	level.rts.karma endon("death");
	mortar.weapon endon("death");
	
	mortar.weapon.takedamage = true;
	mortar.weapon.health	 = 100;
	
	level thread socotra_MortarDamageWatch(mortar);
	
	while(isDefined(level.rts.activeMortar))
		wait 0.05;
		
	level.rts.activeMortar = mortar;

	//trigger some event dialog ...
	//:

	//add objective?
	//:
		
	while(1)
	{
		wait (RandomIntRange(5,10));
		//animation??
		//:
//		squad1 = getSquadByPkg( "infantry_ally_heavy_pkg", "allies" );
	//	squad2 = getSquadByPkg( "infantry_ally_reg_pkg", "allies" );
	//	a_ai_targets = ArrayCombine(squad1.members,squad2.members, false, false);
		a_ai_targets = GetStructArray( "mortar_target","targetname" );
		a_ai_targets = sortArrayByClosest(level.rts.karma.origin, a_ai_targets,1024*1024 );
		a_ai_targets = sortArrayByFurthest(level.rts.karma.origin, a_ai_targets,192*192 );
		if ( a_ai_targets.size > 0 )
		{
			a_ai_targets = array_randomize( a_ai_targets );
			targetLoc = a_ai_targets[0].origin;
			level thread socotra_mortarImpact( targetLoc );
		}
		/#
		foreach(node in a_ai_targets)
		{
			thread maps\_so_rts_support::debug_sphere( node.origin, 10, (0,1,0), 0.6, 20 );
		}
		#/
	}

}

socotra_MortarDamageWatch(mortar)
{
	level endon("karma_outro_begin");
	level endon("socotra_mission_complete");
	level endon( "rts_terminated" );
	while(1)
	{
		mortar.weapon waittill("damage", amount, attacker, vec, p, type);
		if ( attacker!= level.rts.player )
		{
			mortar.weapon.health = 100;
			continue;
		}

		if ( level.rts.player.ally.squadID != level.rts.vtol.squadID )
		{
			mortar.weapon.health = 100;
			continue;
		}
			
		PlayFX( level._effect[ "fx_mortar_explode" ], mortar.weapon.origin );
		RadiusDamage( mortar.weapon.origin, 400, 250, 200, undefined, "MOD_PROJECTILE" );
		ArrayRemoveValue(level.rts.mortars,mortar);
		if (isDefined(level.rts.activeMortar) && level.rts.activeMortar == mortar )
		{
			level.rts.activeMortar = undefined;
		}
	}
}

socotra_mortarImpact(v_target)
{
	playsoundatposition ( "prj_mortar_incoming", v_target );
	wait .45;
	PlayFX( level._effect[ "fx_mortar_explode" ], v_target );
	RadiusDamage( v_target, 400, 120, 100, undefined, "MOD_PROJECTILE" );
	Earthquake( 0.5, 1, v_target, 2000 );	
	Earthquake( 0.2, 1, level.rts.player.origin, 300 );	
	PlaySoundAtPosition( "exp_mortar", v_target );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



