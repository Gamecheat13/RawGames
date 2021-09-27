#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;
#include maps\hijack_code;
#include maps\_shg_fx;

main()
{
	maps\createart\hijack_art::main();
	maps\hijack_fx::main();
	maps\hijack_aud::main();
	maps\hijack_anim::main();
	maps\hijack_precache::main();
	
	level_precache();
	level_init_flags();
	level_init_assets();

    set_default_start( "airplane" );  
	add_start( "airplane", maps\hijack_airplane::start_airplane );
	add_start( "debate", maps\hijack_airplane::start_debate );
	add_start( "pre_zero_g", maps\hijack_airplane::start_pre_zero_g );
	add_start( "lower_level_combat", maps\hijack_airplane::start_lower_level_combat );
	add_start( "crash", maps\hijack_crash::start_crash );
	add_start( "tarmac", maps\hijack_tarmac::start_tarmac );
	add_start( "tarmac_2", maps\hijack_tarmac::start_tarmac_2 );	
	add_start( "post_tarmac", maps\hijack_script_2b::start_post_tarmac );	
	add_start( "end_scene", maps\hijack_script_2c::start_end_scene );
	
	setup();
}

level_precache()
{
	PrecacheItem( "flash_grenade" );
	PrecacheItem( "armory_grenade" );
	PrecacheItem( "rpg_straight" );
	PreCacheItem( "ak74u" );
	PreCacheItem( "ak74u_zero_g" );
	PreCacheItem( "ak47_acog" );
	//PreCacheItem( "beretta" );
	PreCacheItem( "fnfiveseven" );
	PreCacheItem( "fnfiveseven_zero_g" );
	PreCacheShader( "overlay_frozen" );
	PreCacheModel( "electronics_pda" );
	PreCacheModel( "viewhands_fso" );
	PreCacheModel( "viewhands_player_fso" );
}

level_init_flags()
{
	maps\hijack_airplane::airplane_init_flags();
	maps\hijack_crash::crash_init_flags();
	maps\hijack_tarmac::tarmac_init_flags();
	
	flag_init( "stop_rocking" );
	flag_init( "stop_turbulence" );
	flag_init( "in_flight");
	
	flag_init( "pause_inflight_fx" );
	flag_init( "pause_tarmac_fx" );
	
	//tarmac combat flags
	flag_init("start_tarmacend_combat");
	flag_init("tarmac_combat_wave2");
	flag_init("tarmac_combat_wave3");
	flag_init("tarmac_combat_wave4");
	flag_init("endguys_dead");
	
}

level_init_assets()
{
	maps\hijack_tarmac::tarmac_init_assets();
}

