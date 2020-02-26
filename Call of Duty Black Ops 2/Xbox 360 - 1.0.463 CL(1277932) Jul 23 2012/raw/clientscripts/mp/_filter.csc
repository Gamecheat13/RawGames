// #include clientscripts\mp\_utility; 

//-----------------------------------------------------------------------------

init_filter_indices()
{
	if ( isdefined( level.genericfilterinitialized ) ) // only need to do this once...
		return;
		
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.genericfilterinitialized = true;
	
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.filter_matcount = 4; // First two slots are reserved for the regular and infrared ADS scope filters
}


//-----------------------------------------------------------------------------


map_material_helper( player, materialname )
{
	if ( IsDefined( level.filter_matid ) && IsDefined( level.filter_matid[ materialname ] ) )
	{
		player map_material( level.filter_matid[ materialname ], materialname );
		return;
	}

	level.filter_matid[materialname] = level.filter_matcount;
	player map_material( level.filter_matcount, materialname );
	level.filter_matcount++;
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
// Filter ( zombies turned overlay )
//
//-----------------------------------------------------------------------------

	init_filter_zm_turned( player )
	{
		init_filter_indices();
		map_material_helper( player, "generic_filter_zm_turned" );
	}
	
	enable_filter_zm_turned( player, filterid, overlayid )
	{
		player set_filter_pass_material( filterid, 0, level.filter_matid["generic_filter_zm_turned"] );
		player set_filter_pass_enabled( filterid, 0, true );
	}
	
	disable_filter_zm_turned( player, filterid, overlayid )
	{
		player set_filter_pass_enabled( filterid, 0, false );
	}
