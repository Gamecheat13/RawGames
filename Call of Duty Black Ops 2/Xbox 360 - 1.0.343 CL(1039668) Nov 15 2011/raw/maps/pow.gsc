/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/


#include maps\_utility;
#include common_scripts\utility;
#include maps\pow_utility;
#include maps\_music;
#include maps\_scene;

main()
{ 
	init_vehicle_spawn_num();
	
	// Delete all special ops entities
	maps\_specialops::delete_by_type( maps\_specialops::type_so );

	// This MUST be first for CreateFX!	
	maps\pow_fx::main();
	
	level.mapCenter = (0,0,0);
	SetMapCenter(level.mapCenter);
	
	//-- Production Skipto's
	default_skipto( "rra" );
	add_skipto( "rra",					 ::skipto_rra, 					 		&"POW_SKIPTO_RRA", 			::rr_scene);
	add_skipto( "tunnel_start",  ::skipto_tunnel_start,  		&"POW_SKIPTO_TUNNEL",	 	maps\pow_tunnels::start_tunnel_chase );
	add_skipto( "hind_clearing", ::skipto_clearing, 		 		&"POW_SKIPTO_CLEARING", maps\pow_hind_clearing::start_non_demo);
	add_skipto( "start_in_hind", ::skipto_start_in_chopper, &"POW_SKIPTO_CHOPPER",	maps\pow_hind_fly::start);
	add_skipto( "compound", 		 ::skipto_compound, 				&"POW_SKIPTO_COMPOUND",	maps\pow_compound::compound_main);

	//-- Development only Skipto's
	add_skipto( "dev_rrb",			 				 ::skipto_rr_scene_b);
	add_skipto( "dev_rrc", 							 ::skipto_rr_scene_c);
	add_skipto( "dev_rrd", 							 ::skipto_rr_scene_d);
	add_skipto( "dev_tunnels_noscript",  ::skipto_tunnels_noscript );
	add_skipto( "dev_spetz", 						 ::skipto_spetz_scene);
	add_skipto( "dev_susan",					   ::skipto_susan);
	add_skipto( "dev_compound_noscript", ::skipto_compound_noscript );
	add_skipto( "dev_krav", 					   ::skipto_krav_scene);

	
	
	
	SetSavedDvar( "phys_buoyancy", "1" );	
	
	//-- adjustment just for recruit
	if( GetLocalProfileInt( "g_gameskill" ) == 0 )
	{
		level.invulTime_onShield_multiplier = 0.7;
	}
	
	setup_objectives();

	maps\_load::main();

	init_drones_for_level();
	
	level thread maps\_door_breach::door_breach_init(); //-- there is a wait in this main
	maps\_rusher::init_rusher();
	
	//TODO: MOVE THESE ITEMS -------------
	precache_level_items();
	init_flags();
	generic_level_threads();
	//------------------------------------

	maps\pow_amb::main();
	maps\pow_anim::main();
	
	level thread maps\_objectives::objectives();
}

init_vehicle_spawn_num()
{
	// This is a hack to get POW working with prefab appended vehicle spawn groups
	// Going forward scripters will need to be more careful when using scripted_spawn()
	
	level.vehiclespawngroup = 0;
	veh_hind = GetEnt( "flyable_hind", "targetname" );
	if ( IsDefined( veh_hind.script_vehiclespawngroup ) && veh_hind.script_vehiclespawngroup > 100 )
	{
		level.vehiclespawngroup = Int( veh_hind.script_vehiclespawngroup / 100 ) * 100;
	}
}

precache_level_items()
{
	PreCacheModel("c_usa_jungmar_barnes_pris_fb");
	PreCacheItem("sam_pow_sp");
	PreCacheItem("hind_rockets_sp");
	PreCacheItem("hind_rockets_2x_sp");
	PreCacheItem("hind_rockets_norad_sp");
	PreCacheItem("cz75_krav_death_sp");	
	PreCacheItem("rpg_pow_sp");
	
	// player model for hind flying 
	PreCacheModel("viewmodel_usa_prisoner_player_fullbody");
	PreCacheModel("t5_veh_helo_hind_cockpit_control");
	
	// for destructible pipes
	PreCacheModel("p_jun_pipeline_d0");
	PreCacheModel("p_jun_pipeline_d1");
	PreCacheModel("p_jun_pipeline_d2");
	
	PreCacheModel("p_rus_radar_dish");
	
	PreCacheModel("anim_jun_radio_headset_b");
	PreCacheModel("anim_jun_pow_tent");
	
	PreCacheModel("t5_weapon_coltpython_pow");
	PreCacheModel("anim_cz75_world");
	PreCacheModel("p_pow_cage_lid");
	//PreCacheModel("anim_jun_colt_python");
	PreCacheModel("anim_jun_cleaver");
	PreCacheModel("anim_jun_ak47");
	//PreCacheModel("anim_jun_entrenching_tool");
	PreCacheModel("anim_jun_chair_01");
	PreCacheModel("anim_jun_folding_table");
	PreCacheModel("anim_jun_pipe_weapon");
	
	PreCacheModel("t5_weapon_machete");
	PreCacheModel("t5_knife_animate");
	
	PreCacheShader("white");
	PreCacheShader("flamethrowerfx_color_distort_overlay_bloom");
	
	PreCacheRumble("heartbeat");
	PreCacheRumble("heartbeat_low");
	PreCacheRumble("damage_heavy");
	PreCacheRumble("artillery_rumble");
}

