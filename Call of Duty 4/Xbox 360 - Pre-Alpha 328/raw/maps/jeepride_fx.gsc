#include common_scripts\utility;
#include maps\_utility;
#include maps\_weather;

main()
{
	
	flag_init("cargoship_lighting_off");

	level._effect["griggs_brains"] 				= loadfx("impacts/flesh_hit_head_fatal_exit");
	//Ambient FX
	level._effect[ "cloud_bank_far" ]			= loadfx( "weather/jeepride_cloud_bank_far" );
	level._effect[ "hawks" ]					= loadfx( "misc/hawks" );
	level._effect[ "birds" ]					= loadfx( "misc/birds_icbm_runner" ); 	
	level._effect[ "mist_icbm" ]				= loadfx( "weather/mist_icbm" );	
	level._effect[ "exp_wall" ]					= loadfx( "props/wallExp_concrete" );

	//Moment FX	 
	level._effect[ "tunnel_column" ]			= loadfx( "props/jeepride_pillars" );
	level._effect[ "tunnel_brace" ]				= loadfx( "props/jeepride_brace" );
	level._effect[ "tunnelspark" ] 				= loadfx( "misc/jeepride_tunnel_sparks" );
	level._effect[ "tunnelspark_dl" ] 			= loadfx( "misc/jeepride_tunnel_sparks" );

	level.flare_fx[ "hind" ] 					= loadfx( "misc/flares_cobra" );
	level._effect[ "tire_deflate" ]				= loadfx( "impacts/jeepride_tire_shot" ); 	

	level._effect[ "truck_busts_pillar" ]						= loadfx( "explosions/wall_explosion_draft" );
	level._effect[ "truck_crash_flame_spectacular" ]			= loadfx( "misc/blank" );
	level._effect[ "truck_crash_flame_spectacular_arial" ]		= loadfx( "misc/blank" );
	level._effect[ "truck_splash" ] 							= loadfx( "explosions/mortarExp_water" );

	level._effect[ "cliff_explode" ]							= loadfx( "misc/blank" );
	level._effect[ "cliff_explode_jeepride" ] 					= loadfx( "explosions/cliff_explode_jeepride" );
	level._effect[ "tanker_explosion" ] 						= loadfx( "explosions/tanker_explosion" );
	level._effect[ "tanker_explosion_groundfire" ]				= loadfx( "explosions/tanker_explosion_groundfire" );
	
	level._effect[ "rpg_trail" ]				= loadfx( "smoke/smoke_geotrail_rpg" );
	level._effect[ "rpg_flash" ]				= loadfx( "muzzleflashes/at4_flash" );
	level._effect[ "rpg_explode" ]				= loadfx( "explosions/default_explosion" );
	
	level._effect[ "player_explode" ]			= loadfx( "explosions/default_explosion" );

	level._effect[ "bridge_segment" ] 			= loadfx( "explosions/jeepride_bridge_explosion_seg" );
	level._effect[ "bridge_segment_sounder" ] 	= loadfx( "explosions/jeepride_bridge_explosion_seg_s" );
	
	level._effect[ "bridge_chunks" ] 			= loadfx( "misc/jeepride_chunk_thrower" );
	level._effect[ "bridge_chunks2" ] 			= loadfx( "misc/jeepride_chunk_thrower2" );
	level._effect[ "bridge_hubcaps" ] 			= loadfx( "misc/jeepride_hubcap_thrower" );
	
	level._effect[ "bridge_tanker_fire" ] 		= loadfx( "fire/jeepride_tanker_fire" );
	level._effect[ "bridge_tire_fire" ] 		= loadfx( "fire/tire_fire_med" );
	level._effect[ "bridge_amb_smoke" ] 		= loadfx( "smoke/amb_smoke_blend" );
	level._effect[ "bridge_amb_ash" ] 			= loadfx( "smoke/amb_ash" );
	level._effect[ "bridge_crack_smoke" ] 		= loadfx( "smoke/jeepride_crack_smoke" );
	level._effect[ "bridge_sidesmoke" ] 		= loadfx( "smoke/jeepride_bridge_sidesmoke" );
	
	level._effect["griggs_pistol"] 				= loadfx("muzzleflashes/beretta_flash_wv");
	level._effect["griggs_saw"] 				= loadfx("muzzleflashes/saw_flash_wv");
	
		//Hind Deathfx override
//	maps\_vehicle::build_deathfx_override( "hind",  "explosions/aerial_explosion_large" , 	undefined, 	"hind_helicopter_crash");
	//Hind Deathfx override
	maps\_vehicle::build_deathfx_override( "hind",  "explosions/grenadeexp_default" , 	"tag_engine_left", 	"hind_helicopter_hit", 				undefined, 			undefined, 		undefined, 		0.2, 		true );
	maps\_vehicle::build_deathfx_override( "hind",  "explosions/grenadeexp_default" , 	"tail_rotor_jnt", 	"hind_helicopter_hit", 				undefined, 			undefined, 		undefined, 		0.5, 		true );
	maps\_vehicle::build_deathfx_override( "hind",  "fire/fire_smoke_trail_L" , 		"tail_rotor_jnt", 	"hind_helicopter_dying_loop", 		true, 				0.05, 			true, 			0.5, 		true );
	maps\_vehicle::build_deathfx_override( "hind",  "explosions/aerial_explosion" , 	"tag_engine_right", "hind_helicopter_hit", 				undefined, 			undefined, 		undefined, 		2.5, 		true );
	maps\_vehicle::build_deathfx_override( "hind",  "explosions/aerial_explosion" , 	"tag_deathfx", 		"hind_helicopter_hit", 		 		undefined, 			undefined, 		undefined, 		3.0 );
	maps\_vehicle::build_deathfx_override( "hind",  "explosions/aerial_explosion_large" , 	undefined, 	"hind_helicopter_crash", 			undefined, 			undefined, 		undefined, 		4.5, 		undefined, 	"stop_crash_loop_sound" );

	thread main_post_load();
	
}

