#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_sandstorm;
#include maps\payback_util;
#include maps\payback_sandstorm_code;
#include maps\payback_env_code;

main()
{
	maps\createart\payback_art::main();
	maps\payback_fx::main();
	maps\payback_aud::main();
	
		
	init_payback_flags();
	init_assets();
	
	maps\payback_anim::payback_vehicle_anim_overrides();
	
	add_hint_string( "Payback_Dont_Abandon_Mission", &"PAYBACK_DONT_ABANDON_MISSION", maps\payback_1_script_a::HasPlayerReturnedToCompound );
	add_hint_string( "chopper_zoom_hint", &"REMOTE_CHOPPER_GUNNER_ZOOM_HINT", maps\payback_1_script_d::Should_Not_Display_Zoom_Hint );
	
	level.cosine = [];
	level.cosine[ "5" ] = cos( 5 );
	level.cosine[ "10" ] = cos( 10 );
	level.cosine[ "15" ] = cos( 15 );
	level.cosine[ "20" ] = cos( 20 );
	level.cosine[ "25" ] = cos( 25 );
	level.cosine[ "30" ] = cos( 30 );
	level.cosine[ "35" ] = cos( 35 );
	level.cosine[ "40" ] = cos( 40 );
	level.cosine[ "45" ] = cos( 45 );
	level.cosine[ "55" ] = cos( 55 );
	
	define_loadout( "payback" );
	define_introscreen("payback");

	maps\_drone_ai::init();
	
	maps\_breach::main(); 
	maps\_breach_explosive_left::main();
	
	maps\_load::main();
	
	maps\_flare_no_sunchange_pb::main( "tag_flash" );
	
	sandstorm_skybox_hide();
	
	level.payback_breach = 1;
	
	// have to set for dog attack - change model as desired (w/CSV change as well)
	//maps\_load::set_player_viewhand_model( "viewhands_player_usmc" );
	maps\_load::set_player_viewhand_model( "viewhands_player_yuri" );
	//maps\_stealth::main();
	//thread maps\_stealth_utility::disable_stealth_system();
	flag_set( "payback_stealth_ready" );
	
	maps\payback_anim::main();
	
	if ( !IsDefined( level.no_breach ) )
	{
		maps\_slowmo_breach_payback::slowmo_breach_init();
	}
	
	trigger_off( "breach_save_trig_1" , "targetname" );
	trigger_off( "breach_save_trig_2" , "targetname" );
	trigger_off( "ready_to_pick_up_niko_save_trig" , "targetname" );
	
	compound_turret1 = GetEnt( "compound_turret1" , "targetname" );
	compound_turret1 MakeUnusable();
	
	militia_window_mg = GetEnt( "militia_window_mg" , "targetname" );
	militia_window_mg MakeUnusable();
		
	militia_window_mg2 = GetEnt( "militia_window_mg2" , "targetname" );
	militia_window_mg2 MakeUnusable();
	
	street_run_anim_check_triggers = GetEntArray( "street_run_anim_check_triggers", "script_noteworthy" );
	foreach ( trigger in street_run_anim_check_triggers )
	{
		trigger trigger_off();
	}
	
	sslight_01 = GetEnt( "sslight_01" , "targetname" );
	sslight_01 SetLightIntensity( 0 );
		
	street_light_gate = GetEnt( "street_light_gate" , "targetname" );
	street_light_gate SetLightIntensity( 0 );

	// Setup standard spawn functions
	setup_spawn_funcs();
		
	//Temp vision set as Roadkill, worldspawn sun is also set to roadkill
	maps\_utility::vision_set_fog_changes( "payback", 0 );
	
	// For testing/debugging purposes only.. should not be called here. should be called by each section that uses the sandstorm
	//thread blizzard_level_transition_light(0);
	//thread blizzard_level_transition_med( 0 );
	
	price_spawner = getEnt( "price", "script_noteworthy" );
	price_spawner add_spawn_function( ::setup_price );	
	
	soap_spawner = getEnt( "soap", "script_noteworthy" );
	soap_spawner add_spawn_function( ::setup_soap );

/*	
	kruger_spawner = getEnt( "kruger", "script_noteworthy" );
	kruger_spawner add_spawn_function( ::setup_kruger );
*/	
	nikolai_spawner = getEnt( "nikolai", "script_noteworthy" );
	nikolai_spawner add_spawn_function( ::setup_nikolai );
	
	hannibal_spawner = getEnt( "hannibal" , "script_noteworthy" );
	hannibal_spawner add_spawn_function( ::setup_hannibal );
	
	barracus_spawner = getEnt( "barracus" , "script_noteworthy" );
	barracus_spawner add_spawn_function( ::setup_barracus );
	
	murdock_spawner = getEnt( "murdock" , "script_noteworthy" );
	murdock_spawner add_spawn_function( ::setup_murdock );
	
	level.friendly_startup_thread = ::assign_friendlies;
	
// 	run_thread_on_targetname( "burning_trash_fire", maps\payback_util::burning_trash_fire );	
	
	init_objectives();
	
	tv_triggers = GetEntArray( "tv_trigger", "targetname" );
	foreach ( tv_trig in tv_triggers )
	{
		// script_noteworthy e.g.: "london_football"
		// script_parameters e.g.: "scn_london_soccer_tv_loop"
		tv_trig thread tv_trigger_wait_enter( tv_trig.script_noteworthy, tv_trig.script_parameters );
	}
	
	thread maps\payback_env_code::handle_spawning_of_sandstorm_models();
	
	blocker_vols = GetEntArray("construction_roof_blocker_volume","targetname");
	blocker_vols[blocker_vols.size] = GetEnt("construction_roof_blocker_volume_during_anim","targetname");
	foreach(vol in blocker_vols)
	{
		vol NotSolid();
		vol ConnectPaths();
	}
	
	// End mission vista model invisible by default
	GetEnt("pb_end_vista", "targetname") Hide();
	
	//  Hide compound exit vista at map start
	GetEnt("compoundexit_vista", "targetname") Hide();
	
	// Deleting assets that are for spec ops
	so_assets = GetEntArray( "so_asset", "targetname" );
	foreach(so_asset in so_assets)
	{
		so_asset Delete();
	}
}