#using_animtree ("fakeShooters");
init_drones_for_level()
{
	maps\_drones::init();
	maps\_drones::drones_set_max( 100 );

	level.drone_spawnFunction["axis"] = character\c_vtn_vc2_drone::main;
	level.drones.death_func = maps\pow_spawnfuncs::drone_powDeath;
	
	PreCacheModel("c_vtn_vc2_fb_drone");
	
	if(!IsDefined(level.ragdoll_bucket))
	{
		level.ragdoll_bucket = [];
	}
		
	//-- the drones are so far away we don't need the sounds
	level.drones.sounds_disabled = 1;

	// custom drone animations
	level.drones.anims[ "idle" ] = [];
	level.drones.anims[ "idle" ][0] = %patrol_bored_idle;
	level.drones.anims[ "idle" ][1] = %patrol_bored_idle_smoke;
	level.drones.anims[ "idle" ][2] = %patrol_bored_idle_cellphone;
	
	// custom drone functions
	level.drones.funcs[ "run_flame" ] = ::drone_run_flame;
}



// 
//	Custom drone function for guys who play a flame death run
drone_run_flame( s_start, v_destination, params )
{
	self SetCanDamage(false); //-- make it so you don't kill the flame death guys early
	self maps\_drones::drone_set_run_cycle( %ai_flame_death_run );
	self.droneRunRate = 100;
	self.running = false; 
	self thread maps\_drones::drone_loop_run_anim(); 
			
	randomAnimRate = undefined; 

	//recalculate the distance to the next point since it changed now
	d = distance( self.origin, v_destination ); 
	speed = ( d / self.droneRunRate ); 
}


#using_animtree ("generic_human");
generic_level_threads()
{
	//-- Meat Shield
	level._meatshield_no_weapon_management = true; //-- the script removes the weapons before _meatshield.gsc does which caused problems
	level._meatshield_gun_offset = 36;
	level.meatshield_damage_override = ::pow_meatshield_damage;
	level.scripted_meatshield = true;
	level thread maps\_meatshield::set_custom_audio_func( ::pow_empty_function );
	level thread maps\_meatshield::main("cz75_meatshield_sp", "viewmodel_usa_pow_arms", maps\pow_anim::init_meatshield_anims, false);
	//level thread maps\_bulletcam::main(); //-- this is seperate from Meat Shield because we do not do the bulletcam as part of the meat shield
		
	//-- disable tank squish which frees up some script vars
	level.noTankSquish = true;
	
	//-- don't allow the random weapon system to drop the flamethrower
	set_random_alt_weapon_drops( "ft", false );
	
	// KevinD( 5/21/2010 ): Remove the master list of structs once to free up script_variables
	
	PrintLn("Saving: " + level.struct.size + " Structs");
	for(i = level.struct.size; i >= 0; i--)
	{
		level.struct[i] = undefined;
	}
	level.struct = undefined;
	
	level.default_sun_samplesize = getdvar( "sm_sunSampleSizeNear");
	//-- Cleans up vehicles and what not behind the player
	level thread cleanup_watcher();
	level.hinds_killed = 0;
	
	//-- for charring characters
	level.ACTOR_CHARRING = 2;
	level.ACTOR_BLEEDING = 3;
	
	//level.allowBattleChatter = true;
	battlechatter_on();
	
	//-- Setup destructible Pipes
	level thread pipes_init("pipe_");
	level thread pipes_init("pipe_depot_");
	level thread pipe_tank_init("pipe_tank_1");
	level thread pow_objectives();
	
	level thread player_setup();
	
	//-- setup some generic spawnfuncs
	level thread unlimited_rpgs();
	
	level.callbackVehicleDamage = ::pow_vehicle_damage;

	thread delaySnapshot();	
	
	//-- Controls the background music in the level based on a flag system
	level thread music_controller();
	
	//-- Color Manager
	level thread maps\_color_manager::color_manager_think();

	//-- Achievement tracking
	level thread pow_flame_achievement();
	all_axis_spawners = GetSpawnerTeamArray( "axis" );
	array_thread( all_axis_spawners, ::add_spawn_function, ::spawn_func_setup_death_thread );
}


delaySnapshot()
{
	wait(1);
	//SOUND: Shawn J - setting snapshot (so hind idle sounds are off until heli start-up)
	clientnotify( "pow_default_snapshot" );
}


player_setup()
{
	wait_for_first_player();
	player = get_players()[0];
	player SetWeaponAmmoClip( "flash_grenade_sp", 0 );
}

init_flags()
{
	//russian_roulette
	flag_init("rr_scene_done");
	
	//tunnels
	flag_init("move_woods_to_split");
	flag_init("spetz_hit");
	flag_init("spetz_fell");
	flag_init("tunnel_chase_started");
	flag_init("woods_done_with_climbup_anim");
	flag_init("bowman_vo_finished");
	
	//clearing
	flag_init("clearing_notified");
	flag_init("woods_already_started_VO");
	flag_init("woods_takeoff_anim");
	flag_init("woods_takeoff_anim_finished");
	
	//compound
	flag_init("woods_landing_animation_done");
	flag_init("to_compound_fight_start");
	flag_init("woods_ready_to_save_pows");
	flag_init("player_started_saving_pows");
	flag_init("player_saved_pows");
	flag_init("woods_saved_pows");
	flag_init("fake_ai_fight");
	
	//objective flags
	flag_init("obj_chase_russian");
	flag_init("obj_russian_start");
	flag_init("obj_chase_russian_complete");
	flag_init("obj_boost_woods");
	flag_init("obj_boost_woods_complete");
	flag_init("obj_kill_hind_crew");
	flag_init("obj_take_hind");
	flag_init("obj_player_in_hind");
	flag_init("obj_fly_to_base");
	flag_init("obj_truck_depot"); //-- set in a trigger
	flag_init("obj_truck_depot_complete");
	flag_init("obj_enemy_hip");
	flag_init("obj_enemy_hip_complete");
	flag_init("obj_sam_cave");
	flag_init("obj_sam_cave_complete");
	flag_init("obj_large_village"); //-- set in a trigger
	flag_init("obj_large_village_complete");
	flag_init("obj_large_boat");
	flag_init("obj_enemy_hind");
	flag_init("obj_enemy_hind_complete");
	flag_init("obj_hind_landing");
	flag_init("obj_to_kravchenko");
	flag_init("obj_player_needs_ft");
	
	//-- other flags
	flag_init("radio_tower_destroyed");
	flag_init("player_on_heli");
	flag_init("village_1_vehicles_spawned");
	flag_init("play_morph");
	flag_init("swap_rez");
	
	//-- flew past objectives
	flag_init( "obj_truck_depot_passed");
	flag_init( "obj_enemy_hip_passed" );
	flag_init( "obj_sam_cave_passed" );
	
	//music control flags
	flag_init("music_takeoff");
	flag_init("music_truckdepotdestroyed");
	flag_init("music_hiptakingoff");
	flag_init("music_hipdestroyed");
	flag_init("music_sameventstarted");
	flag_init("music_sameventfinished");
	flag_init("music_villagefinished");
	flag_init("music_twohinds");
	flag_init("music_twohindsdestroyed");
	
	// vo flags
	flag_init("story_dialog");
	flag_init("extra_dialog");
	flag_init("dmg_dialog");
	flag_init("reload_dialog");
	flag_init("nag_dialog");
	
	flag_init("vo_tank_destroyed");
	flag_init("vo_bend_reached");
	flag_init("vo_napalm_reached");
	flag_init("vo_sam_reached");
	flag_init("vo_sam_close");
	flag_init("vo_hind_fallback");
	flag_init("vo_one_hind_down");
	flag_init("vo_rus_truck_depot_attacked");
	flag_init("vo_radar_destroyed");
}

