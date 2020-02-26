main()
{
	maps\createart\sniper_art::main();//Added by Rich 3/20/2008 - Calls sniper_art.csv
	thread wind_settings();
	precache_effects();
	spawnFX();
	footsteps();
}

precache_effects()
{
	level._effect["mortar_exp"] 								  		= loadfx("explosions/fx_mortarExp_dirt");
	level._effect["blood_splat"] 								  		= loadfx("impacts/flesh_hit");
	level._effect["fake_rifleflash"] 					        = loadfx("maps/sniper/fx_muzzleflash_fake_rifle");
	level._effect["fire_debris_small"]							  = loadfx("maps/sniper/fx_fire_debris_small");
	level._effect["fire_debris_xsmall"]							  = loadfx("maps/sniper/fx_fire_debris_xsmall");	
	level._effect["fire_debris_medium"]							  = loadfx("maps/sniper/fx_fire_debris_medium");
	level._effect["fire_debris_medium_interval"]			= loadfx("maps/sniper/fx_fire_debris_medium_interval");
	level._effect["fire_debris_medium_burst"]					= loadfx("maps/sniper/fx_fire_debris_medium_burst");
	level._effect["fire_debris_medium2"]						  = loadfx("maps/sniper/fx_fire_debris_medium2");
	level._effect["fire_debris_large"]							  = loadfx("maps/sniper/fx_fire_debris_large");	
	level._effect["fire_tree_trunk_small"]					  = loadfx("maps/sniper/fx_fire_smoke_tree_trunk_small");	
	level._effect["battle_smoke_thin"]					      = loadfx("maps/sniper/fx_fog_rolling_thin");	
	level._effect["battle_smoke_thick"]					      = loadfx("maps/sniper/fx_fog_rolling_thick");	
	level._effect["battle_smoke_thick_area"]				  = loadfx("maps/sniper/fx_fog_rolling_thick_area");		
	level._effect["battle_smoke_thick_fountain"]		  = loadfx("maps/sniper/fx_fog_rolling_thick_fountain");	
	level._effect["smoke_column_1"]					          = loadfx("maps/sniper/fx_smoke_column_1");	
	level._effect["smoke_column_2"]					          = loadfx("maps/sniper/fx_smoke_column_2");	
	level._effect["plane_engine_fire"]					      = loadfx("maps/sniper/fx_fire_propellor_large");	
	level._effect["carcass_flies"]					          = loadfx("maps/sniper/fx_insects_carcass_flies");	
	level._effect["d_light_fire_small"]					      = loadfx("maps/sniper/fx_fire_d_light_small");
	level._effect["d_light_fire_xsmall"]					    = loadfx("maps/sniper/fx_fire_d_light_xsmall");	
	level._effect["d_light_fire_medium"]					    = loadfx("maps/sniper/fx_fire_d_light_med");			
	level._effect["god_rays_large"]					          = loadfx("maps/sniper/fx_light_god_rays_large");	
	level._effect["god_rays_medium"]					        = loadfx("maps/sniper/fx_light_god_rays_medium");	
	level._effect["god_rays_small"]					          = loadfx("maps/sniper/fx_light_god_rays_small");
	level._effect["god_rays_small_short"]					    = loadfx("maps/sniper/fx_light_god_rays_small_short");		
	level._effect["glass_break"]					            = loadfx("maps/sniper/fx_glass_break");	
	level._effect["smoke_ambiance_indoor"]					  = loadfx("maps/sniper/fx_smoke_ambiance_indoor");	
	level._effect["smoke_ambiance_indoor_glow"]			  = loadfx("maps/sniper/fx_smoke_ambiance_indoor_glow");					
	level._effect["smoke_ambiance_outdoor"]					  = loadfx("maps/sniper/fx_smoke_ambiance_outdoor");
	level._effect["clouds"]					                  = loadfx("maps/sniper/fx_clouds");	
	level._effect["fire_indoor_medium"]					      = loadfx("maps/sniper/fx_fire_indoor_medium");
	level._effect["fire_indoor_medium_far"]					  = loadfx("maps/sniper/fx_fire_indoor_medium_far");
	level._effect["fire_indoor_small"]					      = loadfx("maps/sniper/fx_fire_indoor_small");
	level._effect["fire_indoor_small_far"]					  = loadfx("maps/sniper/fx_fire_indoor_small_far");
	level._effect["fire_indoor_wall_crawl"]					  = loadfx("maps/sniper/fx_fire_indoor_wall_crawl");	
	level._effect["fire_indoor_wall_crawl2"]					= loadfx("maps/sniper/fx_fire_indoor_wall_crawl2");
	level._effect["fire_indoor_wall_smoke"]				  	= loadfx("maps/sniper/fx_fire_indoor_wall_crawl_smoke");
	level._effect["fire_indoor_wall_smoke_near"]		  = loadfx("maps/sniper/fx_fire_indoor_wall_crawl_smoke_near");			
	level._effect["fire_indoor_column1"]					    = loadfx("maps/sniper/fx_fire_indoor_column1");	
 	level._effect["fire_indoor_column1_far"]				  = loadfx("maps/sniper/fx_fire_indoor_column1_far");	
	level._effect["fire_indoor_ceiling"]					    = loadfx("maps/sniper/fx_fire_indoor_ceiling_spread");
	level._effect["dirt_falling"]				        	    = loadfx("maps/sniper/fx_dirt_falling_runner");	
	level._effect["dirt_falling_slow"]				        = loadfx("maps/sniper/fx_dirt_falling_runner2");	
	level._effect["water_ripples_shaking"]	     	    = loadfx("maps/sniper/fx_water_ripples_shaking");	
	level._effect["pebble_shaking_1"]				          = loadfx("maps/sniper/fx_pebble_shaking1");	
	level._effect["pebble_shaking_2"]				     	    = loadfx("maps/sniper/fx_pebble_shaking2");	
	level._effect["pebble_shaking_3"]				     	    = loadfx("maps/sniper/fx_pebble_shaking3");
	level._effect["falling_ash_large"]			 	        = loadfx("maps/sniper/fx_fire_falling_ash_cloud");		
	level._effect["falling_ash_small"]				        = loadfx("maps/sniper/fx_fire_falling_ash_cloud2");
	level._effect["falling_ash_outdoors"]				      = loadfx("maps/sniper/fx_fire_falling_ash_cloud3");	
	level._effect["falling_debris"]				            = loadfx("maps/sniper/fx_fire_falling_debris");						
	level._effect["smoke_column_3"]				      	    = loadfx("maps/sniper/fx_smoke_column_3");		
	level._effect["smoke_column_4"]				      	    = loadfx("maps/sniper/fx_smoke_column_4");	
	level._effect["smoke_column_5"]				      	    = loadfx("maps/sniper/fx_smoke_column_5");					
	level._effect["horch_headlights"]					   		  = loadfx("env/light/fx_ray_headlight_truck");
	level._effect["temp_firewall_chase"]							= loadfx("maps/sniper/fx_fire_indoor_barrier");
	level._effect["fallingboards_fire"] 							= loadFX("maps/ber2/fx_debris_wood_boards_fire" );
	level._effect["temp_bb_explode"]					        = loadfx("maps/sniper/fx_fire_explosion_building");
	level._effect["temp_20mm_impact"]					        = loadfx("maps/sniper/fx_20mm_impact_burst");
	level._effect["bb_hall_smoke"]					       	  = loadfx("maps/sniper/fx_smoke_column_indoor");
	level._effect["debris_fall"]					    	  	  = loadfx("maps/sniper/fx_fire_collapse_hallway");
	level._effect["electric_sparks"]					 	  	  = loadfx("maps/sniper/fx_electric_sparks");
	level._effect["flameguy_explode"]					    	  = loadfx("explosions/fx_flamethrower_char_explosion");
	level._effect["building_wall_explode"]				 	  = loadfx("maps/sniper/fx_explosion_building_2");
	level._effect["scope_glint"]											= loadfx("maps/sniper/fx_light_scope_glint");
	level._effect["bloodspurt_5shot"]				 				  = loadfx("maps/sniper/fx_deathfx_body_5shot");
	level._effect["bloodspurt_6shot"]									= loadfx("maps/sniper/fx_deathfx_body_6shot");
	level._effect["mannequin_shot"]										= loadfx("impacts/fx_mannequin_hit");
	level._effect["cigarette"]								  		 = loadFx( "maps/sniper/fx_cigarette_smoke" ); 
	level._effect["cigarette_glow"]								   = loadFx( "maps/sniper/fx_cigarette_glow" );
	level._effect["cigarette_glow_puff"]						 = LoadFx( "maps/sniper/fx_cigarette_glow_puff" );
	level._effect["cigarette_exhale"]					 		 	 = loadFx( "maps/sniper/fx_cigarette_smoke_exhale_puff" ); 
	level._effect["fire_indoor_running"]					  	= loadFx("maps/sniper/fx_fire_indoor_medium_run");	
	level._effect["plane_propellor"]					 		 	 = loadFx( "maps/sniper/fx_plane_propellor_spinning");
	level._effect["collapse_1"]					 		 	 = loadFx( "maps/sniper/fx_fire_collapse_1st_floor");
	level._effect["collapse_2"]					 		 	 = loadFx( "maps/sniper/fx_fire_collapse_2nd_floor");
	level._effect["collapse_chand"]					 		 	 = loadFx( "maps/sniper/fx_fire_collapse_chandlier");
	level._effect["collapse_ambiance"]					 		 	 = loadFx("maps/sniper/fx_fire_collapse_ambiance_runner");
	level._effect["wing_contrails"]										= loadfx("maps/sniper/fx_contrails");
	level._effect["crow_feathers"]										= loadfx("maps/sniper/fx_feathers_crow_elements");
	//level._effect["books_tossed"]										= loadfx("maps/sniper/fx_book_toss");
	level._effect["character_fire_death_sm"] 					= loadfx("env/fire/fx_fire_player_sm");
	level._effect["character_fire_death_torso"]				= loadfx("env/fire/fx_fire_player_torso"); 
	
	level._effect["flamethrower_fire"]				= loadfx("maps/sniper/fx_flamethrower_burst"); 
	level._effect["bookcase_bounce"]					= loadfx("maps/sniper/fx_fire_collapse_bookcase");
	level._effect["pipe_trail"]					= loadfx("maps/sniper/fx_sys_element_flame_trail_small_emitter");
	level._effect["pipe_flame"]					= loadfx("maps/sniper/fx_oven_pipe_flame");
	level._effect["bookcase_fire"]					= loadfx("maps/sniper/fx_fire_bookshelf");
	level._effect["deathstar_escape"]					= loadfx("maps/sniper/fx_fire_player_tunnel");
	
	level._effect["inside_tankhit"]					= loadfx("maps/sniper/fx_tank_shell_impact_building");
	level._effect["river_splash"]						= loadfx("maps/sniper/fx_water_splash");
	level._effect["limb_bubbles"]						= loadfx("maps/sniper/fx_underwater_foam_bubbles_limb");
	level._effect["torso_bubbles"]						= loadfx("maps/sniper/fx_underwater_foam_bubbles_torso");
	level._effect["curtain_fx"]								= loadfx("maps/sniper/fx_fire_curtains");
}

