// clientscripts/mp/_load.csc

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

levelNotifyHandler(clientNum, state, oldState)
{
	if(state != "")
	{
		level notify(state);
	}
}

main()
{
	clientscripts\mp\_utility_code::struct_class_init();
	
	clientscripts\mp\_utility::registerSystem("levelNotify", ::levelNotifyHandler);
	
	level.createFX_enabled = (getdvar("createfx") != "");
	
	clientscripts\mp\_global_fx::main();
	
	clientscripts\mp\_ambientpackage::init();
	clientscripts\mp\_busing::busInit();
	clientscripts\mp\_music::music_init();
	clientscripts\mp\_dogs::init();
	
	level thread parse_structs();

	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		return;
	}
	footsteps();
}

//Bloodlust - 21 May 2008 - Client Side Scripted FX
//get all script_structs, send them to their related functions
parse_structs()
{
	for(i = 0; i < level.struct.size; i++)
	{
		if(isDefined(level.struct[i].targetname))
		{
			if(level.struct[i].targetname == "flak_fire_fx")
			{
				fx_id = "flak20_fire_fx";
				level._effect["flak20_fire_fx"] = loadFX("weapon/tracer/fx_tracer_flak_single_noExp");
				level._effect["flak38_fire_fx"] = loadFX("weapon/tracer/fx_tracer_quad_20mm_Flak38_noExp");
				level._effect["flak_cloudflash_night"] 	= loadFX("weapon/flak/fx_flak_cloudflash_night");
				level._effect["flak_burst_single"] 		= loadFX("weapon/flak/fx_flak_single_day_dist");
				
				level thread clientscripts\mp\_ambient::setup_point_fx(level.struct[i], fx_id);
			}
			
			if(level.struct[i].targetname == "fake_fire_fx")
			{
				fx_id = "distant_muzzleflash";
				level._effect["distant_muzzleflash"] = loadFX("weapon/muzzleflashes/heavy");
		
				level thread clientscripts\mp\_ambient::setup_point_fx(level.struct[i], fx_id);
			}
			
			if(level.struct[i].targetname == "dog_bark_fx")
			{
				fx_id = undefined;
				level thread clientscripts\mp\_ambient::setup_point_fx(level.struct[i], fx_id);
			}
			
			if(level.struct[i].targetname == "spotlight_fx")
			{
				fx_id = "spotlight_beam";
				level._effect["spotlight_beam"] = loadFX( "env/light/fx_ray_spotlight_md" );
				level thread clientscripts\mp\_ambient::setup_point_fx(level.struct[i], fx_id);
			}
		}
	}
}

footsteps()
{
	clientscripts\mp\_utility::setFootstepEffect( "asphalt",    LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\mp\_utility::setFootstepEffect( "brick",      LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\mp\_utility::setFootstepEffect( "carpet",     LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\mp\_utility::setFootstepEffect( "cloth",      LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\mp\_utility::setFootstepEffect( "concrete",   LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\mp\_utility::setFootstepEffect( "dirt",       LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\mp\_utility::setFootstepEffect( "foliage",    LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\mp\_utility::setFootstepEffect( "gravel",     LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\mp\_utility::setFootstepEffect( "grass",      LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\mp\_utility::setFootstepEffect( "metal",      LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\mp\_utility::setFootstepEffect( "mud",        LoadFx( "bio/player/fx_footstep_mud" ) );
	clientscripts\mp\_utility::setFootstepEffect( "paper",      LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\mp\_utility::setFootstepEffect( "plaster",    LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\mp\_utility::setFootstepEffect( "rock",       LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\mp\_utility::setFootstepEffect( "sand",       LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\mp\_utility::setFootstepEffect( "water",      LoadFx( "bio/player/fx_footstep_water" ) );
	clientscripts\mp\_utility::setFootstepEffect( "wood",       LoadFx( "bio/player/fx_footstep_dust" ) );
}