unlimited_rpgs()
{
	spawners = GetEntArray("rpg_unlimited_ammo", "script_noteworthy");
	array_thread( spawners, ::add_spawn_function, maps\pow_spawnfuncs::unlimited_rpgs );
}

/*------------------------

The beginning event of the level, this is mostly a vignette
but it will trigger the chase through the tunnels, which is the first actual
fight

-------------------------*/

intro_hud_fadeout()
{
	wait(0.15);
		// Fade out black
	self FadeOverTime( 0.5 ); 
	self.alpha = 0; 
	
	wait 0.3;
	self Destroy();
}

rr_scene( a, b, c, d)
{
	introblack = NewHudElem(); 
	introblack.x = 0; 
	introblack.y = 0; 
	introblack.horzAlign = "fullscreen"; 
	introblack.vertAlign = "fullscreen"; 
	introblack.foreground = true;
	introblack SetShader( "black", 640, 480 );
		
	wait_for_first_player();
	
	introblack thread intro_hud_fadeout();
	
	clientnotify( "pow_default_snapshot" );
	//Shawn J - dvar for futz override; awaiting exes
	setsaveddvar("snd_dsp_futz", false); 
	
	//TUEY Temp music state until RR scene is done
	setmusicstate ("INTRO");
	level thread maps\pow_amb::event_heart_beat("sedated");
	level thread maps\pow_amb::heartbeat_controller_intro();
	
	//-- disable buoyancy for tunnel section
	SetSavedDvar("phys_buoyancy", 0);
	SetSavedDvar("phys_ragdoll_buoyancy", 0);
	
	//-- start scene
	sync_struct_a = getstruct("rr_sync_a_struct", "targetname");
	sync_struct = getstruct("rr_sync_struct", "targetname");
	//sync_struct thread rr_temp_dialogue();
	
	player = get_players()[0];
	player SetClientDvar("r_poisonFX_blurMin", 0.11);
	player SetClientDvar("r_poisonFX_blurMax", 0.12);
	player StartPoisoning();
	
	if(!IsDefined(a))
	{
		a = true;
		b = true;
		c = true;
		d = true;
	}
	
	//level thread rr_animate_objects( sync_struct_a, sync_struct, a, b, c, d );
	//level thread rr_animate_player( sync_struct_a, sync_struct, a, b, c, d );
	//level thread rr_animate_ai( sync_struct_a, sync_struct, a, b, c, d );
	level thread russian_roulette( a, b, c, d );
	
	//level waittill("rr_ai_ready");
	//level notify("rr_scene_start");
	
	//SOUND - Shawn J - snapshot & intro audio (cage to table)
	//clientnotify( "pow_rr_intro_snapshot" );
  	playsoundatposition( "evt_rr_intro", (0,0,0) );
	
	flag_wait("rr_scene_done");
}

rr_temp_dialogue()
{
	self notify("kill_temp_dialogue");
	self endon("kill_temp_dialogue");
	
	while( true )
	{
		self waittill( "single anim", msg );
		
		if(msg == "end")
		{
			continue;
		}
		
		if(self.animname != "player_hands")
		{
			if(self.animname == "barnes" && msg == "switch_guns")
			{
				level.woods gun_recall();
			}
		}
		else
		{
			if( msg == "timescale_start")
			{
				SetTimeScale(0.3);
			}
			else if(msg == "timescale_end")
			{
				SetTimeScale(1);
			}
			else if( msg == "slap")
			{
				player = get_players()[0];
				player DoDamage( 50, player.origin );
			}
			else
			{
				//-- nothing
			}
		}
	}
}

