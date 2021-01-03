    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
#using scripts\shared\postfx_shared;

#namespace filter;

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

function init_filter_indices()
{
	if ( isdefined( level.genericfilterinitialized ) ) // only need to do this once...
		return;
		
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.genericfilterinitialized = true;
	
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.filter_matcount = 4; // First two slots are reserved for the regular and infrared ADS scope filters
}


//-----------------------------------------------------------------------------


function map_material_helper( player, materialname )
{
	init_filter_indices();
	
	if ( isdefined( level.filter_matid ) && isdefined( level.filter_matid[ materialname ] ) )
	{
		player map_material( level.filter_matid[ materialname ], materialname );
		return;
	}

	level.filter_matid[materialname] = level.filter_matcount;
	player map_material( level.filter_matcount, materialname );
	level.filter_matcount++;
}
		
function mapped_material_id( materialname )
{
	if(!isdefined(level.filter_matid))level.filter_matid=[];
	return level.filter_matid[materialname];
}


		
//-----------------------------------------------------------------------------
//
// Filter ( Binoculars )
//
//-----------------------------------------------------------------------------

function init_filter_binoculars( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_binoculars" );
	}
	
function enable_filter_binoculars( player, filterid, overlayid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_binoculars") );
		player set_filter_pass_enabled( filterid, 0, true );
	}

function disable_filter_binoculars( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}


//-----------------------------------------------------------------------------
//
// Filter ( Binoculars With Outline )
//
//-----------------------------------------------------------------------------

function init_filter_binoculars_with_outline( player )
        {
                init_filter_indices();
                map_material_helper( player, "generic_filter_binoculars_with_outline" );
        }
        
function enable_filter_binoculars_with_outline( player, filterid, overlayid )
        {
                player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_binoculars_with_outline") );
                player set_filter_pass_enabled( filterid, 0, true );
        }

function disable_filter_binoculars_with_outline( player, filterid, overlayid )
        {
                player set_filter_pass_enabled( filterid, 0, false );
        }

//-----------------------------------------------------------------------------
//
// Filter ( Hazmat )
//
//-----------------------------------------------------------------------------

function init_filter_hazmat( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_hazmat" );
		map_material_helper( player, "generic_overlay_hazmat_1" );
		map_material_helper( player, "generic_overlay_hazmat_2" );
		map_material_helper( player, "generic_overlay_hazmat_3" );
		map_material_helper( player, "generic_overlay_hazmat_4" );
	}
	
function set_filter_hazmat_opacity( player, filterid, overlayid, opacity )
	{
		player set_filter_pass_constant( filterid, 0, 0, opacity );
		player set_overlay_constant( overlayid, 0, opacity );
	}
		
function enable_filter_hazmat( player, filterid, overlayid, stage, opacity )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_hazmat") );
		player set_filter_pass_enabled( filterid, 0, true );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		if ( stage == 1 )
			player set_overlay_material( overlayid, mapped_material_id("generic_overlay_hazmat_1"), 1 ); 
		else if ( stage == 2 )
			player set_overlay_material( overlayid, mapped_material_id("generic_overlay_hazmat_2"), 1 ); 
		else if ( stage == 3 )
			player set_overlay_material( overlayid, mapped_material_id("generic_overlay_hazmat_3"), 1 ); 
		else if ( stage == 4 )
			player set_overlay_material( overlayid, mapped_material_id("generic_overlay_hazmat_4"), 1 ); 
			
		player set_overlay_enabled( overlayid, true );
						
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		set_filter_hazmat_opacity( player, filterid, overlayid, opacity );
	}

