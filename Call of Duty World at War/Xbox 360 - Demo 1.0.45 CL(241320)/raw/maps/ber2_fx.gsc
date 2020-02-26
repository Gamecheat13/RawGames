//
// file: ber2_fx.gsc
// description: fx script for berlin2: setup, special fx functions, etc.
// scripter: slayback
//

#include maps\_utility;
#include common_scripts\utility;
#include maps\ber2_util;
#include maps\_weather;

main()
{
	disableFX = false;
	// if it's a geo map don't do stuff that requires level scripting
	disable_fx = GetDvarInt( "disable_fx" );
	if( IsDefined( disable_fx ) && disable_fx > 0 )
	{
		disableFX = true;
	}
	
	// laufer's system
	if( !disableFX )
	{
		if( IsDefined( level._in_geo ) && level._in_geo )
		{
			disableFX = true;
		}
	}
	
	// non-geo version only!
	if( !disableFX )
	{
		precache_util_fx();
		thread water_drops_init();
	}
	
//	thread vision_settings(); // - Added by Rich 05/02/08
	maps\createart\ber2_art::main(); //Added by Rich 05/02/08 calls the ber2_art.gsc that controls the vision sets and fog
	maps\createfx\ber2_fx::main();
	precache_weapon_fx();
	wind_settings();
	// splitscreen_fog_setup();

	footsteps();
	precache_createfx_fx();

	level._effect["rooftopsign_breakaway_dust"] = LoadFX( "maps/ber2/fx_dust_sign_support_break" );
	level._effect["fallingboards_fire"] = LoadFX( "maps/ber2/fx_debris_wood_boards_fire" );
	level._effect["rifleflash"] = LoadFX( "weapon/muzzleflashes/standardflashworld" );
	level._effect["rifle_shelleject"] = LoadFX( "weapon/shellejects/rifle" );
	level._effect["headshot"] = LoadFX( "maps/ber2/fx_deathfx_headshot_ber2" );
	level._effect["bloodspurt"] = LoadFX( "maps/ber2/fx_deathfx_head_bloodspurt_ber2" );

	// katyusha particles
	level._effect["katyusha_rocket_launch"] = LoadFX("weapon/muzzleflashes/fx_rocket_katyusha_launch");
	level._effect["katyusha_rocket_trail"] = LoadFX( "weapon/rocket/fx_rocket_katyusha_geotrail" );
	
	// falling sign moment explosion/shockwave
	level._effect["fallingsign_exp"] = LoadFX( "maps/ber2/fx_exp_roof_sign_shock" );
	
	// rocket hitting bank window w/ money fluttering to ground
	level._effect["bank_window_money_exp"] = LoadFX( "maps/ber2/fx_exp_bank_win_money" );
	// secondaries
	level._effect["window_explosion"] = LoadFX("maps/ber2/fx_exp_window_fireball_out");

	// pak43 building chunks
	level._effect["arty_bldg_impact"] = LoadFX( "maps/ber2/fx_exp_wall_impact_01" );
	
	// smokescreen for the alley, to obscure forcespawns
	level._effect["smokescreen"] = LoadFX( "maps/ber2/fx_smk_fill_small" );

	// falling building fx
	level._effect["building_t34_impact"] = LoadFX( "maps/ber2/fx_exp_building_t34_hit" );
	level._effect["building_collapse"] = LoadFX( "maps/ber2/fx_building_2a_collapse" );
	level._effect["building_collapse_fallout"] = LoadFX( "maps/ber2/fx_building_2a_collapse_fallout" );
	level._effect["battle_smoke_heavy"] = LoadFX( "env/smoke/fx_smoke_low_thick_oneshot" );
	level._effect["tower_dust_trail"] = LoadFX( "maps/ber2/fx_tower_collapse_emit" );
	level._effect["building_collapse_oneshot"] = LoadFX( "maps/ber2/fx_building_2a_collapse_hit" );

	// metro arty impact dust
	level._effect["metro_arty_dust"] = LoadFX( "maps/ber2/fx_debris_sbwy_ceiling_impact_sand" );
	level._effect["metro_arty_dust_chunks"] = LoadFX( "maps/ber2/fx_debris_sbwy_ceiling_impact_conc" );
	
	// metro flickering light - "filler" particle light sources
	//level._effect["metro_light_filler"] = LoadFX( "env/light/fx_ray_ceiling_amber_dim" );
	level._effect["metro_light_filler_high"] = LoadFX( "env/light/fx_lgiht_ceiling_flikr_sys_01" );
	level._effect["metro_light_filler_med"] = LoadFX( "env/light/fx_lgiht_ceiling_flikr_sys_02" );
	level._effect["metro_light_filler_low"] = LoadFX( "env/light/fx_lgiht_ceiling_flikr_sys_03" );

	// metrowave fx
	level._effect["metrowave_base"] = LoadFX( "maps/ber2/fx_wave_base" );
	
	// rat splash
	level._effect["rat_splash"] = LoadFX( "env/water/fx_water_single_splash" );
	
	// light explosion
	level._effect["light_explode"] = LoadFX( "maps/ber2/fx_exp_electric_pole" );
	
	// bubbles
	level._effect["limb_bubbles"] = LoadFX( "maps/sniper/fx_underwater_foam_bubbles_limb" );
	level._effect["torso_bubbles"] = LoadFX( "maps/sniper/fx_underwater_foam_bubbles_torso" );

	// fakefire muzzleflashes
	level._effect["distant_muzzleflash"] = LoadFX( "weapon/muzzleflashes/heavy" );

	// AAA gun tracers & cloudbursts
	level._effect["aaa_tracer"] = LoadFX( "weapon/tracer/fx_tracer_jap_tripple25_projectile" );
	level._effect["cloudburst"] = LoadFX( "weapon/flak/fx_flak_cloudflash_night" );
	
	// metrogate molotov lighting fx
	level._effect["zippo_flame"] = LoadFX( "weapon/molotov/fx_molotov_lighter" );
	level._effect["molotov_flame"] = LoadFX( "weapon/molotov/fx_molotov_wick" );
	
	// flame deaths
	level._effect["character_fire_death_sm"] = LoadFX( "env/fire/fx_fire_player_sm" );
	level._effect["character_fire_death_sm"] = LoadFX( "env/fire/fx_fire_player_sm" );
	level._effect["character_fire_death_sm"] = LoadFX( "env/fire/fx_fire_player_sm" );
	level._effect["character_fire_death_torso"] = LoadFX( "env/fire/fx_fire_player_torso" );
	level._effect["character_fire_death_sm"] = LoadFX( "env/fire/fx_fire_player_sm" );
	level._effect["character_fire_death_sm"] = LoadFX( "env/fire/fx_fire_player_sm" );
	level._effect["character_fire_death_sm"] = LoadFX( "env/fire/fx_fire_player_sm" );
	level._effect["character_fire_death_torso"] = LoadFX( "env/fire/fx_fire_player_torso" );
	level._effect["character_fire_death_sm"] = LoadFX( "env/fire/fx_fire_player_sm" );
	level._effect["character_fire_death_sm"] = LoadFX( "env/fire/fx_fire_player_sm" );
	level._effect["character_fire_death_sm"] = LoadFX( "env/fire/fx_fire_player_sm" );
	level._effect["character_fire_death_torso"] = LoadFX( "env/fire/fx_fire_player_torso" );
	
	// lightning strike
	level._effect["lightning_strike"] = LoadFX( "maps/ber2/fx_ber2_lightning_flash" );

	// rain, controlled by _weather
	//level._effect["rain_heavy_cloudtype"]	= LoadFX( "weather/rain_heavy_cloudtype" );
	level._effect["rain_10"]	= LoadFX( "env/weather/fx_rain_sys_heavy" );
	level._effect["rain_9"]		= LoadFX( "env/weather/fx_rain_sys_heavy" );
	level._effect["rain_8"]		= LoadFX( "env/weather/fx_rain_sys_heavy" );
	level._effect["rain_7"]		= LoadFX( "env/weather/fx_rain_sys_heavy" );
	level._effect["rain_6"]		= LoadFX( "env/weather/fx_rain_sys_med" );
	level._effect["rain_5"]		= LoadFX( "env/weather/fx_rain_sys_med" );
	level._effect["rain_4"]		= LoadFX( "env/weather/fx_rain_sys_med" );
	level._effect["rain_3"]		= LoadFX( "env/weather/fx_rain_sys_med" );
	level._effect["rain_2"]		= LoadFX( "env/weather/fx_rain_sys_lght" );
	level._effect["rain_1"]		= LoadFX( "env/weather/fx_rain_sys_lght" );
	level._effect["rain_0"]		= LoadFX( "env/weather/fx_rain_sys_lght" );

	thread weather_control( disableFX );
	
	thread lights_arty_init();
}