init_objectives()
{
	objective_add( obj( "obj_kruger" ), "invisible", &"PAYBACK_OBJ_KRUGER" );
	//objective_add( obj( "obj_follow" ), "invisible", &"PAYBACK_OBJ_FOLLOW" );
	//objective_setpointertextoverride( obj( "obj_follow" ), &"PAYBACK_FOLLOW" );
	objective_add( obj( "obj_primary_lz" ), "invisible", &"PAYBACK_OBJ_PRIMARY_LZ" );
	objective_add( obj( "obj_secondary_lz" ), "invisible", &"PAYBACK_OBJ_SECONDARY_LZ" );
	objective_add( obj( "obj_find_chopper" ), "invisible", &"PAYBACK_OBJ_FIND_CHOPPER" );
	objective_add( obj( "obj_rescue" ), "invisible", &"PAYBACK_OBJ_RESCUE" );
	//objective_add( obj( "obj_escape" ), "invisible", &"PAYBACK_OBJ_ESCAPE" );
}

init_payback_flags()
{
	// general purpose flags
	flag_init( "payback_stealth_ready" );
	// section specific flags
	maps\payback_compound::init_flags_compound();
	maps\payback_1_script_e::kruger_interrogation_init();
	maps\payback_streets_const::init_construction_flags();
	maps\payback_streets::init_flags_streets();
	maps\payback_rescue::init_flags_rescue();
}

