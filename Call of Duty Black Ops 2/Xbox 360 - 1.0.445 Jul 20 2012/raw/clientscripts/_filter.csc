// #include clientscripts\_utility; 

//-----------------------------------------------------------------------------

/*
	init_filter_indices();
	map_material_helper( player, materialname );
	
	player set_filter_pass_constant( filterid, passid, 0, x );
	player set_filter_pass_constant( filterid, passid, 1, y );
	player set_filter_pass_constant( filterid, passid, 2, z );
	
	player set_filter_pass_material( filterid, passid, level.filter_matid[materialname] );
	player set_filter_pass_quads( filterid, passid, quads );
	player set_filter_pass_enabled( filterid, passid, true );
		
*/

//-----------------------------------------------------------------------------

init_filter_indices()
{
	if ( isdefined( level.genericfilterinitialized ) ) // only need to do this once...
		return;
		
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.genericfilterinitialized = true;
	
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.filter_matcount = 5; // First two slots are reserved for the regular and infrared ADS scope filters
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
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_binoculars"] );
		player set_filter_pass_enabled( filterid, 0, true );
	}

	disable_filter_binoculars( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Binoculars With Outline )
//
//-----------------------------------------------------------------------------

        init_filter_binoculars_with_outline( player )
        {
                init_filter_indices();
                map_material_helper( player, "generic_filter_binoculars_with_outline" );
        }
        
        enable_filter_binoculars_with_outline( player, filterid, overlayid )
        {
                player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_binoculars_with_outline"] );
                player set_filter_pass_enabled( filterid, 0, true );
        }

        disable_filter_binoculars_with_outline( player, filterid, overlayid )
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
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_frost"] );
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
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_hazmat"] );
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
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_helmet"] );
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
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_overlay_tacticalmask"] );
		player set_filter_pass_enabled( filterid, 0, true ); 
	}

	disable_filter_tacticalmask( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false ); 
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
// Filter ( hud_outline ) - only needs to be initialized, the run-time specifically looks for it
//
//-----------------------------------------------------------------------------

	init_filter_hud_outline_code( player )
	{
		init_filter_indices();
		player map_material( 4, "generic_filter_hud_outline" );		
	}

