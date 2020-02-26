//
// file: ber2_fx.gsc
// description: clientside fx script for ber2: setup, special fx functions, etc.
// scripter: laufer/slayback
//

#include clientscripts\_utility;
#include clientscripts\_music;

main()
{
	clientscripts\createfx\ber2_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	footsteps();
	precache_createfx_fx();
	precache_exploders();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
		thread event1_aaa_tracers();
		thread event1_cloudbursts();
	}
	
	addLightningExploder( 10000 );
	addLightningExploder( 10001 );
	addLightningExploder( 10002 );
	addLightningExploder( 10003 );
	addLightningExploder( 10004 );
	addLightningExploder( 10005 );	

	level.lightningNormalFunc = ::lightning_normal_func;
	level.lightningFlashFunc = ::lightning_flash_func;
	
	thread ambient_fakefire_init();
	
	thread building_collapse_hit1_fx();
	thread event1_building_collapse_fx();
	thread tower_fx();
	thread event1_lingering_smoke();
}

lightning_normal_func()
{
	realWait( 0.05 );
	ResetSunLight();
	players = getlocalplayers();
	if(players.size == 1)
	{
		setVolFog(250, 750, 400, -128, 0.44, 0.52, 0.44, 0); 
	}
	
}

lightning_flash_func()
{
	SetSunLight( 1, 1, 1.5 ); 
	players = getlocalplayers();
	if(players.size == 1)
	{
		setVolFog(250, 550, 400, -128, 0.45, 0.45, 0.5, 0); 
	}

	realWait( 0.014 );              
	              
	SetSunLight( 1.5, 1.5, 2 );
	
	players = getlocalplayers();
	if(players.size == 1)
	{
		setVolFog(250, 550, 400, -128, 0.7, 0.7, 0.75, 0);                     
	}
	
	realWait( 0.0010 ); 
	
	SetSunLight( 5, 5, 5.5 );

	players = getlocalplayers();
	if(players.size == 1)
	{
		setVolFog(250, 550, 400, -128, 0.5, 0.5, 0.55, 0);                   
	}
	realWait( 0.0011 ); 
	
	SetSunLight( 1, 1, 1.5 );
	
	players = getlocalplayers();
	if(players.size == 1)
	{
		setVolFog(250, 550, 400, -128, 0.55, 0.55, 0.6, 0);                        
	}
	
	realWait( 0.0015 ); 
	
	SetSunLight( 2.5, 2.5, 3 ); 
	
	players = getlocalplayers();
	if(players.size == 1)
	{
		setVolFog(250, 550, 400, -128, 0.65, 0.65, 0.7, 0);   	
	}
}

lingering_smoke_thread(smokeFX)
{
	level endon("lsmokedone");
	
	realWait(RandomFloatRange(0.25, 1.0));
	
	while(1)
	{
		players = getlocalplayers();
		for(j = 0; j < players.size; j ++)
		{
			playfx(j, smokeFX, self.origin);
		}
		
		realwait(0.8);
	}
}

event1_lingering_smoke()
{
	level waittill("lsmoke");

	println("*** Client : Lingering smoke");

	fxSpots = GetStructArray( "struct_building_collapse_lingering_smoke", "targetname" );
	ASSERTEX( IsDefined( fxSpots ) && fxSpots.size > 0, "Couldn't find the lingering smoke spots!" );
	
	lingeringSmokeFX = level._effect["battle_smoke_heavy"];
	
	array_thread(fxSpots, ::lingering_smoke_thread, lingeringSmokeFX);
	
	level waittill("lsmokedone");
	
	println("*** Client : Lingering smoke done.");
}

building_collapse_setup_anim_pieces()
{
	// automating the process of getting the pieces
	// each line should do the same as this:
	// pieces["rig 1:tower01"] = getent_safe( "sb_model_tower_01", "targetname" );
	// ...etc.
	startNum = 1;
	numPieces = 32;
	bonePrefix = "tower";
	sbModelPrefix = "sb_model_tower_";
	
	pieces = [];
	
	for( i = startNum; i <= numPieces; i++ )
	{
		if( i < 10 )
		{
			tagName = bonePrefix + "0" + i;
			sbModelTNString = sbModelPrefix + "0" + i;
		}
		else
		{
			tagName = bonePrefix + i;
			sbModelTNString = sbModelPrefix + i;
		}
		
		piece = getent(0,  sbModelTNString, "targetname" );
		pieces[pieces.size] = piece;
	}
	
//	ASSERTEX( IsDefined( pieces ) && pieces.size == 32, "Something went wrong with getting the collapsing building pieces." );
	
	return pieces;
}

building_collapse_oneshot_fx_randomchance( chancePercent )
{
	if( chancePercent < 0 )
	{
		chancePercent = 0;
	}
	if( chancePercent > 100 )
	{
		chancePercent = 100;
	}
	
	if( RandomInt( 100 ) < chancePercent )
	{
		self building_collapse_oneshot_fx();
	}
}

building_collapse_oneshot_fx()
{
	oneShotFX = level._effect["building_collapse_oneshot"];
	wait( RandomFloat( 0.5 ) );
	

	for(i = 0; i < getlocalplayers().size; i ++)
	{	
		angles = VectorToAngles( self.origin - getlocalplayers()[i].origin );
	
		PlayFX( i, oneShotFX, self.origin, angles );
	}
}

building_collapse_hit1_fx()
{
	level waittill("bch");
	
	pieces = building_collapse_setup_anim_pieces();
	
	println("*** Client : building hit 1 fx - " + pieces.size + " pieces.");
	
	array_thread( pieces, ::building_collapse_oneshot_fx_randomchance, 15 );
}