precache_weapon_fx()
{
	PrecacheItem( "napalmblob" );  // for the molotov
	precacheItem( "napalmbloblight" );                                
}

// load fx used by util scripts
precache_util_fx()
{
	level._effect["flesh_hit"] = LoadFX( "impacts/flesh_hit_body_fatal_exit" );
	level._effect["katyusha_rocket_explosion"] = LoadFX( "weapon/rocket/fx_rocket_katyusha_explosion" );
}

// set up footsteps
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

//// SRS 6/13/2008: splitscreen fog
//splitscreen_fog_setup()
//{
//	if( IsSplitScreen() )
//	{
//		start_dist = 700;
//		halfway_dist = 2000;
//		halfway_height = 10000;
//		cull_dist = 2000;
//		base_height = 0;
//		red = 0.115;
//		green = 0.123;
//		blue = 0.141;
//		trans_time = 0;
//
//		cull_dist = 2000;
//		set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
//	}
//}

// --- BARRY'S SECTION ---//

// Global Wind Settings
wind_settings()
{
	// These values are supposed to be in inches per second.
	SetSavedDvar( "wind_global_vector", "-33 111 18" ); // (171, -140) = 13.3 mph w/ a normal of -0.9 at hi_altitude
	SetSavedDvar( "wind_global_low_altitude", 25 );
	SetSavedDvar( "wind_global_hi_altitude", 1400 );
	SetSavedDvar( "wind_global_low_strength_percent", 1.3 ); // 4mph at low altitude

	// Add a while loop to vary the strength of the wind over time.
}

