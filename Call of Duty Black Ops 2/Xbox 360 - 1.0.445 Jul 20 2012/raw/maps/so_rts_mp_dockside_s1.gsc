#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_vehicle;
#include maps\_audio;
#include maps\_music;

#insert raw\maps\_so_rts.gsh;
#insert raw\maps\_scene.gsh;
//////////////////////////////////////////////////////////////////////////////////////////////////
///SCENARIO 1
//////////////////////////////////////////////////////////////////////////////////////////////////

precache()
{
	level._effect[ "missile_explosion" ] 	   	= LoadFx( "explosions/fx_exp_war_rocket_air_death" );
	level._effect[ "missile_exhaust" ] 		  	= LoadFx( "weapon/rocket/fx_rocket_war_exhaust" );
	level._effect[ "missile_launch" ] 		  	= LoadFx( "weapon/rocket/fx_rocket_war_smoke_kickup" );
	level._effect[ "sam_missile_explosion" ] 	= LoadFx( "explosions/fx_war_exp_sam_air" );
	level._effect[ "boat_explosion_xlg" ]		= LoadFx( "explosions/fx_war_exp_ship_fireball_xlg" );
	level._effect[ "boat_explosion_lg" ]		= LoadFx( "explosions/fx_war_exp_ship_fireball_lg" );
	level._effect[ "boat_water" ]				= LoadFx( "water/fx_war_water_cargo_ship_sink" );
	level._effect[ "heli_light" ]				= LoadFx( "light/fx_war_light_interior_blackhawk" );
	level._effect[ "laser_turret_light_green" ]	= LoadFx( "light/fx_war_light_laser_turret_grn" );
	level._effect[ "laser_turret_light_red" ]	= LoadFx( "light/fx_war_light_laser_turret_red" );
	level._effect[ "laser_turret_disabled" ]	= LoadFx( "electrical/fx_war_laser_turret_disabled" );
	level._effect[ "water_splash_tall" ]		= LoadFx( "water/fx_war_water_cargo_hit_tall" );
	level._effect[ "water_splash_wide" ]		= LoadFx( "water/fx_war_water_cargo_hit_wide" );
	level._effect[ "predator_trail" ]			= LoadFX( "weapon/predator/fx_predator_trail" );
	level._effect[ "boat_fire" ]				= LoadFX( "fire/fx_war_ship_fire_billow_lg" );
	level._effect[ "sniper_glint" ] 			= LoadFX( "misc/fx_misc_sniper_scope_glint" );
	level._effect[ "base_fire" ]		  		= loadfx("env/fire/fx_fire_md");
	level._effect[ "base_hurt" ]		 		= loadfx("explosions/fx_default_explosion");
	level._effect[ "base_blow" ] 				= loadfx("explosions/fx_airlift_explosion_large");
	level._effect[ "network_intruder_death" ] 	= loadfx("explosions/fx_exp_equipment");
	level._effect[ "network_intruder_blink" ] 	= loadfx("misc/fx_equip_light_green");
	level._effect[ "missile_reticle" ]			= LoadFx( "misc/fx_reticle_war_missile_target" );
	
	PrecacheModel( "p6_boat_cargo_ship_singapore");
	PrecacheModel( "veh_t6_missile_truck");
	PrecacheModel( "veh_t6_missile_truck_missile");
	PrecacheModel( "T6_wpn_turret_sam_larger");
	PrecacheModel( "com_ammo_pallet");
	PrecacheModel( "fxanim_war_sing_cargo_ship_sink_mod" );
	PrecacheModel( "fxanim_war_sing_rappel_rope_01_mod" );
	PrecacheModel( "fxanim_war_sing_rappel_rope_02_mod" );
	PrecacheModel( "t6_wpn_turret_sentry_gun");
	PrecacheModel( "t5_weapon_sam_turret_detect" );


	PrecacheShader( "hud_icon_helicopter" ); // 
	PrecacheShader( "compass_a10" ); // 
	
	// models
	PrecacheModel( "t6_wpn_hacking_device_world");
	PrecacheModel( "p6_ammo_resupply_01");
	PrecacheModel( "fxanim_gp_vtol_drop_asd_drone_mod");
	PrecacheModel( "fxanim_gp_vtol_drop_claw_mod");	

	PrecacheItem("smaw_sp");
	PrecacheItem( "remote_missile_missile_rts" );
	PrecacheItem( "tow_turret_sp" );
	level.remote_missile_type = "remote_missile_missile_rts";


    maps\_quadrotor::init();
    maps\_metal_storm::init();
    maps\_claw::init();
	
}
//////////////////////////////////////////////////////////////////////////////////////////////////

dockside_level_scenario_one()
{

	flag_init("airstrike_avail");

	//overrides default introscreen function
	level.custom_introscreen = maps\_so_rts_support::custom_introscreen;
	intro_fastrope_scene();

	flag_set("block_input");
	maps\_so_rts_rules::set_GameMode("attack");//game type attack
	flag_wait( "start_rts" );
	dockside_level_scenario_one_registerEvents();
	dockside_geo_changes();

	assert(isDefined(level.rts.enemy_base) && isDefined(level.rts.enemy_base.entity),"enemy base not defined");
	level.rts.enemy_base.entity thread dockside_EnemyBaseWatch();


	maps\_so_rts_catalog::package_select("infantry_ally_reg_pkg",true,::dockside_level_player_startFPS);
	maps\_so_rts_catalog::spawn_package( "infantry_enemy_reg_pkg", "axis", true, maps\_so_rts_enemy::order_new_squad );
	maps\_so_rts_catalog::spawn_package( "infantry_enemy_reg_pkg", "axis", true, maps\_so_rts_enemy::order_new_squad );
	bigDogSquadID = maps\_so_rts_catalog::spawn_package( "bigdog_pkg", "axis", true, ::docksdie_order_to_samsite );

	maps\_so_rts_catalog::setPkgQty("infantry_ally_reg_pkg","allies",0);
	maps\_so_rts_catalog::setPkgQty("quadrotor_pkg","allies",0);
	maps\_so_rts_catalog::setPkgQty("metalstorm_pkg","allies",0);
	maps\_so_rts_catalog::setPkgQty("bigdog_pkg","allies",0);

	
	//terminate bigDog's redeploy orders
	level notify("redeploy_on_poi_takeover"+bigDogSquadID);
	level thread dockside_level_waitforPOINotify();

	flag_set("rts_event_ready");
	maps\_so_rts_event::trigger_event("main_music_state");
	if ( maps\_so_rts_event::trigger_event("intro_dlg_01") ) 	//10 seconds out
		level waittill("intro_dlg_01_done");
	wait 0.4;
	if ( maps\_so_rts_event::trigger_event("intro_dlg_02"))	//approaching insertion point
		level waittill("intro_dlg_02_done");
	maps\_so_rts_event::trigger_event("intro_dlg_04");  //kick ropes, prep to deploy
	exploder( 99 );  // barry's awesome rotor wash
	if (maps\_so_rts_event::trigger_event("intro_dlg_04b"))	//here we go
	if (maps\_so_rts_event::trigger_event("intro_dlg_03"))  //lz is clear, mission is a go
		level waittill("intro_dlg_03_done");
	maps\_so_rts_event::trigger_event("intro_dlg_04d"); //all eagles out the door
	maps\_so_rts_event::trigger_event("intro_dlg_04e"); //go go go


	docksdie_level_create_turrets();
	level waittill("intro_dlg_04e_done");
	wait 3;
	level.rts.player VisionSetNaked( "sp_singapore_default", 2 );
	level.rts.player depth_of_field_off( 2 );
	wait .2;
	maps\_so_rts_event::trigger_event("intro_dlg_04c"); //on me
}