russian_roulette( a, b, c, d )
{
	battlechatter_off();
	//show_friendly_names( 0 );
	
	level.player thread take_and_giveback_weapons( "rr_scene_done" );
	level.player.animname = "player";
	
	level.barnes = simple_spawn_single( "barnes_rr_scene" );
	level.woods = level.barnes;
	
	a_vc = simple_spawn( "rr_vc_guys" );
	
	ai_vc_1 = undefined;
	for ( i = 0; i < a_vc.size; i++ )
	{
		ai_vc = a_vc[i];
		
		if( ai_vc.animname == "vc1")
		{
			ai_vc_1 = ai_vc;
			ai_vc_1 Hide();
			break;
		}
	}
	
	trigger_use("color_trig_after_roulette_allies"); //-- set woods color
	
	if ( a )
	{
		level.player thread player_dialog_over_black();
	
		run_scene( "rr_1a_1" );
	
		PhysicsJolt( ( -6395.5, -50462.5, -300 ), 32, 1, VectorScale( AnglesToForward( ( 0, 90, 0 ) ), 0.5) );
		//PhysicsJolt( (-6395.5, -50462.5, -300), 32, 1, vector_scale(AnglesToForward((0, 90, 0)), 0.5));
	
		level.barnes Hide();
	
		run_scene( "rr_1a_2" );
	
		level thread notify_rats( 0.5 );
	
		run_scene( "rr_1a_3" );
		
		level notify( "vs_tunnels" );
		
		if ( IsDefined( level.fadetoblackrr ) )
		{
			level.fadetoblackrr FadeOverTime( 2.0 );
			level.fadetoblackrr.alpha = 0;
		}
	}
	
	level notify( "after_meatshield_dof_change" );
	
	level.player StopPoisoning();
	
	m_bowman = Spawn( "script_model", (0,0,0) );
	m_bowman character\c_usa_jungmar_pow_bowman::main();
	m_bowman.script_animname = "bowman";
	
	level.ai_the_russian = simple_spawn_single( "spetz_rr_scene" );
	
	ai_vc_1 Show();
	
	if ( b )
	{
		playsoundatposition( "evt_deer_hunter", level.player.origin );
		level notify( "at_roullete_table" );
	
		run_scene( "rr_1b" );
	
		level thread notify_bowman_hit_hb();
	
		level.barnes Show();
	
		run_scene( "rr_1b2" );
	}
	
	s_rr_align = getstruct( "rr_sync_struct" );
	v_start_org = GetStartOrigin( s_rr_align.origin, s_rr_align.angles, level.scr_anim["_meatshield:player"]["grab"] );
	v_start_ang = GetStartAngles( s_rr_align.origin, s_rr_align.angles, level.scr_anim["_meatshield:player"]["grab"] );
	level.player.early_contextual_player_hands = spawn_anim_model( "player_hands_contextual_melee", v_start_org, v_start_ang );
	level.player.early_contextual_player_hands Hide();
	
	s_rr_align thread maps\_anim::anim_first_frame( level.player.early_contextual_player_hands, "grab" );
	
	if ( c )
	{
		n_anim_length = GetAnimLength( level.scr_anim[ "player_hands" ]["rr_1c"] );
	
		level thread run_scene( "rr_1c" );
	
		wait( n_anim_length - 2 );
		level notify( "hb_gun_at_head" );
	
		scene_wait( "rr_1c" );
	}

	if ( d )
	{
		level thread run_scene( "rr_1d" );
		
		flag_wait( "rr_1d_started" );
		
		a_prop_array = get_model_or_models_from_scene( "rr_1d" );
		array_thread( a_prop_array, ::freeze_me, "rr_1d" );

		level.ai_bookie = GetEnt( "rr_scene_guys_ai", "targetname" );
	
		ai_vc_5 = GetEnt( "rr_vc_5_ai", "targetname" );
		ai_vc_5 add_meatshield_target( level.ai_bookie );
		ai_vc_5 thread freeze_me( "rr_1d" );
		ai_vc_5 thread disable_react(); //-- keep them from sidestepping on whizbys
		ai_vc_5 thread meatshield_infinite_ammo();
		level thread start_anim_then_end_it_at_meatshield( ai_vc_5, "rr_1d" );
	
		ai_vc_6 = GetEnt( "rr_vc_6_ai", "targetname" );
		ai_vc_6 add_meatshield_target( level.ai_bookie );
		ai_vc_6 thread freeze_me( "rr_1d" );
		ai_vc_6 thread disable_react(); //-- keep them from sidestepping on whizbys
		ai_vc_6 thread meatshield_infinite_ammo();
		level thread start_anim_then_end_it_at_meatshield( ai_vc_6, "rr_1d" );
	
		ai_vc_1 thread ragdoll_death();

		level.ai_bookie thread maps\pow_utility::pow_meatshield_success_fail();
	}
	
	level.player waittill( "_meatshield:done" );
	
	for ( i = 0; i < a_vc.size; i++ )
	{
		ai_vc = a_vc[i];
		
		if ( IsAlive( ai_vc ) )
		{
			ai_vc thread ragdoll_death();
		}
	}
	
	autosave_by_name( "pow_meatshield_end" );
	level.player SetClientDvar( "ammoCounterHide", "0" );	
	level notify( "player_max_ammo" );
	level notify( "clear_dof" );	
	level.ai_the_russian StopAnimScripted();
	level.ai_the_russian set_ignoreme( true );
	
	level.barnes StopAnimScripted();
	
	//show_friendly_names( 1 );
	
	flag_set( "rr_scene_done" );
	level.player notify( "rr_scene_done" );
	
	align_node = getstruct("struct_align_spetz_escape", "targetname");
	level.ai_the_russian ForceTeleport( align_node.origin, align_node.angles );
	align_node thread maps\_anim::anim_first_frame( level.ai_the_russian, "escape");
	
	//TUEY Temp music state until RR scene is done
	setmusicstate( "CAVE_FIGHT" );
	
	if (IsDefined( level.fadetoblackrr ) )
	{
		level.fadetoblackrr Destroy();
	}
	
	battlechatter_on();
	
	flag_set( "obj_chase_russian" );
	
	wait 0.1;
	
	level.player SwitchToWeapon( "ak47_sp" );
}