event1_building_collapse_fx()
{
	level waittill(	"bcf");
	
	// moved to client
	playsound(0, "tower1", ( 28, 225, -112 ));
	
	pieces = building_collapse_setup_anim_pieces();	
	
	println("*** Client : building collapse fx " + pieces.size + " pieces.");
	
	array_thread( pieces, ::building_collapse_oneshot_fx_randomchance, 50 );
}

tower_fx()
{
	level waittill("bct");
	
	pieces = building_collapse_setup_anim_pieces();
	
	fxPieces = [];
	fxPieces[0] = pieces[1];
	fxPieces[1] = pieces[2];
	fxPieces[2] = pieces[3];
	fxPieces[3] = pieces[4];
	fxPieces[4] = pieces[5];
	
	println("*** Client : tower fall fx - " + pieces.size + " pieces.");
	
	array_thread( fxPieces, ::building_collapse_oneshot_fx );
}

precache_scripted_fx()
{
	// fakefire muzzleflashes
	level._effect["distant_muzzleflash"] = LoadFX( "weapon/muzzleflashes/heavy" );
}

// --- FAKEFIRE ---
ambient_fakefire_init()
{
	level thread event1_fakefire_starter();
	level thread street_fakefire_starter();
}

event1_fakefire_starter()
{
	level waittill( "e1fs" );
	//println("*** Client: Starting event1 fakefire");
		
	firePoints = GetStructArray( "struct_e1_fakefire", "targetname" );
	ASSERTEX( IsDefined( firePoints ) && firePoints.size > 0, "Can't find fakefire points." );
	
	array_thread( firePoints, ::ambient_fakefire, "subway_gate_closed", false );
}

street_fakefire_starter()
{
	level waittill( "sfs" );
	//println("*** Client: Starting street fakefire");
	
	firePoints = GetStructArray( "struct_street_fakefire", "targetname" );
	ASSERTEX( IsDefined( firePoints ) && firePoints.size > 0, "Can't find fakefire points." );
	array_thread( firePoints, ::ambient_fakefire, "bcf", true );
		
	firePoints = [];
	firePoints = GetStructArray( "struct_street_building_fakefire", "targetname" );
	ASSERTEX( IsDefined( firePoints ) && firePoints.size > 0, "Can't find fakefire points." );
	array_thread( firePoints, ::ambient_fakefire, "btf", true );
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
			
			BulletTracer( self.origin, target, false );
			
			// play fx with tracers
			PlayFX( 0, muzzleFlash, self.origin, AnglesToForward( self.angles ) );
			
			// snyder steez - reduce popcorn effect
			// TODO make the sound chance dependent on player proximity?
			if( RandomInt( 100 ) <= soundChance )
			{
				playsound( 0, fireSound, self.origin );
			}
			
			wait( RandomFloatRange( betweenShotsMin, betweenShotsMax ) );
		}
		
		wait( RandomFloatRange( reloadTimeMin, reloadTimeMax ) );
	}
}
// --- END FAKEFIRE ---

// set up footsteps
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

precache_exploders()
{
	// lightning strike
	level._effect["lightning_strike"] = LoadFX( "maps/ber2/fx_ber2_lightning_flash" );	
}

// --- BARRY'S SECTION ---//
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
	
		// AAA gun tracers & cloudbursts
	level._effect["aaa_tracer"] = LoadFX( "weapon/tracer/fx_tracer_jap_tripple25_projectile" );
	level._effect["cloudburst"] = LoadFX( "weapon/flak/fx_flak_cloudflash_night" );	
	
	// Event1 Building collapse.
	
	level._effect["building_collapse_oneshot"] = LoadFX( "maps/ber2/fx_building_2a_collapse_hit" );
	level._effect["battle_smoke_heavy"] = LoadFX( "env/smoke/fx_smoke_low_thick_oneshot" );
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
			players = getlocalplayers();
			for(j = 0; j < players.size; j ++)
			{
				PlayFX( j, level._effect["aaa_tracer"], self.origin, AnglesToForward( self.angles ) );
			}
			realwait( RandomFloatRange( 0.14, 0.19 ) );
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

event1_aaa_tracers()
{
	wait(1.0);
	fxSpots = GetEntArray( 0, "origin_e1_ambient_flak", "targetname" );
	ASSERTEX( IsDefined( fxSpots ) && fxSpots.size > 0, "Can't find ambient AAA tracer fxSpots." );
	
	for( i = 0; i < fxSpots.size; i++ )
	{
		fxSpots[i] thread ambient_aaa_fx( "subway_gate_closed" );
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
	realwait( RandomInt( 5 ) );

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

			players = GetLocalPlayers();
			
			for(j = 0; j < players.size; j++)
			{
				PlayFX( j, level._effect["cloudburst"], self.origin + offsetVec );
			}

			realwait( RandomFloatRange( burstWaitMin, burstWaitMax ) );
		}

		wait( RandomFloatRange( pauseMin, pauseMax ) );
	}
}

event1_cloudbursts()
{
	fxSpots = GetStructArray( "origin_e1_ambient_cloudburst", "targetname" );
	ASSERTEX( IsDefined( fxSpots ) && fxSpots.size > 0, "Can't find ambient cloudburst fxSpots." );
	
	for( i = 0; i < fxSpots.size; i++ )
	{
		fxSpots[i] thread ambient_cloudburst_fx( "subway_gate_closed" );
	}
}