setup()
{
	maps\_load::main();

	PreCacheShellShock( "hijack_airplane" );
	PreCacheShellShock( "hijack_minor" );
	PreCacheShellShock( "hijack_slowview" );
	PreCacheShellShock( "default" );
	PreCacheShellShock( "dcburning" );
	PreCacheShellShock( "hijack_door_explosion" );
	PreCacheShellShock( "hijack_engine_explosion" );
	PreCacheShellShock( "hijack_tail_explosion" );
	PreCacheShellShock( "hijack_end_scene" );
	precacherumble( "hijack_plane_low");
	precacherumble( "hijack_plane_medium");
	precacherumble( "hijack_plane_large");
		
	//SetSavedDvar( "hud_showstance", 0 );
	//SetSavedDvar( "compass", 0 );
	
	battlechatter_off( "axis" );
	battlechatter_off( "allies" );
	
	thread set_vision_set( "hijack_airplane", 1 );
	
	level.debate_trigger = getEnt( "player_debate_trigger", "script_noteworthy" );
	level.debate_trigger trigger_off();
	
	level.debate_trigger_b = getEnt( "player_debate_trigger_b", "script_noteworthy" );
	level.debate_trigger_b trigger_off();
	
	level.debate_laptop_off = getEnt( "debate_laptop_off", "targetname" );
	level.debate_laptop_off hide();
		
	if ( getdvar( "airmasks" ) == "" )
	setdvar( "airmasks", "1" );
	
	maps\_flare::main( "tag_flash" );
	
	//level._effect["flare_runner"]	= loadfx("misc/flare_hijack");
	
	maps\_drone_ai::init();
	
	level.friendlyfire[ "enemy_kill_points" ]	 = 3;
	level.friendlyfire[ "friend_kill_points" ] 	 = -1000;
	
	level.player SetWeaponAmmoStock( "fnfiveseven", 60 );
	
	level.orig_phys_gravity = GetDvar( "phys_gravity" );
	level.orig_ragdoll_gravity = GetDvar( "phys_gravity_ragdoll" );
	level.orig_WakeupRadius = GetDvar( "phys_gravityChangeWakeupRadius" );
	level.orig_ragdoll_life = GetDvar( "ragdoll_max_life" );
	level.orig_sundirection = (-14, 114, 0); //GetMapSunAngles(); this won't work since this area of plane is in a "stage" volume.
	
	level.org_view_roll = getent( "org_view_roll", "targetname" );
	assert( isdefined( level.org_view_roll ) );
	level.player playerSetGroundReferenceEnt( level.org_view_roll );
	level.aRollers = [];
	level.aRollers = array_add( level.aRollers, level.org_view_roll );

	level.conf_lights_off = GetEntArray( "conf_light_off", "targetname" );
	array_call(level.conf_lights_off, ::hide);
	array_call(level.conf_lights_off, ::NotSolid);
	
	airmasks = getentarray( "airmask", "targetname" );
	array_thread( airmasks, ::airmask_setup );
	
	level.seatbeltsigns = getentarray( "seatbelt_signs", "targetname" );
	array_call(level.seatbeltsigns, ::hide);
	
	// disabling chopper wash until the end to save on fx budget
	//maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing", "snow", "treadfx/heli_snow_hijack");
	//maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing", "ice", "treadfx/heli_snow_hijack");
	//maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing", "slush", "treadfx/heli_snow_hijack");
	maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing", "snow");
	maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing", "ice");
	maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing", "slush");
		
	//Set up AI
	commander_spawner = getEnt( "commander", "script_noteworthy" );
	commander_spawner add_spawn_function( ::setup_commander );

	commander_spawner_tarmac = getEnt( "commander_tarmac", "script_noteworthy" );
	commander_spawner_tarmac add_spawn_function( ::setup_commander );
	
	advisor_spawner = getEnt( "advisor", "script_noteworthy" );
	advisor_spawner add_spawn_function( ::setup_advisor );
	
	advisor_spawner_tarmac = getEnt( "advisor_tarmac", "script_noteworthy" );
	advisor_spawner_tarmac add_spawn_function( ::setup_advisor );
	
	president_spawner = getEnt( "president", "script_noteworthy" );
	president_spawner add_spawn_function( ::setup_president );
	
	president_spawner_tarmac = getEnt( "president_tarmac", "script_noteworthy" );
	president_spawner_tarmac add_spawn_function( ::setup_president );
	
	//daughter_spawner = getEnt( "daughter", "script_noteworthy" );
	//daughter_spawner add_spawn_function( ::setup_daughter	 );
	
	daughter_spawner = getEnt( "find_daughter_pre_crash", "targetname" );
	daughter_spawner add_spawn_function( ::setup_daughter );	
		
	hero_agent_01_spawner = getEnt( "hero_agent_01", "script_noteworthy" );
	hero_agent_01_spawner add_spawn_function( ::setup_hero_agent_01 );
	
	zerog_agent_01_spawner = getEnt( "zerog_agent_01", "script_noteworthy" );
	zerog_agent_01_spawner add_spawn_function( ::setup_zerog_agent_01 );
	
	zerog_agent_02_spawner = getEnt( "zerog_agent_02", "script_noteworthy" );
	zerog_agent_02_spawner add_spawn_function( ::setup_zerog_agent_02 );
	
	crash_agent_1_spawner = getEnt( "crash_agent_1", "script_noteworthy" );
	crash_agent_1_spawner add_spawn_function( ::setup_crash_agent_1 );
	
	array_spawn_function_targetname( "pre_zerog_terrorists", ::temp_bullet_shield );
		
	array_spawn_function_noteworthy( "terrorists", ::no_grenades );
	//array_spawn_function_targetname( "secret_service", ::no_grenades );
	
	level.crash_models = GetEntArray("hijack_crash_plane_model", "targetname");	

	thread manage_tail_models();
	thread setup_volumetric_lights();
	thread setup_object_mass();
	thread no_grenade_death_hack();
	thread setup_tarmac_triggers();
	thread setup_hijack_specific_lights();
	thread setup_end_heli_interior();
	
	thread pause_inflight_fx();
	thread pause_tarmac_fx();
	thread pause_fuselage_fire_fx();
	thread pause_wreckage_interior_fx();
	
	//thread fx_zone_watcher(333, "fx_comm_room_sparks");
	thread fx_zone_watcher(400, "fx_crash_trench_fire");
	thread fx_zone_watcher(410, "fx_hangar_combat_area");
	thread fx_zone_watcher(420, "fx_final_area");
}

