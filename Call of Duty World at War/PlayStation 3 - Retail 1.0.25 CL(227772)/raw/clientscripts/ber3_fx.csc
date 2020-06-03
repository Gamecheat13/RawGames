//
// file: ber3_fx.gsc
// description: clientside fx script for ber3: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_music;


// load fx used by util scripts
precache_util_fx()
{	
	level._effect["distant_muzzleflash"] =	loadfx("weapon/muzzleflashes/fx_50cal");	
	level._effect["reich_tracer"] = loadfx("weapon/tracer/fx_tracer_single_md");
}

precache_scripted_fx()
{
}


// --- BARRY'S SECTION ---//
precache_createfx_fx()
{
	level._effect["fire_static_detail"]					= loadfx("env/fire/fx_static_fire_detail_ndlight");
	level._effect["fire_static_small"]					= loadfx("env/fire/fx_static_fire_sm_ndlight");
	level._effect["fire_static_blk_smk"]				= loadfx("env/fire/fx_static_fire_md_ndlight");
	level._effect["dlight_fire_glow"]						= loadfx("env/light/fx_dlight_fire_glow");

	level._effect["fire_distant_150_150"]				= loadfx("env/fire/fx_fire_150x150_tall_distant");
	level._effect["fire_distant_150_600"]				= loadfx("env/fire/fx_fire_150x600_tall_distant");

	level._effect["fire_wall_100_150"]							= loadfx("env/fire/fx_fire_wall_smk_0x100y155z");
	level._effect["fire_ceiling_100_100"]						= loadfx("env/fire/fx_fire_ceiling_100x100");
	level._effect["fire_ceiling_300_300"]						= loadfx("env/fire/fx_fire_ceiling_300x300");
	level._effect["fire_win_smk_0x35y50z_blk"]			= loadfx("env/fire/fx_fire_win_smk_0x35y50z_blk");
	level._effect["fire_window_nsmk"]								= loadfx("env/fire/fx_fire_win_nsmk_0x35y50z");
	level._effect["fire_tree"]											= loadfx("env/fire/fx_fire_smoke_tree_trunk_med_w");
	level._effect["a_fire_rubble_detail"]						= loadfx("env/fire/fx_fire_rubble_detail");
	level._effect["a_fire_rubble_detail_grp"]				= loadfx("env/fire/fx_fire_rubble_detail_grp");
	level._effect["a_fire_rubble_md"]								= loadfx("env/fire/fx_fire_rubble_md");
	level._effect["a_fire_rubble_md_lowsmk"]				= loadfx("env/fire/fx_fire_rubble_md_lowsmk");
	level._effect["a_fire_rubble_sm"]								= loadfx("env/fire/fx_fire_rubble_sm");
	level._effect["a_fire_rubble_sm_column"]				= loadfx("env/fire/fx_fire_rubble_sm_column");
	level._effect["a_fire_rubble_sm_column_smldr"]	= loadfx("env/fire/fx_fire_rubble_sm_column_smldr");
	
	level._effect["smoke_detail"]								= loadfx("env/smoke/fx_smoke_smolder_sm_blk");
	level._effect["smoke_battle_mist"]					= loadfx("env/smoke/fx_battlefield_smokebank_ling_lg_w");
	level._effect["smoke_plume_sm_fast_blk_w"]	= loadfx("env/smoke/fx_smoke_plume_sm_fast_blk_w");
	level._effect["smoke_plume_md_slow_def"]		= loadfx("env/smoke/fx_smoke_plume_md_slow_def");
	level._effect["smoke_plume_lg_slow_blk"]		= loadfx("env/smoke/fx_smoke_plume_xlg_slow_blk");
	level._effect["smoke_plume_lg_slow_def"]		= loadfx("env/smoke/fx_smoke_plume_lg_slow_def");
	level._effect["smoke_hallway_thick_dark"]		= loadfx("env/smoke/fx_smoke_hall_ceiling_600");
	level._effect["smoke_hallway_faint_dark"]		= loadfx("env/smoke/fx_smoke_hallway_faint_dark");
	level._effect["smoke_window_out"]						= loadfx("env/smoke/fx_smoke_door_top_exit_drk");
	level._effect["a_smoke_smolder_md_gry"]			= loadfx("env/smoke/fx_smoke_smolder_md_gry");
	level._effect["a_smokebank_thick_dist1"]		= loadfx("maps/ber3/fx_smokebank_thick_dist1");
	level._effect["a_smokebank_thick_dist2"]		= loadfx("maps/ber3/fx_smokebank_thick_dist2");
	level._effect["a_smokebank_thick_dist3"]		= loadfx("maps/ber3/fx_smokebank_thick_dist3");
	level._effect["a_smokebank_thin_dist1"]			= loadfx("maps/ber3/fx_smokebank_thin_dist1");
	
	level._effect["water_single_leak"]					= loadfx("env/water/fx_water_single_leak");
	level._effect["water_leak_runner"]					= loadfx("env/water/fx_water_leak_runner_100");
	
	level._effect["debris_paper_falling"]				= loadfx("maps/ber3/fx_debris_papers_falling");
	level._effect["debris_wood_burn_fall"]			= loadfx("maps/ber3/fx_debris_burning_wood_fall");
	level._effect["a_dust_falling_sm"]					= loadfx("env/dirt/fx_dust_falling_sm");
	level._effect["a_dust_falling_md"]					= loadfx("env/dirt/fx_dust_falling_md");
	level._effect["a_column_collapse_ground"]		= loadfx("maps/ber3/fx_column_collapse_ground");
	level._effect["a_column_collapse_ground_end"]		= loadfx("maps/ber3/fx_column_collapse_ground_end");
	level._effect["a_column_collapse_thick"]		= loadfx("maps/ber3/fx_column_collapse_ground_thick");
	level._effect["a_debris_papers_windy"]			= loadfx("maps/ber3/fx_debris_papers_windy");

	level._effect["wire_sparks"]								= loadfx("env/electrical/fx_elec_wire_spark_burst");
	level._effect["wire_sparks_blue"]						= loadfx("env/electrical/fx_elec_wire_spark_burst_blue");

	level._effect["ash_and_embers"]							= loadfx("env/fire/fx_ash_embers_light");	
	level._effect["flak_field"]									= loadfx("weapon/flak/fx_flak_field_8k_dist");
	level._effect["a_flak_field_cloudflash"]		= loadfx("weapon/flak/fx_flak_cloudflash_8k");
	level._effect["a_tracers_flak88_amb"]				= loadfx("maps/ber3/fx_tracers_flak88_amb");
	level._effect["a_tracers_flak88_dir"]				= loadfx("maps/ber3/fx_tracers_flak88_dir");
	level._effect["bio_flies"]									= loadfx("bio/insects/fx_insects_carcass_flies");
	level._effect["bio_crows_overhead"]					= loadfx("bio/animals/fx_crows_circling");
}