//-----------------------------------------------------------------------------
//
// Init all the code filters:
//
//-----------------------------------------------------------------------------
	
	init_code_filters( player )
	{
		init_filter_scope( player );
		init_filter_infrared( player );
		init_filter_tvguided( player );
		init_filter_hud_outline_code( player );
		// If you add something here, be sure to update filter_matcount in init_filter_indices.
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
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_teargas"] ); 
		player set_filter_pass_enabled( filterid, 0, true );
				
		set_filter_teargas_amount( player, filterid, amount );
	}

	disable_filter_teargas( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}


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
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_sonar_glass2"] );
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
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_hud_outline"] );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_hud_outline( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

	
//-----------------------------------------------------------------------------
//
// Filter ( sonar attachment fullscreen )
//
//-----------------------------------------------------------------------------

	init_filter_sonar_attachment( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_overlay_sonar_attachment" );
	}
	
	set_filter_sonar_attachment_params( player, filterid, pulse_duration, pulse_time )
	{
		player set_filter_pass_constant( filterid, 0, 10, pulse_duration ); // scriptVector2.z
		player set_filter_pass_constant( filterid, 0, 11, pulse_time );     // scriptVector2.w
	}
	
	enable_filter_sonar_attachment( player, filterid, overlayid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_overlay_sonar_attachment"] );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_sonar_attachment( player, filterid, overlayid )
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
	
	enable_filter_hud_projected_grid( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_hud_projected_grid"] );
		player set_filter_pass_enabled( filterid, 0, true );
	       	player set_filter_hud_projected_grid_position( player, filterid, 500 );
	       	player set_filter_hud_projected_grid_radius( player, filterid, 200 );
      	}
	
	disable_filter_hud_projected_grid( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}


//-----------------------------------------------------------------------------
//
// Filter ( rts hologram )
//
//-----------------------------------------------------------------------------

	init_filter_rts_hologram( player, materialName )
	{
		init_filter_indices();
		map_material_helper( player, materialName );
    }
	
	set_filter_rts_hologram_position( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}

    set_filter_rts_hologram_radius( player, filterid, amount )	
	{
		player set_filter_pass_constant( filterid, 0, 1, amount );
	}
	
	enable_filter_rts_hologram( player, filterid, materialName )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid[materialName] );
		player set_filter_pass_enabled( filterid, 0, true );
	  	player set_filter_rts_hologram_position( player, filterid, 500 );
	  	player set_filter_rts_hologram_radius( player, filterid, 200 );
        player set_filter_bit_flag( filterid, 0, 1 );
    }
	
	disable_filter_rts_hologram( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
        player set_filter_bit_flag( filterid, 0, 0 );
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
	
	enable_filter_satellite_transition( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_satellite_transition"] );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_satellite_transition( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}


//-----------------------------------------------------------------------------
//
// Filter ( SAM/F35 Damage )
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
		
	enable_filter_f35_damage( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_f35_damage"] );
		player set_filter_pass_enabled( filterid, 0, true );

		set_filter_f35_damage_amount( player, filterid, 0 );
	}
	
	disable_filter_f35_damage( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}


//-----------------------------------------------------------------------------
//
// Filter ( Karma Spiderbot )
//
//-----------------------------------------------------------------------------

	init_filter_karma_spiderbot( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_karma_spiderbot" );
	}
	
	enable_filter_karma_spiderbot( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_karma_spiderbot"] );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_karma_spiderbot( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Karma Low Light )
//
//-----------------------------------------------------------------------------

        init_filter_karma_lowlight( player )
        {
                init_filter_indices();
                map_material_helper( player, "generic_filter_karma_lowlight" );
        }
        
        enable_filter_karma_lowlight( player, filterid )
        {
                player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_karma_lowlight"] );
                player set_filter_pass_enabled( filterid, 0, true );
        }
        
        disable_filter_karma_lowlight( player, filterid )
        {
                player set_filter_pass_enabled( filterid, 0, false );
        }

	
	
//-----------------------------------------------------------------------------
//
// Filter ( Vehicle Damage )
//
//-----------------------------------------------------------------------------

	init_filter_vehicle_damage( player, materialname )
	{
		init_filter_indices();
		map_material_helper( player, materialname );		
	}
	
	set_filter_vehicle_damage_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	set_filter_vehicle_sun_position( player, filterid, x, y )
	{
		player set_filter_pass_constant( filterid, 0, 4, x );
		player set_filter_pass_constant( filterid, 0, 5, y );
	}
	
	enable_filter_vehicle_damage( player, filterid, materialname )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid[materialname] );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_vehicle_damage( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}



//-----------------------------------------------------------------------------
//
// Filter ( EMP )
//
//-----------------------------------------------------------------------------

	init_filter_emp( player, materialname )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_emp_damage" );		
	}
	
	set_filter_emp_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_emp( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_emp_damage"] );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_emp( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Raindrops )
//
//-----------------------------------------------------------------------------

	init_filter_raindrops( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_raindrops" );
	}
	
	set_filter_raindrops_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_raindrops( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_raindrops"] );
		player set_filter_pass_enabled( filterid, 0, true );
		player set_filter_pass_quads( filterid, 0, 400 );

		set_filter_raindrops_amount( player, filterid, 1.0 );
	}
	
	disable_filter_raindrops( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	

//-----------------------------------------------------------------------------
//
// Filter ( Squirrel Raindrops )
//
//-----------------------------------------------------------------------------

	init_filter_squirrel_raindrops( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_squirrel_raindrops" );
	}
	
	set_filter_squirrel_raindrops_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_squirrel_raindrops( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_squirrel_raindrops"] );
		player set_filter_pass_enabled( filterid, 0, true );
		player set_filter_pass_quads( filterid, 0, 400 );

		set_filter_squirrel_raindrops_amount( player, filterid, 1.0 );
	}
	
	disable_filter_squirrel_raindrops( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	

//-----------------------------------------------------------------------------
//
// Filter ( Zodiac Raindrops )
//
//-----------------------------------------------------------------------------

	init_filter_zodiac_raindrops( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_zodiac_raindrops" );
	}
	
	set_filter_zodiac_raindrops_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_zodiac_raindrops( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_zodiac_raindrops"] );
		player set_filter_pass_enabled( filterid, 0, true );
		player set_filter_pass_quads( filterid, 0, 400 );

		set_filter_zodiac_raindrops_amount( player, filterid, 1.0 );
	}
	
	disable_filter_zodiac_raindrops( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}


//-----------------------------------------------------------------------------
//
// Filter ( Rage )
//
//-----------------------------------------------------------------------------

	init_filter_rage( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_rage" );
	}
	
	set_filter_rage_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_rage( player, filterid, amount )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_rage"] );
		player set_filter_pass_enabled( filterid, 0, true );

		set_filter_rage_amount( player, filterid, amount );
	}
	
	disable_filter_rage( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
	
//-----------------------------------------------------------------------------
//
// Filter ( Massiah )
//
//-----------------------------------------------------------------------------

	init_filter_massiah( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_massiah" );
	}
	
	set_filter_massiah_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_massiah( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_massiah"] );
		player set_filter_pass_enabled( filterid, 0, true );

		set_filter_massiah_amount( player, filterid, 1.0 );
	}
	
	disable_filter_massiah( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	


//-----------------------------------------------------------------------------
//
// Filter ( Oxygen Mask - Haiti )
//
//-----------------------------------------------------------------------------

	init_filter_oxygenmask( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_oxygenmask_warp" );
		map_material_helper( player, "generic_filter_oxygenmask_condensation" );
		map_material_helper( player, "generic_overlay_oxygenmask_1" );
		map_material_helper( player, "generic_overlay_oxygenmask_2" );
		map_material_helper( player, "generic_overlay_oxygenmask_3" );
		map_material_helper( player, "generic_overlay_oxygenmask_4" );
	}
	
	set_filter_oxygenmask_amount( player, filterid_warp, amount )
	{
		player set_filter_pass_constant( filterid_warp, 0, 0, amount );
	}

	set_filter_oxygenmask_smoke_amount( player, filterid_warp, amount )
	{
		player set_filter_pass_constant( filterid_warp, 0, 1, amount );
	}

	set_filter_oxygenmask_condensation_amount( player, filterid_condensation, amount )
	{
		player set_filter_pass_constant( filterid_condensation, 0, 0, amount );
	}
	
	set_filter_oxygenmask_crack_state( player, overlayid, stage )
	{
		if ( stage == 1 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_oxygenmask_1"], 1 ); 
		else if ( stage == 2 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_oxygenmask_2"], 1 ); 
		else if ( stage == 3 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_oxygenmask_3"], 1 ); 
		else if ( stage == 4 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_oxygenmask_4"], 1 ); 		
	}
		
	enable_filter_oxygenmask( player, filterid_warp, filterid_condensation, overlayid, stage )
	{
		player set_filter_pass_material( filterid_warp, 0, level.filter_matid["generic_filter_oxygenmask_warp"] );
		player set_filter_pass_enabled( filterid_warp, 0, true );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		player set_filter_pass_material( filterid_condensation, 0, level.filter_matid["generic_filter_oxygenmask_condensation"] );
		player set_filter_pass_enabled( filterid_condensation, 0, true );
		player set_filter_pass_quads( filterid_condensation, 0, 400 );

		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		if ( stage == 1 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_oxygenmask_1"], 1 ); 
		else if ( stage == 2 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_oxygenmask_2"], 1 ); 
		else if ( stage == 3 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_oxygenmask_3"], 1 ); 
		else if ( stage == 4 )
			player set_overlay_material( overlayid, level.filter_matid["generic_overlay_oxygenmask_4"], 1 ); 

		player set_overlay_enabled( overlayid, true );
	}

	disable_filter_oxygenmask( player, filterid_warp, filterid_condensation, overlayid )
	{
		player set_filter_pass_enabled( filterid_warp, 0, false );
		player set_filter_pass_enabled( filterid_condensation, 0, false );
		player set_overlay_enabled( overlayid, false );
	}


//-----------------------------------------------------------------------------
//
// Filter ( Harper Blood Splat )
//
//-----------------------------------------------------------------------------

	init_filter_harper_blood( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_harper_blood" );
	}
	
	set_filter_harper_blood_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_harper_blood( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_harper_blood"] );
		player set_filter_pass_enabled( filterid, 0, true );

		set_filter_harper_blood_amount( player, filterid, 1.0 );
	}
	
	disable_filter_harper_blood( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( Pakistan CLAW Boot-up )
//
//-----------------------------------------------------------------------------

	init_filter_claw_boot( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_boot_up" );
	}
	
	set_filter_claw_boot_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_claw_boot( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_boot_up"] );
		player set_filter_pass_enabled( filterid, 0, true );

		set_filter_claw_boot_amount( player, filterid, 1.0 );
	}
	
	disable_filter_claw_boot( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Angola Gun Cam )
//
//-----------------------------------------------------------------------------

	init_filter_angola_gun_cam( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_angola_gun_cam" );
	}
	
	set_filter_angola_gun_cam( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
	enable_filter_angola_gun_cam( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_angola_gun_cam"] );
		player set_filter_pass_enabled( filterid, 0, true );

		set_filter_angola_gun_cam( player, filterid, 1.0 );
	}
	
	disable_filter_angola_gun_cam( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}