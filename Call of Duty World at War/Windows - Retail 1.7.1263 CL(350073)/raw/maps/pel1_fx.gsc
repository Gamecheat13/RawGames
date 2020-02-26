#include maps\_utility;
main()
{
	maps\createart\pel1_art::main();
	precacheFX();
	spawnFX();	
	 	
 	thread fog_settings();
 	thread vision_settings();
 	thread wind_settings();
 	thread water_settings();
 	thread view_settings();
}

view_settings()
{
  setsaveddvar("r_motionblur_enable", 1);
  setsaveddvar("r_motionblur_positionFactor", 0.35);
  setsaveddvar("r_motionblur_directionFactor", .2);

	maps\createart\pel1_art::main();
}

vision_settings()
{
	wait 1;
	set_all_players_visionset( "pel1_intro", 1 );
//	VisionSetNaked("pel1_intro",1);	
	
	wait 5;
	level waittill ("lst doors opened");
	set_all_players_visionset( "pel1", 3 );
//	VisionSetNaked("pel1",3);	
	

}

set_outro_vision()
{
	set_all_players_visionset( "pel1_intro", 1 );
//	VisionSetNaked("pel1_intro",1);		
}

fog_settings()
{

	start_dist 			= 814;
	halfway_dist 		= 1763;
	halfway_height 	= 541;
	base_height 		= -451;
	red 						= 0.50;
	green 					= 0.613;
	blue		 				= 0.657;
	trans_time			= 0;

	if( IsSplitScreen() )
	{
		halfway_height 	= 10000;
		cull_dist 			= 2000;
		set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
	}
	else
	{
			// per craig and collin
  		//setVolFog(1000, 7500, 0, 3000, 0.4, 0.45, 0.47, 0.0);
  		level waittill ("do aftermath");       
  		setVolFog(100, 5500, 0, 3000, 0.4, 0.45, 0.47, 10.0);
	}
}

// Global Wind Settings
wind_settings()
{
	// These values are supposed to be in inches per second.
	SetSavedDvar( "wind_global_vector", "-178 140 0" ); // 71.69 inches per second or about 4mph
	SetSavedDvar( "wind_global_low_altitude", -500 );
	SetSavedDvar( "wind_global_hi_altitude", 1600 );
	SetSavedDvar( "wind_global_low_strength_percent", 0.2 );

	// Add a while loop to vary the strength of the wind over time.
}

water_settings()
{
	//-- All of these values were borrowed from Pel1
	/* Water Dvars							Default Values	What They Do
	========================		==============	================================
	r_watersim_enabled					default=true		Enables dynamic water simulation
	r_watersim_debug						default=false		Enables bullet debug markers
  r_watersim_flatten					default=false		Flattens the water surface out
  r_watersim_waveSeedDelay		default=500.0		Time between seeding a new wave (ms)
  r_watersim_curlAmount				default=0.5			Amount of curl applied
  r_watersim_curlMax					default=0.4			Maximum curl limit
  r_watersim_curlReduce				default=0.95		Amount curl gets reduced by when over limit
  r_watersim_minShoreHeight		default=0.04		Allows water to lap over the shoreline edge
  r_watersim_foamAppear				default=20.0		Rate foam appears at
  r_watersim_foamDisappear		default=0.78		Rate foam disappears at
  r_watersim_windAmount				default=0.02		Amount of wind applied
  r_watersim_windDir					default=45.0		Wind direction (degrees)
  r_watersim_windMax					default=0.4			Maximum wind limit
  r_watersim_particleGravity	default=0.03		Particle gravity
  r_watersim_particleLimit		default=2.5			Limit at which particles get spawned
  r_watersim_particleLength		default=0.03		Length of each particle
  r_watersim_particleWidth		default=2.0			Width of each particle
	*/
	
	SetDvar( "r_watersim_waveSeedDelay", 100.0 );
	SetDvar( "r_watersim_curlAmount", 0.18 );
	SetDvar( "r_watersim_curlMax", 0.2 );
	SetDvar( "r_watersim_curlReduce", 0.95 );
	SetDvar( "r_watersim_minShoreHeight", 0.04 );
	SetDvar( "r_watersim_foamAppear", 20.0 );
	SetDvar( "r_watersim_foamDisappear", 0.45 );
	SetDvar( "r_watersim_windAmount", 0.026 );
	SetDvar( "r_watersim_windDir", 75 );
	SetDvar( "r_watersim_windMax", 1.96 );
	SetDvar( "r_watersim_particleGravity", 0.03 );
	SetDvar( "r_watersim_particleLimit", 2.5 );
	SetDvar( "r_watersim_particleLength", 0.03 );
	SetDvar( "r_watersim_particleWidth", 2.0 );	
}