main_post_load()
{
	waittillframeend;
}

jeepride_fxline()
{
//	comment out this stuff to record effects. 
//	make sure jeepride_fxline_* are checked out so that the game can write to them.
//	also check to see if a new one has been written and add that to P4
//	emitters are setup in these prefab map files they can be fastfiled over
	
//	sparkrig_vehicle_80s_hatch1_brn_destructible.map
//	sparkrig_vehicle_bm21_mobile_bed.map
//	sparkrig_vehicle_luxurysedan_test.map
//	sparkrig_vehicle_pickup_4door.map
//	sparkrig_vehicle_uaz_open.map
//	sparkrig_vehicle_uaz_open_for_ride.map
	
	//this stuff you comment out to record:
	maps\scriptgen\jeepride_fxline_0::fxline();
	maps\scriptgen\jeepride_fxline_1::fxline();
	maps\scriptgen\jeepride_fxline_2::fxline();
	maps\scriptgen\jeepride_fxline_3::fxline();
	maps\scriptgen\jeepride_fxline_4::fxline();
	maps\scriptgen\jeepride_fxline_5::fxline();
	maps\scriptgen\jeepride_fxline_6::fxline();
	maps\scriptgen\jeepride_fxline_7::fxline();
	maps\scriptgen\jeepride_fxline_8::fxline();
	maps\scriptgen\jeepride_fxline_9::fxline();
	maps\scriptgen\jeepride_fxline_10::fxline();
	maps\scriptgen\jeepride_fxline_11::fxline();
	maps\scriptgen\jeepride_fxline_12::fxline();
	maps\scriptgen\jeepride_fxline_13::fxline();

//	maps\scriptgen\jeepride_fxline_14::fxline();
	
}