loop_tracers(startPoint, endPoint)
{
	level endon("siff");
	
	while(true)
	{
		realwait( randomFloatRange(0.1, 0.5) );
		
		bulletTracer(startPoint, endPoint, false);
	}
}

intro_fakefire()
{
	level waittill("iff");
	
	struct_tracers = getstructarray("e1_tracer_struct", "targetname");
	
	for(i = 0; i < struct_tracers.size; i++)
	{
		thread loop_tracers(struct_tracers[i].origin, struct_tracers[i].targeted[0].origin);
	}	
}

ambient_fakefire( endonString, delayStart, endonTrig )
{	
	if( delayStart )
	{
		realwait( RandomFloatRange( 0.25, 3.5 ) );
	}
	
	if( IsDefined( endonString ) )
	{
		level endon( endonString );
	}
	
	if( IsDefined( endonTrig ) )
	{
		endonTrig endon( "trigger" );
	}
	
	team = undefined;
	fireSound = undefined;
	weapType = "rifle";
	
	if( !IsDefined( self.script_noteworthy ) )
	{
		team = "axis_mg";
	}
	else
	{
		team = self.script_noteworthy;
	}
	
	switch( team )
	{
		case "axis_mg":
			fireSound = "weap_type92_fire";
			weapType = "mg";
			break;
			
		default:
			ASSERTMSG( "ambient_fakefire: team name '" + team + "' is not recognized." );
	}
	
	// TODO make the sound chance dependent on player proximity?
	
	muzzleFlash = level._effect["distant_muzzleflash"];
	fake_tracer = level._effect["reich_tracer"];
	soundChance = 45;
	
	burstMin = 10;
	burstMax = 20;
	betweenShotsMin = 0.048;		// mg42 fire time from turretsettings.gdt
	betweenShotsMax = 0.049;
	reloadTimeMin = 0.3;
	reloadTimeMax = 3.0;
	
	burst_area = (1250,8250,1000);
	
	traceDist = 10000;
	orig_target = self.origin + vector_multiply( AnglesToForward( self.angles ),  traceDist );
			
	target_org = spawn (0, orig_target, "script_origin");
	
	//target_org thread drawlineon_org();
	
	println("org" + target_org.origin);
	println("BA" + burst_area);
		
	while( 1 )
	{		
		// burst fire
		burst = RandomIntRange( burstMin, burstMax );

		targ_point = (	(orig_target[0]) - (burst_area[0]/2) + randomfloat(burst_area[0]),
						(orig_target[1]) - (burst_area[1]/2) + randomfloat(burst_area[1]), 
						(orig_target[2]) - (burst_area[2]/2) + randomfloat(burst_area[2]));
						
		// TODO randomize the target a bit so we're not always firing in the same direction
		// get a point in front of where the struct is pointing
		target_org moveto(targ_point, randomfloatrange(0.5, 6.0));

		
		for (i = 0; i < burst; i++)
		{			
			target = target_org.origin;
			//BulletTracer( self.origin, target, false );
			
			// play fx with tracers
			fx_angles = VectorNormalize(target - self.origin);
			
			players = getlocalplayers();
			
			for(j = 0; j < players.size; j ++)
			{
				PlayFX(j, muzzleFlash, self.origin, fx_angles );
			}
			
			if( i % 4 == 0 )
			{
				players = getlocalplayers();
				
				for(j = 0; j < players.size; j ++)
				{
					PlayFX(j, fake_tracer, self.origin, fx_angles );
				}
			}
			
			//if (self.origin[0] > 1850 && self.origin[0] < 2300)
			//{
			//	thread whiz_by_sound(self.origin, target);
			//}
			// muzzle pop sound from gary
			//playsound (0, "pacific_fake_fire", self.origin);
			
			// snyder steez - reduce popcorn effect
			//if( RandomInt( 100 ) <= soundChance )
			//{
				//playsound( 0, fireSound, self.origin );
			//}
			
			realwait( RandomFloatRange( betweenShotsMin, betweenShotsMax ) );
		}
		
		realwait( RandomFloatRange( reloadTimeMin, reloadTimeMax ) );
	}
	
}

reich_fakefire()
{
	level waittill("rff");
	
	fake_reich_mg_trigs = getstructarray("e3_reich_mg_trig", "targetname");
	
	for(i = 0; i < fake_reich_mg_trigs.size; i++)
	{
	//		fire_struct = getstruct(fake_reich_mg_trigs[i].target, "targetname");
		fake_reich_mg_trigs[i] thread ambient_fakefire( "srff", true, fake_reich_mg_trigs[i]);
	} 
	
}

main()
{
	clientscripts\createfx\ber3_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
	
	level thread intro_fakefire();
	level thread reich_fakefire();
}