init_assets()
{
	precacheitem("m4m203_acog_payback");
	PreCacheItem( "deserteagle" );
	PreCacheItem( "remote_chopper_gunner" );
	PreCacheItem( "scuba_mask_on" );
	PreCacheItem( "scuba_mask_off" );
	PreCacheItem( "hind_12.7mm" );
	PreCacheItem( "zippy_rockets" );
//	PreCacheShader( "mtl_viewmodel_pmc_glove" );
//	PreCacheShader( "mtl_viewmodel_pmc_sleeve" );
//	PreCacheShader( "mtl_viewmodel_pmc_tattoo" );
	PreCacheModel( "prop_sas_gasmask" );
	PreCacheModel( "pb_gas_mask_prop" );
	PreCacheModel( "projectile_us_smoke_grenade" );
	PreCacheModel( "generic_prop_raven" );
	PreCacheModel( "weapon_beretta" );
	PreCacheModel( "weapon_desert_eagle_tactical" );
	PreCacheModel( "payback_vehicle_hind" );
	PreCacheModel( "payback_const_rappel_rope" );
	PreCacheModel( "payback_const_rappel_rope_obj" );
	//PreCacheModel( "viewhands_player_usmc" );
	PreCacheModel( "viewhands_player_yuri" );
	PreCacheModel( "viewhands_yuri" );
	PreCacheModel( "payback_escape_debris" );
	PreCacheModel( "pb_sstorm_chopper_rescue_propeller" );
	PreCacheModel( "pb_sstorm_chopper_rescue_tail_anim" );
	PreCacheModel( "viewlegs_generic" );
	PreCacheModel( "tag_flash" );
	PreCacheModel( "com_flashlight_on" );
	PreCacheModel( "com_flashlight_off" );
	PreCacheModel( "weapon_frame_charge_iw5_water" );
	PreCacheModel( "hjk_laptop_animated" );
	PreCacheModel( "pb_weapon_casing_closed" );
	PreCacheModel( "pb_weapon_casing_closed_splatter" );
	PreCacheModel( "com_clipboard_wpaper" );
	PreCacheModel( "hjk_cell_phone_off" );
	PreCacheModel( "pb_door_breach" );
	PreCacheModel( "pb_grenade_smoke" );
	PreCacheModel( "pb_door_breach_anim" );
	PreCacheModel( "pb_door_breach_hinge_anim" );
	PreCacheModel( "com_plasticcase_beige_big_us_dirt_animated" );
	PreCacheModel( "pb_heli_crash_rappel_debris" );
	PreCacheModel( "payback_sstorm_dwarf_palm" );
	PreCacheModel( "payback_foliage_tree_palm_med_1" );
    PreCacheModel( "pb_sstorm_tree_jungle" );
    PreCacheModel( "payback_sstorm_grass" );
    PreCacheModel( "com_square_flag_green" );
    PreCacheModel( "highrise_fencetarp_08" );
    PreCacheModel( "highrise_fencetarp_01" );
    PreCacheModel( "highrise_fencetarp_03" );
    PreCacheModel( "payback_const_crates" );
    PreCacheModel( "payback_studwall_collapse" );
    PreCacheModel( "pb_gate_chain" );
    PreCacheModel( "mil_emergency_flare" );
    PreCacheModel( "hat_price_africa" );
    PreCacheModel( "fullbody_price_africa_assault_a_nohat" );
    PreCacheModel( "vehicle_pickup_technical_pb_rusted" );
	precacheShader( "javelin_overlay_grain" );
	precacheShader( "nightvision_overlay_goggles" );
	PreCacheShader( "veh_hud_target_chopperfly" );
	PreCacheShader( "veh_hud_target_chopperfly_offscreen" );
	PreCacheShader( "veh_hud_target_offscreen" );
	PreCacheShader( "remote_chopper_hud_reticle" );
	PreCacheShader( "remote_chopper_hud_target_hit" );
	PreCacheShader( "remote_chopper_hud_target_enemy" );
	PreCacheShader( "remote_chopper_hud_target_e_vehicle" );
	PreCacheShader( "remote_chopper_hud_target_friendly" );
	PreCacheShader( "remote_chopper_hud_target_player" );
	PreCacheShader( "remote_chopper_hud_targeting_frame" );
	PreCacheShader( "remote_chopper_hud_targeting_bar" );
	PreCacheShader( "remote_chopper_hud_targeting_circle" );
	PreCacheShader( "remote_chopper_hud_targeting_rectangle" );
	PreCacheShader( "remote_chopper_hud_compass_bar" );
	PreCacheShader( "remote_chopper_hud_compass_bracket" );
	PreCacheShader( "remote_chopper_hud_compass_triangle" );
	PreCacheShader( "remote_chopper_overlay_scratches" );
	PreCacheShader( "dpad_remote_chopper_gunner" );
	PreCacheShader( "hud_dpad" );
	PreCacheShader( "hud_arrow_right" );
	PreCacheShader( "overlay_sandstorm" );
	PreCacheShader( "overlay_static" );
	PreCacheShader( "stance_carry" );
	PreCacheShader( "gfx_laser_light_bright");
	PreCacheShader( "gfx_laser_bright");
	PreCacheString( &"PAYBACK_REMOTE_CHOPPER_TURRET" );
	PreCacheString( &"PAYBACK_FAIL_ABANDONED" );
	PreCacheString( &"REMOTE_CHOPPER_GUNNER_TADS" );
	PreCacheString( &"REMOTE_CHOPPER_GUNNER_RCT_ACTIVE" );
	PreCacheString( &"REMOTE_CHOPPER_GUNNER_X" );
	PreCacheString( &"REMOTE_CHOPPER_GUNNER_Z" );
	PreCacheString( &"REMOTE_CHOPPER_GUNNER_12_7MM" );
	PreCacheString( &"REMOTE_CHOPPER_GUNNER_ROUNDS" );
	PreCacheString( &"REMOTE_CHOPPER_GUNNER_63" );
	PreCacheString( &"REMOTE_CHOPPER_GUNNER_N1_4" );
	PreCacheString( &"REMOTE_CHOPPER_GUNNER_RECORDING" );
	PreCacheString( &"PAYBACK_KRUGER_NEEDED_ALIVE" );
	PreCacheString( &"PAYBACK_USE_THE_ROPE" );
	PreCacheString( &"PAYBACK_JUMP" );
	PreCacheString( &"PAYBACK_STAY_WITH_TEAM" );
	PreCacheString( &"PAYBACK_CAPTURE_KRUGER" );
	PreCacheString( &"PAYBACK_KEEP_UP" );
	PreCacheString( &"PAYBACK_FAIL_GAS" );
	PreCacheString( &"PAYBACK_JEEP_JUMP" );
	PreCacheString( &"PAYBACK_RUN_TO_JEEP" );
	PreCacheRumble( "heavy_3s" );
	PreCacheRumble( "damage_heavy" );
	PreCacheRumble( "crash_heli_rumble_rest" );
	PreCacheRumble( "steady_rumble" );
	PreCacheRumble( "light_1s" );
	PrecacheRumble( "subtle_tank_rumble" );	
	PrecacheRumble( "viewmodel_large" );
	PrecacheRumble( "grenade_rumble" );	
	
	maps\_treadfx::setallvehiclefx( "script_vehicle_payback_hind", "treadfx/Heli_sand_pb" );
}