apply_ghettotag()
{
	if ( !isdefined( level.ghettotag ) || !isdefined( level.ghettotag[ self.model ] ) )
		return;
	self.ghettotags = [];
	ghettotags = level.ghettotag[ self.model ];
	for ( i = 0 ; i < ghettotags.size ; i ++ )
	{
		model = spawn( "script_model", self.origin );
		model setmodel( "axis" );
		model hide();
// 		origin = self localtoworldcoords( ghettotags[ i ].origin );
// 		angles = self.angles + ghettotags[ i ].angles;
		model linkto( self, "tag_body", ghettotags[ i ].origin, ghettotags[ i ].angles );
		model notsolid();
		self.ghettotags[ self.ghettotags.size ] = model;// todo create special string value of these.
//		model thread maps\jeepride_fx::ghettotagfx( self );
	}
	
	//this is for a bug repro.  attach a bunch of extra stuff.
	if(getdvar("jeepride_crashrepro") != "off")
		for(j = 0 ; j<2;j++)
			for ( i = 0 ; i < ghettotags.size ; i ++ )
			{
				model = spawn( "script_model", self.origin );
				model setmodel( ghettotags[ i ].model );
				model hide();
		// 		origin = self localtoworldcoords( ghettotags[ i ].origin );
		// 		angles = self.angles + ghettotags[ i ].angles;
				model linkto( self, "tag_body", ghettotags[ i ].origin, ghettotags[ i ].angles );
				model notsolid();
				self.ghettotags[ self.ghettotags.size ] = model;// todo create special string value of these.
		//		model thread maps\jeepride_fx::ghettotagfx( self );
			}
	
	
	
	
	
	
	delaytime = .05;
	while ( isdefined( self ) )
	{
		for ( i = 0 ; i < self.ghettotags.size ; i ++ )
		{
			org1 = self.ghettotags[ i ].origin;
			org2 = self.ghettotags[ i ].origin + vector_multiply( anglestoup( self.ghettotags[ i ].angles ), 8 );  //project up 8 units
			trace = bullettrace( org1, org2, false, self ); 
			//there are other things that trace gets like surface types objects that we can change the reaction to here.
			if ( trace[ "fraction" ] < 1 && ! trace_isjunk( trace ) )
				playfxontag_record( getspark(), self.ghettotags[ i ], "polySurface1" );
		}
		wait delaytime;
	}
}

getspark()
{
	// this is really simple right now, 3 dynamic light sparks exists per frame, 
	//I may have disabled that part in the actual effect asignment above because 
	//I didn't like the light coming off.  You should inject your own logic here.
	//  IE: you could pass in the trace and return different effects id's based on different surface types.

	if ( level.sparksclaimed > 3 )
		return "tunnelspark" ;
	else
	{
		thread claimspark();
		return "tunnelspark_dl" ;
	}
}

claimspark()
{
	level.sparksclaimed ++ ;
	wait .05;
	level.sparksclaimed -- ;
}

trace_isjunk( trace )
{
	// check simply makes everything that's a script_model not spark against the vehicle.
	if ( isdefined( trace[ "entity" ] ) )
		if ( trace[ "entity" ].classname == "script_model" )
			return true;// I don't have any cases that I'm aware of where I want it to spark on a script model
	return false;
}

playfx_write_all( recorded )
{
	//this is where the effects get written to scripts
	 /#
	index = level.fxplay_writeindex;
	level.fxplay_writeindex ++ ;// have to write multiple files out as the sparkfile grows and variables need to be cleared;
	file = "scriptgen/" + level.script + "_fxline_" + index + ".gsc";
	file = fileprint_start( file );
	fileprint_chk( level.fileprint, "#include maps\\jeepride_code;" );
	fileprint_chk( level.fileprint, "fxline()" );
	fileprint_chk( level.fileprint, "{" );
	if ( !index )
		fileprint_chk( level.fileprint, "createfxplayers( 8 );" );
	for ( i = 0 ; i < recorded.size ; i ++ )
		fileprint_chk( level.fileprint, "fx_wait_set( " + recorded[ i ].delay + ", " + recorded[ i ].origin + ", " + recorded[ i ].angles + ", \"" + recorded[ i ].effectid + "\" );" );
	fileprint_chk( level.fileprint, "}" );
	fileprint_end();
	#/ 
}

playfxontag_record( strFXid, object, tag )
{
//	playfxontag( level._effect[ strFXid ], object, "polySurface1" );
	struct = spawnstruct();
	struct.effectid = strFXid;
	struct.origin = object.origin;
	struct.angles = object.angles;
	struct.delay = gettime();
	if ( level.recorded_fx.size > 500 )
	{
		thread playfx_write_all( level.recorded_fx );// dump a new file to keep variable count from overflowing.. pain in the neck blah
		level.recorded_fx = [];
	}
	else
	{
		level.recorded_fx[ level.recorded_fx.size ] = struct;
		level.recorded_fx_timer = gettime();	
	}
}