#using_animtree ("animated_props");
rr_animate_objects( sync_node_a, sync_node, a, b, c, d )
{
	/*
	props_array = [];
	props_array[0] = spawn_anim_model("rr_cleaver", (0,0,0));
	props_array[1] = spawn_anim_model( "rr_roulettegun", (0,0,0) );
	props_array[2] = spawn_anim_model( "rr_otherchair", (0,0,0) );
	props_array[3] = spawn_anim_model("rr_playerchair", (0,0,0));
	props_array[4] = spawn_anim_model( "rr_table", (0,0,0) );
	*/
	
	//level waittill("rr_scene_start");
	
	if(a)
	{
		
		//level waittill("rr_scene_a_1_done");
		
		//lid = spawn_anim_model( "rr_cage_lid", (0,0,0) );
		//sync_node_a maps\_anim::anim_single_aligned( lid, "rr_1a_2");
		//level waittill("rr_scene_a_done");
		//lid Delete();
	}
	//props_array[5] = spawn_anim_model("rr_shovel", (0,0,0));
	
	//level waittill( "continue_rr" );
	
	/*
	props_array = [];
	props_array[0] = level.prop_array[ "rr_cleaver" ];
	//props_array[1] = level.prop_array[ "rr_roulettegun" ];
	props_array[1] = level.prop_array[ "rr_otherchair" ];
	props_array[2] = level.prop_array[ "rr_playerchair" ];
	props_array[3] = level.prop_array[ "rr_table" ];
	props_array[4] = level.prop_array[ "rr_shovel" ];
	*/
	
	if(b)
	{
		//sync_node maps\_anim::anim_single_aligned( props_array, "rr_1b");
		//sync_node maps\_anim::anim_single_aligned( props_array, "rr_1b2");
	}
		
	//props_array[6] = spawn_anim_model("rr_ak47", (0,0,0));
	//props_array[7] = spawn_anim_model( "rr_bookiegun", (0,0,0) );
		
	if(c)
	{
		//sync_node maps\_anim::anim_single_aligned( props_array, "rr_1c");
	}
	
	//gun = props_array[1];
	//props_array = array_remove( props_array, props_array[1] );
	//gun Delete();
	
	//array_thread( props_array, ::freeze_me, "rr_1d" );
	if(d)
	{
		//sync_node maps\_anim::anim_single_aligned( props_array, "rr_1d");
	}
	
	//props_array[0] Delete(); //-- delete the knife
}

#using_animtree ("generic_human");
rr_animate_ai( sync_node_a, sync_node, a, b, c, d )
{
	scene_actors = simple_spawn("rr_scene_guys");
	bookie = undefined;
	
	for(i = 0; i < scene_actors.size; i++ )
	{
		if(scene_actors[i].animname == "bookie")
		{
			level.bookie = scene_actors[i];
			level thread rr_animate_bookie( sync_node_a, sync_node, a, b, d, c, scene_actors[i] );
			scene_actors = array_remove(scene_actors, scene_actors[i]);
		}
	}
	
	//barnes = simple_spawn_single("barnes_rr_scene");
	//level.barnes = barnes;
	//level.woods = barnes; //-- this is sloppy but keeps from having to change a bunch of other script
	//level.woods gun_remove();
		
	//trigger_use("color_trig_after_roulette_allies"); //-- set woods color
	
	//level waittill( "first_scene_started" );
	
	//barnes = level.barnes;
	//vc = level.vc;
	
	//scene_actors = array_add(scene_actors, barnes);
	
	//vc = simple_spawn("rr_vc_guys");
	
	//scene_actors = array_combine(scene_actors, vc);
	
	/*
	bowman = Spawn("script_model", (0,0,0));
	bowman character\c_usa_jungmar_pow_bowman::main();
	bowman useAnimTree( #animtree );
	bowman.animname = "bowman";
	*/
	
	//level notify("rr_ai_ready");
	//level waittill("rr_scene_start");
	
	/*
	vc1 = undefined;
	for(i = 0; i < vc.size; i++)
	{
		if(vc[i].animname == "vc1")
		{
			vc1 = vc[i];
			break;
		}
	}
	*/
		
	//array_thread(scene_actors, ::rr_temp_dialogue);
	if(a)
	{
		//sync_node_a maps\_anim::anim_single_aligned(scene_actors, "rr_1a");
		//sync_node_a maps\_anim::anim_single_aligned(scene_actors, "rr_1a_1"); //-- look at woods
		
		//-- remove barnes and vc1 
		//scene_actors = array_remove(scene_actors, barnes);
		//barnes Hide();
		//scene_actors = array_remove(scene_actors, vc1);
		//vc1 Hide();
		//sync_node_a maps\_anim::anim_single_aligned(scene_actors, "rr_1a_2"); //-- pull from cage
		level waittill( "continue_rr" );
		//sync_node_a maps\_anim::anim_single_aligned(scene_actors, "rr_1a_3"); //-- dragged
	}
	
	/*
	barnes Show();
	barnes gun_remove();
	vc1 Show();
	vc1 set_ignoreme(true);
	
	scene_actors = array_add(scene_actors, barnes);
	scene_actors = array_add(scene_actors, vc1);
	
	level.russian = simple_spawn_single( "spetz_rr_scene" );
	level.russian gun_remove();
	scene_actors = array_add(scene_actors, level.russian);
	
	//-- swap out actors
	//scene_actors = array_add(scene_actors, bowman);
	
	
	vc5 = simple_spawn_single("rr_vc_5");
	vc5 set_ignoreme(true);
	scene_actors = array_add(scene_actors, vc5);
	vc6 = simple_spawn_single("rr_vc_6");
	vc6 set_ignoreme(true);
	scene_actors = array_add(scene_actors, vc6);
	
	
	array_thread(scene_actors, ::rr_temp_dialogue);
	if(b)
	{
		sync_node maps\_anim::anim_single_aligned(scene_actors, "rr_1b");
		sync_node maps\_anim::anim_single_aligned(scene_actors, "rr_1b2");
	}
	
	if(c)
	{
		sync_node maps\_anim::anim_single_aligned(scene_actors, "rr_1c");
	}
	
	kill_array = [];
	for( i = 0; i < scene_actors.size; i++ )
	{
		if(IsSubStr(scene_actors[i].animname, "vc" ) && (scene_actors[i].animname == "vc5" || scene_actors[i].animname == "vc6"))
		{
			
			scene_actors[i] add_meatshield_target(level.bookie);
			scene_actors[i] thread freeze_me( "rr_1d" );
			scene_actors[i] thread disable_react(); //-- keep them from sidestepping on whizbys
			scene_actors[i] thread meatshield_infinite_ammo();
			scene_actors[i] set_ignoreme(false);
			sync_node thread start_anim_then_end_it_at_meatshield( scene_actors[i], "rr_1d" );
		}
		else if( scene_actors[i].animname == "vc2" ) //-- This is the one that Woods kills
		{
			scene_actors[i] thread freeze_me( "rr_1d" );
			scene_actors[i] gun_remove();
			scene_actors[i].ignoreme = true;
			scene_actors[i].dropweapon = 0;
			sync_node thread maps\_anim::anim_single_aligned(scene_actors[i], "rr_1d");
		}
		else if(scene_actors[i].animname == "vc1" || scene_actors[i].animname == "vc3" || scene_actors[i].animname == "vc4")
		{
			scene_actors[i] gun_remove();
			scene_actors[i].dropweapon = 0;
			kill_array = array_add(kill_array, scene_actors[i]);
		}
	}
	
	array_thread(kill_array, ::ragdoll_death);
	
	
	//-- Remove the VC from the scene array so that they can fight the player
	scene_actors = [];
	scene_actors[0] = barnes;
	scene_actors[1] = level.russian;
	level.russian gun_remove();
	
	array_thread( scene_actors, ::rr_temp_dialogue);
	if(d)
	{
		array_thread( scene_actors, ::freeze_me, "rr_1d" );
		sync_node thread maps\_anim::anim_single_aligned(scene_actors, "rr_1d");
	}
	
	level waittill("player_done_with_meatshield");
	barnes StopAnimScripted();
	level.russian StopAnimScripted();
	
	//wait(0.1);
	player = get_players()[0];
	flag_set("rr_scene_done");
	player notify("rr_scene_done");
			
	//level.russian thread maps\pow_tunnels::russian_color_chain();
	align_node = getstruct("struct_align_spetz_escape", "targetname");
	level.russian ForceTeleport( align_node.origin, align_node.angles );
	align_node thread maps\_anim::anim_first_frame( level.russian, "escape");
	
	//-- some russian setup
	flag_set( "obj_chase_russian" );
	level.russian set_ignoreme( true );
	
	wait(0.1);//-- This delay was actually necessary for something
	player SwitchToWeapon("ak47_sp");
	*/
}