function disable_filter_hazmat( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
		player set_overlay_enabled( overlayid, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Helmet )
//
//-----------------------------------------------------------------------------

function init_filter_helmet( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_helmet" );
		map_material_helper( player, "generic_overlay_helmet" );
	}
	
function enable_filter_helmet( player, filterid, overlayid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_helmet") );
		player set_filter_pass_enabled( filterid, 0, true );
		
		player set_overlay_material( overlayid, mapped_material_id("generic_overlay_helmet"), 1 ); 
		player set_overlay_enabled( overlayid, true );
	}

function disable_filter_helmet( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
		player set_overlay_enabled( overlayid, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( TacticalMask )
//
//-----------------------------------------------------------------------------

function init_filter_tacticalmask( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_overlay_tacticalmask" );
	}
	
function enable_filter_tacticalmask( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_overlay_tacticalmask") );
		player set_filter_pass_enabled( filterid, 0, true ); 
	}

function disable_filter_tacticalmask( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false ); 
	}


//-----------------------------------------------------------------------------
//
// Filter ( Scope ) - only needs to be initialized, the run-time specifically looks for it
//
//-----------------------------------------------------------------------------

function init_filter_scope( player )
	{
		init_filter_indices();

		// this effect doesn't work in PS3 splitscreen, so we don't
		// use it in that case.
		if ( GetActiveLocalClients() == 1 )
			player map_material( 0, "generic_filter_scope" ); // special case material for ADS
	}

//-----------------------------------------------------------------------------
//
// Filter ( Infrared ) - only needs to be initialized, the run-time specifically looks for it
//
//-----------------------------------------------------------------------------

function init_filter_infrared( player )
	{
		init_filter_indices();
	
		// this effect (also) doesn't work in PS3 splitscreen, so we don't
		// use it in that case.
		if ( GetActiveLocalClients() == 1 )
			player map_material( 1, "generic_filter_infrared" ); // special case material for ADS
	}

//-----------------------------------------------------------------------------
//
// Filter ( TV Guided Missile ) - only needs to be initialized, the run-time specifically looks for it
//
//-----------------------------------------------------------------------------
	
function init_filter_tvguided( player )
	{
		init_filter_indices();
		player map_material( 2, "tow_filter_overlay_sp" ); 
		player map_material( 3, "tow_overlay" );		
	}
	

//-----------------------------------------------------------------------------
//
// Filter ( hud_outline ) - only needs to be initialized, the run-time specifically looks for it
//
//-----------------------------------------------------------------------------

function init_filter_hud_outline_code( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_hud_outline" );		
	}

//-----------------------------------------------------------------------------
//
// Init all the code filters:
//
//-----------------------------------------------------------------------------
	
function init_code_filters( player )
	{
		init_filter_scope( player );
		init_filter_infrared( player );
		init_filter_tvguided( player );
		init_filter_hud_outline_code( player );
		// If you add something here, be sure to update filter_matcount in init_filter_indices.
	}
	
	
//-----------------------------------------------------------------------------
//
// Filter ( hud outline )
//
//-----------------------------------------------------------------------------

function init_filter_hud_outline( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_hud_outline" );
	}
	
function set_filter_hud_outline_reveal_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
		player set_filter_pass_constant( filterid, 1, 0, amount );
	}
	
function enable_filter_hud_outline( player, filterid, overlayid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_hud_outline") );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
function disable_filter_hud_outline( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}


//-----------------------------------------------------------------------------
//
// Filter ( hud projected grid )
//
//-----------------------------------------------------------------------------

function init_filter_hud_projected_grid( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_hud_projected_grid" );
    }

function init_filter_hud_projected_grid_haiti( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_hud_projected_grid_haiti" );
    }
	
function set_filter_hud_projected_grid_position( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}

function set_filter_hud_projected_grid_radius( player, filterid, amount )	
	{
		player set_filter_pass_constant( filterid, 0, 1, amount );
	}
	
function enable_filter_hud_projected_grid( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_hud_projected_grid") );
		player set_filter_pass_enabled( filterid, 0, true );
	   	player set_filter_hud_projected_grid_position( player, filterid, 500 );
	   	player set_filter_hud_projected_grid_radius( player, filterid, 200 );
    }
	
function enable_filter_hud_projected_grid_haiti( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_hud_projected_grid_haiti") );
		player set_filter_pass_enabled( filterid, 0, true );
	   	player set_filter_hud_projected_grid_position( player, filterid, 500 );
	   	player set_filter_hud_projected_grid_radius( player, filterid, 200 );
    }

function disable_filter_hud_projected_grid( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}


//-----------------------------------------------------------------------------
//
// Filter ( EMP )
//
//-----------------------------------------------------------------------------

function init_filter_emp( player, materialname )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_emp_damage" );		
	}
	
function set_filter_emp_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
function enable_filter_emp( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_emp_damage") );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
function disable_filter_emp( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Raindrops )
//
//-----------------------------------------------------------------------------

function init_filter_raindrops( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_raindrops" );
	}
	
function set_filter_raindrops_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
function enable_filter_raindrops( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_raindrops") );
		player set_filter_pass_enabled( filterid, 0, true );
		player set_filter_pass_quads( filterid, 0, 400 );

		set_filter_raindrops_amount( player, filterid, 1.0 );
	}
	
function disable_filter_raindrops( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Squirrel Raindrops )
//
//-----------------------------------------------------------------------------

function init_filter_squirrel_raindrops( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_squirrel_raindrops" );
	}
	
function set_filter_squirrel_raindrops_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
function enable_filter_squirrel_raindrops( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_squirrel_raindrops") );
		player set_filter_pass_enabled( filterid, 0, true );
		player set_filter_pass_quads( filterid, 0, 400 );

		set_filter_squirrel_raindrops_amount( player, filterid, 1.0 );
	}
	
function disable_filter_squirrel_raindrops( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	

//-----------------------------------------------------------------------------
//
// Filter ( Radial Blur )
//
//-----------------------------------------------------------------------------

function init_filter_radialblur( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_radialblur" );
	}
	
function set_filter_radialblur_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
function enable_filter_radialblur( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_radialblur") );
		player set_filter_pass_enabled( filterid, 0, true );
		
		set_filter_radialblur_amount( player, filterid, 1.0 );
	}
	
function disable_filter_radialblur( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Vehicle Damage )
//
//-----------------------------------------------------------------------------

function init_filter_vehicle_damage( player, materialname )
	{
		init_filter_indices();
		
		if ( !isdefined( level.filter_matid[ materialname ] ) )
			map_material_helper( player, materialname );		
	}
	
function set_filter_vehicle_damage_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}
	
function set_filter_vehicle_sun_position( player, filterid, x, y )
	{
		player set_filter_pass_constant( filterid, 0, 4, x );
		player set_filter_pass_constant( filterid, 0, 5, y );
	}
	
function enable_filter_vehicle_damage( player, filterid, materialname )
	{
		if ( isdefined( level.filter_matid[ materialname ] ) )
		{
			player set_filter_pass_material( filterid, 0, level.filter_matid[ materialname ] );
			player set_filter_pass_enabled( filterid, 0, true );
		}
	}
	
function disable_filter_vehicle_damage( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( MP out of bounds )
//
//-----------------------------------------------------------------------------

function init_filter_oob( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_out_of_bounds" );
	}
	
function enable_filter_oob( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id( "generic_filter_out_of_bounds" ) );
		player set_filter_pass_enabled( filterid, 0, true );
	}

function disable_filter_oob( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( EMP/Tactical grenades )
//
//-----------------------------------------------------------------------------

function init_filter_tactical( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_tactical_damage" );		
	}
	
	
function enable_filter_tactical( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_tactical_damage") );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
function set_filter_tactical_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}

function disable_filter_tactical( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter water sheeting
//
//-----------------------------------------------------------------------------

function init_filter_water_sheeting( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_water_sheeting" );		
	}
	
function enable_filter_water_sheeting( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id( "generic_filter_water_sheeting" ) );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
function set_filter_water_sheet_reveal( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}

function set_filter_water_sheet_speed( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 1, amount );
	}

function set_filter_water_sheet_rivulet_reveal( player, filterid, riv1, riv2, riv3 )
	{
		player set_filter_pass_constant( filterid, 0, 2, riv1 );
		player set_filter_pass_constant( filterid, 0, 3, riv2 );
		player set_filter_pass_constant( filterid, 0, 4, riv3 );
	}

function disable_filter_water_sheeting( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter water dive
//
//-----------------------------------------------------------------------------

function init_filter_water_dive( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_water_dive" );		
	}
	
	
function enable_filter_water_dive( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id( "generic_filter_water_dive" ) );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
function disable_filter_water_dive( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

function set_filter_water_dive_bubbles( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}

function set_filter_water_scuba_bubbles( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 1, amount );
	}

function set_filter_water_scuba_dive_speed( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 2, amount );
	}

function set_filter_water_scuba_bubble_attitude( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 3, amount );
	}

function set_filter_water_wash_reveal_dir( player, filterid, dir )
	{
		player set_filter_pass_constant( filterid, 0, 4, dir );
	}

function set_filter_water_wash_color( player, filterid, red, green, blue )
	{
		player set_filter_pass_constant( filterid, 0, 5, red );
		player set_filter_pass_constant( filterid, 0, 6, green );
		player set_filter_pass_constant( filterid, 0, 7, blue );
	}

//-----------------------------------------------------------------------------
//
// Filter teleportation
//
//-----------------------------------------------------------------------------

function init_filter_teleportation( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_teleportation" );		
	}
	
	
function enable_filter_teleportation( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id( "generic_filter_teleportation" ) );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
function set_filter_teleportation_anus_zoom( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}

function set_filter_teleportation_anus_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 6, amount );
	}

