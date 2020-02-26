#include clientscripts\_utility;

#insert raw\maps\pakistan.gsh;

main()
{
	clientscripts\createfx\pakistan_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
	
	footsteps();
}

// Scripted effects
precache_scripted_fx()
{
	level._effect[ "water_loop" ] 						= LoadFX( "water/fx_water_pak_player_wake" );
	level._effect[ "frogger_wake_com_pallet_2" ]		= LoadFX( "water/fx_water_wake_com_pallet_2" );
}

// Ambient effects
precache_createfx_fx()
{
	// Exploders
	level._effect["fx_pak_water_gush_over_bus"]					= loadFX("water/fx_pak_water_gush_over_bus");	// 210
	level._effect["fx_pak_water_splash_lg"]							= loadFX("water/fx_pak_water_splash_lg");	// 210
	level._effect["fx_water_gush_heavy_md_pak"]					= loadFX("water/fx_water_gush_heavy_md_pak");
		level._effect["fx_bus_smash_impact"]							= loadFX("maps/pakistan/fx_bus_smash_impact");//10150
	level._effect["fx_bus_wall_collapse"]								= loadFX("maps/pakistan/fx_bus_wall_collapse");//10151
	level._effect["fx_car_smash_impact"]								= loadFX("maps/pakistan/fx_car_smash_impact");//10152
	level._effect["fx_car_smash_corner_impact"]					= loadFX("maps/pakistan/fx_car_smash_corner_impact");//10200
	level._effect["fx_arch_tunnel_collapse"]						= loadFX("maps/pakistan/fx_arch_tunnel_collapse");//10210
	level._effect["fx_arch_wall_collapse"]							= loadFX("maps/pakistan/fx_arch_wall_collapse");//10210
	level._effect["fx_arch_tunnel_water_impact"]				= loadFX("maps/pakistan/fx_arch_tunnel_water_impact");//10211
	level._effect["fx_arch_wall_water_impact"]					= loadFX("maps/pakistan/fx_arch_wall_water_impact");//10212
	level._effect["fx_balcony_collapse_wood"]					= loadFX("maps/pakistan/fx_balcony_collapse_wood");//10230
	level._effect["fx_sign_kashmir_sparks_01"]					= loadFX("maps/pakistan/fx_sign_kashmir_sparks_01");//10240
	level._effect["fx_sign_kashmir_sparks_02"]					= loadFX("maps/pakistan/fx_sign_kashmir_sparks_02");//10241
	level._effect["fx_sign_dangle_break"]								= loadFX("maps/pakistan/fx_sign_dangle_break");//10215
	level._effect["fx_market_ceiling_collapse"]					= loadFX("maps/pakistan/fx_market_ceiling_collapse");//10110
	level._effect["fx_market_ceiling_water_impact"]			= loadFX("maps/pakistan/fx_market_ceiling_water_impact");//10111
	
	//destructible
	level._effect["fx_pak_dest_shelving_unit"]					= loadFX("destructibles/fx_pak_dest_shelving_unit");


	level._effect["fx_rain_light_loop"]									= loadFX("weather/fx_rain_light_loop");
	level._effect["fx_insects_fly_swarm"]								= loadFX("bio/insects/fx_insects_fly_swarm");
	level._effect["fx_pak_debri_papers"]								= loadFX("maps/pakistan/fx_pak_debri_papers");

	// Event 2
	level._effect["fx_elec_transformer_sparks_runner"]	= loadFX("electrical/fx_elec_transformer_sparks_runner");

	// Event 3
	level._effect["fx_pak_water_particles_lit"]					= loadFX("water/fx_pak_water_particles_lit");	// 310

	// Water
	level._effect["fx_wtr_spill_sm_thin"]								= loadFX("env/water/fx_wtr_spill_sm_thin");
	level._effect["fx_water_pipe_spill_sm_thin_tall"]		= loadFX("water/fx_water_pipe_spill_sm_thin_tall");
	level._effect["fx_water_spill_sm"]									= loadFX("water/fx_water_spill_sm");
	level._effect["fx_water_spill_sm_splash"]						= loadFX("water/fx_water_spill_sm_splash");
	level._effect["fx_water_roof_spill_md"]							= loadFX("water/fx_water_roof_spill_md");
	level._effect["fx_water_roof_spill_md_hvy"]					= loadFX("water/fx_water_roof_spill_md_hvy");
	level._effect["fx_water_roof_spill_lg"]							= loadFX("water/fx_water_roof_spill_lg");
	level._effect["fx_water_roof_spill_lg_hvy"]					= loadFX("water/fx_water_roof_spill_lg_hvy");
	level._effect["fx_water_sheeting_lg_hvy"]						= loadFX("water/fx_water_sheeting_lg_hvy");
	level._effect["fx_rain_spatter_06x30"]							= loadFX("water/fx_rain_spatter_06x30");
	level._effect["fx_rain_spatter_25x25"]							= loadFX("water/fx_rain_spatter_25x25");
	level._effect["fx_rain_spatter_25x50"]							= loadFX("water/fx_rain_spatter_25x50");
	level._effect["fx_rain_spatter_25x120"] 						=	loadFX("water/fx_rain_spatter_25x120");
	level._effect["fx_water_splash_detail_lg"]					= loadFX("water/fx_water_splash_detail_lg");
	level._effect["fx_pak_water_elec_pole_wake"]				= loadFX("water/fx_pak_water_elec_pole_wake");
	level._effect["fx_pak_water_pipe_spill_wake"]				= loadFX("water/fx_pak_water_pipe_spill_wake");
	level._effect["fx_water_spill_splash_wide"]					= loadFX("water/fx_water_spill_splash_wide");
	level._effect["fx_water_drips_hvy_30"]							= loadFX("water/fx_water_drips_hvy_30");
	level._effect["fx_water_drips_hvy_120"]							= loadFX("water/fx_water_drips_hvy_120");
	level._effect["fx_water_drips_hvy_200"]							= loadFX("water/fx_water_drips_hvy_200");
	level._effect["fx_pak_water_froth_sm_front"]				= loadFX("water/fx_pak_water_froth_sm_front");
	level._effect["fx_pak_water_froth_md_front"]				= loadFX("water/fx_pak_water_froth_md_front");
	level._effect["fx_pak_water_froth_sm_side"] 				= loadFX("water/fx_pak_water_froth_sm_side");
	
	// Lights
	level._effect["fx_pak_light_overhead_rain"]					= loadFX("light/fx_pak_light_overhead_rain");
}