assign_friendlies()
{
	self endon("death");
	
	if( IsDefined( self.script_noteworthy ))
	{
    switch( self.script_noteworthy )
	    {
	        case "hannibal":
	            if( !IsDefined( level.hannibal ) && !IsAlive(level.hannibal ) )
	            {
	                self setup_hannibal();
	                return;
	            }
	            break;
	        case "murdock":
	            if( !IsDefined( level.murdock ) && !IsAlive( level.murdock ) )
	            {
	                self setup_murdock();
	                return;
	            }
	            break;
	            
	        case "barracus":
	            if( !IsDefined( level.barracus) && !IsAlive( level.barracus) )
	            {
	                self setup_barracus();
	                return;
	            }
	            break;
	    }
	}
	while(1)
	{
	    if( !IsDefined( level.hannibal ) && !IsAlive(level.hannibal ) )
	    {
	        level.hannibal = self;
	    	self.script_noteworthy = "hannibal";
			self.animname = "hannibal";
			self setup_merc();
			level notify( "hannibal_spawned" );
			return;
			
	        
	    }
	    else if( !IsDefined( level.murdock ) && !IsAlive( level.murdock ) )
	    {
	        level.murdock = self;
	    	self.script_noteworthy = "murdock";
	        
			self setup_merc();
			level notify( "murdock_spawned" );
			return;
			
			
	    }
	    else if( !IsDefined( level.barracus ) && !IsAlive( level.barracus ) )
	    {
	        level.barracus = self;
	    	self.script_noteworthy = "barracus";
			self setup_merc();
			level notify( "barracus_spawned" );
			return;
	    }
	    wait 0.1;
	    
	    // sometimes the friendly gets deleted before this gets killed
	    if (!IsDefined(self) || !IsAlive(self))
	    {
	    	break;
	    }
	}
}
setup_price()
{
	level.price = self;
	level.price magic_bullet_shield();
	level.price.animname = "price";
	level.price thread make_hero();
//	level.price.disableBulletWhizbyReaction = true;
//	level.price.a.disablePain = true;
//	level.price.ignoresuppression = true;
	level.price.voice = "taskforce";
	level.price.countryID = "TF";
	level.price payback_setup_stealth();
	level.price.baseAccuracy = 0.5;
	//objective_onentity( obj( "obj_follow" ), level.price, (0,0,50) );
	//objective_state( obj( "obj_follow" ), "invisible" );
}