setup_hijack_specific_lights()
{
	//hjk_pulsing_lights = GetEntArray( "hjk_red_light_pulsing", "targetname" );
	light0 = GetEnt("hjk_red_light_pulsing0", "targetname" );
	light1 = GetEnt("hjk_red_light_pulsing1", "targetname" );
	light2 = GetEnt("hjk_red_light_pulsing2", "targetname" );
	light3 = GetEnt("hjk_red_light_pulsing3", "targetname" );
	light0 thread hjk_red_light_pulsing(0);
	light1 thread hjk_red_light_pulsing(1);
	light2 thread hjk_red_light_pulsing(2);
	light3 thread hjk_red_light_pulsing(3);
	//array_thread( hjk_pulsing_lights, ::hjk_red_light_pulsing );
}

setup_cloud_tunnel()
{
	cloud_tunnel_ent = getent("cloud_tunnel", "targetname");
	cloud_tunnel_fx = getfx("cloud_tunnel");
	cloud_dummy = Spawn("script_model", cloud_tunnel_ent.origin);
	cloud_dummy SetModel("generic_prop_raven");
	cloud_dummy_startPos = cloud_dummy.origin;
	
	flag_set( "in_flight" );
	
	while (1)
	{
		flag_wait( "in_flight" );
		flag_set( "pause_tarmac_fx" );
		PlayFXOnTag(cloud_tunnel_fx, cloud_dummy, "tag_origin");
		cloud_dummy.origin = cloud_dummy_startPos;
				
		flag_waitopen( "in_flight" );
		cloud_dummy.origin = cloud_dummy_startPos - (0,0,100000);
	}
}

pause_inflight_fx()
{
	fx = [];
	fx = getfxarraybyID( "window_volumetric" );
	fx = array_combine( fx, getfxarraybyID( "conference_room_smoke" ));
	fx = array_combine( fx, getfxarraybyID( "banner_fire" ));
	fx = array_combine( fx, getfxarraybyID( "hijack_potlight_volumetric" ));
	fx = array_combine( fx, getfxarraybyID( "hijack_iris_volumetric" ));
	fx = array_combine( fx, getfxarraybyID( "aircraft_light_white_blink" ));
	fx = array_combine( fx, getfxarraybyID( "aircraft_light_wingtip_green" ));
	fx = array_combine( fx, getfxarraybyID( "aircraft_light_wingtip_red" ));

	//wait( 0.1 ); // must wait until fx are started
	level waittill("volumetrics_setup");
	for ( ;; )
	{
		flag_wait( "pause_inflight_fx" );
		//iprintln( "FX: Inflight effects paused." );
		foreach ( ent in level.volumetric_window_fx_ents )
		{
			StopFXOnTag(getfx("window_volumetric"), ent, "tag_origin");		
			StopFXOntag(getfx("window_volumetric_open"), ent, "tag_origin");
		}
		foreach ( oneshot in fx )
			oneshot pauseEffect();
		flag_waitopen( "pause_inflight_fx" );
		//iprintln( "FX: Inflight effects restarted." );
		foreach ( oneshot in fx )
			oneshot restartEffect();
	}
}