precache_createfx_fx()
{
	level._effect["smoke_window_out"]			        = loadfx ("env/smoke/fx_smoke_window_lg_gry");
	level._effect["smoke_plume_xlg_slow_blk"]			= loadfx ("maps/ber2/fx_smk_plume_xlg_slow_blk_w");
	level._effect["smoke_hallway_faint_dark"]			= loadfx ("env/smoke/fx_smoke_hallway_faint_dark");
	level._effect["smoke_hallway_thick_dark"]			= loadfx ("maps/ber2/fx_smoke_hallway_smoke_roll_dark");
	level._effect["smoke_bank"]							      = loadfx ("env/smoke/fx_battlefield_smokebank_ling_lg_w");
	level._effect["battlefield_smokebank_sm_tan"]			= loadfx ("env/smoke/fx_battlefield_smokebank_ling_sm_w");
	level._effect["ash_and_embers"]					      = loadfx ("env/fire/fx_ash_embers_light");
	level._effect["smoke_hall_exit_drk"]				= loadfx ("maps/ber2/fx_smoke_hall_exit_drk");
	level._effect["smoke_window_out_small"]				= loadfx ("env/smoke/fx_smoke_door_top_exit_drk");
	level._effect["smoke_plume_sm_fast_blk_w"]		= loadfx ("env/smoke/fx_smoke_plume_sm_fast_blk_w");
	level._effect["smoke_plume_lg_slow_def"]		= loadfx ("env/smoke/fx_smoke_plume_lg_slow_def");
	level._effect["brush_smoke_smolder_sm"]			= loadfx ("env/smoke/fx_smoke_brush_smolder_md");
	level._effect["smoke_impact_smolder_w"]		  = loadfx ("env/smoke/fx_smoke_crater_w");
	level._effect["fire_window"]			        = loadfx ("env/fire/fx_fire_win_nsmk_0x35y50z");
	level._effect["fire_wall_100_150"]	  	= loadfx ("env/fire/fx_fire_wall_smk_0x100y155z");
  level._effect["water_heavy_leak"]			    = loadfx ("env/water/fx_water_drips_hvy");
  level._effect["water_heavy_leak_long"]			    = loadfx ("env/water/fx_water_drips_hvy_long");
  level._effect["wire_sparks"]		          = loadfx ("env/electrical/fx_elec_wire_spark_burst");
  level._effect["wire_sparks_blue"]		      = loadfx ("env/electrical/fx_elec_wire_spark_burst_blue");
  level._effect["fire_distant_150_600"]			= loadfx ("env/fire/fx_fire_150x600_tall_distant");
  level._effect["light_ceiling_dspot"]		  = loadfx ("env/light/fx_ray_ceiling_amber_dim");
  level._effect["water_pipe_leak_md"]		      = loadfx ("env/water/fx_wtr_pipe_spill_md");
  level._effect["water_pipe_leak_sm"]		      = loadfx ("env/water/fx_wtr_pipe_spill_sm");
  level._effect["water_spill_fall"]		      = loadfx ("env/water/fx_wtr_spill_sm_thin"); 
  level._effect["water_wake_md"]		      = loadfx ("env/water/fx_water_wake_flow_md");
  level._effect["water_leak_runner"]	  		= loadfx ("env/water/fx_water_leak_runner_100");
  level._effect["water_wake_sm"]		      = loadfx ("env/water/fx_water_wake_flow_sm");
  level._effect["water_wake_mist"]		      = loadfx ("env/water/fx_water_wake_flow_mist");
  level._effect["water_splash_md"]		      = loadfx ("env/water/fx_water_splash_leak_md");
  level._effect["water_rain_distortion"]			     = loadfx ("env/water/fx_water_rain_distortion");	
	level._effect["debris_brick_fall_bank"]			= loadfx ("maps/ber2/fx_building_debris_fall_bank");
	level._effect["debris_brick_fall"]			 = loadfx ("maps/ber2/fx_building_debris_fall_amb");
  level._effect["debris_dust_motes"]		      = loadfx ("maps/ber2/fx_debris_dust_motes");  
  level._effect["ray_godray"]		              = loadfx ("maps/ber2/fx_ray_bank_godray"); 
  level._effect["ray_small_glow"]		          = loadfx ("maps/ber2/fx_ray_small_glow");
  level._effect["god_rays_large"]					   = loadfx("env/light/fx_light_god_rays_large");	
	level._effect["god_rays_medium"]				   = loadfx("env/light/fx_light_god_rays_medium");	
	level._effect["god_rays_small"]					   = loadfx("maps/ber2/fx_light_god_raysb_small");
	level._effect["god_rays_dust_motes"]			 = loadfx("env/light/fx_light_god_rays_dust_motes");
	level._effect["fire_bookcase_wide"]			 = loadfx ("env/fire/fx_fire_bookshelf_wide");
	level._effect["fire_column_creep_xsm"]			       = loadfx ("env/fire/fx_fire_column_creep_xsm");
	level._effect["fire_column_creep_sm"]			         = loadfx ("env/fire/fx_fire_column_creep_sm");
	level._effect["smoke_room_fill"]			  	= loadfx ("maps/ber2/fx_smoke_fill_indoor");
	level._effect["ash_and_embers_hall"]			  	= loadfx ("maps/ber2/fx_debris_hall_ash_embers");
	level._effect["fire_detail"]			           = loadfx ("env/fire/fx_fire_debris_xsmall");
	level._effect["fire_ceiling_50_100"]			   = loadfx ("env/fire/fx_fire_ceiling_50x100");
	level._effect["fire_ceiling_100_100"]			   = loadfx ("env/fire/fx_fire_ceiling_100x100");
	level._effect["ash_and_embers_small"]			  	= loadfx ("maps/ber2/fx_debris_fire_motes");
}