function set_filter_teleportation_panther_zoom( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 1, amount );
	}

function set_filter_teleportation_panther_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 7, amount );
	}

function set_filter_teleportation_glow_radius( player, filterid, radius )
	{
		player set_filter_pass_constant( filterid, 0, 2, radius );
	}

function set_filter_teleportation_warp_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 3, amount );
	}

function set_filter_teleportation_warp_direction( player, filterid, direction )
	{
		player set_filter_pass_constant( filterid, 0, 4, direction );
	}

function set_filter_teleportation_lightning_reveal( player, filterid, threshold )
	{
		player set_filter_pass_constant( filterid, 0, 5, threshold );
	}

function set_filter_teleportation_faces_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 8, amount );
	}

function set_filter_teleportation_space_background( player, filterid, set )
	{
		player set_filter_pass_constant( filterid, 0, 9, set );
	}

function set_filter_teleportation_sparkle_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 10, amount );
	}

function disable_filter_teleportation( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

function SetTransported( player )
	{
		player thread postfx::PlayPostfxBundle( "zm_teleporter" );
	}

//-----------------------------------------------------------------------------
//
// Filter ( EV Interference )
//
//-----------------------------------------------------------------------------

function init_filter_ev_interference( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_ev_interference" );		
	}
	
function enable_filter_ev_interference( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_ev_interference") );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
function set_filter_ev_interference_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}

function disable_filter_ev_interference( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
	
		
//-----------------------------------------------------------------------------
//
// Filter ( VehicleHijack )
//
//-----------------------------------------------------------------------------

function init_filter_vehicleHijack( player )
{
	init_filter_indices();
	map_material_helper( player, "generic_filter_vehicle_takeover" );
	return mapped_material_id( "generic_filter_vehicle_takeover" );
}
function enable_filter_vehicleHijack( player, filterid, overlayid )
{
	player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_vehicle_takeover") );
	player set_filter_pass_enabled( filterid, 0, true );
}
function disable_filter_vehicleHijack( player, filterid, overlayid )
{
	player set_filter_pass_enabled( filterid, 0, false );
}
function set_filter_ev_vehicleHijack_amount( player, filterid, amount )
{
	player set_filter_pass_constant( filterid, 0, 0, amount );
}

//-----------------------------------------------------------------------------
//
// Filter ( Vehicle Hijack Out of Range )
//
//-----------------------------------------------------------------------------

function init_filter_vehicle_hijack_oor( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_vehicle_out_of_range" );		
	}
	
function enable_filter_vehicle_hijack_oor( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id( "generic_filter_vehicle_out_of_range" ) );
		player set_filter_pass_enabled( filterid, 0, true );

		player set_filter_pass_constant( filterid, 0, 1, 1.0 );
		player set_filter_pass_constant( filterid, 0, 2, 1.0 );
		player set_filter_pass_constant( filterid, 0, 3, 1.0 );
		player set_filter_pass_constant( filterid, 0, 4, -1.0 );
	}
	
function set_filter_vehicle_hijack_oor_amount( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}

function disable_filter_vehicle_hijack_oor( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Speed Burst )
//
//-----------------------------------------------------------------------------

function init_filter_speed_burst( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_speed_burst" );		
	}
	
function enable_filter_speed_burst( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id("generic_filter_speed_burst") );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
function set_filter_speed_burst( player, filterid, constantindex, amount )
	{
		player set_filter_pass_constant( filterid, 0, constantindex, amount );
	}

function disable_filter_speed_burst( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
	
//-----------------------------------------------------------------------------
//
// Filter ( Frost )
//
//-----------------------------------------------------------------------------

function init_filter_frost( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_frost" );		
	}
	
function enable_filter_frost( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id( "generic_filter_frost" ) );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
function set_filter_frost_layer_one( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 0, amount );
	}

function set_filter_frost_layer_two( player, filterid, amount )
	{
		player set_filter_pass_constant( filterid, 0, 1, amount );
	}

function set_filter_frost_reveal_direction( player, filterid, direction )
	{
		player set_filter_pass_constant( filterid, 0, 2, direction );
	}

function disable_filter_frost( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}

//-----------------------------------------------------------------------------
//
// Filter ( Vision Pulse )
//
//-----------------------------------------------------------------------------

function init_filter_vision_pulse( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_vision_pulse" );		
	}
	
function enable_filter_vision_pulse( player, filterid )
	{
		player set_filter_pass_material( filterid, 0, mapped_material_id( "generic_filter_vision_pulse" ) );
		player set_filter_pass_enabled( filterid, 0, true );
	}

function set_filter_vision_pulse_constant( player, filterid, constid, value )
	{
		player set_filter_pass_constant( filterid, 0, constid, value );
	}

function disable_filter_vision_pulse( player, filterid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
