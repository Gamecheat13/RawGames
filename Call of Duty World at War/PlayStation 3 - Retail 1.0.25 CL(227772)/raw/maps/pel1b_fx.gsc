#include maps\_utility;
#include common_scripts\utility;

main()
{
	maps\createart\pel1b_art::main();
	precacheFX();
	footsteps();
	spawnFX();	

	
//	fog_settings(); Now handled by pel1b_art.gsc
}

// Load some basic FX to play around with.
precacheFX()
{

	//////////////////////////////////////////////////////////////////////////////////////
	///////////////////////Sumeet Section	////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////

	// sherman explosion
	level._effect["rocket_explode"]	   = loadfx("weapon/mortar/fx_mortar_exp_dirt_medium");
	level._effect["rocket_trail"]	   = loadfx("weapon/artillery/fx_artillery_pak43_geotrail");
	level._effect["smoke_destroyed_tank"]	= loadfx("maps/pel1b/fx_smoke_destroyed_tank_sherman");
	level._effect["tank_blowup"] = loadfx("maps/pel1b/fx_large_tank_explosion");

	//tree guys
	level._effect["fall_out_fx"]		= loadfx("maps/mak/fx_dust_and_leaves_kickup_small");	
	level._effect["sniper_leaf_loop"]	= loadfx("destructibles/fx_dest_tree_palm_snipe_leaf01");	
	level._effect["sniper_leaf_canned"]	= loadfx("destructibles/fx_dest_tree_palm_snipe_leaf02");		
	
	// Used for fake death
	level.fleshhit 						= loadfx("impacts/flesh_hit");
	
	// blood drop for snare trap
	level._effect["blood_drop"]			= loadfx("maps/pel1b/fx_flesh_blood_drop");

	//plane crash effect - temp
	level._effect["bomber_wing_hit"]	= loadfx("maps/pel2/fx_bomber_dmg_trail");

	// hut explosion
	level._effect["hut_explosion"]		= loadfx("maps/pel1b/fx_explosion_tank_impact_hut");	

	// panic birds
	level._effect["birds_fly"] 			= LoadFx( "maps/pel2/fx_birds_tree_panic" );

	level._effect["grass_guy_water"] 	= LoadFx( "maps/pel1b/fx_water_character_rise");
	
	// trapped guy blood
	level._effect["blood_drop"]			= LoadFx( "maps/pel1b/fx_flesh_blood_drop");

	// byonet death
	level._effect["character_bayonet_blood_in"] = LoadFx( "impacts/fx_flesh_bayonet_impact" );
	level._effect["character_bayonet_blood_front"] = LoadFx( "impacts/fx_flesh_bayonet_fatal_fr" );
	level._effect["character_bayonet_blood_back"] = LoadFx( "impacts/fx_flesh_bayonet_fatal_bk" );
	level._effect["character_bayonet_blood_right"] = LoadFx( "impacts/fx_flesh_bayonet_fatal_rt" );
	level._effect["character_bayonet_blood_left"] = LoadFx( "impacts/fx_flesh_bayonet_fatal_lf" );
	
	// glocke - end vignette
	level._effect["target_smoke"]								= loadfx ("env/smoke/fx_smoke_ground_marker_green_w");
	
	//////////////////////////////////////////////////////////////////////////////////////
	///////////////////////Alex Section	////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////

	// napalm explosion and the residual fire effect
	level._effect["napalm_explosion"] 		= loadfx("weapon/napalm/fx_napalmExp_lg_blk_smk_01");
	level._effect["fire_foliage_large"]		= loadfx("maps/pel1b/fx_fire_foliage_large");	
	level._effect["smoke_column"]		= loadfx("env/smoke/fx_smoke_plume_md_fast_blk");	

	// flame death AI
	level._effect["character_fire_pain_sm"] 	= LoadFx( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"] 	= LoadFx( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] = LoadFx( "env/fire/fx_fire_player_torso" );

	// a generic flashy explosion
	level._effect["fireball_explosion"] 	= LoadFx( "explosions/fx_flamethrower_char_explosion" );

	// dirt falling
	level._effect["dirt_fall_sm"] = LoadFx( "env/dirt/fx_dirt_falling_sm" );
	level._effect["dirt_fall_md"] = LoadFx( "env/dirt/fx_dirt_falling_quick_md" );
	level._effect["dirt_fall_huge"] = LoadFx( "env/dirt/fx_dust_ceiling_impact_lg_mdbrown" );

	//////////////////////////////////////////////////////////////////////////////////////
	///////////////////////Quinn Section	////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////

	SetSavedDvar( "wind_global_vector", "196 0 0" );
	SetSavedDvar( "wind_global_low_altitude", -2000 );
	SetSavedDvar( "wind_global_hi_altitude", 2000 );
	SetSavedDvar( "wind_global_low_strength_percent", 0.05 );
	
	level._effect["fire_foliage_small"]		  = loadfx("maps/pel1b/fx_fire_foliage_small");		
	level._effect["fire_foliage_xsmall"]		= loadfx("maps/pel1b/fx_fire_foliage_xsmall");		
	level._effect["insects_swarm"]	  	    = loadfx("maps/pel1b/fx_insects_swarm");		
	level._effect["smoke_rolling_thick"] 		= loadfx("maps/pel1b/fx_smoke_rolling_thick");	
	level._effect["heat_haze_medium"] 	  	= loadfx("maps/pel1b/fx_heathaze_md");
	level._effect["leaves_fluttering"] 	  	= loadfx("maps/pel1b/fx_leaves_fluttering_wind");	
	level._effect["godray_medium"] 	  	    = loadfx("maps/pel1b/fx_godray_medium");		
	level._effect["godray_short"] 	       	= loadfx("maps/pel1b/fx_godray_small_short");		
	level._effect["godray_short2"] 	      	= loadfx("maps/pel1b/fx_godray_small_short2");		
	level._effect["ambiance_smoke_misty"]  	= loadfx("maps/pel1b/fx_smoke_ambiance_misty");		
	level._effect["smoke_column_vehicle"]  	= loadfx("maps/pel1b/fx_smoke_column_crashed_vehicle");		
	level._effect["water_splash_small"] 	 	= loadfx("maps/pel1b/fx_water_splash_small");		
	level._effect["water_wake_flow"] 	    	= loadfx("maps/pel1b/fx_water_wake_flow");		
	level._effect["fire_foliage_medium"]   	= loadfx("maps/pel1b/fx_fire_foliage_medium");	
	level._effect["cloud_flashes"]        	= loadfx("maps/pel1b/fx_cloud_flashes");	
	level._effect["flak_field"]           	= loadfx("maps/pel1b/fx_flak_field");	
	level._effect["water_drip"]           	= loadfx("maps/pel1b/fx_water_drip_cave");		
	level._effect["debris_falling"]        	= loadfx("maps/pel1b/fx_dust_falling_runner");										
	
		
		
}

spawnFX()
{
	maps\createfx\pel1b_fx::main();	
}   

//fog_settings()
//{
//	start_dist 		= 4500;
//	halfway_dist 	= 5000;
//	halfway_height 	= 1000;
//	base_height 	= 0;
//	red 			= 0.115;
//	green 			= 0.123;
//	blue		 	= 0.141;
//	trans_time		= 0;
//
//	if( IsSplitScreen() )
//	{
//		halfway_height 	= 10000;
//		cull_dist 		= 6000;
//		set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
//	}
//} 


footsteps()
{

	animscripts\utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "brick", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "carpet", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "cloth", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "dirt", LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "foliage", LoadFx( "bio/player/fx_footstep_sand" ) );
	animscripts\utility::setFootstepEffect( "gravel", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "grass", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "metal", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "mud", LoadFx( "bio/player/fx_footstep_mud" ) );
	animscripts\utility::setFootstepEffect( "paper", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "plaster", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "rock", LoadFx( "bio/player/fx_footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "water", LoadFx( "bio/player/fx_footstep_water" ) );
	animscripts\utility::setFootstepEffect( "wood", LoadFx( "bio/player/fx_footstep_dust" ) );

}