//--- RICH'S SECTION - Added by Rich 05/02/08 ---//
//set initial vision settings
//vision_settings()
//{
//	wait .5;
//	VisionSetNaked( "ber2_interior", 0 );
//}
////---END OF RICH'S SECTION---//


// --- ambient FX functions ---

weather_control( disableFX )
{
	if( IsDefined( disableFX ) && disableFX )
	{
		disableFX = true;
	}
	else
	{
		disableFX = false;
	}
	
	// -- RAIN --
	// controls the temperament of the weather
	rainInit( "hard" ); // get rain going
	level thread rainEffectChange( 9, 0.1 );  // tweak initial rain strength
	thread playerWeather(); // make the actual rain effect generate around the players
	
	// -- LIGHTNING --
	if( !disableFX )
	{
		addLightningExploder( 10000 );
		addLightningExploder( 10001 );
		addLightningExploder( 10002 );
		addLightningExploder( 10003 );
		addLightningExploder( 10004 );
		addLightningExploder( 10005 );
	}
	
	if( !disableFX )
	{
		level.thunderSoundEmitter = getent_safe( "thunder_struct", "targetname" );
	}
	
	level.nextLightning = GetTime() + 1;  // sets when the first lightning of the level will go off
	thread lightning( ::lightning_normal, ::lightning_flash );  // kicks off lightning in _weather
	
	if( !disableFX )
	{
		// turn rain off when player goes belowground
		flag_wait( "subway_gate_closed" );
		thread rainEffectChange( 0, 6 );
	}
}

