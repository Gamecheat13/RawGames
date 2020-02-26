// clientscripts/mp/_load.csc

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_clientfaceanim_mp;

levelNotifyHandler(clientNum, state, oldState)
{
	if(state != "")
	{
		level notify(state);
	}
}

default_flag_change_handler(localClientNum, flag, set, newEnt)
{
	action = "SET";
	if(!set)
	{
		action = "CLEAR";
	}

	clientscripts\mp\_callbacks::client_flag_debug( "*** DEFAULT client_flag_callback to " + action + "  flag " + flag + " - for ent " + self getentitynumber() + "["+self.type+"]" );
}

setup_default_client_flag_callbacks()
{	
	level._client_flag_callbacks	= [];
	
	level._client_flag_callbacks["vehicle"] = [];
	level._client_flag_callbacks["player"] = [];
	level._client_flag_callbacks["actor"] = [];
	level._client_flag_callbacks["NA"] = ::default_flag_change_handler;
	level._client_flag_callbacks["general"] = ::default_flag_change_handler;
	level._client_flag_callbacks["missile"] = [];
	level._client_flag_callbacks["scriptmover"] = [];
	level._client_flag_callbacks["helicopter"] = [];
	level._client_flag_callbacks["turret"] = ::default_flag_change_handler;
	level._client_flag_callbacks["plane"] = [];

	level._client_flag_callbacks["missile"][level.const_flag_stunned] = clientscripts\mp\_callbacks::stunned_callback;
	level._client_flag_callbacks["missile"][level.const_flag_emp] = clientscripts\mp\_callbacks::emp_callback;
	level._client_flag_callbacks["missile"][level.const_flag_proximity] = clientscripts\mp\_callbacks::proximity_callback;
	level._client_flag_callbacks["scriptmover"][level.const_flag_stunned] = clientscripts\mp\_callbacks::stunned_callback;
	level._client_flag_callbacks["scriptmover"][level.const_flag_emp] = clientscripts\mp\_callbacks::emp_callback;
}

main()
{
	level thread clientscripts\mp\_utility::serverTime();
	level thread clientscripts\mp\_utility::initUtility();

	clientscripts\mp\_utility_code::struct_class_init();
	
	clientscripts\mp\_utility::registerSystem("levelNotify", ::levelNotifyHandler);
	
	level.createFX_enabled = (GetDvar("createfx") != "");
	
	clientscripts\mp\_clientflags::init();

	if( !SessionModeIsZombiesGame() )
	{
		setup_default_client_flag_callbacks();	
	}

	clientscripts\mp\_global_fx::main();
	
	if( !SessionModeIsZombiesGame() )
	{
		//The functions are threaded just in case any of them create 'wait's. Note these functions should not have 'wait's in their 'init' and 'main' functions.
		level thread clientscripts\mp\_ambientpackage::init();
		level thread clientscripts\mp\_busing::busInit();
		level thread clientscripts\mp\_music::music_init();
		level thread clientscripts\mp\_dogs::init();
		level thread clientscripts\mp\_ctf::init();
		
		//level thread clientscripts\mp\_airstrike::init();
		//level thread clientscripts\mp\_plane::init();
		level thread clientscripts\mp\_claymore::init();
		level thread clientscripts\mp\_cameraspike::init();
		level thread clientscripts\mp\_tacticalinsertion::init();
		level thread clientscripts\mp\_riotshield::init();
		level thread clientscripts\mp\_scrambler::init();
		level thread clientscripts\mp\_satchel_charge::init();
		level thread clientscripts\mp\_explosive_bolt::main();
		level thread clientscripts\mp\_sticky_grenade::main();
		level thread clientscripts\mp\_proximity_grenade::main();
		level thread clientscripts\mp\_explode::main();
		level thread clientscripts\mp\_decoy::init();
		level thread clientscripts\mp\_rewindobjects::init_rewind();
		level thread clientscripts\mp\_fxanim::init();

		level thread clientscripts\mp\_helicopter::init();
		level thread clientscripts\mp\_helicopter_sounds::init();
		//level thread clientscripts\mp\_helicopter_player::init();
		level thread clientscripts\mp\_footsteps::init();

		level thread clientscripts\mp\_clientfaceanim_mp::init_clientfaceanim();
	}
	else
	{
		//level thread clientscripts\mp\_dogs::init();
		level thread clientscripts\mp\_ambientpackage::init();
		level thread clientscripts\mp\_music::music_init();
		level thread clientscripts\mp\_footsteps::init();
	}

	level thread clientscripts\mp\_destructible::init();

	/#
	level thread clientscripts\_radiant_live_update::main();
	#/
	
	level thread parse_structs();

	if ( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		return;
	}

	if( !SessionModeIsZombiesGame() )
	{
		clientscripts\mp\_vehicle::init_vehicles();
	}

	footsteps();
	
	if ( !isps3() )
	{
		SetDvar( "cg_enableHelicopterNoCullLodOut", 1 );
	}
}

//Client Side Scripted FX
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
