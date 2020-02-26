// #include clientscripts\_utility; 

//-----------------------------------------------------------------------------

init_filter_indices()
{
	if ( isdefined( level.genericfilterinitialized ) ) // only need to do this once...
		return;
		
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.genericfilterinitialized = true;
	
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.filter_matcount = 4; // First two slots are reserved for the regular and infrared ADS scope filters
	
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.targetid_none		 = 0;
	level.targerid_small0	 = 1;
	level.targerid_small1	 = 2;
	level.targerid_scene	 = 3;
	level.targerid_postsun	 = 4;
	level.targerid_smallblur = 5;
}


//-----------------------------------------------------------------------------


map_material_helper( player, materialname )
{
	level.filter_matid[materialname] = level.filter_matcount;
	player map_material( level.filter_matcount, materialname );
	level.filter_matcount++;
}
		
		
//-----------------------------------------------------------------------------
//
// Filter ( Binoculars )
//
//-----------------------------------------------------------------------------

	init_filter_binoculars( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_binoculars" );
	}
	
	enable_filter_binoculars( player, filterid, overlayid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_binoculars"], level.targerid_scene, level.targerid_scene, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
	}

	disable_filter_binoculars( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Warp SR71 )
//
//-----------------------------------------------------------------------------

	init_filter_warp_sr71( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_warp_sr71" );
	}
	
	set_filter_warp_sr71_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_warp_sr71( player, filterid, amount )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_warp_sr71"], level.targerid_scene, level.targerid_smallblur, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

		set_filter_warp_sr71_amount( player, filterid, amount );
	}

	disable_filter_warp_sr71( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( Frost )
//
//-----------------------------------------------------------------------------

	init_filter_frost( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_frost" );
	}
	
	set_filter_frost_opacity( player, filterid, opacity )
	{
		player set_filter_pass_constant( filterid, 0, 0, opacity );
	}
	
	enable_filter_frost( player, filterid, opacity )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_frost"], level.targerid_scene, level.targerid_scene, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

		set_filter_frost_opacity( player, filterid, opacity );
	}

	disable_filter_frost( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( Pentagon - Fullscreen )
//
//-----------------------------------------------------------------------------

	init_filter_pentagon_fullscreen( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_pentagon_fullscreen" );
	}
	
	set_filter_pentagon_fullscreen_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_pentagon_fullscreen( player, filterid, amount )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_pentagon_fullscreen"], level.targerid_scene, level.targerid_scene, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

		set_filter_pentagon_fullscreen_amount( player, filterid, amount );
	}

	disable_filter_pentagon_fullscreen( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( Pentagon - Blowout )
//
//-----------------------------------------------------------------------------

	init_filter_pentagon_blowout( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_pentagon_blowout" );
	}
	
	set_filter_pentagon_blowout_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_pentagon_blowout( player, filterid, amount )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_pentagon_blowout"], level.targerid_scene, level.targerid_scene, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

		set_filter_pentagon_blowout_amount( player, filterid, amount );
	}

	disable_filter_pentagon_blowout( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( Pentagon - BulgeBlur )
//
//-----------------------------------------------------------------------------

	init_filter_pentagon_bulgeblur( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_pentagon_bulgeblur" );
	}
	
	set_filter_pentagon_bulgeblur_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_pentagon_bulgeblur( player, filterid, amount )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_pentagon_bulgeblur"], level.targerid_scene, level.targerid_smallblur, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

		set_filter_pentagon_bulgeblur_amount( player, filterid, amount );
	}

	disable_filter_pentagon_bulgeblur( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( Pentagon - MultiCam1 )
//
//-----------------------------------------------------------------------------

	init_filter_pentagon_multicam1( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_pentagon_multicam1" );
	}
	
	set_filter_pentagon_multicam1_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	set_filter_pentagon_multicam1_bink1( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 1, amount );
	}
	
	set_filter_pentagon_multicam1_bink2( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 2, amount );
	}
	
	enable_filter_pentagon_multicam1( player, filterid, amount )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_pentagon_multicam1"], level.targerid_scene, level.targerid_scene, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

		set_filter_pentagon_multicam1_amount( player, filterid, amount );
	}

	disable_filter_pentagon_multicam1( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( Pentagon - MultiCam2 )
//
//-----------------------------------------------------------------------------

	init_filter_pentagon_multicam2( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_pentagon_multicam2" );
	}
	
	set_filter_pentagon_multicam2_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	set_filter_pentagon_multicam2_bink1( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 1, amount );
	}
	
	set_filter_pentagon_multicam2_bink2( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 2, amount );
	}
	
	enable_filter_pentagon_multicam2( player, filterid, amount )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_pentagon_multicam2"], level.targerid_scene, level.targerid_scene, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

		set_filter_pentagon_multicam2_amount( player, filterid, amount );
	}

	disable_filter_pentagon_multicam2( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( Hazmat )
//
//-----------------------------------------------------------------------------

	init_filter_hazmat( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_hazmat" );
		map_material_helper( player, "generic_overlay_hazmat_1" );
		map_material_helper( player, "generic_overlay_hazmat_2" );
		map_material_helper( player, "generic_overlay_hazmat_3" );
		map_material_helper( player, "generic_overlay_hazmat_4" );
	}
	
	set_filter_hazmat_opacity( player, filterid, overlayid, opacity )
	{
		player set_filter_pass_constant( filterid, 0, 0, opacity );
		player set_overlay_constant( overlayid, 0, opacity );
	}
		
	enable_filter_hazmat( player, filterid, overlayid, stage, opacity )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_hazmat"], level.targerid_scene, level.targerid_scene, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		if ( stage == 1 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_hazmat_1"], 1 ); 
		else if ( stage == 2 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_hazmat_2"], 1 ); 
		else if ( stage == 3 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_hazmat_3"], 1 ); 
		else if ( stage == 4 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_hazmat_4"], 1 ); 
			
		player set_overlay_enabled( overlayid, true );
						
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		set_filter_hazmat_opacity( player, filterid, overlayid, opacity );
	}

	disable_filter_hazmat( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
		player set_overlay_enabled( overlayid, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Helmet )
//
//-----------------------------------------------------------------------------

	init_filter_helmet( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_helmet" );
		map_material_helper( player, "generic_overlay_helmet" );
	}
	
	enable_filter_helmet( player, filterid, overlayid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_helmet"], level.targerid_scene, level.targerid_scene, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
		
		player set_overlay_material( overlayid, level.filter_matid["generic_overlay_helmet"], 1 ); 
		player set_overlay_enabled( overlayid, true );
	}

	disable_filter_helmet( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
		player set_overlay_enabled( overlayid, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( TacticalMask )
//
//-----------------------------------------------------------------------------

	init_filter_tacticalmask( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_overlay_tacticalmask" );
	}
	
	enable_filter_tacticalmask( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_overlay_tacticalmask"], level.targerid_scene, level.targerid_scene, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true ); 
	}

	disable_filter_tacticalmask( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false ); 
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( SuperFlare )
//
//-----------------------------------------------------------------------------

	init_filter_superflare( player, materialname )
	{
		init_filter_indices();
		map_material_helper( player, materialname );
	}
	
	set_filter_superflare_position( player, filterid, passid, x, y, z )
	{
		player set_filter_pass_constant( filterid, passid, 0, x );
		player set_filter_pass_constant( filterid, passid, 1, y );
		player set_filter_pass_constant( filterid, passid, 2, z );
	}
	
	set_filter_superflare_intensity( player, filterid, passid, intensity )
	{
		player set_filter_pass_constant( filterid, passid, 4, intensity );
	}
	
	set_filter_superflare_radius( player, filterid, passid, radius )
	{
		player set_filter_pass_constant( filterid, passid, 5, radius );
	}
	
	enable_filter_superflare( player, materialname, filterid, passid, quads, x, y, z, intensity, radius )
	{
		player set_filter_pass_material( filterid, passid, level.filter_matid[materialname], level.targerid_small0, level.targetid_none, level.targetid_none );
		player set_filter_pass_quads( filterid, passid, quads );
		player set_filter_pass_enabled( filterid, passid, true );
		
		set_filter_superflare_intensity( player, filterid, passid, intensity );
		set_filter_superflare_radius( player, filterid, passid, radius );
		set_filter_superflare_position( player, filterid, passid, x, y, z );
	}

	disable_filter_superflare( player, materialname, filterid, passid )
	{
		player set_filter_pass_enabled( filterid, passid, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( LensFlare )
//
//-----------------------------------------------------------------------------

	init_filter_lensflare( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_lensflare_cutoff" );
		map_material_helper( player, "generic_filter_lensflare_flip" );
		map_material_helper( player, "generic_filter_lensflare_apply" );
	}
	
	set_filter_lensflare_cutoff( player, filterid, cutoff )
	{
		player set_filter_pass_constant( filterid, 0, 0, cutoff );
	}

	set_filter_lensflare_intensity( player, filterid, intensity )
	{
		player set_filter_pass_constant( filterid, 0, 1, intensity );
	}

	set_filter_lensflare_brightness( player, filterid, brightness )
	{
		player set_filter_pass_constant( filterid, 1, 0, brightness );
	}

	enable_filter_lensflare( player, filterid, cutoff, intensity, brightness )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_lensflare_cutoff"], level.targerid_small0, level.targerid_smallblur, level.targetid_none ); 
		player set_filter_pass_enabled( filterid, 0, true );
		
		player set_filter_pass_material( filterid, 1, level.filter_matid["generic_filter_lensflare_flip"], level.targerid_small0, level.targerid_small0, level.targetid_none ); 
		player set_filter_pass_enabled( filterid, 1, true );
		
		player set_filter_pass_material( filterid, 2, level.filter_matid["generic_filter_lensflare_apply"], level.targerid_scene, level.targerid_small0, level.targetid_none ); 
		player set_filter_pass_enabled( filterid, 2, true );
		
		set_filter_lensflare_cutoff( player, filterid, cutoff );
		set_filter_lensflare_intensity( player, filterid, intensity );
		set_filter_lensflare_brightness( player, filterid, brightness );
	}

	disable_filter_lensflare( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
		player set_filter_pass_enabled( filterid, 1, false );
		player set_filter_pass_enabled( filterid, 2, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Scope ) - only needs to be initialized, the run-time specifically looks for it
//
//-----------------------------------------------------------------------------

	init_filter_scope( player )
	{
		init_filter_indices();

		// this effect doesn't work in PS3 splitscreen, so we don't
		// use it in that case.
		if( !isps3() || level.localPlayers.size == 1 )
			player map_material( 0, "generic_filter_scope" ); // special case material for ADS
	}

//-----------------------------------------------------------------------------
//
// Filter ( Infrared ) - only needs to be initialized, the run-time specifically looks for it
//
//-----------------------------------------------------------------------------

	init_filter_infrared( player )
	{
		init_filter_indices();
	
		// this effect (also) doesn't work in PS3 splitscreen, so we don't
		// use it in that case.
		if( !isps3() || level.localPlayers.size == 1 )
			player map_material( 1, "generic_filter_infrared" ); // special case material for ADS
	}

//-----------------------------------------------------------------------------
//
// Filter ( TV Guided Missile ) - only needs to be initialized, the run-time specifically looks for it
//
//-----------------------------------------------------------------------------
	
	init_filter_tvguided( player )
	{
		init_filter_indices();
		player map_material( 2, "tow_filter_overlay" ); 
		player map_material( 3, "tow_overlay" );		
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( TearGas )
//
//-----------------------------------------------------------------------------

	init_filter_teargas( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_teargas" );
	}
		
	set_filter_teargas_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_teargas( player, filterid, amount )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_teargas"], level.targerid_scene, level.targerid_scene, level.targetid_none ); 
		player set_filter_pass_enabled( filterid, 0, true );
				
		set_filter_teargas_amount( player, filterid, amount );
	}

	disable_filter_teargas( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( RcCarCam )
//
//-----------------------------------------------------------------------------

/*
	init_filter_rccarcam( player )
	{
		init_filter_indices();
		player map_material( level.matid_overlay_rccarcam, "generic_overlay_rccarcam" );
	}
	
	set_filter_rccarcam_noise( player, overlayid, noise )
	{
		player set_overlay_constant( overlayid, level.constid_overlay_rccarcam_noise, noise );
	}

	set_filter_rccarcam_scanline_speed( player, overlayid, scanline_speed )
	{
		player set_overlay_constant( overlayid, level.constid_overlay_rccarcam_scanline_speed, scanline_speed );
	}

	set_filter_rccarcam_scanline_intensity( player, overlayid, scanline_intensity )
	{
		player set_overlay_constant( overlayid, level.constid_overlay_rccarcam_scanline_intensity, scanline_intensity );
	}
		
	enable_filter_rccarcam( player, overlayid, noise, scanline_speed, scanline_intensity )
	{
		player enable_overlay( overlayid, true );
		player set_overlay_material( overlayid, level.matid_overlay_rccarcam, 1 ); 
		
		set_filter_rccarcam_noise( player, overlayid, noise ); 
		set_filter_rccarcam_scanline_speed( player, overlayid, scanline_speed ); 
		set_filter_rccarcam_scanline_intensity( player, overlayid, scanline_intensity ); 
	}

	disable_filter_rccarcam( player, overlayid )
	{
		player enable_overlay( overlayid, false ); 
	}
*/

//-----------------------------------------------------------------------------
//
// Filter ( sonar glass )
//
//-----------------------------------------------------------------------------

	init_filter_sonar( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_sonar_glass2" );
	}
	
	set_filter_sonar_reveal_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
		player set_filter_pass_constant( filterid, 1, 0, amount );
	}
	
	enable_filter_sonar_glass( player, filterid, overlayid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_sonar_glass2"], level.targerid_scene, level.targetid_none, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_sonar_glass( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( hud outline )
//
//-----------------------------------------------------------------------------

	init_filter_hud_outline( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_hud_outline" );
	}
	
	set_filter_hud_outline_reveal_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
		player set_filter_pass_constant( filterid, 1, 0, amount );
	}
	
	enable_filter_hud_outline( player, filterid, overlayid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_hud_outline"], level.targerid_scene, level.targetid_none, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_hud_outline( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}


//-----------------------------------------------------------------------------
//
// Filter ( hud projected grid )
//
//-----------------------------------------------------------------------------

	init_filter_hud_projected_grid( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_hud_projected_grid" );
      	}
	
	set_filter_hud_projected_grid_position( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}

        set_filter_hud_projected_grid_radius( player, filterid, amount )	
	{
		player set_filter_pass_constant( filterid, 0, 1, amount );
	}
	
	enable_filter_hud_projected_grid( player, filterid, overlayid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_hud_projected_grid"], level.targerid_scene, level.targetid_none, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
	       	player set_filter_hud_projected_grid_position( player, filterid, 500 );
	       	player set_filter_hud_projected_grid_radius( player, filterid, 200 );
      	}
	
	disable_filter_hud_projected_grid( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

	
//-----------------------------------------------------------------------------
//
// Filter ( satellite transition )
//
//-----------------------------------------------------------------------------

	init_filter_satellite_transition( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_satellite_transition" );
	}
	
	set_filter_satellite_transition_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_satellite_transition( player, filterid, overlayid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_satellite_transition"], level.targerid_scene, level.targetid_none, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_satellite_transition( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}


//-----------------------------------------------------------------------------
//
// Filter ( SAM Damage )
//
//-----------------------------------------------------------------------------

	init_filter_sam_damage( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_sam_damage" );
	}
	
	set_filter_sam_damage_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	set_filter_sam_sun_position( player, filterid, x, y )
	{
		player set_filter_pass_constant( filterid, 0, 4, x );
		player set_filter_pass_constant( filterid, 0, 5, y );
	}
	
	enable_filter_sam_damage( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_sam_damage"], level.targerid_scene, level.targetid_none, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_sam_damage( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	

//-----------------------------------------------------------------------------
//
// Filter ( F35 Damage )
//
//-----------------------------------------------------------------------------

	init_filter_f35_damage( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_f35_damage" );
	}
	
	set_filter_f35_damage_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	set_filter_f35_sun_position( player, filterid, x, y )
	{
		player set_filter_pass_constant( filterid, 0, 4, x );
		player set_filter_pass_constant( filterid, 0, 5, y );
	}
	
	enable_filter_f35_damage( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_f35_damage"], level.targerid_scene, level.targetid_none, level.targetid_none );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_f35_damage( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