// Load some basic FX to play around with.
precacheFX()
{
	//level._effect["smoke_screen1"]				= loadfx("env/smoke/fx_battlefield_beach_smokebank_ling_lg");
	
	level._effectType["dirt_mortar"] 			= "mortar";
	level._effect["dirt_mortar"]					= loadfx("explosions/fx_mortarExp_dirt");
	
	level._effectType["water_mortar"] 		= "mortar_water";
	level._effect["water_mortar"]					= loadfx("explosions/mortarExp_water");		

	level._effectType["beach_mortar_water"] 		= "mortar_water";
	level._effect["beach_mortar_water"]					= loadfx("explosions/mortarExp_water");	

	
	// bunker door explodes
	level._effect["bunker_door_charge"]		= loadfx("explosions/large_vehicle_explosion");
	
	//LCI rocket explode
	level._effect["lci_rocket_impact"]					= loadfx("weapon/rocket/fx_LCI_rocket_explosion_beach");
//	level._effect["lci_rocket_impact_dummy"]		= loadfx("weapon/rocket/fx_LCI_rocket_explosion_beach_dummy");
	
	// lvt door open
//	level._effect["lvt_door_open_dirt"]		= loadfx("maps/pel1/fx_lvt_door_open_spray_dirt");
//	level._effect["lvt_door_open_water"]	= loadfx("maps/pel1/fx_lvt_door_open_spray_water");
//	
	// jeep explosion	
	level._effect["jeep_explode"]					= loadfx("vehicle/vexplosion/fx_Vexplode_willyjeep");
	level._effect["lvt_explode"]					= loadfx("vehicle/vexplosion/fx_Vexplode_lvt_beach");
	
	level._effect["special_lvt_explode"]			= loadfx("maps/pel1/fx_exp_lvt_pel1");
	
	// trail on rockets
	level._effect["rocket_launch"]				= loadfx("weapon/rocket/fx_LCI_rocket_ignite_launch");
	level._effect["rocket_trail"]					= loadfx("weapon/rocket/fx_lci_rocket_geotrail");
	
	// rocket aftermath
	level._effect["rocket_aftermath"]			= loadfx("maps/pel1/fx_LCI_rocket_debris_aftermath");
 
 	level._effect["thompson_muzzle"]			= loadfx("weapon/muzzleflashes/standardflashworld");
 

	// bunker blowing up stuff
	level._effect["bunker_explode_large"]		= loadfx("maps/pel1/fx_beach_bunker_explosion_lg");
	level._effect["bunker_explode_medium"]	= loadfx("maps/pel1/fx_beach_bunker_explosion_md");
//	level._effect["air_napalm"]							= loadfx("maps/pel1/fx_napalm_midair_burst");
//	level._effect["napalm_explo"]							= loadfx("weapon/napalm/fx_napalmExp_lg_blk_smk_01");
	level._effect["napalm_fire_smolder"]	= loadfx ("maps/pel1/fx_bunker_napalm_fire_smolder");

	// japanese shooting from a distance
	level._effect["distant_muzzleflash"]		=	loadfx("weapon/tracer/fx_muz_distnt_lg_wrld");	
	level._effect["one_squib"]							= loadfx("impacts/fx_bullet_dirt_lg");
	
	// muzzle fx for the battleships
//	level._effect["battleship_muzzle"]		=	loadfx("weapon/ship/fx_ship_battle_14in");	
//	level._effect["cruiser_muzzle"]				= loadfx("weapon/ship/fx_ship_cruiser_6in");
	level._effect["model3_muzzle"]				= loadfx("weapon/artillery/fx_artillery_jap_200mm_no_smoke");	

	// LVT WAKE
	level._effect["lvt_wake"]							= loadfx("vehicle/water/fx_wake_lvt_churn");	

	// FLAME AI FX
	level._effect["character_fire_pain_sm"] 		= LoadFx( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"] 		= LoadFx( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] = LoadFx( "env/fire/fx_fire_player_torso" );
	
	// Bunker fire comes out
	level._effect["bunker_fire_out"] 		= LoadFx( "env/fire/fx_fire_flamethrower_outward_burst" );
	level._effect["bunker_fire_smolder"] = LoadFx( "maps/pel1/fx_bunker_flamed_smolder" );

	// pistol fx
	level._effect["pistol_flash"]				= loadfx ("weapon/muzzleflashes/pistolflash");
	
	// smoke fx used for spotting targets
	level._effect["target_smoke"]				= loadfx ("env/smoke/fx_smoke_ground_marker_green_w");
	
	// aaa muzzle flash
	level._effect["aaa_tracer"]				= loadfx ("Weapon/Tracer/fx_tracer_jap_tripple25_projectile");
	
	// aaa muzzle flash
	level._effect["plane_crashing"]				= loadfx ("trail/fx_trail_plane_smoke_fire_damage");

	// burning trees
	level._effect["palms01"]				= loadfx ("maps/pel1/fx_foliage_snapped_palms01");
	level._effect["palms04"]				= loadfx ("maps/pel1/fx_foliage_snapped_palms04");
	level._effect["palms04a"]				= loadfx ("maps/pel1/fx_foliage_snapped_palms04a");
	level._effect["palms04b"]				= loadfx ("maps/pel1/fx_foliage_snapped_palms04b");
	level._effect["palms04c"]				= loadfx ("maps/pel1/fx_foliage_snapped_palms04c");

	// lvt water splashes
	level._effect["door_splash"]				= loadfx ("vehicle/water/fx_lst_door_splash");
	level._effect["exit_splash"]				= loadfx ("vehicle/water/fx_lvt_lci_exit_splash");	


	level._effect["head_shot"]				= loadfx ("impacts/flesh_hit_body_fatal_exit");	

	level._effect["palm_break"]				= loadfx ("env/dirt/fx_dust_fol_palm_dust_burst");	

	// mortar team stuff
	level.scr_sound["mortar_flash"] = "wpn_mortar_fire";
	level._effect["mortar_flash"] = loadfx("weapon/mortar/fx_mortar_launch_w_trail");

	// load it on the server as well
	level._effect["side_smoke"] = loadfx("maps/pel1/fx_smokebank_beach_xxlg");	//-

	// flak in the air
	level._effect["air_flak"] = loadfx("weapon/flak/fx_flak_field_8k_dist");
	
	// new bomb explos
	level._effect["bomb_explo"] = loadfx("weapon/napalm/fx_napalmexp_tall_blk");
	level.plane_bomb_fx[ "corsair" ] =level._effect["bomb_explo"];
	
	// when guys get hit underwater
	level._effect["uw_blood"] = loadfx("impacts/fx_flesh_hit_knife_uw");
	
	// big bubbles
	level._effect["splash_bubbles"] = loadfx("maps/sniper/fx_underwater_foam_bubbles_torso");
			
	// underwater ai fx	
	level._effect["limb_bubbles"] = loadfx("bio/player/fx_underwater_bubbles_torso");
	level._effect["torso_bubbles"] = loadfx("bio/player/fx_underwater_bubbles_torso");

	//radio zort
	level._effect["broken_radio_spark"] = loadfx("env/electrical/fx_elec_short_oneshot");
				
	//sullivan death fx
	level._effect["sullivan_death_fx"] = loadfx("maps/pel1/fx_deathfx_sullivan");								

	level._effect["flesh_hit"]						= loadFX( "impacts/flesh_hit" );
	
	//LVT wake
	//vehicle/water/fx_wake_lvt_churn.efx

//////////////////////////////////////////////////////////////////////////////////////
///////////////////////BARRYS SECTION	////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

	level._effect["a_smoke_plume_xlg_slow_blk"] = loadfx ("env/smoke/fx_smoke_plume_xlg_slow_blk");
	level._effect["a_smoke_plume_xlg_slow_blk_tall"] = loadfx ("env/smoke/fx_smoke_plume_xlg_slow_blk_tall_w");
  level._effect["a_smk_column_lg_blk"]		    = loadfx ("env/smoke/fx_smk_column_lg_blk");
  level._effect["smoke_rolling_thick"]			= loadfx ("maps/pel1/fx_smoke_rolling_thick");
  level._effect["smoke_rolling_thick2"]			= loadfx ("maps/pel1/fx_smoke_rolling_thick2");
  level._effect["lingering_cliff_smoke_w"]	= loadfx ("env/smoke/fx_smoke_artillery_barrage_w");
  
  level._effect["smoke_impact_smolder"]		      = loadfx ("maps/pel1/fx_smoke_crater_w");
  
  level._effect["player_water_blood_cloud"]		    = loadfx ("env/water/fx_water_blood_cloud_player");	
  level._effect["med_water_blood_cloud"]					= loadfx ("env/water/fx_water_blood_cloud_256x256");
  level._effect["large_water_blood_cloud"]		    = loadfx ("env/water/fx_water_blood_cloud_512x512");
  level._effect["xlarge_water_blood_cloud"]		    = loadfx ("env/water/fx_water_blood_cloud_1024x1024");
  
  level._effect["detail_fire"]	= loadfx ("env/fire/fx_fire_rubble_detail");
  level._effect["small_fire"]	= loadfx ("env/fire/fx_fire_smoke_tree_brush_small_w");
  level._effect["med_fire"]	= loadfx ("env/fire/fx_fire_smoke_tree_brush_med_w");
  level._effect["trunk_fire"]	= loadfx ("env/fire/fx_fire_smoke_tree_trunk_med_w");
  
  level._effect["bunker_dust"]	= loadfx ("maps/pel1/fx_bunker_dust_ceiling_impact");
	level._effect["bunker_dust_ambient"]	= loadfx ("maps/pel1/fx_bunker_dust_ceiling_impact_ambient");
	
	level._effect["godray_small"]	= loadfx ("env/light/fx_ray_sun_small");
	level._effect["godray_small_short"]	= loadfx ("maps/pel1/fx_godray_small_short");
	level._effect["godray_small_short2"]	= loadfx ("maps/pel1/fx_godray_small_short2");
	
	level._effect["tide_splash_small"] = loadfx ("env/water/fx_water_splash_tide_small");
	level._effect["tide_splash_med"] = loadfx ("env/water/fx_water_splash_tide_med");
	level._effect["tide_splash_large"] = loadfx ("env/water/fx_water_splash_tide_lrg");
	
	level._effect["ash_and_embers"] = loadfx ("env/fire/fx_tree_fire_ash_embers");
	level._effect["large_fire_distant"] = loadfx ("env/fire/fx_fire_large_distant");
	level._effect["xlarge_fire_distant"] = loadfx ("env/fire/fx_fire_xlarge_distant");
	
	level._effect["heat_haze_medium"] = loadfx ("maps/pel1/fx_heathaze_md");	
	level._effect["ash_cloud_1"] = loadfx ("maps/pel1/fx_ash_cloud");	
	level._effect["dust_kick_up_emitter"] = loadfx ("maps/pel1/fx_dust_kick_up_emitter");
	level._effect["dust_ambiance_tunnel"] = loadfx ("maps/pel1/fx_dust_ambiance_tunnel");
}

spawnFX()
{
	maps\createfx\pel1_fx::main();
}    