//////////////////////////////////////////////////////////////////////////////////////////////////
dockside_level_player_startFPS()
{
	nextSquad = maps\_so_rts_squad::getNextValidSquad(undefined);
	assert(nextSquad != -1, "should not be -1, player squad should be created");
	level.rts.targetTeamMate =level.rts.squads[nextSquad].members[0];
	level.rts.targetTeamMate forceteleport(level.rts.player.origin,level.rts.player.angles);
	maps\_so_rts_main::player_in_control();
	flag_set("block_input");
	level.rts.player thread player_waitfor_vehicleEntry();

	level.rts.player GiveWeapon( "metalstorm_mms_rts" );
	level.rts.player TakeWeapon( "kard_sp" );


	level thread maps\_so_rts_support::flag_set_inNSeconds("start_rts_enemy",8);
	level thread dockside_fastrope_intro();	
	scene_wait( "intro_fastrope_player" );
	level.rts.player.ignoreme = false;
	level.rts.player DisableInvulnerability();
	flag_clear("block_input");
	flag_set("rts_start_clock");
	
	maps\_so_rts_event::trigger_event("intro_dlg_05");
	maps\_so_rts_event::trigger_event("intro_dlg_onground");
	maps\_so_rts_catalog::setPkgQty("infantry_ally_reg_pkg","allies",-1);
	
	/////////////////////////////////////////////////////////////////
	//// Time Estimation from start location to unload node + an estimation for return trip time
	startLoc 	= maps\_so_rts_support::get_transport_startLoc( maps\_so_rts_ai::get_package_drop_target( "allies" ) );
	lastNode 	= startLoc;
	unloadNode 	= undefined;
	while ( isdefined( lastNode.target ) )
	{
		if ( !isDefined(unloadNode) && isdefined( lastNode.script_unload ) )
		{
			unloadNode = lastNode;
		}
		
		lastNode = GetVehicleNode( lastNode.target, "targetname" );
	}
	timeBack 	= GetTimeFromVehicleNodeToNode( unloadNode, lastNode )*1000 + level.rts.transport_refuel_delay;
	timeToZone	= GetTimeFromVehicleNodeToNode( startLoc, unloadNode )*1000;
	/////////////////////////////////////////////////////////////////
	
	/////////////////////////////////////////////////////////////////
	//bring in metalstorm
	pkg_ref = maps\_so_rts_catalog::package_GetPackageByType("metalstorm_pkg");	
	timeTo 		= timeToZone + pkg_ref.cost["allies"];	
	timeTo		= timeTo/1000;
	timeWait	= 30 - timeTo;
	if (timeWait>0)
		wait timeWait;
	maps\_so_rts_catalog::setPkgQty("metalstorm_pkg","allies",1);
	maps\_so_rts_catalog::setPkgDependancyEnforcement("metalstorm_pkg","allies",false);
	level waittill("friendly_unit_spawned_metalstorm_pkg");
	wait timeTo;
	maps\_so_rts_catalog::setPkgQty("metalstorm_pkg","allies",-1);
	/////////////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////////////
	//bring in bigdog
	pkg_ref = maps\_so_rts_catalog::package_GetPackageByType("bigdog_pkg");	
	timeTo 		= timeToZone + pkg_ref.cost["allies"];	
	timeTo		= timeTo/1000;
	
	timeWait	= 30 - timeTo;
	if (timeWait>0)
		wait timeWait;
	maps\_so_rts_catalog::setPkgQty("bigdog_pkg","allies",1);
	maps\_so_rts_catalog::setPkgDependancyEnforcement("bigdog_pkg","allies",false);
	level waittill("friendly_unit_spawned_bigdog_pkg");
	wait timeTo;
	maps\_so_rts_catalog::setPkgQty("bigdog_pkg","allies",-1);

	/////////////////////////////////////////////////////////////////
	//bring in quads
	pkg_ref 	= maps\_so_rts_catalog::package_GetPackageByType("quadrotor_pkg");	
	timeTo 		= timeToZone + pkg_ref.cost["allies"];	
	timeTo		= timeTo/1000;
	timeWait	= 30 - timeTo;
	if (timeWait>0)
		wait timeWait;
	maps\_so_rts_catalog::setPkgQty("quadrotor_pkg","allies",1);
	maps\_so_rts_catalog::setPkgDependancyEnforcement("quadrotor_pkg","allies",false);
	level waittill("friendly_unit_spawned_quadrotor_pkg");
	wait timeTo;
	maps\_so_rts_catalog::setPkgQty("quadrotor_pkg","allies",-1);
	/////////////////////////////////////////////////////////////////

//	wait timeBack/1000;

}
//////////////////////////////////////////////////////////////////////////////////////////////////

intro_fastrope_scene()
{
	add_scene( "intro_fastrope_player", "sing_fastrope" );	
	add_player_anim( "player_body", %player::p_intro_wm_fastrope_player, true, 0, undefined, true, 1, 15, 15, 15, 15 );		
	add_notetrack_custom_function( "player_body", "start_fade_up", ::level_fade_in );
	
	add_scene( "intro_fastrope_heli", "sing_fastrope" );
	add_prop_anim( "fastrope_blackhawk", %animated_props::v_intro_wp_fastrope_blackhawk, undefined, true );
	
	add_scene( "intro_fastrope_squad_1", "sing_fastrope" );	
	add_actor_anim( "guy0", %generic_human::ch_intro_wm_fastrope_guy1 );
	
	add_scene( "intro_fastrope_squad_2", "sing_fastrope" );	
	add_actor_anim( "guy1", %generic_human::ch_intro_wm_fastrope_guy2 );
	
	add_scene( "intro_fastrope_squad_3", "sing_fastrope" );	
	add_actor_anim( "guy2", %generic_human::ch_intro_wm_fastrope_guy3 );

	precache_assets();
}