lightning_flash()
{
	
	// Happens on the client now - DSL
	
/*	SetSunLight( 4, 4, 4.5 );
	setVolFog(250, 550, 400, -128, 0.6, 0.6, 0.7, 0);
         
	SetSunLight( 1, 1, 1.5 ); 
	setVolFog(250, 550, 400, -128, 0.45, 0.45, 0.5, 0); 

	wait( 0.0014 );              
	              
	SetSunLight( 3, 3, 3.5 );
	setVolFog(250, 550, 400, -128, 0.55, 0.55, 0.6, 0);                   
	
	SetSunLight( 2, 2, 2.5 );
	setVolFog(250, 550, 400, -128, 0.65, 0.65, 0.7, 0);                                  
	                          
	SetSunLight( 1.5, 1.5, 2 );
	setVolFog(250, 550, 400, -128, 0.7, 0.7, 0.75, 0);                     
	
	wait( 0.0010 ); 
	
	SetSunLight( 1, 1, 1.5 );
	setVolFog(250, 550, 400, -128, 0.55, 0.55, 0.6, 0);               
                               
	SetSunLight( 5, 5, 5.5 );
	setVolFog(250, 550, 400, -128, 0.5, 0.5, 0.55, 0);                   
	
	wait( 0.0011 ); 
	
	SetSunLight( 4, 4, 4.5 );
	setVolFog(250, 550, 400, -128, 0.55, 0.55, 0.6, 0);             
           
	SetSunLight( 1, 1, 1.5 );
	setVolFog(250, 550, 400, -128, 0.55, 0.55, 0.6, 0);                        
	
	wait( 0.0015 ); 
	
	SetSunLight( 2.5, 2.5, 3 ); 
	setVolFog(250, 550, 400, -128, 0.65, 0.65, 0.7, 0);            
  */       
//Slayback's Settings
//	SetSunLight( 3, 3, 3.5 );
//	SetSunDirection( ( 270, 0, 0 ) );
//	
//	wait( 0.1 );
//	
//	SetSunLight( 3.9, 3.9, 4 );
}

lightning_normal()
{
	// Happens on the client now.  DSL
	
/*	wait( 0.05 );
	ResetSunLight();
	setVolFog(250, 750, 400, -128, 0.44, 0.52, 0.44, 0);  */
//Salybacks Setting	
//ResetSunDirection(); 
}

water_drops_init( startCount )
{
	trigs = GetEntArray( "trigger_water_drops", "targetname" );
	ASSERTEX( IsDefined( trigs ) && trigs.size > 0, "Can't find any water drop fx triggers." );
	
	array_thread( trigs, ::water_drops_trigger_think );
	
	if( IsDefined( startCount ) && startCount > 0 )
	{
		// wait for everyone to connect, and start them with water on the lens
		flagMsg = "all_players_connected";
		if( !IsDefined( level.flag[flagMsg] ) )
		{
			level waittill( flagMsg );
		}
		else
		{		
			flag_wait( flagMsg );
		}
	
		array_thread( get_players(), ::scr_set_water_drops, startCount );
	}
	
	level thread water_drops_triggers_delete( trigs );
}

water_drops_triggers_delete( trigs )
{
	flagMsg = "all_players_connected";
	if( !IsDefined( level.flag[flagMsg] ) )
	{
		level waittill( flagMsg );
	}
	else
	{		
		flag_wait( flagMsg );
	}
	
	flag_wait( "subway_gate_closed" );
	array_thread( get_players(), ::scr_set_water_drops, 0 );
	delete_group( trigs );
}

