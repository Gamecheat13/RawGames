//
// file: pel1b_fx.gsc
// description: clientside fx script for pel1b: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 


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

footsteps()
{

    clientscripts\_utility::setFootstepEffect( "asphalt",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "brick",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "carpet",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "cloth",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "concrete",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "dirt",		LoadFx( "bio/player/fx_footstep_sand" ) ); 
    clientscripts\_utility::setFootstepEffect( "foliage",	LoadFx( "bio/player/fx_footstep_sand" ) ); 
    clientscripts\_utility::setFootstepEffect( "gravel",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "grass",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "metal",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "mud",       LoadFx( "bio/player/fx_footstep_mud" ) ); 
    clientscripts\_utility::setFootstepEffect( "paper",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "plaster",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "rock",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "sand",		LoadFx( "bio/player/fx_footstep_sand" ) ); 
    clientscripts\_utility::setFootstepEffect( "water",		LoadFx( "bio/player/fx_footstep_water" ) ); 
    clientscripts\_utility::setFootstepEffect( "wood",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
}


main()
{
	clientscripts\createfx\pel1b_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();

	footsteps();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}