level_fade_in( player )
{
	screen_fade_in(0.5);
}
//////////////////////////////////////////////////////////////////////////////////////////////////
dockside_fastrope_intro() 
{
	maps\_so_rts_squad::removeDeadFromSquad(0);
	assert(level.rts.squads[0].members.size>=3,"Not enough guys around");
	
	//ending vision set and DOF
	n_near_start = 0;
	n_near_end = 5;
	n_far_start = 270;
	n_far_end = 900;
	n_near_blur = 6;
	n_far_blur = 2;
	n_time = 0.2;
	level.rts.player VisionSetNaked( "sp_singapore_intro", 0 );
	level.rts.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
	
	vh_heli = Spawn( "script_model", (0,0,0) );
	vh_heli SetModel( "Veh_iw_air_blackhawk" );
	vh_heli.script_animname = "fastrope_blackhawk";
	maps\_so_rts_event::trigger_event("heli_light",vh_heli);
	//vh_heli Rpc( "clientscripts/_helicopter_sounds", "start_helicopter_sounds_wrapper" );
	vh_heli HidePart( "tag_tail_rotor_static" );
	vh_heli HidePart( "tag_main_rotor_static" );
	vh_heli SetClientFlag(FLAG_CLIENT_FLAG_MAKE_FAKE_BLACKHAWK);
	
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
	
	level.rts.intro_rope_l = Spawn( "script_model", vh_heli.origin );
	level.rts.intro_rope_l SetModel( "fxanim_war_sing_rappel_rope_01_mod" );
	level.rts.intro_rope_l LinkTo( vh_heli, "tag_origin" );
	
	level.rts.intro_rope_r = Spawn( "script_model", vh_heli.origin );
	level.rts.intro_rope_r SetModel( "fxanim_war_sing_rappel_rope_02_mod" );
	level.rts.intro_rope_r LinkTo( vh_heli, "tag_origin" );

	level thread rope_l();
	level thread rope_r();
	
	level thread run_scene( "intro_fastrope_player" );
	level thread run_scene( "intro_fastrope_heli" );
	level thread run_scene( "intro_fastrope_squad_1" );
	level thread run_scene( "intro_fastrope_squad_2" );
	level thread run_scene( "intro_fastrope_squad_3" );
	scene_wait( "intro_fastrope_player" );
	
	level.rts.intro_rope_r Delete();
	level.rts.intro_rope_l Delete();
		
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

dockside_mission_complete_s1(success,baseJustLost)
{
	screen_fade_out(0);
		
	if (IS_TRUE(baseJustLost) )
	{
		maps\_so_rts_event::trigger_event("base_died");
		//player lost his base... go into locked FPS mode
		//thread maps\_so_rts_main::fps_OnlyMode("airstrike_pkg");  //allow airstrike pkg to be selectable
		return;
	}
	level notify("mission_complete",success);
	level.rts.game_success = success;

	if (IS_TRUE(success))
	{
		SetDvar("lui_enabled",0);
		level.rts.player ClearClientFlag( FLAG_CLIENT_FLAG_RETICLE );
		// framing
		level.rts.player waittill( "remotemissile_done" );
		maps\_so_rts_event::event_clearAll(EVENT_TYPE_DIALOG);
		maps\_so_rts_event::trigger_event("airstrike_hit_confirm");
		maps\_so_rts_event::trigger_event("infantry_rtb");
		maps\_so_rts_event::trigger_event("mission_win_sfx");
		flag_clear("rts_event_ready"); //don't allow any more dialog in the queue
		
		level.rts.player thread maps\_so_rts_ai::restoreReplacement();
		level.rts.player Unlink();
		
		view_location = GetStruct( "end_view_location", "targetname" );	
		boat_location = GetStruct( "boat_location", "targetname" );
		
		toBoat = boat_location.origin - view_location.origin;
		view_angles = VectorToAngles( toBoat );
		
		boat_location_ent = spawn_model( "tag_origin", boat_location.origin, boat_location.angles );
		view_location_ent = spawn_model( "tag_origin", view_location.origin, view_angles );
		
		level.rts.player SetOrigin( view_location.origin );
		level.rts.player SetPlayerAngles( view_angles );
		level.rts.player PlayerLinkToAbsolute( view_location_ent, "tag_origin" );
		level.rts.player FreezeControls( true );
		
		level.rts.player set_ignoreme( true );
		level.rts.player hide_hud();
		level.rts.player EnableInvulnerability(); // so the player doesn't get killed by the hurt trigger in mp maps
		level.rts.player HideViewModel();	
		
		//ending vision set and DOF
		n_near_start 	= 0;
		n_near_end 		= 1000;
		n_far_start 	= 8200;
		n_far_end 		= 20000;
		n_near_blur 	= 6;
		n_far_blur		= 1.8;
		n_time			= 0.2;
		level.rts.player VisionSetNaked( "sp_singapore_end", 0 );
		level.rts.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time );
					
		view_location_ent LinkTo( boat_location_ent );
		boat_location_ent RotateYaw( -30, 25 );
		
		// play the big anim and fx
		thread boat_ending();
	}
	else
	{
		delay_thread( 6, maps\_so_rts_support::missionCompleteMsg, success );
	}
	
	level thread screen_fade_in( 0.5 );
	
	wait 16;
	level notify( "fade_mission_complete" );
	//fade out the sound
	level clientnotify ("rts_fd");
	wait 1;
	
	screen_fade_out( 1 );
	SetDvar("lui_enabled","1");
	maps\_so_rts_support::toggle_damage_indicators(true);
	
	nextmission();
}
//////////////////////////////////////////////////////////////////////////////////////////////////
airstrike_HudMsgPulse(msg)
{
	level endon("fire_missile");
	while(isDefined(msg))
	{
		msg FadeOverTime( 1 );
		msg.color 	= ( 1.0, 1.0, .5 );
		msg.alpha 	= 1;

		wait 1;

		msg FadeOverTime( 1 );
		msg.color 	= ( 1.0, 1.0, 1.0 );
		msg.alpha 	= 0.5;

		wait 1;

	}
}

