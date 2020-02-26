//
// file: sniper_fx.gsc
// description: clientside fx script for template: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 


footsteps()
{
    clientscripts\_utility::setFootstepEffect( "asphalt",   LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "brick",       LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "carpet",     LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "cloth",       LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "dirt",         LoadFx( "bio/player/fx_footstep_sand" ) ); 
    clientscripts\_utility::setFootstepEffect( "foliage",    LoadFx( "bio/player/fx_footstep_sand" ) ); 
    clientscripts\_utility::setFootstepEffect( "gravel",     LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "grass",      LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "ice",         LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "metal",      LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "mud",       LoadFx( "bio/player/fx_footstep_mud" ) ); 
    clientscripts\_utility::setFootstepEffect( "paper",      LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "plaster",    LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "rock",       LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "sand",       LoadFx( "bio/player/fx_footstep_sand" ) ); 
    clientscripts\_utility::setFootstepEffect( "snow",      LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "water",      LoadFx( "bio/player/fx_footstep_water" ) ); 
    clientscripts\_utility::setFootstepEffect( "wood",      LoadFx( "bio/player/fx_footstep_dust" ) ); 
}


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{
}


// --- QUINN'S SECTION ---//
precache_createfx_fx()
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
	level._effect["fire_indoor_running"]					  	= loadFx("maps/sniper/fx_fire_indoor_medium_run");
	level._effect["collapse_ambiance"]					 		 	 = loadFx("maps/sniper/fx_fire_collapse_ambiance_runner");		
	
}


main()
{
	clientscripts\createfx\sniper_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	footsteps();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