meatshield_infinite_ammo()
{
	self endon("death");
	
	while(1)
	{
		self.bulletsinclip = WeaponClipSize(self.weapon);
		wait(0.05);
	}
}

freeze_me(scene_name)
{
	self endon( "death" );
	
	str_animname = self.animname;
	level waittill("freeze_everyone");
	
	self SetFlaggedAnimLimited( "single anim", level.scr_anim[ self.animname ][ scene_name ], 1, 0, 0 );
	self thread rr_temp_dialogue();
	
	level waittill("unfreeze_everyone");
	
	self SetFlaggedAnimLimited( "single anim", level.scr_anim[ self.animname ][ scene_name ], 1, 0, 1 );
	self thread rr_temp_dialogue();
	
}

rr_animate_bookie( sync_node_a, sync_node, a, b, c, d, bookie )
{
	Assert( IsDefined( bookie), "Can't find the bookie for the russian roulette scene" );
	bookie gun_remove();
	
	level waittill("rr_scene_start");
	
	bookie thread rr_temp_dialogue();
	bookie.dropweapon = 0;
	
	if(a)
	{
		level waittill("rr_scene_a_done");
	}
	if(b)
	{
		sync_node maps\_anim::anim_single_aligned(bookie, "rr_1b");
		sync_node maps\_anim::anim_single_aligned(bookie, "rr_1b2");
	}
	if(c)
	{
		sync_node maps\_anim::anim_single_aligned(bookie, "rr_1c");
	}
	if(d) //-- start meatshield
	{
		waittillframeend;
		bookie maps\pow_utility::pow_meatshield_success_fail();
	}
}

#using_animtree ("player");

player_dialog_over_black() //-- self == player
{
	level waittill("first_fade_to_black");
	wait(0.9);
	self maps\_anim::anim_single( self, "narration_1a");
	self thread maps\_anim::anim_single( self, "narration_1");
}