airstrike_HudMsg()
{
	if(!IS_TRUE(level.rts.remotemissile))
	{
		//default game over handler.
		level.rts.missile_msg 	= NewHudElem();
		if (!isDefined(level.rts.missile_msg))
			return;
			
		level.rts.missile_msg.alignX 			= "center";
		level.rts.missile_msg.alignY 			= "middle";
		level.rts.missile_msg.horzAlign			= "center";
		level.rts.missile_msg.vertAlign			= "middle";
		level.rts.missile_msg.y 	 	   	   -= 160;
		level.rts.missile_msg.foreground 		= true;
		level.rts.missile_msg.fontScale 		= 2;
		level.rts.missile_msg.color 			= ( 1.0, 1.0, 1.0 );
		level.rts.missile_msg.hidewheninmenu	= false;
		level.rts.missile_msg.alpha 			= 0;
		level.rts.missile_msg SetText( &"SO_RTS_AIRSTRIKE_AVAIL" );
		level.rts.missile_msg FadeOverTime( 1 );
		level.rts.missile_msg.alpha 			= 1;
		level thread airstrike_HudMsgPulse(level.rts.missile_msg);
		level waittill("fire_missile");
	}
	if ( isDefined(level.rts.missile_msg))
	{
		level.rts.missile_msg maps\_hud_util::destroyElem();
		level.rts.missile_msg = undefined;
	}
}