water_drops_trigger_think()
{
	if( !IsDefined( self.script_int ) )
	{
		ASSERTMSG( "Water drop fx trigger at origin " + self.origin + " does not have script_int set.  You need to set this to specify the amount of water drops that will be generated." );
		return;
	}
	
	while( 1 )
	{
		self waittill( "trigger", player );
		
		if( IsPlayer( player ) )
		{
			player scr_set_water_drops( self.script_int );
			
			// wait for player to leave trigger
			while( player IsTouching( self ) )
			{
				wait( 0.05 );
			}
		}
		else
		{
			wait( 0.05 );
		}
	}
}

scr_set_water_drops( count )
{
	// need to make sure we don't call SetWaterDrops() with a positive count
	//  while the drops are already on screen - otherwise they will "snap" off of the screen
	if( !IsDefined( self.waterDropsActive ) )
	{
		self.waterDropsActive = false;
	}
	
	if( count > 0 && self.waterDropsActive )
	{
		return;
	}
	
	if( count > 0 )
	{
		self.waterDropsActive = true;
	}
	else
	{
		self.waterDropsActive = false;
	}
	
	if( IsDefined( self ) )
	{
		self SetWaterDrops( count );
	}
}

// self = a script_struct in the map
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
		team = "axis_rifle";
	}
	else
	{
		team = self.script_noteworthy;
	}

	switch( team )
	{
		case "axis_rifle":
			fireSound = "weap_kar98k_fire";
			weapType = "rifle";
			break;

		case "allied_rifle":
			fireSound = "weap_mosinnagant_fire";
			weapType = "rifle";
			break;

		case "axis_smg":
			fireSound = "weap_mp40_fire";
			weapType = "smg";
			break;

		case "allied_smg":
			fireSound = "weap_ppsh_fire";
			weapType = "smg";
			break;

		default:
			ASSERTMSG( "ambient_fakefire: team name '" + team + "' is not recognized." );
	}

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
		betweenShotsMin = 0.048;
		betweenShotsMax = 0.08;
		reloadTimeMin = 5;
		reloadTimeMax = 12;
	}

	while( 1 )
	{
		// burst fire
		burst = RandomIntRange( burstMin, burstMax );

		for (i = 0; i < burst; i++)
		{
			// get a point in front of where the struct is pointing
			traceDist = 10000;
			target = self.origin + vector_multiply( AnglesToForward( self.angles ),  traceDist );

			// play muzzleflash fx and shoot tracer
			PlayFX( muzzleFlash, self.origin, AnglesToForward( self.angles ) );
			BulletTracer( self.origin, target, false );

			// snyder steez - reduce popcorn effect
			// TODO make the sound chance dependent on player proximity?
			if( RandomInt( 100 ) <= soundChance )
			{
				thread play_sound_in_space( fireSound, self.origin );
			}

			wait( RandomFloatRange( betweenShotsMin, betweenShotsMax ) );
		}

		wait( RandomFloatRange( reloadTimeMin, reloadTimeMax ) );
	}
}

// self = a script_struct in the map
ambient_cloudburst_fx( endonString )
{
	if( IsDefined( endonString ) )
	{
		level endon( endonString );
	}

	// don't make them all start together
	wait( RandomInt( 5 ) );

	offsetX = 200;
	offsetY = 200;
	offsetZ = 200;

	burstsMin = 2;
	burstsMax = 5;

	burstWaitMin = 0.25;
	burstWaitMax = 0.65;

	pauseMin = 4;
	pauseMax = 10;

	while( 1 )
	{
		numBursts = RandomIntRange( burstsMin, burstsMax );

		for( i = 0; i < numBursts; i++ )
		{
			offsetVec = self.origin +
				( RandomIntRange( ( offsetX * -1 ), offsetX ),
				  RandomIntRange( ( offsetY * -1 ), offsetY ),
				  RandomIntRange( ( offsetZ * -1 ), offsetZ ) );

			PlayFX( level._effect["cloudburst"], self.origin + offsetVec );

			wait( RandomFloatRange( burstWaitMin, burstWaitMax ) );
		}

		wait( RandomFloatRange( pauseMin, pauseMax ) );
	}
}