footsteps()
{
}

toggle_water_fx_actor( localClientNum, set, newEnt )
{
	if ( set )  // turn on water fx
	{
		self thread _play_water_fx_actor( localClientNum );
	}
	else // turn off water fx
	{
		self _kill_water_fx_actor( localClientNum );
	}
}

_play_water_fx_actor( localClientNum )
{
	self notify( "stop_water_fx" );
	self endon( "stop_water_fx" );
	level endon( "save_restore" ); 
	
	// make sure AI is standing in water
	if ( !IsDefined( self.e_water_fx ) )
	{
		self.e_water_fx = Spawn( localClientNum, self.origin, "script_model" );
		self.e_water_fx SetModel( "tag_origin" );
	}
	
	self.playing_water_fx = false;
	
	if( !self IsPlayer() )
	{
		self thread play_water_fx_audio();
	}
	
	while ( IsDefined( self ) )
	{
		v_start = self.origin + ( 0, 0, 50 );
		v_end = self.origin - ( 0, 0, 150 );
		a_trace = BulletTrace( v_start, v_end, false, undefined );  // trace for water surface height
		
		if ( a_trace[ "surfacetype" ] == "water" )  // in water
		{	
			// move water fx ent to water surface, or ground
			self.e_water_fx.origin = a_trace[ "position" ];
			// if no fx playing, start playing fx
			if ( !self.playing_water_fx )
			{
				self.n_water_fx_id = PlayFxOnTag( localClientNum, level._effect[ "water_loop" ], self.e_water_fx, "tag_origin" );
				self.playing_water_fx = true;
			}			
		}
		else // not in water
		{
			// stop fx if they were playing before
			if ( self.playing_water_fx )
			{
				DeleteFX( localClientNum, self.n_water_fx_id, 0 );  // let fx fade out
				self.playing_water_fx = false;
			}
		}
		
		wait 0.1;
	}
}