dockside_airStrikeGo()
{
	level endon( "rts_terminated" );
	level endon( "mission_control_abort");

	if (IS_TRUE(level.dockside_airStrikeMsg))
		return;

	level.dockside_airStrikeMsg = true;

	LUINotifyEvent( &"rts_airstrike_avail_in", 1, 0 );  //zero should turn this control off
	if ( maps\_so_rts_event::trigger_event("airstrike_ready") )
	{
		level waittill("airstrike_ready_done");
	}

	wait 1;
	if ( maps\_so_rts_event::trigger_event("dlg_easy_rhino") )
	{
		level waittill("dlg_easy_rhino_done");
	}


	level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_AIRSTRIKE_AVAIL");
	level thread airstrike_HudMsg();
	
	flag_set("airstrike_avail");
	level waittill("fire_missile");

	maps\_so_rts_event::event_clearAll(EVENT_TYPE_DIALOG);
	maps\_so_rts_event::trigger_event("airstrike_inc");
	level.dockside_airStrikeMsg = undefined;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
dockside_level_waitforPOIFailNotify()
{
	level endon( "rts_terminated" );
	while(1)
	{
		level waittill("poi_nolonger_contested",entity);
		which = maps\_so_rts_poi::isPOIEnt(entity);
		if (isDefined(which))
		{
			if ( which == "rts_poi_hellads1" || which == "rts_poi_hellads2" )
			{
				maps\_so_rts_event::trigger_event("hellads_hack_fail");
			}
			else
			if ( which == "rts_poi_df21" )
			{
				maps\_so_rts_event::trigger_event("missile_hack_fail");
			}
		}
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////

dockside_mission_control_abort()
{
	level endon( "rts_terminated" );
	while(1)
	{
		level waittill("mission_complete",success);
		if (IS_TRUE(success))
		{	
			if ( isDefined(level.rts.missile_msg))
			{
				level.rts.missile_msg maps\_hud_util::destroyElem();
				level.rts.missile_msg = undefined;
				level.dockside_airStrikeMsg = undefined;
			}
			level notify("mission_control_abort");
			return;
		}
	}
}
dockside_missile_control()
{
	level endon( "rts_terminated" );
	level endon( "mission_control_abort");
	strike_pkg = maps\_so_rts_catalog::package_GetPackageByType("airstrike_pkg");

	flag_set("airstrike_avail");

	while(!flag("rts_game_over"))
	{
		packages_avail = maps\_so_rts_catalog::package_generateAvailable(level.rts.player.team);		
		if (IsInArray(packages_avail,strike_pkg) && strike_pkg.selectable)
		{
			flag_clear("airstrike_avail");
			level thread dockside_airStrikeGo();
			level waittill("fire_missile_done");
			if ( !flag("rts_game_over") )
			{
				LUINotifyEvent( &"rts_airstrike_avail_in", 1, int(strike_pkg.cost["allies"]/1000) );  //cost is in seconds
			}
			wait (int(strike_pkg.cost["allies"]/1000));
		}
		wait 0.05;
	}
}

dockside_level_waitforPOINotify()
{
	level endon( "rts_terminated" );
	level thread dockside_level_waitforPOIFailNotify();
	
	poiCaps = 0;
	while(1)
	{
		level waittill("poi_captured_allies",which);
		

		if (isDefined(which))
		{
			if ( which == "rts_poi_hellads1" )
			{
				if ( isDefined(getPOIByRef("rts_poi_hellads2")) )
				{
					maps\_so_rts_event::trigger_event("hellads1_hacked");
				}
				else
				{
					maps\_so_rts_event::trigger_event("hellads2_hacked");
				}
			}
			else
			if ( which == "rts_poi_hellads2" )
			{
				if ( isDefined(getPOIByRef("rts_poi_hellads1")) )
				{
					maps\_so_rts_event::trigger_event("hellads1_hacked");
				}
				else
				{
					maps\_so_rts_event::trigger_event("hellads2_hacked");
				}
			}
			else
			if ( which == "rts_poi_df21" )
			{
				maps\_so_rts_event::trigger_event("missile_hacked");
			}
		}
		
		poiCaps++;
		println("POI CAP:"+poiCaps);
		switch(poiCaps)
		{
			case 3:
				level thread dockside_missile_control();
				break;
			case 2:
				//level.rts.blockFastDelivery = true;
				//what pkgs are available....
				packages_avail = maps\_so_rts_catalog::package_generateAvailable( "allies",true );
				for(i=0;i<packages_avail.size;i++)
				{
					if ( packages_avail[i].ref == "metalstorm_pkg")
					{
						packages_avail[i].min_friendly = 3;
						packages_avail[i].max_friendly = 3;
						break;
					}
				}
			break;
			case 1:
			break;
		}
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////

docksdie_level_create_turrets()
{
	turretOrigins = getEntArray("turret_loc_friendly","targetname");
	foreach(tur in turretOrigins)
	{
		if (isDefined(tur.script_noteworthy))
			model = tur.script_noteworthy;
		else
			model = "t5_weapon_minigun_turret";
		turret = spawnTurret( "auto_turret", tur.origin, "auto_gun_turret_sp" );
		turret.turretType = "sentry";
		turret SetTurretType(turret.turretType);
		turret SetModel( model );
		turret.angles = tur.angles;
		turret setturretteam( "allies" );
		turret.team = "allies";
		turret.health = 1000;
		turret thread maps\sp_killstreaks\_turret_killstreak::burst_fire_unmanned();
		turret SetMode( "auto_nonai","scan" );
		turret MakeUnusable();
		turret maps\_so_rts_support::set_as_target( "allies" );
		tur delete();
	}
/*
	turretOrigins = getEntArray("turret_loc_enemy","targetname");
	foreach(tur in turretOrigins)
	{
		turret = spawnTurret( "auto_turret", tur.origin, "auto_gun_turret_sp" );
		turret.turretType = "sentry";
		turret SetTurretType(turret.turretType);
		turret SetModel( "t5_weapon_minigun_turret" );
		turret.angles = tur.angles;
		turret setturretteam( "axis" );
		turret.team = "axis";
		turret.health = 1000;
		turret thread maps\sp_killstreaks\_turret_killstreak::burst_fire_unmanned();
		turret SetMode( "auto_nonai","scan" );
		tur delete();
	}
*/	
}
//////////////////////////////////////////////////////////////////////////////////////////////////

dockside_geo_changes()
{
	// remove the gates connecting to the auxiliary RTS area
	gateBrushes = GetEntArray( "rts_gate", "script_noteworthy" );	
	foreach( brush in gateBrushes )
	{
		brush ConnectPaths();
		brush Delete();
	}
	
	// spawn boat and anim rig
	if( IsDefined(level.rts.enemy_base) && IsDefined(level.rts.enemy_base.entity) )
	{		
		boatAnimRig = Spawn( "script_model", (-300, -2100, 900), 0 );
		//boatAnimRig.angles = boat_location.angles;
		boatAnimRig SetModel( "fxanim_war_sing_cargo_ship_sink_mod" );
		
		// link the boat to the anim rig
		level.rts.enemy_base.entity.origin = boatAnimRig GetTagOrigin( "cargo_ship_jnt" );
		level.rts.enemy_base.entity.angles = boatAnimRig GetTagAngles( "cargo_ship_jnt" );
		
		level.rts.enemy_base.entity LinkTo( boatAnimRig, "cargo_ship_jnt" );
		level.rts.enemy_base.entity.animRig = boatAnimRig;
	}
	
	// remove the three middle crates
	crates = GetEntArray( "crate", "targetname" );

	foreach( crate in crates )
	{
		crate Delete();
	}
	
	// remove the crate that will be replaced by the laser turret
	crate = GetEnt( "rts_crate_off", "targetname" );
	if( IsDefined( crate ) )
		crate Delete();
	
	// disable cover nodes around the laser turret for now
	turretLocation = GetEnt( "rts_poi_hellads1", "targetname" );
	coverNodes = GetCoverNodeArray( turretLocation.origin, 256 );
	foreach( node in coverNodes )
	{
		SetEnableNode( node, false );
	}
	
	// add the sam launchers on the boat
	sam_locations = GetStructArray( "sam_launcher_location", "targetname" );
	foreach( loc in sam_locations )
	{
		turret = spawnTurret( "auto_turret", loc.origin, "tow_turret_sp" );
		turret.turretType = "tow";
		turret SetTurretType(turret.turretType);
		turret SetModel( "T6_wpn_turret_sam_larger" );
		turret.angles = loc.angles;
		turret setturretteam( "axis" );
		turret.team = "axis";
		turret.health = 1000;
		turret SetMode( "auto_nonai","scan" );
		
		//Set the scan angle to look at the sky.
		turret SetScanningPitch(-35.0);
		
		turret thread shoot_remote_missile();
		
		//turret thread maps\sp_killstreaks\_turret_killstreak::burst_fire_unmanned();
		//turret SetMode( "auto_nonai","scan" );
	}
	
	/*
	// place weapons
	weapon_locations = GetStructArray( "weapon_location", "targetname" );
	foreach( loc in weapon_locations )
	{
		e_rpg = Spawn( loc.script_noteworthy, loc.origin, 0 );
		e_rpg.angles = loc.angles;
		e_rpg ItemWeaponSetAmmo( 9999, 9999 );
	}
	
	// place ammo crates
	crate_locations = GetStructArray( "ammo_crate_location", "targetname" );
	foreach( loc in crate_locations )
	{
		crate = Spawn( "script_model", loc.origin, 0 );
		crate.angles = loc.angles;
		crate SetModel( loc.script_noteworthy );
		
		crate.trigger = Spawn( "trigger_radius_use", loc.origin, 0, 96, 72 );
		crate.trigger thread ammo_refill_trigger();
	}
	*/
	
	// set up the missile truck
	poi = maps\_so_rts_poi::getPOIByRef("rts_poi_df21");
	assert(isDefined(poi));
	missileTagOrigin = poi.entity GetTagOrigin( "tag_missle" );
	missileTagAngles = poi.entity GetTagAngles( "tag_missle" );
	poi.missile = Spawn( "script_model", missileTagOrigin );
	poi.missile.angles = missileTagAngles;
	poi.missile SetModel( "veh_t6_missile_truck_missile" );	
	poi.missile LinkTo( poi.entity, "tag_missle" );
	poi.claimCallback = ::missileTruckLaunch;
	
	// laser turret logic and animation
	poi = maps\_so_rts_poi::getPOIByRef("rts_poi_hellads1");
	poi thread laser_turret_think();
	
	// laser turret logic and animation
	poi = maps\_so_rts_poi::getPOIByRef("rts_poi_hellads2");
	poi thread laser_turret_think();
	
	// place some rpg dudes
	dudes = 0;
	switch( GetDifficulty() )
	{
		case "easy":
			dudes = 0;
			break;
		case "medium":
			dudes = 1;
			break;
		case "hard":
			dudes = 2;
			break;
		case "fu":
			dudes = 3;
			break;
	}
	rpg_guy_locations = GetStructArray( "rpg_guy_location", "targetname" );
	foreach( loc in rpg_guy_locations )
	{
		if (dudes > 0 )
		{
			ai = simple_spawn_single( "ai_spawner_enemy_rpg", undefined, undefined, undefined, undefined, undefined, undefined, true);
			ai ForceTeleport( loc.origin, loc.angles );
			ai SetGoalPos( loc.origin );
			ai thread ai_rocketman_Think();
			dudes--;
		}
		else
		{
			break;
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////

ai_rocketman_Think()
{
	self endon("death");
	
	self.goalradius = 64;
	self.ignoreAll  = true;
	pkg_ref = maps\_so_rts_catalog::package_GetPackageByType("infantry_enemy_reg_pkg");
	ai_ref = level.rts.ai[ pkg_ref.units[0] ];

	scene_wait( "intro_fastrope_player" );
	squad = maps\_so_rts_squad::getSquadByPkg( "infantry_enemy_reg_pkg", self.team );
	self maps\_so_rts_ai::ai_preInitialize(ai_ref,pkg_ref,self.team,squad.id);
	self maps\_so_rts_ai::ai_initialize(ai_ref,self.team,self.origin,squad.id,self.angles,pkg_ref,self.health);

	//initialize messes with these vals
	self.goalradius 	= 64;
	self.ignoreAll  	= true;
	self.rts_unloaded 	= true;
	self.takedamage  	= true;
	while(1)
	{
		targets = ArrayCombine(getAIBySpecies("robot_actor","allies"),getAIBySpecies("vehicle","allies"), false, false);
		
		if (targets.size > 0 )
		{
			self allowedstances( "crouch", "stand" );

			for(i=0;i<targets.size;i++)
			{
				target = targets[i];
				if( isDefined(target) && self cansee( target ) )
				{
					self.ignoreAll  	= false;
					self.favoriteEnemy 	= target;
					while(isAlive(target))
					{
						wait 1;
					}
					self.ignoreAll  	= true;
					self.favoriteEnemy 	= undefined;
					self allowedstances( "crouch" );
					wait 5;//cooldown/reload/pacing/coffee break..
					continue;
				}
			}
		}
		else
		{
			self.ignoreAll  	= true;
			self.favoriteEnemy 	= undefined;
			self allowedstances( "crouch" );
		}
		
		wait 1;
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////
GetRandomOffset()
{
	offset = RandomIntRange(1000,1500);
	if (RandomInt(100)<50)
		offset = -offset;
	return offset;
}


shoot_remote_missile()
{
	level endon( "rts_terminated" );

	while(!flag("rts_game_over"))
	{
		level.rts.player waittill( "remote_missile_start" );
		level.rts.player waittill( "missile_fire", rocket );
		
		fakeEnt = Spawn( "script_model", rocket.origin);
		fakeEnt SetModel( "tag_origin" );
		fakeEnt LinkTo( rocket, "tag_origin", (GetRandomOffset(),GetRandomOffset(), RandomIntRange(100,1000)) );
		self.fake_target = fakeEnt;
		self SetTargetEntity( fakeEnt );
		
		self SetConvergenceTime( 0, "yaw" );
		self SetConvergenceTime( 0, "pitch" );
		
		// stagger the launches
		wait( RandomFloatRange( 1, 2.5 ) );
		
		missileInterval = 3;
		for( i=0; i <= 1; i++ )
		{
			self delay_thread( 0.05, ::shoot_turret );
			self waittill( "missile_fire", missile );
			
			// destroy by time or if it gets close
			missile thread missile_destroy_before_impact( rocket );
			
			wait( missileInterval );
		}
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////

shoot_turret()
{
	self ShootTurret();
}
//////////////////////////////////////////////////////////////////////////////////////////////////

missile_destroy_before_impact( target )
{
	self endon( "death" );
	
	maxDistSq = RandomIntRange(1024*1024,5000*5000);
	
	while(isDefined(target))
	{
		distToTargetSq = DistanceSquared( target.origin, self.origin );
		
		//Record3DText( Distance( target.origin, self.origin ), self.origin, (0,1,0), "Script" );
		
		if( distToTargetSq < maxDistSq )
			break;
		
		wait( 0.05 );
	}

	//play temp sound for press CDC TODO replace after press
	PlaySoundAtPosition ("evt_sam_explo", (0,0,0));
	self missile_destroy();
}
//////////////////////////////////////////////////////////////////////////////////////////////////

missile_destroy()
{
	maps\_so_rts_event::trigger_event("sam_missile_explosion",self.origin);
	if ( isDefined(self.fake_target ) )
		self.fake_target  Delete();
	self Delete();
}
//////////////////////////////////////////////////////////////////////////////////////////////////

docksdie_order_to_samsite(squadID)
{
	poi = maps\_so_rts_poi::getPOIByRef("rts_poi_hellads1");
	if ( !isDefined(poi) )
	{
		maps\_so_rts_enemy::order_new_squad(squadID);
	}
	else
	{
		maps\_so_rts_squad::OrderSquadDefend(poi.entity.origin,squadID);
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////

dockside_EnemyBaseDamageWatch()
{
	while(self.health>0)
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		if (isDefined(attacker) && attacker != level.rts.player )
			self.health += damage;
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////

dockside_EnemyBaseWatch()
{
	self thread dockside_EnemyBaseDamageWatch();
	while (isdefined(self) && self.health > 0 )
	{
		self.takedamage = false;
		level waittill("fire_missile");
		self.takedamage = true;
		level waittill("fire_missile_done");
	}
	flag_set("rts_game_over");
}

//////////////////////////////////////////////////////////////////////////////////////////////////

#using_animtree( "animated_props" );
missileTruckLaunch( team )
{
	if( team == "allies" )
	{
		level notify("missile_launch");
		self.entity UseAnimTree( #animtree );
		self.entity SetFlaggedAnim( "missile_launch", %v_missile_truck_raise, 1, 0.2, 1 );
		
		//maps\_so_rts_event::trigger_event ("missile_launch_sfx");
		self.entity PlaySound ( "evt_sam_servo_start" );
		
		self.entity waittillmatch( "missile_launch", "end" );
		
		maps\_so_rts_event::trigger_event("missile_launch",self.missile);
		
		//maps\_so_rts_event::trigger_event ("missile_launch_sfx_2");
		self.entity PlaySound ( "evt_sam_launch" );
		
		wait(5);
		maps\_so_rts_event::trigger_event("missile_exhaust",self.missile);
		
		missileGoal = self.missile.origin + (0, 0, 3000);
		
		self.missile Unlink();
		self.missile MoveTo( missileGoal, 6, 4, 0 );
		self.missile waittill( "movedone" );
		
		maps\_so_rts_event::trigger_event("missile_explosion",self.missile.origin+(0,0,100));
		
		//maps\_so_rts_event::trigger_event ("missile_launch_explo");
		self.missile PlaySound ( "evt_sam_explo" );
		
		self.missile Delete();
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////

rope_l()
{	
	level.rts.intro_rope_l UseAnimTree( #animtree );
	
	level.rts.intro_rope_l SetFlaggedAnimKnobAllRestart( "rope_kick", %fxanim_war_sing_rappel_rope_01_anim, %root, 1, 0.2, 1 );
	level.rts.intro_rope_l waittillmatch( "rope_kick", "end" );
}

rope_r()
{	
	level.rts.intro_rope_r UseAnimTree( #animtree );
	
	level.rts.intro_rope_r SetFlaggedAnimKnobAllRestart( "rope_kick", %fxanim_war_sing_rappel_rope_02_anim, %root, 1, 0.2, 1 );
	level.rts.intro_rope_r waittillmatch( "rope_kick", "end" );
}
//////////////////////////////////////////////////////////////////////////////////////////////////

play_fx_on_tag( fx, ent, tag )
{
	tagOrigin = ent GetTagOrigin( tag );
	tagAngles = ent GetTagAngles( tag );
	
	fx_base = Spawn( "script_model", tagOrigin );
	fx_base.angles = tagAngles;
	fx_base SetModel( "tag_origin" );
	fx_base LinkTo( ent, tag );
		
	PlayFXOnTag( fx, fx_base, "tag_origin" );
	
	return fx_base;
}

// self is the poi
laser_turret_think()
{
	turret = self.entity;
	
	// play enemy fx
	fx_base = play_fx_on_tag( level._effect[ "laser_turret_light_red" ], turret, "tag_fx_base" );
	fx_turret = play_fx_on_tag( level._effect[ "laser_turret_light_red" ], turret, "tag_fx_turret" );
	
	turret UseAnimTree( #animtree );
	
	idleAnimArray = array( %fxanim_war_laser_turret_search_01_anim, %fxanim_war_laser_turret_search_02_anim, %fxanim_war_laser_turret_search_03_anim, %fxanim_war_laser_turret_search_04_anim );
	
	// play random idles
	while( !IS_TRUE(self.captured) )
	{
		turret laser_turret_idle( idleAnimArray );
		
		//LEE SOUND
		//maps\_so_rts_event::trigger_event ("laser_servo");
		turret PlaySound ( "evt_laser_servo" );
		
		
		
	}
	
	// stop enemy fx
	fx_base Delete();
	fx_turret Delete();
	
	// play the disabled fx
	fx_base = play_fx_on_tag( level._effect[ "laser_turret_disabled" ], turret, "tag_fx_turret" );
	
	//LEE SOUND
	//maps\_so_rts_event::trigger_event ("laser_shutdown");
	fx_base PlaySound ( "evt_laser_shutdown" );
	
	
	// deactivate
	turret SetFlaggedAnimKnobAllRestart( "deactivate", %fxanim_war_laser_turret_off_anim, %root, 1, 0.2, 1 );
	turret waittillmatch( "deactivate", "end" );
	
	wait( 2 );
	
	// stop the disabled fx
	fx_base Delete();
	
	// play friendly fx
	fx_base = play_fx_on_tag( level._effect[ "laser_turret_light_green" ], turret, "tag_fx_base" );
	fx_turret = play_fx_on_tag( level._effect[ "laser_turret_light_green" ], turret, "tag_fx_turret" );
	
	// reactivate
	turret SetFlaggedAnimKnobAllRestart( "activate", %fxanim_war_laser_turret_on_anim, %root, 1, 0.2, 1 );
	turret waittillmatch( "activate", "end" );
	
	//LEE SOUND
	//maps\_so_rts_event::trigger_event ("laser_servo");
	turret PlaySound ( "evt_laser_servo" );
	
	// play random idles
	while( 1 )
	{
		turret laser_turret_idle( idleAnimArray );
		
		
	}
}

// self is the turret
laser_turret_idle( idleAnimArray )
{
	self SetFlaggedAnimKnobAllRestart( "idle", idleAnimArray[ RandomInt( idleAnimArray.size ) ], %root, 1, 0.2, 0.5 );
	self waittillmatch( "idle", "end" );
}
//////////////////////////////////////////////////////////////////////////////////////////////////

boat_ending()
{	
	assert( IsDefined( level.rts.enemy_base.entity.animRig ) );
	
	// post boat death SFX HERE
	setmusicstate ("DOCKSIDE_ACTION_WIN");
	level clientnotify ("rts_ON");
	
	missile_end = GetStruct( "boat_location", "targetname" ).origin + ( 0, 0, 500 );
	missile_start = missile_end + ( 0, 0, 2500 );
	missile_vector = missile_start - missile_end;
	missile_angles = VectorToAngles( missile_vector );
			
	missile = spawn_model( "projectile_javelin_missile", missile_start, missile_angles );
	PlayFXOnTag( level._effect[ "predator_trail" ], missile, "TAG_FX" );
	missile MoveTo( missile_end, 1.5 );
	missile waittill( "movedone" );
	//temp explosion
	PlaySoundAtPosition ("evt_ship_missle_exp", (0,0,0));

	missile Delete();
	
	level.rts.enemy_base.entity.animRig UseAnimTree( #animtree );
	level.rts.enemy_base.entity.animRig SetFlaggedAnimKnobAllRestart( "boat", %fxanim_war_sing_cargo_ship_sink_anim, %root, 1, 0.2, 1 );
	
	level.rts.enemy_base.entity.animRig thread container_splashes();
	
	// water fx
	PlayFXOnTag( level._effect[ "boat_water" ], level.rts.enemy_base.entity.animRig, "tag_waterline" );
	
	// first explosion
	level.rts.enemy_base.entity.animRig waittillmatch( "boat", "explosion01" );
	PlayFXOnTag( level._effect[ "boat_explosion_xlg" ], level.rts.enemy_base.entity.animRig, "tag_explode1" );
	PlayFXOnTag( level._effect[ "boat_fire" ], level.rts.enemy_base.entity.animRig, "tag_explode1" );
	level thread boat_ending_explosion_1();
	
	// second explosion
	level.rts.enemy_base.entity.animRig waittillmatch( "boat", "explosion02" );
	PlayFXOnTag( level._effect[ "boat_explosion_lg" ], level.rts.enemy_base.entity.animRig, "tag_explode2" );
	PlayFXOnTag( level._effect[ "boat_fire" ], level.rts.enemy_base.entity.animRig, "tag_explode1" );
	level thread boat_ending_explosion_2();
	
	// third explosion
	level.rts.enemy_base.entity.animRig waittillmatch( "boat", "explosion03" );
	PlayFXOnTag( level._effect[ "boat_explosion_lg" ], level.rts.enemy_base.entity.animRig, "tag_explode3" );
	PlayFXOnTag( level._effect[ "boat_fire" ], level.rts.enemy_base.entity.animRig, "tag_explode1" );
	level thread boat_ending_explosion_3();
	
	level.rts.enemy_base.entity.animRig waittillmatch( "boat", "end" );
}
//////////////////////////////////////////////////////////////////////////////////////////////////

boat_ending_explosion_1()
{
	Earthquake( 0.5, 2.5, level.player.origin, 500 );
	level.player PlayRumbleLoopOnEntity( "artillery_rumble" );	
	wait 2.5;
	level.player StopRumble( "artillery_rumble" );
}

boat_ending_explosion_2()
{
	Earthquake( 0.3, 1.5, level.player.origin, 500 );
	level.player PlayRumbleOnEntity( "artillery_rumble" );	
}

boat_ending_explosion_3()
{
	Earthquake( 0.4, 1, level.player.origin, 500 );
	level.player PlayRumbleOnEntity( "artillery_rumble" );	
}

container_splashes()
{
	splash_fx = [];
	splash_fx[0] 	= undefined;
	splash_fx[1] 	= "water_splash_tall";
	splash_fx[2] 	= "water_splash_wide";
	splash_fx[3] 	= "water_splash_wide";
	splash_fx[4] 	= "water_splash_tall";
	splash_fx[5] 	= "water_splash_tall";
	splash_fx[6] 	= "water_splash_wide";
	splash_fx[7] 	= "water_splash_wide";
	splash_fx[8] 	= "water_splash_wide";
	splash_fx[9] 	= "water_splash_tall";
	splash_fx[10] 	= "water_splash_wide";
	splash_fx[11] 	= "water_splash_wide";
	splash_fx[12] 	= "water_splash_tall";
	splash_fx[13] 	= "water_splash_wide";
	splash_fx[14] 	= "water_splash_tall";
	splash_fx[15] 	= "water_splash_wide";
	
	containerIndex = 1;
	
	while(1)
	{
		self waittill( "boat", note );

		if( IsDefined( note ) )
		{
			if( note == "end" )
				return;
			
			// play the splash on the right container
			if( IsSubStr( note, "cargo_splash" ) )
			{
				if( containerIndex < 10 )
					tagName = "tag_fx_splash0" + containerIndex;
				else
					tagName = "tag_fx_splash" + containerIndex;
				
				assert( IsDefined( splash_fx[ containerIndex ] ) );
				fxId = splash_fx[ containerIndex ];
				
				PlayFXOnTag( level._effect[ fxId ], self, tagName );
				Earthquake( 0.1, 0.1, level.player.origin, 500 );
				level.player PlayRumbleOnEntity( "damage_light" );	
				
				containerIndex++;
			}
		}
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////

dockside_level_scenario_one_registerEvents()
{
	//register_event(ref,dataParam,cooldown,latency,trigNotify,oneTimeOnly)
	//make_event_param(type, alias, target, species)
	
	//CALLBACK TYPE events need to be manually registered.
	maps\_so_rts_event::register_event("friendly_select",	maps\_so_rts_event::make_event_param(EVENT_TYPE_CALLBACK,maps\_so_rts_support::get_selection_alias_from_targetname),850 );
	maps\_so_rts_event::register_event("intruder_explode",	maps\_so_rts_event::make_event_param(EVENT_TYPE_CALLBACK,maps\_so_rts_support::sfxAndFx,"evt_rts_acoustic_sensor_explode","network_intruder_death") );

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// NOT HOOKED UP
/*	maps\_so_rts_event::register_event("forceswitch_infantry_ally_reg_pkg",	maps\_so_rts_event::make_event_param(EVENT_TYPE_DIALOG,"vox_cmd_move_unit0",level.rts.player),5000,2000);//TODO get a valid force switch for infantry
	maps\_so_rts_event::register_event("forceswitch_quadrotor_pkg",			maps\_so_rts_event::make_event_param(EVENT_TYPE_DIALOG,"vox_cmd_quad_oper",level.rts.player),5000,2000);//crap
	maps\_so_rts_event::register_event("forceswitch_bigdog_pkg",			maps\_so_rts_event::make_event_param(EVENT_TYPE_DIALOG,"vox_cmd_claw_oper",level.rts.player),5000,2000);//crap
	maps\_so_rts_event::register_event("forceswitch_metalstorm_pkg",		maps\_so_rts_event::make_event_param(EVENT_TYPE_DIALOG,"vox_cmd_asd_oper",level.rts.player),5000,2000);//crap
	maps\_so_rts_event::register_event("movefps_infantry_ally_reg_pkg",		maps\_so_rts_event::make_event_param(EVENT_TYPE_DIALOG,"vox_#%#_unit0_obj1",undefined,"allies"));//Moving to your mark.

	maps\_so_rts_event::register_event("new_enemy",			maps\_so_rts_event::make_event_param(EVENT_TYPE_DIALOG,"vox_#%#_enemy_enga",undefined,"allies"),10000,2000);//Enemy personnel in sight.  Engaging.
	maps\_so_rts_event::register_event("move_all_squads",		maps\_so_rts_event::make_event_param(EVENT_TYPE_DIALOG,"vox_cmd_move_all",level.rts.player),5000,2000);//Units converge on marked position.
*/

}
//////////////////////////////////////////////////////////////////////////////////////////////////
player_waitfor_vehicleEntry()
{
	level endon( "rts_terminated" );
	while(1)
	{
		self waittill("vehicle_taken_over",entity);
		if (isDefined(entity))
			entity thread vehicleHealthRegen();//self is vehicle
	}
}


vehicleHealthRegen()//self is vehicle
{
	self notify("vehicleHealthRegen");
	self endon("vehicleHealthRegen");
	self endon("death");
	self endon("player_exited");
	level endon("eye_in_the_sky");
	level endon("switch_and_takeover");
	
	if ( !isDefined(self.ai_ref.regenrate) || (self.ai_ref.regenrate == 0) )
		return;
		
	amount 		= int(float(self.health_max * self.ai_ref.regenrate));
	threshold 	= 5000;
	
	while(1)
	{
		if ( isDefined(self.lastHitStamp) )
		{
			curTime = GetTime();
			if ( (self.lastHitStamp + threshold) < curTime )
			{
				if ( self.health < self.health_max )
				{
					println("$$$ Regenerating health on "+self.ai_ref.ref+". Amount("+amount+") CurHealth: "+self.health);
					self.health += amount;
					if (self.health > self.health_max )
					{
						self.health = self.health_max;
					}
					if( self.vehicletype == "drone_metalstorm_rts" )
					{
						self maps\_metal_storm::metalstorm_update_damage_fx();
					}
					else if( self.vehicletype == "heli_quadrotor_rts" || self.vehicletype == "heli_quadrotor_rts_player" )
					{
						self maps\_quadrotor::quadrotor_update_damage_fx();
					}
				}
			}
		}
		wait 1;
	}
}