// snyder steez
// self = a script_origin in the map
ambient_aaa_fx( endonString )
{
	if( IsDefined( endonString ) )
	{
		level endon( endonString );
	}

	self thread ambient_aaa_fx_rotate( endonString );

	while( 1 )
	{
		firetime = RandomIntRange( 3, 8 );

		for( i = 0; i < firetime * 5; i++ )
		{
			PlayFX( level._effect["aaa_tracer"], self.origin, AnglesToForward( self.angles ) );
			wait( RandomFloatRange( 0.14, 0.19 ) );
		}
		wait RandomFloatRange( 1.5, 3 );
	}
}

// self = the emitter script_origin
ambient_aaa_fx_rotate( endonString )
{
	if( IsDefined( endonString ) )
	{
		level endon( endonString );
	}

	while( 1 )
	{
		self RotateTo( ( 312.6, 180, -90 ), RandomFloatRange( 3.5, 6 ) );
		self waittill( "rotatedone" );
		self RotateTo( ( 307.4, 1.7, 90 ), RandomFloatRange( 3.5, 6 ) );
		self waittill( "rotatedone" );
	}
}

lights_arty_init()
{
	hatLamps = GetEntArray( "metro_flicker_hatlamp", "targetname" );
	ASSERTEX( array_validate( hatLamps ), "Can't find any metro flickering hat lamp light sets." );
	
	for( i = 0; i < hatLamps.size; i++ )
	{
		hatLamp = hatLamps[i];
		hatLamp.offModel = getent_safe( hatLamp.target, "targetname" );
		hatLamp.light = getent_safe( hatLamp.offModel.target, "targetname" );
		
		hatLamp.offModel Hide();
		
		hatLamp.light.onIntensity = 3.5;  // rich's value = 3.5
		hatLamp.light SetLightIntensity( hatLamp.light.onIntensity );
		hatLamp thread particle_light( "on" );
	}
	
	level.metro_flicker_lights = hatLamps;
}

// self = a scriptable light set
light_arty_flicker( darkTimeMin, darkTimeMax )
{
	hatLamp = self;
	
	on = hatLamp.light.onIntensity;
	off = 0;
	
	darkTime = RandomFloatRange( darkTimeMin, darkTimeMax );
	flickerTime = RandomFloatRange( level.flickerTimeMin, level.flickerTimeMax );
	comboTime = darkTime + flickerTime;
	endTime = GetTime() + ( comboTime * 1000 );
	
	firstFlicker = true;
	self.lightRegistered = false;
	
	onFrac = on * RandomFloatRange( 0.1, 0.15 );
	intensityCap = on * 0.9;
	stepMultiplier = 0.04;  // hacky, should derive this based on flickerTime
	
	while( GetTime() < endTime )
	{
		if( firstFlicker )
		{
			wait( RandomFloat( 0.5 ) );
			if( RandomInt( 100 ) > 25 )
			{
				hatLamp.light maps\ber2_util::light_setintensity( off, RandomFloatRange( 0.3, 0.4 ) );
			}
			else
			{
				// sometimes just turn off immediately
				hatLamp.light SetLightIntensity( off );
			}
			
			// dark!
			hatLamp thread particle_light( "off" );
			lamp_swap( "off" );
			wait( darkTime );
			
			firstFlicker = false;
		}
		
		if( RandomInt( 100 ) > 15 )
		{
			flicker = RandomFloatRange( 0.05, 0.15 );
			
			//Kevins notify for flickers
			SetClientSysState("levelNotify","f");	// was 'flicker'
		}
		else
		{
			// sometimes do a long flicker
			flicker = RandomFloatRange( 0.4, 0.8 );
			
			//Kevins notify for flickers
			SetClientSysState("levelNotify","flicker");
		}
		
		lamp_swap( "on" );
		
		hatLamp.light SetLightIntensity( RandomFloatRange( off, onFrac ) );
		hatLamp thread set_particle_light( onFrac );
		wait( flicker );
		
		hatLamp.light SetLightIntensity( onFrac );
		hatLamp thread set_particle_light( onFrac );
		wait( flicker );
		
		// get brighter over time, up to a point
		onFrac += ( on * stepMultiplier );
		if( onFrac > intensityCap )
		{
			onFrac = intensityCap;
		}
		
		// if bright enough, register that this light is turning on
		if( onFrac > ( on * 0.5 ) && !self.lightRegistered )
		{
			// another light is turning on
			level.arty_flickerlights_on++;
			self.lightRegistered = true;
		}
	}
	
	lastFrac = RandomFloatRange( off, onFrac );
	hatLamp.light SetLightIntensity( lastFrac );
	hatLamp thread set_particle_light( lastFrac );
	
	wait( RandomFloatRange( 0.05, 1 ) );
	hatLamp.light maps\ber2_util::light_setintensity( on, RandomFloatRange( 0.25, 0.35 ) );
	hatLamp thread particle_light( "on" );
	lamp_swap( "on" );
	
	//Kevins notify to stop light flicker
	SetClientSysState("levelNotify","fs");	// was flicker_stop
}

