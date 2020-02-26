//
// file: ber3b_fx.gsc
// description: fx script for berlin3b: setup, special fx functions, etc.
// scripter: slayback
//

#include common_scripts\utility;
#include maps\_utility;
#include maps\ber3_util;

main()
{
	maps\createart\ber3b_art::main();
	maps\createfx\ber3b_fx::main();
	precache_util_fx();
	precache_createfx_fx();
	footsteps();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) )
	{
		disableFX = 0;
	}
	
	if( disableFX <= 0 )
	{
		precache_scripted_fx();
		thread play_scripted_fx();
	}
	
	thread vol_fog_think( disableFX );
	thread vision_sets_init();
	thread sunlight_samplesize_change_init();
}

precache_scripted_fx()
{
	// fakefire muzzleflashes
	level._effect["distant_muzzleflash"] = LoadFX( "weapon/muzzleflashes/heavy" );
	
	// AAA & plane gun tracers
	level._effect["aaa_tracer"] = LoadFX( "weapon/tracer/fx_tracer_jap_tripple25_projectile" );
	level._effect["plane_tracers"] = level._effect["aaa_tracer"];
	
	// sandbag explosion
	level._effect["sandbag_explosion_small"] = LoadFX( "maps/ber3b/fx_sandbag_exp_sm" );
	
	// spotlight
	level._effect["spotlight_beam"] = LoadFX( "env/light/fx_ray_spotlight_md" );
	level._effect["spotlight_burst"] = LoadFX( "env/electrical/fx_elec_searchlight_burst" );
	
	// flag highlight (d-light)
	level._effect["flag_highlight"] = LoadFX( "misc/fx_NV_dlight" );
	
	// eagle fall
	level._effect["eagle_support_break"] = LoadFX( "maps/ber3b/fx_dust_eagle_support_break" );
	level._effect["eagle_fall_impact"] = LoadFX( "maps/ber3b/fx_eagle_fall_impact" );
	
	// flamethrower guy death
	level._effect["flameguy_explode"] = LoadFX( "explosions/fx_flamethrower_char_explosion" );
	
	// katyusha
	level._effect["katyusha_rocket_trail"] = LoadFX( "weapon/rocket/fx_rocket_katyusha_geotrail" );
	level._effect["katyusha_rocket_trail_exaggerated"] = LoadFX( "maps/ber3b/fx_thick_rocket_geotrail" );
	level._effect["katyusha_rocket_explosion"] = LoadFX( "weapon/rocket/fx_rocket_katyusha_explosion" );
	
	// statue fall
	level._effect["statue_fall"] = LoadFX( "maps/ber3b/fx_statue_fall_cloud" );
	level._effect["statue_fallout_cloud"] = LoadFX( "maps/ber3b/fx_statue_fall_impact" );
	
	// gun fx
	level._effect["rifleflash"] = LoadFX( "weapon/muzzleflashes/rifleflash" );
	level._effect["rifle_shelleject"] = LoadFX( "weapon/shellejects/rifle" );
	level._effect["pistolflash"] = LoadFX( "weapon/muzzleflashes/pistolflash" );
	level._effect["pistol_shelleject"] = LoadFX( "weapon/shellejects/pistol" );
	
	// outro fx
	level._effect["knife_glint"] = LoadFX( "maps/ber3b/fx_knife_glint" );
	level._effect["knife_slash_blood"] = LoadFX( "maps/ber3b/fx_knife_slash_blood" );
	level._effect["knife_stab_blood"] = LoadFX( "maps/ber3b/fx_knife_thrust" );
	level._effect["knife_blood_drip"] = LoadFX( "maps/ber3b/fx_knife_blood_drops" );
	level._effect["knife_sparks"] = LoadFX( "maps/ber3b/fx_spark_flag_pole" );
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

play_scripted_fx()
{	
	level waittill( "load main complete" );
	
	thread spotlight_fx();
}

// load fx used by util scripts
precache_util_fx()
{	
	level._effect["flesh_hit"] = LoadFX( "impacts/flesh_hit" );
	level._effect["flesh_hit_large"] = LoadFX( "impacts/flesh_hit_body_fatal_exit" );
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

spotlight_fx()
{
	spots = GetStructArray( "struct_spotlight_fx", "targetname" );
	spots_nonprimary = GetStructArray( "struct_spotlight_fx_non_prime", "targetname" );
	
	array_thread( spots, ::spotlight_fx_spawn );
	array_thread( spots_nonprimary, ::spotlight_fx_spawn );
}

// self = the fx spot
spotlight_fx_spawn()
{
	org = Spawn( "script_model", self.origin );
	org.angles = self.angles;
	org SetModel( "tag_origin" );
	PlayFXOnTag( level._effect["spotlight_beam"], org, "tag_origin" );
	org playloopsound( "ber3b_lightbulb_loop" );
	self.fxOrg = org;		
	self thread spotlight_damage_think();
}

// self = a spotlight fx spot
spotlight_damage_think()
{
	if( !IsDefined( self.target ) )
	{
		return;
	}
	
	trig = undefined;
	model_undamaged = undefined;
	
	ents = GetEntArray( self.target, "targetname" );
	
	for( i = 0; i < ents.size; i++ )
	{
		ent = ents[i];
		
		if( ent.classname == "trigger_damage" )
		{
			trig = ent;
		}
		else if( ent.classname == "script_model" )
		{
			model_undamaged = ent;
		}
		else
		{
			ASSERTMSG( "spotlight_damage_think(): couldn't identify fxspot target of classname " + ent.classname );
		}
	}
	
	ASSERTEX( IsDefined( trig ) && IsDefined( model_undamaged ), "spotlight_damage_think(): couldn't find either the damage trigger or the undamaged model for fxspot at origin " + self.origin );

	model_damaged = GetEnt( model_undamaged.target, "targetname" );
	middleman = GetStruct( trig.target, "targetname" );
	light = GetEnt( middleman.target, "targetname" );
	
	ASSERTEX( IsDefined( trig.classname ) && trig.classname == "trigger_damage", "Trigger fx spot at origin " + self.origin + " does not target a damage trigger." );
	
	// do light stuff only if it's a primary light
	if( self.targetname != "struct_spotlight_fx_non_prime" )
	{
		// CODER_MOD : DSL 06/11/08 - remove this when the lights have been flagged as server side.
		if( !IsDefined( light ) )
		{
			return;
		}
			
		ASSERTEX( IsDefined( light ), "Trigger fx spot at origin " + self.origin + " does not connect to a light source.  Is the light set as server-side?" );
		light.ogIntensity = light GetLightIntensity();
	}
	
	// hide damaged version
	model_damaged Hide();
	
	trig waittill( "trigger" );
	
	trig Delete();
	
	// model swap
	model_undamaged Hide();
	model_damaged Show();
	
	if( IsDefined( self.fxOrg ) )
	{
		PlayFX( level._effect["spotlight_burst"], self.fxOrg.origin, self.fxOrg.angles );
		
		// reduce intensity only if it's a primary light
		if( self.targetname != "struct_spotlight_fx_non_prime" )
		{
			light SetLightIntensity( light GetLightIntensity() - ( light.ogIntensity / 2 ) );
		}
		
		self.fxOrg Delete();
	}
}

vol_fog_think( disableFX )
{
	set_vol_fog( "map_start" );
	
	if( disableFX <= 0 )
	{
		trigger_wait( "trig_roof_outside_entrance", "targetname" );
		set_vol_fog( "roof" );
	}
}

set_vol_fog( section )
{
	switch( section )
	{
		case "map_start":
			setVolFog( 90, 2500, 850, 850, 0.2901, 0.2941, 0.3019, 0 );
			break;
			
		case "roof":
			setVolFog( 90, 8000, 450, 1400, 0.3137, 0.3176, 0.3254, 5 );
			break;
			
		default:
			ASSERTMSG( "vol_fog setting for map section " + section + " not found." );
	}
}

// handles swapping vision sets throughout the level
vision_sets_init()
{
	VisionSetNaked( "Ber3b", 0.1 );  // TODO change to per-client
	
	visionset_changetrigs = GetEntArray( "set_vision", "targetname" );
	
	if( !IsDefined( visionset_changetrigs ) || visionset_changetrigs.size <= 0 )
	{
		return;
	}
	
	array_thread( visionset_changetrigs, ::vision_set_trigger_think );
}

// self = a trigger
vision_set_trigger_think()
{	
	if( !IsDefined( self.script_noteworthy ) )
	{
		ASSERTMSG( "vision_set_trigger_think(): vision set trigger at origin " + self.origin + " does not have script_noteworthy set.  Make sure that you set this to your vision set name." );
		return;
	}
	
	visionSetName = self.script_noteworthy;
	visionSetTransTime = undefined;
	
	if( IsDefined( self.script_float )  && self.script_float > 0 )
	{
		visionSetTransTime = self.script_float;
	}
	else
	{
		visionSetTransTime = 1;
	}
	
	while( 1 )
	{
		self waittill( "trigger", player );
		
		if( IsPlayer( player ) )
		{
			// if we've already started using vision sets...
			if( IsDefined( player.activeVisionSet ) )
			{
				if( player.activeVisionSet == visionSetName )
				{
					// continue if the player is using the same vision set this trigger references
					continue;
				}
			}
			else
			{
				// ...set it up
				player.activeVisionSet = visionSetName;
			}
			
			// change the vision set
			VisionSetNaked( visionSetName, visionSetTransTime );  // TODO change to per-client
			
			player.activeVisionSet = visionSetName;
			
			doprint = GetDvarInt( "debug_visionset_changes" );
			if( IsDefined( doprint ) && doprint > 0 )
			{
				iprintlnbold( "Vision changed to: " + visionSetName );
			}
		}
	}
}

sunlight_samplesize_change_init()
{
	sampleScale_dvar = "sm_sunSampleSizeNear";
	sampleScale_default = 0.25;
	sampleScale_parliament = 1;
	
	trigger_wait( "trig_parliament_rightbalcony_entrance", "targetname" );
	level thread merge_sunsingledvar( sampleScale_dvar, 0, 5, sampleScale_default, sampleScale_parliament );
	
	trigger_wait( "trig_dome_pacing_start", "targetname" );
	level thread merge_sunsingledvar( sampleScale_dvar, 0, 5, sampleScale_parliament, sampleScale_default );
}

merge_sunsingledvar( dvar, delay, timer, l1, l2 )
{
//	level notify( dvar + "new_lightmerge" );
//	level endon( dvar + "new_lightmerge" );

	setsaveddvar( dvar, l1 );
	wait( delay );
	timer = timer*20;
	suncolor = [];

	for ( i=0; i < timer; i++ )
	{
		dif = i / timer;
		level.thedif = dif;
		ld = l2 * dif + l1 * ( 1 - dif );
		
		setsaveddvar( dvar, ld );
		wait( 0.05 );
	}
	
	setsaveddvar( dvar, l2 );
}

// ---------------------
// ambient FX functions
// ---------------------

fire_flicker_init()
{
	lights = GetEntArray( "firecaster", "targetname" );
	
	if( !IsDefined( lights ) || lights.size <= 0 )
	{
		return;
	}
	
	array_thread( lights, ::ber3b_firelight );
}

// modified version of _lights::burning_trash_fire()
ber3b_firelight()
{
	full = self GetLightIntensity();
	
	old_intensity = full;
	
	while( 1 )
	{
		intensity = RandomFloatRange( full * 0.63, full * 1.2 );
		// old values = 6, 12
		timer = RandomFloatRange( 2, 5 );

		for ( i = 0; i < timer; i ++ )
		{
			new_intensity = intensity * ( i / timer ) + old_intensity * ( ( timer - i ) / timer );
			
			self SetLightIntensity( new_intensity );
			wait( 0.05 );
		}
		
		old_intensity = intensity;
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
			PlayFX( muzzleFlash, self.origin, AnglesToForward( self.angles ) );
			
			// snyder steez - reduce popcorn effect
			if( RandomInt( 100 ) <= soundChance )
			{
				thread play_sound_in_space( fireSound, self.origin );
			}
			
			wait( RandomFloatRange( betweenShotsMin, betweenShotsMax ) );
		}
		
		wait( RandomFloatRange( reloadTimeMin, reloadTimeMax ) );
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