rr_animate_player( sync_node_a, sync_node, a, b, c, d )
{
	//russian_roulette();
	//player_body = level.player_body;
	//player = level.player;
	//show_friendly_names( 0 );
	
	//player = get_players()[0];
	//player_body = spawn_anim_model( "player_hands", (0,0,0) );
		
	//player thread take_and_giveback_weapons("rr_scene_done");
	//player PlayerLinkToAbsolute(player_body, "tag_player");
	//player_body thread rr_temp_dialogue();
	//level waittill("rr_scene_start");
	
	//battlechatter_off();
	
	if(a)
	{
		//player = get_players()[0];
		//player.animname = "player";
		//player thread player_dialog_over_black();
			
		//sync_node_a maps\_anim::anim_single_aligned(player_body, "rr_1a");
		//sync_node_a maps\_anim::anim_single_aligned(player_body, "rr_1a_1");
		//level notify("rr_scene_a_1_done");
				
		//push the physics light above the table
		//push_pos = getstruct("struct_light_push", "targetname");
		//PhysicsJolt( (-6395.5, -50462.5, -300), 32, 1, vector_scale(AnglesToForward((0, 90, 0)), 0.5));
		//sync_node_a maps\_anim::anim_single_aligned(player_body, "rr_1a_2");
		//level thread notify_rats(0.1);
		//sync_node_a maps\_anim::anim_single_aligned(player_body, "rr_1a_3");
		//level notify("rr_scene_a_done");
		//level notify("vs_tunnels");
		
		//if(IsDefined(level.fadetoblackrr))
		//{
		//	level.fadetoblackrr FadeOverTime( 2.0 );
		//	level.fadetoblackrr.alpha = 0;
		//}
	}
	
	//level notify("after_meatshield_dof_change");
	
	//player StopPoisoning();
	
	if(b)
	{
		//play the sound for the scene
		//playsoundatposition("evt_deer_hunter", player.origin);
		//level notify("at_roullete_table");
		//sync_node maps\_anim::anim_single_aligned(player_body, "rr_1b");
		//level thread notify_bowman_hit_hb();
		//sync_node maps\_anim::anim_single_aligned(player_body, "rr_1b2");
	}
	
	/*
	player = get_players()[0];

	align_ent = getstruct("rr_sync_struct");
	start_org = GetStartOrigin(align_ent.origin, align_ent.angles, level.scr_anim["_meatshield:player"]["grab"] );
	start_ang = GetStartAngles(align_ent.origin, align_ent.angles, level.scr_anim["_meatshield:player"]["grab"] );
	player.early_contextual_player_hands = spawn_anim_model( "player_hands_contextual_melee", start_org, start_ang );
	player.early_contextual_player_hands Hide();

	align_ent thread maps\_anim::anim_first_frame( player.early_contextual_player_hands, "grab"); 
	*/
	
	if(c)
	{
		//anim_length = GetAnimLength(level.scr_anim[player_body.animname]["rr_1c"]);
		//sync_node thread maps\_anim::anim_single_aligned(player_body, "rr_1c");
		//wait(anim_length - 2);
		//level notify("hb_gun_at_head");
		//sync_node waittill("rr_1c");
	}
	
	//player_body Delete();

	/*	
	player = get_players()[0];
	player waittill("_meatshield:done");
	autosave_by_name( "pow_meatshield_end" );
	player SetClientDvar( "ammoCounterHide", "0" );	
	level notify("player_max_ammo");
	level notify("player_done_with_meatshield");
	level notify("clear_dof");
	show_friendly_names( 1 );
	*/
	//level notify("after_meatshield_dof_change"); // already commented
	
	//TUEY Temp music state until RR scene is done
	//setmusicstate ("CAVE_FIGHT");
	
	/*
	if(IsDefined(level.fadetoblackrr))
	{
		level.fadetoblackrr Destroy();
	}
	
	battlechatter_on();
	*/
}

notify_bowman_hit_hb()
{
	wait(3);
	level notify("hb_bowman_hit");
	wait(10);
	level notify("woods_at_table");
}

notify_rats(delay)
{
	wait(delay);
	level notify("rat_01_start");
}

music_delay()
{
	wait (2);
	//TUEY INTRO music state
	setmusicstate("CLEARING_INTRO");

}


start_anim_then_end_it_at_meatshield( actor, anim_str ) //-- self is the align node
{
	//self thread maps\_anim::anim_single_aligned( actor, anim_str );
	level.ai_bookie waittill("_meatshield:start");
	
	wait(1.0);
	
	actor StopAnimScripted();
	actor.goalradius = 12;
	actor SetGoalPos( actor.origin );
	
	//-- Link me to something so I don't stand on the bench
	linker = Spawn("script_origin", actor.origin);
	actor LinkTo(linker);
	actor waittill("death");
	linker Delete();
}


/*----------------------------------

	SKIPTOS: PRODUCTION

----------------------------------*/


skipto_rra()
{
	skipto_setup();
}

skipto_tunnel_start()
{
	wait_for_first_player();
	skipto_setup();
	
	player_warpto_struct("player_warpto_tunnel_start");
	
	//SOUND: Shawn J - setting snapshot
	clientnotify( "low_ext_amb_snapshot" );
	
	level.woods = simple_spawn_single("barnes_rr_scene");
	warp_point = getstruct("woods_warpto_tunnel_start");
	level.woods ForceTeleport(warp_point.origin, warp_point.angles);
	trigger_use("color_trig_after_roulette_allies");
	
	level thread notify_delay("clear_dof", 1);
}


skipto_clearing()
{
	wait_for_first_player();
	skipto_setup();
	
	level thread music_delay();
	
	player = get_players()[0];
	
	
	player setorigin((-6417.9, -44592.1, -126));
	new_player_angles = (0, player.angles[1], player.angles[2]);
	player SetPlayerAngles( new_player_angles );
	player set_ignoreme(true);

	level.barnes = simple_spawn_single("demo_barnes_spawner" );
	level.woods = level.barnes;
	level.barnes set_ignoreall(true);
	level.barnes set_ignoreme(true);
	level.barnes forceteleport((-6417.9, -44652.1, -126));
	
		//level thread maps\pow_hind_clearing::start();
	//maps\pow_hind_clearing::start_non_demo();
	
	//SOUND: Shawn J - setting snapshot (so hind idle sounds are off until heli start-up)
	thread clientnotify_delay( "pow_default_snapshot", 1 );
	
}


skipto_start_in_chopper()
{
	wait_for_first_player();
	skipto_setup();
	
	player_warpto_struct("start_in_chopper_struct");
	
	//SOUND: Shawn J - setting snapshot
	clientnotify( "low_ext_amb_snapshot" );
	
	jumpto_objective = 3; //-- objective after stealing the hind
	//level thread pow_update_objectives(jumpto_objective);
	
	level.hind = maps\_vehicle::scripted_spawn(level.vehiclespawngroup + 30)[0];
	Assert( IsDefined(level.hind), "THE HIND IS NOT DEFINED AND THE LEVEL JUST BROKE!");
	level.hind maps\pow_hind_clearing::init_hind();
	
	maps\pow_hind_clearing::clearing_enter_chopper();
}


skipto_compound()
{
	wait_for_first_player();
	skipto_setup();
	
	player = get_players()[0];

	get_players()[0] setorigin((34864, 56856, 552));
	level.woods = simple_spawn_single("woods_compound_spawner");
	level.woods forceteleport((34964, 56856, 552));
	
	enable_random_alt_weapon_drops();
	set_random_alt_weapon_drops( "ft", false );
	
	wait 4;
}