pause_tarmac_fx()
{
	fx = [];
	fx = getfxarraybyID( "after_math_embers" );
	fx = array_combine( fx, getfxarraybyID( "horizon_fireglow" ));
	fx = array_combine( fx, getfxarraybyID( "interior_ceiling_smoke" ));
	fx = array_combine( fx, getfxarraybyID( "interior_ceiling_smoke2" ));
	fx = array_combine( fx, getfxarraybyID( "interior_ceiling_smoke3" ));
	fx = array_combine( fx, getfxarraybyID( "hijack_firelp_med_pm" ));
	fx = array_combine( fx, getfxarraybyID( "firelp_large_pm_nolight" ));
	fx = array_combine( fx, getfxarraybyID( "hijack_megafire" ));
	fx = array_combine( fx, getfxarraybyID( "fire_trail_60" ));
	fx = array_combine( fx, getfxarraybyID( "firelp_med_pm_nolight" ));
	fx = array_combine( fx, getfxarraybyID( "banner_fire" ));
	fx = array_combine( fx, getfxarraybyID( "banner_fire_nodrip" ));
	fx = array_combine( fx, getfxarraybyID( "firelp_small_pm_nolight" ));
	fx = array_combine( fx, getfxarraybyID( "powerline_runner_cheap_hijack" ));
	fx = array_combine( fx, getfxarraybyID( "field_fire_distant2" ));
	fx = array_combine( fx, getfxarraybyID( "plane_gash_volumetric" ));

	//wait( 0.1 ); // must wait until fx are started	
	level waittill("volumetrics_setup");
	for ( ;; )
	{
		flag_wait( "pause_tarmac_fx" );
		//iprintln( "FX: Tarmac effects paused." );
		foreach ( oneshot in fx )
			oneshot pauseEffect();
		flag_waitopen( "pause_tarmac_fx" );
		//iprintln( "FX: Tarmac effects restarted." );
		foreach ( oneshot in fx )
			oneshot restartEffect();
	}
}

pause_fuselage_fire_fx()
{
	fxStartOff = [];
	fxStartOff = getfxarraybyID( "banner_fire" );
	
	fxStartOn = [];
	fxStartOn = getfxarraybyID( "airplane_crash_embers" );
	fxStartOn = array_combine( fxStartOn, getfxarraybyID( "hijack_firelp_huge_pm_nolight" ));
	fxStartOn = array_combine( fxStartOn, getfxarraybyID( "trench_glow" ));
	fxStartOn = array_combine( fxStartOn, getfxarraybyID( "fire_trail_60" ));

	//wait( 0.1 ); // must wait until fx are started	
	level waittill("volumetrics_setup");
	for ( ;; )
	{
		flag_wait( "pause_fuselage_fire_fx" );
		//iprintln( "FX: Fuselage fire effects restarted." );
		foreach ( oneshot in fxStartOff )
			oneshot restartEffect();
		foreach ( oneshot in fxStartOn )
			oneshot pauseEffect();
		flag_waitopen( "pause_fuselage_fire_fx" );
		//iprintln( "FX: Fuselage fire effects paused." );
		foreach ( oneshot in fxStartOff )
			oneshot pauseEffect();
		foreach ( oneshot in fxStartOn )
			oneshot restartEffect();
	}
}

