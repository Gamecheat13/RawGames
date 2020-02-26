//
// file: pel1a_fx.gsc
// description: clientside fx script for pel1a: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 


// load fx used by util scripts
precache_util_fx()
{	
	// Mortar section
	clientscripts\_mortar::set_mortar_delays( "dirt_mortar", 2, 5  );
	clientscripts\_mortar::set_mortar_range( "dirt_mortar", 500, 5000 );

	level._effectType["dirt_mortar"]	 			= "mortar";
	level._effect["dirt_mortar"]					= LoadFx( "weapon/mortar/fx_mortar_exp_dirt_medium" );

	// Ceiling Dust for the dynamic mortars
	clientscripts\_mortar::set_mortar_dust( "dirt_mortar", "ceiling_dust" );
	level._effect["ceiling_dust"]					= LoadFx("env/dirt/fx_dust_ceiling_impact_md_rocks");
	
	// Muzzleflash for the big artillery piece
	level._effect["model3_muzzle"]					= LoadFx("weapon/artillery/fx_artillery_jap_200mm");

	// Mortar muzzleflash when they launch a mortar
	level._effect["mortar_flash"]					= LoadFx( "weapon/mortar/fx_mortar_launch" );
	level.scr_sound["mortar_flash"]					="wpn_mortar_fire";
}

precache_scripted_fx()
{
}


// --- BARRY'S SECTION ---//
precache_createfx_fx()
{
	level._effect["smoke_plume_xlg_slow_blk_w"]			= loadfx ("env/smoke/fx_smoke_plume_xlg_slow_blk_w");
	//level._effect["smoke_plume_lg_low_gry_w"]		    = loadfx ("env/smoke/fx_smoke_plume_md_low_gry_w");
	level._effect["smoke_impact_smolder_w"]		      	= loadfx ("env/smoke/fx_smoke_crater_w");
	level._effect["battlefield_smokebank_lg_white_w"]	= loadfx ("env/smoke/fx_battlefield_smokebank_ling_lg_w");
	level._effect["battlefield_smokebank_sm_tan_w"]		= loadfx ("env/smoke/fx_battlefield_smokebank_ling_sm_w");
	level._effect["smoke_plume_sm_fast_blk_w"]			= loadfx ("env/smoke/fx_smoke_plume_sm_fast_blk_w");
	level._effect["smoke_xsm_detail_slow_gry_w"]		= loadfx ("env/smoke/fx_smoke_plume_xsm_detail_slow_gry_w");
	level._effect["fire_blown_md_blk_smk_w"]			= loadfx ("env/fire/fx_fire_blown_md_blk_smk_w");
	level._effect["small_fire_w"]						= loadfx ("env/fire/fx_fire_smoke_tree_brush_small_w");
	level._effect["tree_fire_w"]						= loadfx ("env/fire/fx_fire_smoke_tree_trunk_med_w");
	level._effect["detail_fire"]						= loadfx ("env/fire/fx_fire_smoke_tree_brush_detail");
	level._effect["bunker_dust_ceiling_ambient"]		= loadfx ("maps/pel1/fx_bunker_dust_ceiling_impact_ambient");
	level._effect["godray_lg"]							= loadfx ("env/light/fx_ray_sun_lrg");
	level._effect["godray_med"]							= loadfx ("env/light/fx_ray_sun_med");
	
  level._effect["smoke_impact_smolder"]		      = loadfx ("maps/pel1a/fx_smoke_crater_w");	
  level._effect["smoke_rolling_thick"]			= loadfx ("maps/pel1a/fx_smoke_rolling_thick");
  level._effect["smoke_rolling_thick2"]			= loadfx ("maps/pel1a/fx_smoke_rolling_thick2");	
  level._effect["detail_fire"]	= loadfx ("maps/pel1a/fx_fire_detail");	 
	level._effect["godray_small_short"]	= loadfx ("maps/pel1a/fx_godray_small_short");	
	level._effect["godray_large_short"]	= loadfx ("maps/pel1a/fx_godray_large_short");		
	level._effect["godray_small_short2"]	= loadfx ("maps/pel1a/fx_godray_small_short2"); 
	level._effect["heat_haze_medium"] = loadfx ("maps/pel1a/fx_heathaze_md");	
	level._effect["dust_kick_up_emitter"] = loadfx ("maps/pel1a/fx_dust_kick_up_emitter");	
	level._effect["dust_ambiance_tunnel"] = loadfx ("maps/pel1a/fx_dust_ambiance_tunnel");		
	
}

increase_mortar_delay()
{
	while(1)
	{
		level waittill("imd");	// increase mortar delay
		min_delay = level._explosion_min_delay["dirt_mortar"] + ( level._explosion_min_delay["dirt_mortar"] * 0.5 );
		max_delay = level._explosion_max_delay["dirt_mortar"] + ( level._explosion_max_delay["dirt_mortar"] * 0.5 );
		clientscripts\_mortar::set_mortar_delays( "dirt_mortar", min_delay, max_delay ); 
	}
}

event1_mortars()
{
	level waittill("sm");	// start mortars
	
	// Start the mortars!

	// Get the dust_points for the canned mortars.
	dust_points = getstructarray( "ceiling_dust", "targetname" );
	for( i = 0; i < dust_points.size; i++ )
	{
		// Tells explosion_activate that the struct is a struct and not an entity
		dust_points[i].is_struct = true;
	}


	struct = getstruct( "event1_mortar1", "targetname" );
	struct.is_struct = true; // Tells explosion_activate that the struct is a struct and not an entity
	struct thread clientscripts\_mortar::explosion_activate( "dirt_mortar", undefined, undefined, undefined, undefined, undefined, undefined, dust_points );	

	level thread clientscripts\_mortar::mortar_loop( "dirt_mortar", 1 );
	
	//trigger = GetEnt( "event1_mortar2", "targetname" );
	//trigger waittill( "trigger" );

	struct = getstruct( "event1_mortar2", "targetname" );
	struct.is_struct = true; // Tells explosion_activate that the struct is a struct and not an entity
	struct thread clientscripts\_mortar::explosion_activate( "dirt_mortar", undefined, undefined, undefined, undefined, undefined, undefined, dust_points );
	
}


main()
{
	clientscripts\createfx\pel1a_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
	
	level.mortar = level._effect["dirt_mortar"];
	level thread clientscripts\_mortar::set_mortar_quake( "dirt_mortar", 0.4, 1, 1500 );	
	
	level thread increase_mortar_delay();
	
	level thread event1_mortars();
}