/*----------------------------------

	SKIPTOS: DEVELOPMENT

----------------------------------*/

skipto_rr_scene_d()
{
	rr_scene(false, false, false, true);
}

skipto_rr_scene_c()
{
	rr_scene(false, false, true, true);
}

skipto_rr_scene_b()
{
	rr_scene(false, true, true, true);
}


skipto_tunnels_noscript()
{
	wait_for_first_player();
	
	player_warpto_struct("player_tunnels");
	
}


skipto_compound_noscript()
{
	wait_for_first_player();
	
	player_warpto_struct("player_compound");
}

skipto_krav_scene()
{
	wait_for_first_player();
	
	level thread maps\_gameskill::setSkill( true, 3 ); //-- should make it veteran
	
	double_hind = GetEntArray( "hind_for_last_battle", "targetname" );
	array_delete( double_hind );
		
	level.woods = simple_spawn_single("barnes_rr_scene");
	flag_wait( "starting final intro screen fadeout" );
	
	if(IsSubStr(level.woods GetAttachModelName(0), "head"))
	{
		level.woods Detach(level.woods.headmodel);
		level.woods SetModel("c_usa_jungmar_barnes_pris_fb");
	}
	
	player_warpto_struct( "struct_krav_door");
	
	player = get_players()[0];
	player waittill("door_breached");
	
	level.hind = maps\_vehicle::scripted_spawn( level.vehiclespawngroup + 15 )[0]; //-- other hind
	level.hind MakeVehicleUsable();
	
	Assert(IsDefined(level.hind), "The HInd is not defined in this jumpto");
	
	level thread maps\pow_compound::play_endfight_animation();
	wait(1);
	level notify("vs_tunnels");
	/*
	player FreezeControls(true);
	player EnableInvulnerability();
	
	wait(0.05);
	
	//level maps\pow_compound::play_fade_map_picture();
	//level maps\pow_compound::play_fade_woods_dead();
	//level maps\pow_compound::play_fade_getting_out();
	//level maps\pow_compound::play_fade_in_helicopter();
	
	player FreezeControls(false);
	*/
	//nextmission();
}

skipto_spetz_scene()
{
	wait_for_first_player();
	
	//SOUND: Shawn J - setting snapshot
	clientnotify( "low_ext_amb_snapshot" );
	
	//spetz_spawner = GetEnt( "spetz_escape_spawner", "targetname");
	//spetz = spetz_spawner DoSpawn();
	spetz = simple_spawn_single( "spetz_escape_spawner" );
	
	level.woods = simple_spawn_single("barnes_rr_scene");
	warp_point = getstruct("woods_warp_spetz_scene");
	level.woods ForceTeleport(warp_point.origin, warp_point.angles);
	
	flag_wait( "starting final intro screen fadeout" );
	wait(3);
	
	player_warpto_struct( "player_warp_spetz_scene" );
	
	level thread maps\pow_tunnels::spetz_escape_scene( spetz );
}



skipto_susan()
{
	wait_for_first_player();
	player_warpto_struct("start_in_chopper_struct");
	
	//SOUND: Shawn J - setting snapshot
	clientnotify( "no_ext_amb_snapshot" );
	
	level.hind = maps\_vehicle::scripted_spawn(level.vehiclespawngroup + 30)[0];
	Assert( IsDefined(level.hind), "THE HIND IS NOT DEFINED AND THE LEVEL JUST BROKE!");
	level.hind maps\pow_hind_clearing::init_hind();
	
	//-- make the player the driver of the vehicle
	player = get_players()[0];
	level.hind UseBy(player);
	//level.hind MakeVehicleUnusable();
	
	level.hind.lockheliheight = true;
	
	//-- turn on the hinds controls
	level.hind.tut_hud["fly_controls"] = false;
	level.hind.tut_hud["gun_controls"] = true;
	level.hind.tut_hud["rocket_controls"] = true;
	level.hind maps\_hind_player::create_tutorial_hud( true );
	level.hind maps\_hind_player::enable_driver_weapons();
	
	level.hind maps\pow_hind_fly::init_hind_flight_dvars_flying();
}


skipto_setup()
{
	if (level.skipto_point == "rra")
		return;
	//>----------------------------------------------------------------------------------------------------
	
	flag_set( "obj_chase_russian" );
	
	if (level.skipto_point == "tunnel_start" )
		return;
	//>----------------------------------------------------------------------------------------------------
		
	flag_set("obj_chase_russian");
	flag_set("obj_russian_start");
	flag_set("spetz_hit");
	flag_set("obj_chase_russian_complete");
	flag_set("obj_boost_woods");
	flag_set("obj_boost_woods_complete");
	flag_set("woods_done_with_climbup_anim");
	flag_set("obj_kill_hind_crew");
	
	level thread maps\pow_tunnels::tunnel_cleanup_after_fork();
	trigger_use("tunnel_cleanup_sides");
	level thread delay_thread(1, ::trigger_use, "tunnel_exit", "script_noteworthy");
	
	if (level.skipto_point == "hind_clearing")
		return;
	//>----------------------------------------------------------------------------------------------------
	
	flag_set("obj_take_hind");		
	
	if (level.skipto_point == "start_in_hind")
		return;
	//>----------------------------------------------------------------------------------------------------
	
	flag_set("obj_player_in_hind");
	flag_set("obj_fly_to_base");
	flag_set("obj_truck_depot"); //-- set in a trigger
	flag_set("obj_truck_depot_complete");
	flag_set("obj_enemy_hip");
	flag_set("obj_enemy_hip_complete");
	flag_set("obj_sam_cave");
	flag_set("obj_sam_cave_complete");
	flag_set("obj_large_village"); //-- set in a trigger
	flag_set("obj_large_village_complete");
	flag_set("obj_large_boat");
	flag_set("obj_enemy_hind");
	flag_set("obj_hind_landing");
	flag_set("obj_enemy_hind_complete");
	
	if (level.skipto_point == "compound")
		return;
}