pause_wreckage_interior_fx()
{
	
	fxStartOff = [];
	//fxStartOff = getfxarraybyID( "engine_spark" );
	
	fxStartOn = [];
	fxStartOn = getfxarraybyID( "powerline_runner" );
	fxStartOn = array_combine( fxStartOn, getfxarraybyID( "powerline_runner_cheap" ));
	fxStartOn = array_combine( fxStartOn, getfxarraybyID( "interior_ceiling_smoke" ));
	fxStartOn = array_combine( fxStartOn, getfxarraybyID( "interior_ceiling_smoke2" ));
	fxStartOn = array_combine( fxStartOn, getfxarraybyID( "interior_ceiling_smoke3" ));

	//wait( 0.1 ); // must wait until fx are started	
	level waittill("volumetrics_setup");
	for ( ;; )
	{
		flag_wait( "pause_wreckage_interior_fx" );
		//iprintln( "FX: Wreckage interior effects restarted." );
		foreach ( oneshot in fxStartOff )
			oneshot restartEffect();
		foreach ( oneshot in fxStartOn )
			oneshot pauseEffect();
		flag_waitopen( "pause_wreckage_interior_fx" );
		//iprintln( "FX: Wreckage interior effects paused." );
		foreach ( oneshot in fxStartOff )
			oneshot pauseEffect();
		foreach ( oneshot in fxStartOn )
			oneshot restartEffect();
	}
}

setup_object_mass()
{
	level.objectmass = [];
	level.objectmass["trash_cup_short1"] = 1;				// physics preset: cardboardbox_empty
	level.objectmass["hjk_vodka_glass"] = 0.5;				// physics preset: glass_chunk
	level.objectmass["hjk_vodka_glass_lrg"] = 0.5;			// physics preset: glass_chunk
	level.objectmass["trash_bottle_whisky"] = 0.5;			// physics preset: glass_chunk
	level.objectmass["cs_coffeemug02_static"] = 0.1;	 	// physics preset: bottle_plastic
	level.objectmass["ma_salt_shaker_1"] = 0.1;	 			// physics preset: bottle_plastic
	level.objectmass["ma_restaurant_plate_01"] = 5;			// physics preset: plate
	level.objectmass["hjk_ashtray"] = 5;					// physics preset: plate
	level.objectmass["hjk_napkin_1"] = 5;					// physics preset: picture_frame
	level.objectmass["hjk_napkin_2"] = 5;					// physics preset: picture_frame
	level.objectmass["newspaper_folded_static"] = 5;		// physics preset: picture_frame
	level.objectmass["cs_vodkabottle01"] = 3;				// physics preset: glass_bottle
	level.objectmass["trash_bottle_wine"] = 3;				// physics preset: glass_bottle
	level.objectmass["hjk_metal_pitcher"] = 6;				// physics preset: bucket_metal
	level.objectmass["bo_p_glo_beer_bottle01_world"] = 3;	// physics preset: glass_bottle
	level.objectmass["hjk_laptop_closed"] = 1;				// physics preset: com_laptop_close
	level.objectmass["ap_luggage02"] = 1;					// physics preset: ap_luggage03
	level.objectmass["ap_luggage03"] = 1;					// physics preset: ap_luggage03
	level.objectmass["me_banana"] = 0.5;					// physics preset: fruit_small
	level.objectmass["me_fruit_orange"] = 0.5;				// physics preset: fruit_small
	level.objectmass["me_fruit_mango_green"] = 0.5;			// physics preset: fruit_small
	level.objectmass["me_fruit_mango_redorange"] = 0.5;		// physics preset: fruit_small
}

setup_tarmac_triggers()
{
	triggers = GetEntArray("disable_during_crash","script_noteworthy");
	backtrack_trigger = GetEnt("tarmac_backtrack_trigger","script_noteworthy");
	foreach(trigger in triggers)
	{
		trigger trigger_off();
	}
	backtrack_trigger trigger_off();
	
	flag_wait("player_on_feet_post_crash");
	foreach(trigger in triggers)
	{
		trigger trigger_on();
	}
	
	flag_wait("entered_post_tarmac_area");
	backtrack_trigger trigger_on();
}