lamp_swap( state )
{
	if( state == "on" )
	{
		self.offModel Hide();
		self Show();
	}
	else
	{
		self.offModel Show();
		self Hide();
	}
}

set_particle_light( onFrac, on )
{
	on = self.light.onIntensity;
	
	// evaluate intensity to pick the correct particle
	fxIntensity = "med";
	
	if( onFrac <= ( on * 0.35 ) )
	{
		fxIntensity = "low";
	}
	else if( onFrac >= ( on * 0.65 ) )
	{
		fxIntensity = "high";
	}
	
	self thread particle_light( "on", fxIntensity );
}

particle_light( state, intensity )
{
	self notify( "creating_particle_light" );
	self endon( "creating_particle_light" );
	
	// 3 different intensities to choose from in the particles
	lightFX_high = level._effect["metro_light_filler_high"];
	lightFX_med = level._effect["metro_light_filler_med"];
	lightFX_low = level._effect["metro_light_filler_low"];
	
	// default intensity = high
	lightFX = lightFX_high;
	
	if( IsDefined( intensity ) )
	{
		if( intensity == "high" )
		{
			lightFX = lightFX_high;
		}
		else if( intensity == "med" )
		{
			lightFX = lightFX_med;
		}
		else if( intensity == "low" )
		{
			lightFX = lightFX_low;
		}
		else
		{
			ASSERTMSG( "particle_light(): intensity of '" + intensity + "' not identified." );
		}
	}
	
	if( state == "on" )
	{
		// don't keep deleting and spawning new particles while we're choosing the same one
		if( IsDefined( self.lastParticleLight ) )
		{
			if( self.lastParticleLight == lightFX )
			{
				return;
			}
		}
		
		// if we have to make a new one, delete the old one
		if( IsDefined( self.particleLight ) )
		{
			self.particleLight Delete();
		}
		
		self.particleLight = Spawn( "script_model", self.origin + ( 0, 0, -4 ) );
		self.particleLight.angles = ( 90, 0, 0 );
		self.particleLight SetModel( "tag_origin" );
		PlayFxOnTag( lightFX, self.particleLight, "tag_origin" );
		
		self.lastParticleLight = lightFX;
	}
	else
	{
		if( IsDefined( self.particleLight ) )
		{
			self.particleLight Delete();
		}
	}
}

// --- end ambient FX functions ---

/* No longer needed, keeping in case someone else wants it
//
// sets up water sheeting fx triggers
water_sheeting_init()
{
	trigs = GetEntArray( "trigger_water_sheeting", "targetname" );
	ASSERTEX( IsDefined( trigs ) && trigs.size > 0, "Can't find any water sheeting triggers." );
	
	array_thread( trigs, ::water_sheeting_trigger_think );
}

water_sheeting_trigger_think()
{
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( IsPlayer( other ) )
		{
			other thread water_sheeting_fx( self );
		}
	}
}

water_sheeting_fx( trig )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	if( !IsDefined( self.isWaterSheeting ) )
	{
		self.isWaterSheeting = false;
	}
	
	if( self.isWaterSheeting )
	{
		return;
	}
	
	waterSheetingMinLength = 0.85;
	waterSheetingEndTime = GetTime() + ( waterSheetingMinLength * 1000 );
	
	self.isWaterSheeting = true;
	
	while( GetTime() < waterSheetingEndTime )
	{
		self SetWaterSheeting( 1, waterSheetingMinLength );
		wait( 0.2 );
		
		if( self IsTouching( trig ) )
		{
			waterSheetingEndTime = GetTime() + ( waterSheetingMinLength * 1000 );
		}
	}
	
	self.isWaterSheeting = false;
}
*/