wind_settings()
{

SetSavedDvar( "wind_global_vector", (60, 60, 0 ) );    // change "0 0 0" to your wind vector
SetSavedDvar( "wind_global_low_altitude", 200);    // change 0 to your wind's lower bound
SetSavedDvar( "wind_global_hi_altitude", 2000);    // change 10000 to your wind's upper bound
SetSavedDvar( "wind_global_low_strength_percent", 0.15);    // change 0.5 to your desired wind strength percentage

}

spawnFX()
{
	maps\createfx\sniper_fx::main();
}

footsteps()
{
            animscripts\utility::setFootstepEffect( "asphalt",   LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "brick",       LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "carpet",     LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "cloth",       LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "dirt",         LoadFx( "bio/player/fx_footstep_sand" ) ); 
            animscripts\utility::setFootstepEffect( "foliage",    LoadFx( "bio/player/fx_footstep_sand" ) ); 
            animscripts\utility::setFootstepEffect( "gravel",     LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "grass",      LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "ice",         LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "metal",      LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "mud",       LoadFx( "bio/player/fx_footstep_mud" ) ); 
            animscripts\utility::setFootstepEffect( "paper",      LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "plaster",    LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "rock",       LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "sand",       LoadFx( "bio/player/fx_footstep_sand" ) ); 
            animscripts\utility::setFootstepEffect( "snow",      LoadFx( "bio/player/fx_footstep_dust" ) ); 
            animscripts\utility::setFootstepEffect( "water",      LoadFx( "bio/player/fx_footstep_water" ) ); 
            animscripts\utility::setFootstepEffect( "wood",      LoadFx( "bio/player/fx_footstep_dust" ) ); 
}