setup_volumetric_lights()
{
	wait 0.1;
	level.volumetric_window_fx = [];
	level.volumetric_window_fx_ents = [];
	
	//find the loopingFX from createFX
	/*fx = getfxarraybyID("window_volumetric");
	foreach (effect in fx)
	{
		//play our own fx attached to entities, so we can rotate them.
		ent = spawn_tag_origin();
		ent.origin = effect.v["origin"];
		ent.angles = effect.v["angles"];
		PlayFXOnTag(getfx("window_volumetric"), ent, "tag_origin");
		
		//attach *that* entity to one with zero rotation.
		entZeroRot = spawn_tag_origin();
		entZeroRot.origin = ent.origin;
		ent linkto(entZeroRot);
		level.volumetric_window_fx_ents[level.volumetric_window_fx_ents.size] = ent;		
		level.volumetric_window_fx[level.volumetric_window_fx.size] = entZeroRot;
		
		//effect pauseEffect();
		stop_exploder( "window_volumetric" );
			
	}*/
		
	//add them to the rollers array so they tilt with everything else
	//level.aRollers = array_combine( level.aRollers, level.volumetric_window_fx );
	
	level.godrays = GetEntArray( "god_ray_emitter", "targetname" );
	
	foreach (obj in level.godrays)
	{
		//play our own fx attached to entities, so we can rotate them.
		ent = spawn_tag_origin();
		ent.origin = obj.origin;
		ent.angles = obj.angles;
		
		if ( obj.script_noteworthy == "window_volumetric_open" )
		{
			PlayFXOnTag(getfx("window_volumetric_open"), ent, "tag_origin");
		}
		else
		{
			PlayFXOnTag(getfx("window_volumetric"), ent, "tag_origin");
		}
		
		//attach *that* entity to one with zero rotation.
		entZeroRot = spawn_tag_origin();
		entZeroRot.origin = ent.origin;
		ent linkto(entZeroRot);
		level.volumetric_window_fx_ents[level.volumetric_window_fx_ents.size] = ent;		
		level.volumetric_window_fx[level.volumetric_window_fx.size] = entZeroRot;
	}
	
	level.aRollers = array_combine( level.aRollers, level.volumetric_window_fx );
	level notify("volumetrics_setup");
	//level.aRollers = array_combine( level.aRollers, level.godrays );
}

no_grenade_death_hack()
{
	//can't have any AI doing grenade death since they have no grenades
	while ( true )
	{
		anim.nextCornerGrenadeDeathTime = gettime() + 60 * 1000 * 5; wait 60;
	}
}

setup_common_hijack_features()
{
	self.ignoreme = true;	
	self.ignoreall = true;
	self magic_bullet_shield();
	self no_grenades();
	self setFlashbangImmunity( true );
}

player_damage_to_friendlies()
{
	self endon("death");
		
	while(1)
	{
		self waittill( "damage", amount, attacker);
		
		if ( attacker == level.player )
		{
			if(IsDefined (self.magic_bullet_shield))
			{
				self stop_magic_bullet_shield();
				self.allowdeath = true;
				if( self != level.president )
				{
					self.deathfunction = agent_death();
				}
				else
				{
					self.deathfunction = civilian_death();
				}
			}
		}
	}
}

civilian_death()
{
	SetDvar( "ui_deadquote", &"HIJACK_MISSIONFAIL_PRESIDENT" );	// You shot a civilian. Watch your fire!
	thread maps\_utility::missionFailedWrapper();
}

agent_death()
{
	SetDvar( "ui_deadquote", &"SCRIPT_MISSIONFAIL_KILLTEAM_AMERICAN" );	// Friendly fire will not be tolerated!
	thread maps\_utility::missionFailedWrapper();
}

setup_generic_script_guy()
{
	thread setup_common_hijack_features();
	self.animname = "generic";
	self gun_remove();
}

setup_commander()
{
	thread setup_common_hijack_features();
	level.commander = self;
	level.commander.notarget = true;
	level.commander.animname = "commander";
}

setup_daughter()
{
	thread setup_common_hijack_features();
	level.daughter = self;
	self.animname = "daughter";
}

setup_advisor()
{
	thread setup_common_hijack_features();
	level.advisor = self;
	level.advisor.notarget = true;
	level.advisor.animname = "advisor";
	level.advisor gun_remove();
}

