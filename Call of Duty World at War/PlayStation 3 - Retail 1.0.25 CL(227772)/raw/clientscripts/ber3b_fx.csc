//
// file: ber3b_fx.gsc
// description: clientside fx script for berlin3b: setup, special fx functions, etc.
// scripter: slayback (initial clientside work - laufer)
//

#include clientscripts\_utility; 


// load fx used by util scripts
precache_util_fx()
{	
	level._effect["flesh_hit"] = LoadedFX( "impacts/flesh_hit" );
}

precache_scripted_fx()
{
	level._effect["rtag_foyer_dome_ashes"] = LoadedFX( "maps/ber3b/fx_reichstage_dome_fallout" );
	
	level._effect["spotlight_beam"] = LoadedFX( "env/light/fx_ray_spotlight_md" );
	level._effect["spotlight_burst"] = LoadedFX( "env/electrical/fx_elec_searchlight_burst" );
	
	level._effect["flag_highlight"] = LoadedFX( "misc/fx_NV_dlight" );
	
	// mortar team explosions
	level._effect["mortar_explosion"] = LoadedFX( "explosions/fx_mortarexp_dirt" );
	
	// fakefire muzzleflashes
	level._effect["distant_muzzleflash"] = LoadedFX( "weapon/muzzleflashes/heavy" );
	
	level.mortar = level._effect["mortar_explosion"];	
}


// --- BARRY'S SECTION ---//
precache_createfx_fx()
{
	level._effect["fx_reichstage_dome_fallout"] = loadfx ("maps/ber3b/fx_reichstage_dome_fallout");
	
	level._effect["fire_static_detail"]			     = loadfx ("env/fire/fx_static_fire_detail_ndlight");
	level._effect["fire_static_small"]			     = loadfx ("env/fire/fx_static_fire_sm_ndlight");
	level._effect["fire_static_blk_smk"]			   = loadfx ("env/fire/fx_static_fire_md_ndlight");
	level._effect["fire_distant_150_150"]			   = loadfx ("env/fire/fx_fire_150x150_tall_distant");
	level._effect["fire_distant_150_600"]			   = loadfx ("env/fire/fx_fire_150x600_tall_distant");
  level._effect["dlight_fire_glow"]			       = loadfx ("env/light/fx_dlight_fire_glow");
	level._effect["fire_wall_100_150"]			     = loadfx ("env/fire/fx_fire_wall_smk_0x100y155z");
	level._effect["fire_ceiling_50_100"]			   = loadfx ("env/fire/fx_fire_ceiling_50x100");
	level._effect["fire_ceiling_100_100"]			   = loadfx ("env/fire/fx_fire_ceiling_100x100");
	level._effect["fire_ceiling_300_300"]			   = loadfx ("env/fire/fx_fire_ceiling_300x300");
	level._effect["fire_win_smk_0x35y50z_blk"]	 = loadfx ("env/fire/fx_fire_win_smk_0x35y50z_blk");
	level._effect["fire_ceiling_100_150"]			   = loadfx ("env/fire/fx_fire_ceiling_100x150");
	level._effect["fire_bookcase_wide"]			   = loadfx ("env/fire/fx_fire_bookshelf_wide");
	level._effect["fire_column"]			         = loadfx ("env/fire/fx_fire_column_tall_distant");
  level._effect["fire_column_creep_lg"]			 = loadfx ("env/fire/fx_fire_column_creep_lg");
  level._effect["fire_column_creep_md"]			 = loadfx ("env/fire/fx_fire_column_creep_md");

	level._effect["smoke_detail"]			            = loadfx ("env/smoke/fx_smoke_smolder_sm_blk");
  level._effect["smoke_battle_mist"]			      = loadfx ("maps/ber3b/fx_smoke_dome_floor");
  level._effect["smoke_plume_lg_slow_blk"]			= loadfx ("env/smoke/fx_smoke_plume_lg_slow_blk");
  level._effect["smoke_hallway_thick_dark"]			= loadfx ("env/smoke/fx_smoke_hall_ceiling_600");
	level._effect["smoke_hallway_faint_dark"]			= loadfx ("env/smoke/fx_smoke_hallway_faint_dark");
	level._effect["smoke_window_out"]			        = loadfx ("env/smoke/fx_smoke_door_top_exit_drk");
	level._effect["smoke_blk_w"]			            = loadfx ("maps/ber3b/fx_smk_plume_xlg_slow_blk_3b");
	
	level._effect["debris_burning_paper_dome"]		= loadfx ("maps/ber3b/fx_debris_burning_papers_dome");
  level._effect["debris_paper_falling"]		      = loadfx ("maps/ber3b/fx_debris_papers_falling");
  level._effect["debris_wood_burn_fall"]			  = loadfx ("maps/ber3b/fx_debris_burning_wood_fall");

  level._effect["wire_sparks"]		              = loadfx ("env/electrical/fx_elec_wire_spark_burst");
  level._effect["wire_sparks_blue"]		          = loadfx ("env/electrical/fx_elec_wire_spark_burst_blue");
	
	level._effect["water_single_leak"]			      = loadfx ("env/water/fx_water_single_leak");
	level._effect["water_leak_runner"]			      = loadfx ("env/water/fx_water_leak_runner_100");
	
  level._effect["flak_field"]		                = loadfx ("weapon/flak/fx_flak_field_8k");
    
  level._effect["insect_swarm"]					   	 = loadfx ("bio/insects/fx_insects_ambient");
	
	level._effect["god_rays_large"]					   = loadfx("maps/ber3b/fx_light_god_rays_lg_streak");	
	level._effect["god_rays_medium"]				   = loadfx("env/light/fx_light_god_rays_medium");	
	level._effect["god_rays_small"]					   = loadfx("env/light/fx_light_god_rays_small");
	level._effect["god_rays_small_short"]			 = loadfx("env/light/fx_light_god_rays_small_short");
	level._effect["ray_huge_light"]		         = loadfx ("env/light/fx_ray_sun_xxlrg_linear");
	level._effect["god_rays_dust_motes"]			 = loadfx("env/light/fx_light_god_rays_dust_motes");
 
  level._effect["lantern_light"]		         = loadfx ("env/light/fx_lights_lantern_on");
  level._effect["candle_flame"]		           = loadfx ("env/light/fx_lights_candle_flame");

  level._effect["pipe_steam"]       		= loadfx ("env/smoke/fx_pipe_steam_sm_onesht");
	level._effect["fire_column_creep_xsm"]		= loadfx ("env/fire/fx_fire_column_creep_xsm");
	level._effect["fire_column_creep_sm"]		  = loadfx ("env/fire/fx_fire_column_creep_sm");
	level._effect["smoke_room_fill"]			  	= loadfx ("maps/ber2/fx_smoke_fill_indoor");
	level._effect["ash_and_embers_hall"]			= loadfx ("maps/ber2/fx_debris_hall_ash_embers");
	level._effect["ash_and_embers_small"]			= loadfx ("maps/ber2/fx_debris_fire_motes");
	level._effect["ash_hallway"]			        = loadfx ("maps/ber3b/fx_debris_soot_hallway");  
	level._effect["fire_detail"]			        = loadfx ("env/fire/fx_fire_debris_xsmall");
  level._effect["water_heavy_leak"]			    = loadfx ("env/water/fx_water_drips_hvy");
  level._effect["water_heavy_leak_long"]	  = loadfx ("env/water/fx_water_drips_hvy_long");
}

footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "brick", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "carpet", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "cloth", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "dirt", LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\_utility::setFootstepEffect( "foliage", LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\_utility::setFootstepEffect( "gravel", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "grass", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "metal", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "mud", LoadFx( "bio/player/fx_footstep_mud" ) );
	clientscripts\_utility::setFootstepEffect( "paper", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "plaster", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "rock", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "water", LoadFx( "bio/player/fx_footstep_water" ) );
	clientscripts\_utility::setFootstepEffect( "wood", LoadFx( "bio/player/fx_footstep_dust" ) );
}

ambient_fakefire( endonString, delayStart )
{
	if( delayStart )
	{
		wait( RandomFloatRange( 0.25, 5 ) );
	}
	
	if( IsDefined( endonString ) )
	{
		level endon( endonString );
	}
	
	team = undefined;
	fireSound = undefined;
	weapType = "rifle";
	
	if( !IsDefined( self.script_noteworthy ) )
	{
		team = "allied_rifle";
	}
	else
	{
		team = self.script_noteworthy;
	}
	
	switch( team )
	{
		case "axis_rifle":
			fireSound = "weap_g43_fire";
			weapType = "rifle";
			break;
		
		case "allied_rifle":
			fireSound = "weap_svt40_fire";
			weapType = "rifle";
			break;
			
		case "axis_smg":
			fireSound = "weap_mp44_fire";
			weapType = "smg";
			break;
		
		case "allied_smg":
			fireSound = "weap_ppsh_fire";
			weapType = "smg";
			break;
			
		default:
			ASSERTMSG( "ambient_fakefire: team name '" + team + "' is not recognized." );
	}
	
	// TODO make the sound chance dependent on player proximity?
	
	if( weapType == "rifle" )
	{
		muzzleFlash = level._effect["distant_muzzleflash"];
		soundChance = 60;
		
		burstMin = 1;
		burstMax = 4;
		betweenShotsMin = 0.8;
		betweenShotsMax = 1.3;
		reloadTimeMin = 5;
		reloadTimeMax = 10;
	}
	else
	{
		muzzleFlash = level._effect["distant_muzzleflash"];
		soundChance = 45;
		
		burstMin = 6;
		burstMax = 17;
		betweenShotsMin = 0.08;
		betweenShotsMax = 0.12;
		reloadTimeMin = 5;
		reloadTimeMax = 12;
	}
	
	while( 1 )
	{		
		// burst fire
		burst = RandomIntRange( burstMin, burstMax );
		
		for (i = 0; i < burst; i++)
		{			
			// TODO randomize the target a bit so we're not always firing in the same direction
			// get a point in front of where the struct is pointing
			traceDist = 10000;
			target = self.origin + vector_multiply( AnglesToForward( self.angles ),  traceDist );
			
			BulletTracer( self.origin, target, false );
			
			// play fx with tracers
			PlayFX( 0, muzzleFlash, self.origin, AnglesToForward( self.angles ) );
			
			// snyder steez - reduce popcorn effect
			if( RandomInt( 100 ) <= soundChance )
			{
				playsound( 0, fireSound, self.origin );
			}
			
			wait( RandomFloatRange( betweenShotsMin, betweenShotsMax ) );
		}
		
		wait( RandomFloatRange( reloadTimeMin, reloadTimeMax ) );
	}
	
}

intro_fakefire_starter()
{
		while(1)
		{
			level waittill("intro_fakefire_start");
			println("*** Client : Starting intro fakefire");
			firePoints = GetStructArray( "struct_intro_fakefire", "targetname" );
		    ASSERTEX( IsDefined( firePoints ) && firePoints.size > 0, "Can't find fakefire points." );
		  	  				
			array_thread( firePoints, ::ambient_fakefire, "intro_fakefire_end", false );
		}
}

manage_ambient_fakefire()
{
	level thread intro_fakefire_starter();
}

main()
{
	clientscripts\createfx\ber3b_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	footsteps();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
//		thread play_scripted_fx();
	}
	

	manage_ambient_fakefire();
}