_kill_water_fx_actor( localClientNum )
{
	self notify( "stop_water_fx" );
	
	if ( IsDefined( self.n_water_fx_id ) )
	{
		DeleteFX( localClientNum, self.n_water_fx_id, 0 );  // let fx loop and die off
		
		wait 2;  // wait until fx has finished playing before deleting entity it's attached to
	}

	if ( IsDefined ( self.e_water_fx ) )
	{
		self.e_water_fx Delete();
	}
}


toggle_water_fx_model( localClientNum, set, newEnt )
{
	if ( set )
	{
		self thread _play_water_fx_model( localClientNum );
	}
	else 
	{
		self _kill_water_fx_model( localClientNum );
	}
}

_play_water_fx_model( localClientNum )
{
	self notify( "stop_water_fx" );
	self endon( "stop_water_fx" );
	
	if ( !IsDefined( self.e_water_fx ) )
	{
		self.e_water_fx = Spawn( localClientNum, self.origin, "script_model" );
		self.e_water_fx SetModel( "tag_origin" );
	}
	
	n_fx_id = level._effect[ "frogger_wake_" + self.model ];
	
	if ( IsDefined( n_fx_id ) )
	{
		self.n_water_fx_id = PlayFxOnTag( localClientNum, n_fx_id, self.e_water_fx, "tag_origin" );
	}
	else 
	{
		return;
	}
	
	while ( IsDefined( self ) )
	{
		v_start = self.origin + ( 0, 0, 50 );
		v_end = self.origin - ( 0, 0, 150 );
		a_trace = BulletTrace( v_start, v_end, false, undefined );  // trace for water surface height
		
		if ( a_trace[ "surfacetype" ] == "water" )  // in water
		{
			self.e_water_fx.origin = a_trace[ "position" ];
			self.e_water_fx.angles = self _get_frogger_movement_direction_angles();
		}
		
		wait 0.05;
	}
}

_get_frogger_movement_direction_angles()
{
	// TODO: figure out how to get real movement direction. Since this is for frogger specifically, hard code angles to look down that street
	v_angles = ( 0, 90, 0 );
	
	return v_angles;
}

_kill_water_fx_model( localClientNum )
{
	self notify( "stop_water_fx" );
	
	if ( IsDefined( self.n_water_fx_id ) )
	{
		DeleteFX( localClientNum, self.n_water_fx_id, 0 );  //
		
		wait 2;  // wait until fx has finished playing before deleting entity it's attached to
	}

	if ( IsDefined ( self.e_water_fx ) )
	{
		self.e_water_fx Delete();
	}	
}

play_water_fx_audio()
{
	self endon( "death" );
	self endon( "stop_water_fx" );
	self endon( "entityshutdown" );
	self.e_water_fx endon( "death" );
	
	while( IsDefined( self ) && IsDefined( self.playing_water_fx ) )
	{
		while( IsDefined( self ) )
		{
			if( self GetSpeed() > 50 )
			{
				self.e_water_fx playloopsound( "chr_swimming_swim_loop_npc", .1 );
			}
			else
			{
				self.e_water_fx playloopsound( "chr_swimming_float_loop_npc", .1 );
			}
			wait(.25);
		}
		
		self.e_water_fx stoploopsound( 1 );
		wait(.25);
	}
}