setup_soap()
{
	level.soap = self;
	level.soap magic_bullet_shield();
	level.soap.animname = "soap";
	level.soap.disable_sniper_glint = 1;
	// currently using seal version, force voice to be taskforce
	level.soap.voice = "taskforce";
	level.soap.countryID = "TF";
//	level.soap.disableBulletWhizbyReaction = true;
//	level.soap.a.disablePain = true;
//	level.soap.ignoresuppression = true;
	level.soap payback_setup_stealth();
	level.soap.baseAccuracy = 0.5;
}

setup_kruger()
{
	level.kruger = self;
	level.kruger magic_bullet_shield();
	level.kruger.animname = "kruger";
	level.kruger.notarget = true;	
}

setup_nikolai()
{
	level.nikolai = self;
	level.nikolai.ignoreall = true;
	level.nikolai.notarget = true;
	level.nikolai magic_bullet_shield();
	level.nikolai.animname = "nikolai";
	level.nikolai.ignoreme = true;
	level.nikolai.baseAccuracy = 0.5;
}

remove_funcs_from( who, func )
{
	
	ents = getEntArray( who , "script_noteworthy" );
	foreach(ent in ents)
	{
		if( IsSpawner( ent ) )
		{
			ent remove_spawn_function( func );
		}
	}
	
}


setup_hannibal()
{
	
	level.hannibal = self;
	setup_merc();
	self.animname = "hannibal";
	remove_funcs_from( "hannibal" , ::setup_hannibal );
	level notify( self.script_noteworthy + "_spawned" );

}

setup_barracus()
{
	level.barracus = self;
	setup_merc();
	remove_funcs_from( "barracus" , ::setup_barracus );
	level notify( self.script_noteworthy + "_spawned" );
}

setup_murdock()
{
	level.murdock = self;
	setup_merc();
	remove_funcs_from( "murdock" , ::setup_murdock );
	level notify( self.script_noteworthy + "_spawned" );
}

setup_merc()
{
	self thread replace_on_death();
	self payback_setup_stealth();
	self.baseAccuracy = 0.5;
}

payback_setup_stealth()
{
	/*
	if ( !flag( "_stealth_enabled" ) )
	{
		self flag_set( "_stealth_spotted" );
	}
	self stealth_plugin_basic();
	array = [];
	array[ "hidden" ] = ::friendly_color_hidden_override;
	array[ "spotted" ] = ::friendly_color_hidden_override;
	self._stealth.plugins.color_system = true;
	self stealth_plugin_aicolor( array );
	//self stealth_plugin_accuracy();
	self stealth_plugin_smart_stance();
	array = [];
	array[ "hidden" ] = ::friendly_state_hidden_override;
	self maps\_stealth_behavior_friendly::friendly_custom_state_behavior( array );
	*/
}

friendly_color_hidden_override()
{
	if ( IsDefined(self.script_forcecolor) )
	{
		self set_force_color( self.script_forcecolor );
		self.fixednode = true;
	}
}

// don't ignore allies ... TODO does this need to be only when allies have an enemy?
// if so, may want to manage separately anyway, prevent this from taking over
/*
friendly_state_hidden_override()
{
	maps\_stealth_behavior_friendly::friendly_state_hidden();
	self.ignoreme = false;
}
*/