setup_president()
{
	thread setup_common_hijack_features();
	level.president = self;
	level.president.notarget = true;
	level.president.animname = "president";
	level.president.force_civilian_stand_run = true;
	level.president maps\hijack_anim::president_setup_anims();
	wait(0.1);
	level.president notify("disable_combat_state_check");
	self.pathTurnAnimOverrideFunc = maps\hijack_anim::president_setup_turn_anims_override;
	
	//level.president.allowdeath = true;
	level.president thread player_damage_to_friendlies();
	//level.president.deathfunction = ::civilian_death;
}

setup_hero_agent_01()
{
	thread setup_common_hijack_features();
	level.hero_agent_01 = self;
	
	//level.hero_agent_01.allowdeath = true;
	level.hero_agent_01 thread player_damage_to_friendlies();
	//level.hero_agent_01.deathfunction = ::agent_death;
}

setup_zerog_agent_01()
{
	thread setup_common_hijack_features();
	level.zerog_agent_01 = self;
	self.animname = "agent1"; 
	self.fixednode = true;
	self.goalradius = 16;
	self enable_cqbwalk();
	self.ignoreSuppression = true;
	self.baseaccuracy = .1;
}

setup_zerog_agent_02()
{
	thread setup_common_hijack_features();
	level.zerog_agent_02 = self;
	self.animname = "agent2"; 
	self.fixednode = true;
	self.goalradius = 16;
	self enable_cqbwalk();
	self.ignoreSuppression = true;
	self.baseaccuracy = .1;
}

setup_crash_agent_1()
{	
	thread setup_common_hijack_features();
	level.crash_agent_1 = self;
	self set_force_color("c");
	self.animname = "crash_agent1";
	self.notarget = true;
}

temp_bullet_shield()
{
	self thread magic_bullet_shield();
}

manage_tail_models()
{
	level endon("planecrash_approaching");
	
	//hide this until we get to the bottom level	
	hide_tail_models();
	
	while(1)
	{
		flag_clear("show_crash_model");
		flag_wait("show_crash_model");
		show_tail_models();
	
		flag_clear("hide_crash_model");
		flag_wait("hide_crash_model");
		hide_tail_models();
	}
}

hide_tail_models()
{
	array_call(level.crash_models, ::hide);
	array_call(level.crash_models, ::NotSolid);
}

show_tail_models()
{
	array_call(level.crash_models,::Show);
	if ( !isdefined(level.setup_crash_models) )
	{
		model_origin = getstruct("hijack_plane_crash_model_origin", "targetname");
		foreach(ent in level.crash_models)
		{
			ent.origin = model_origin.origin;
		}
	
		level.setup_crash_models = true;
	}
	array_call(level.crash_models, ::Solid);
}

setup_turbines()
{
	turbines = getEntArray( "turbine", "targetname" );
	
	foreach(turbine in turbines)
	{
		turbine thread turbine_anim();
	}
}

turbine_anim()
{
	turbine_rig = spawn_anim_model("turbines");
	turbine_rig.origin = self.origin;
	turbine_rig.angles = self.angles;
	turbine_rig anim_first_frame_solo( turbine_rig, "engine_turbine_spin" );
	self linkto( turbine_rig, "J_prop_1" );
	turbine_rig thread anim_loop_solo( turbine_rig, "engine_turbine_spin_loop", "kill_turbines" );
	
	flag_wait( "stop_phones" ); //stops when crash starts
	
	turbine_rig notify( "kill_turbines" );
	waittillframeend;
	
	turbine_rig delete();
	self delete();

}

setup_end_heli_interior()
{
	node = GetStruct("heli_end_node", "targetname");
	level.heli_interior = getEntArray( "heli_interior", "targetname" );
	foreach( object in level.heli_interior )
	{
		//level.heli_interior.origin = node.origin;
		//level.heli_interior.angles = node.angles;
		object hide();	
		object NotSolid();
	}
	
	level.end_cards = getEntArray( "hijack_blurcard_ending", "targetname" );
	foreach( card in level.end_cards )
	{
		card hide();
	}
}
	
