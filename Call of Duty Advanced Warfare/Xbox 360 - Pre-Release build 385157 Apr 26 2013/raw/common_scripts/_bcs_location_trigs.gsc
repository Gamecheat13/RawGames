#include common_scripts\utility;

bcs_location_trigs_init()
{
	ASSERT( !IsDefined( level.bcs_location_mappings ) );
	level.bcs_location_mappings = [];
	
	bcs_location_trigger_mapping();	
	bcs_trigs_assign_aliases();
	
	// now that the trigger ents have their aliases set on them, clear out our big array
	//  so we can save on script variables
	level.bcs_location_mappings = undefined;
	
	anim.locationLastCalloutTimes = [];
}

bcs_trigs_assign_aliases()
{
	ASSERT( !IsDefined( anim.bcs_locations ) );
	anim.bcs_locations = [];
	
	ents = GetEntArray();
	trigs = [];
	foreach( trig in ents )
	{
		if( IsDefined( trig.classname ) && IsSubStr( trig.classname, "trigger_multiple_bcs" ) )
		{
			trigs[ trigs.size ] = trig;
		}
	}
	
	foreach( trig in trigs )
	{
		if ( !IsDefined( level.bcs_location_mappings[ trig.classname ] ) )
		{
			/#
			// iPrintln( "^2" + "WARNING: Couldn't find bcs location mapping for battlechatter trigger with classname " + trig.classname );
			// do nothing since too many prints kills the command buffer
			#/
		}
		else
		{
			aliases = ParseLocationAliases( level.bcs_location_mappings[ trig.classname ] );
			if( aliases.size > 1 )
			{
				aliases = array_randomize( aliases );
			}
			
			trig.locationAliases = aliases;
		}
	}
	
	anim.bcs_locations = trigs;
}

// parses locationStr using a space as a token and returns an array of the data in that field
ParseLocationAliases( locationStr )
{
	locationAliases = StrTok( locationStr, " " );
	return locationAliases;
}

add_bcs_location_mapping( classname, alias )
{
	// see if we have to add to an existing entry
	if( IsDefined( level.bcs_location_mappings[ classname ] ) )
	{
		existing = level.bcs_location_mappings[ classname ];
		existingArr = ParseLocationAliases( existing );
		aliases = ParseLocationAliases( alias );
		
		foreach( a in aliases )
		{
			foreach( e in existingArr )
			{
				if( a == e )
				{
					return;
				}
			}
		}
		
		existing += " " + alias;
		level.bcs_location_mappings[ classname ] = existing;
		
		return;
	}
	
	// otherwise make a new entry
	level.bcs_location_mappings[ classname ] = alias;
}


// here's where we set up each kind of trigger and map them to their (partial) soundaliases
bcs_location_trigger_mapping()
{
	generic_locations();

	fusion_locations();
	sanfran_locations();
	sanfran_b_locations();
	
	merida();
	
	old_locations();
	old_locations_mp();
}

//---------------------------------------------------------
// GENERICS
//---------------------------------------------------------
generic_locations()
{
/*QUAKED trigger_multiple_bcs_generic_doorway_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="doorway_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_generic_doorway_generic", "doorway_generic" );

/*QUAKED trigger_multiple_bcs_generic_window_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="window_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_generic_window_generic", "window_generic" );

/*QUAKED trigger_multiple_bcs_generic_1stfloor_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="1stfloor_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_generic_1stfloor_generic", "1stfloor_generic" );

/*QUAKED trigger_multiple_bcs_generic_1stfloor_doorway (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="1stfloor_doorway"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_generic_1stfloor_doorway", "1stfloor_doorway" );

/*QUAKED trigger_multiple_bcs_generic_1stfloor_window (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="1stfloor_window"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_generic_1stfloor_window", "1stfloor_window" );

/*QUAKED trigger_multiple_bcs_generic_2ndfloor_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="2ndfloor_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_generic_2ndfloor_generic", "2ndfloor_generic" );

/*QUAKED trigger_multiple_bcs_generic_2ndfloor_window (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="2ndfloor_window"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_generic_2ndfloor_window", "2ndfloor_window" );

/*QUAKED trigger_multiple_bcs_generic_rooftop (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="rooftop"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_generic_rooftop", "rooftop" );

/*QUAKED trigger_multiple_bcs_generic_2ndfloor_balcony (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="2ndfloor_balcony"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_generic_2ndfloor_balcony", "2ndfloor_balcony" );
}

//------------------------------//
//-------XSLICE BCS Trigs-------//
//------------------------------//

fusion_locations()
{
/*QUAKED trigger_multiple_bcs_xs_fuel_trucks (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="fuel_trucks"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_fuel_trucks", "fuel_trucks" );
	
/*QUAKED trigger_multiple_bcs_xs_truck (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="truck"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_truck", "truck" );
	
/*QUAKED trigger_multiple_bcs_xs_tower (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="tower"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_tower", "tower" );
	
/*QUAKED trigger_multiple_bcs_xs_rubble (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="rubble"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_rubble", "rubble" );
	
/*QUAKED trigger_multiple_bcs_xs_cart (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cart"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_cart", "cart" );
	
/*QUAKED trigger_multiple_bcs_xs_dumpster (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="dumpster"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_dumpster", "dumpster" );
	
/*QUAKED trigger_multiple_bcs_xs_generator (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="generator"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_generator", "generator" );
	
/*QUAKED trigger_multiple_bcs_xs_upper_walkway (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="upper_walkway"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_upper_walkway", "upper_walkway" );
	
/*QUAKED trigger_multiple_bcs_xs_support_column (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="support_column"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_support_column", "support_column" );
	
/*QUAKED trigger_multiple_bcs_xs_mt (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="mt"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_mt", "mt" );
	
/*QUAKED trigger_multiple_bcs_xs_cover_drone (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cover_drone"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_cover_drone", "cover_drone" );
	
/*QUAKED trigger_multiple_bcs_xs_titan (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="titan"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_titan", "titan" );
	
/*QUAKED trigger_multiple_bcs_xs_hill (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="hill"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_hill", "hill" );
	
/*QUAKED trigger_multiple_bcs_xs_crater (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="crater"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_crater", "crater" );	
	
/*QUAKED trigger_multiple_bcs_xs_loader (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="loader"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_loader", "loader" );	
	
/*QUAKED trigger_multiple_bcs_xs_destroyed_truck (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="destroyed_truck"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_destroyed_truck", "destroyed_truck" );	
	
/*QUAKED trigger_multiple_bcs_xs_flatbed (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="flatbed"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_flatbed", "flatbed" );
	
/*QUAKED trigger_multiple_bcs_xs_garage_2nd_floor (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="garage_2nd"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_garage_2nd_floor", "garage_2nd" );
	
/*QUAKED trigger_multiple_bcs_xs_garage (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="garage"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_garage", "garage" );
	
/*QUAKED trigger_multiple_bcs_xs_2ndlevel (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="2ndlevel"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_2ndlevel", "2ndlevel" );

/*QUAKED trigger_multiple_bcs_xs_3rdlevel (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="3rdlevel"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_3rdlevel", "3rdlevel" );

/*QUAKED trigger_multiple_bcs_xs_groundlevel (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="groundlevel"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_groundlevel", "groundlevel" );

/*QUAKED trigger_multiple_bcs_xs_column (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="column"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_column", "column" );	
	
/*QUAKED trigger_multiple_bcs_xs_crane (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="crane"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_crane", "crane" );
	
/*QUAKED trigger_multiple_bcs_xs_credenza (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="credenza"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_credenza", "credenza" );
	
/*QUAKED trigger_multiple_bcs_xs_desk (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="desk"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_desk", "desk" );
	
/*QUAKED trigger_multiple_bcs_xs_destroyedturbine (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="destroyedturbine"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_destroyedturbine", "destroyedturbine" );
	
/*QUAKED trigger_multiple_bcs_xs_forklift (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="forklift"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_forklift", "forklift" );
	
/*QUAKED trigger_multiple_bcs_xs_ladder (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="ladder"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_ladder", "ladder" );
	
/*QUAKED trigger_multiple_bcs_xs_machpipemodule (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="machpipemodule"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_machpipemodule", "machpipemodule" );
	
/*QUAKED trigger_multiple_bcs_xs_pillar (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="pillar"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_pillar", "pillar" );
	
/*QUAKED trigger_multiple_bcs_xs_pipes (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="pipes"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_pipes", "pipes" );
	
/*QUAKED trigger_multiple_bcs_xs_pool (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="pool"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_pool", "pool" );
	
/*QUAKED trigger_multiple_bcs_xs_shelves (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="shelves"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_shelves", "shelves" );
	
/*QUAKED trigger_multiple_bcs_xs_staircase (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="staircase"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_staircase", "staircase" );
	
/*QUAKED trigger_multiple_bcs_xs_turbine (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="turbine"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_turbine", "turbine" );
	
/*QUAKED trigger_multiple_bcs_xs_balcony (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="balcony"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_balcony", "balcony" );
	
/*QUAKED trigger_multiple_bcs_xs_barrel (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="barrel"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_barrel", "barrel" );
	
/*QUAKED trigger_multiple_bcs_xs_catwalk (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="catwalk"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_catwalk", "catwalk" );
	
/*QUAKED trigger_multiple_bcs_xs_console (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="console"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_console", "console" );
	
}

sanfran_locations()
{
	
/*QUAKED trigger_multiple_bcs_xs_bus (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="bus"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_bus", "bus" );
	
/*QUAKED trigger_multiple_bcs_xs_cardoor (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cardoor"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_cardoor", "cardoor" );
	
/*QUAKED trigger_multiple_bcs_xs_cargovan (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cargovan"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_cargovan", "cargovan" );
	
/*QUAKED trigger_multiple_bcs_xs_policecar (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="policecar"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_policecar", "policecar" );
	
/*QUAKED trigger_multiple_bcs_xs_roadsign (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="roadsign"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_roadsign", "roadsign" );
	
/*QUAKED trigger_multiple_bcs_xs_sidewalk (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="sidewalk"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_sidewalk", "sidewalk" );
	
/*QUAKED trigger_multiple_bcs_xs_sportscar (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="sportscar"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_sportscar", "sportscar" );
	
/*QUAKED trigger_multiple_bcs_xs_topbus (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="topbus"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_topbus", "topbus" );
	
/*QUAKED trigger_multiple_bcs_xs_sfa_tower (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="sfa_tower"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_sfa_tower", "sfa_tower" );
	
/*QUAKED trigger_multiple_bcs_xs_trailer (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="trailer"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_trailer", "trailer" );
		
}

sanfran_b_locations()
{
	
/*QUAKED trigger_multiple_bcs_xs_above (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="above"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_above", "above" );
	
/*QUAKED trigger_multiple_bcs_xs_containers (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="containers"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_containers", "containers" );
	
/*QUAKED trigger_multiple_bcs_xs_doors (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="doors"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_doors", "doors" );
	
/*QUAKED trigger_multiple_bcs_xs_helipad (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="helipad"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_helipad", "helipad" );
	
/*QUAKED trigger_multiple_bcs_xs_missileturret (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="missileturret"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_missileturret", "missileturret" );
	
/*QUAKED trigger_multiple_bcs_xs_table (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="table"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_table", "table" );
	
/*QUAKED trigger_multiple_bcs_xs_sfb_truck (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="sfb_truck"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_sfb_truck", "sfb_truck" );
	
/*QUAKED trigger_multiple_bcs_xs_vtol (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="vtol"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_vtol", "vtol" );
	
/*QUAKED trigger_multiple_bcs_xs_wreckage (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="wreckage"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_wreckage", "wreckage" );
	
/*QUAKED trigger_multiple_bcs_xs_cargocrane (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cargocrane"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_cargocrane", "cargocrane" );
	
/*QUAKED trigger_multiple_bcs_xs_sfb_catwalk (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="sfb_catwalk"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_sfb_catwalk", "sfb_catwalk" );
	
/*QUAKED trigger_multiple_bcs_xs_sfb_console (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="sfb_console"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_xs_sfb_console", "sfb_console" );
		
}

merida()
{
/*QUAKED trigger_multiple_bcs_mp_merida_radiotower (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="radiotower"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_radiotower", "radiotower" );

/*QUAKED trigger_multiple_bcs_mp_merida_embassy_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="embassy_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_embassy_generic", "embassy_generic" );

/*QUAKED trigger_multiple_bcs_mp_merida_aaguns (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="aaguns"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_aaguns", "aaguns" );

/*QUAKED trigger_multiple_bcs_mp_merida_tunnel (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="tunnel"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_tunnel", "tunnel" );

/*QUAKED trigger_multiple_bcs_mp_merida_cannons_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cannons_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_cannons_generic", "cannons_generic" );

/*QUAKED trigger_multiple_bcs_mp_merida_pool (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="pool"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_pool", "pool" );

/*QUAKED trigger_multiple_bcs_mp_merida_embassy_north (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="embassy_north"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_embassy_north", "embassy_north" );

/*QUAKED trigger_multiple_bcs_mp_merida_embassy_south (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="embassy_south"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_embassy_south", "embassy_south" );

/*QUAKED trigger_multiple_bcs_mp_merida_embassy_east (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="embassy_east"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_embassy_east", "embassy_east" );

/*QUAKED trigger_multiple_bcs_mp_merida_embassy_west (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="embassy_west"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_embassy_west", "embassy_west" );

/*QUAKED trigger_multiple_bcs_mp_merida_cannons_embassy (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cannons_embassy"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_cannons_embassy", "cannons_embassy" );

/*QUAKED trigger_multiple_bcs_mp_merida_cannons_radiotower (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cannons_radiotower"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_merida_cannons_radiotower", "cannons_radiotower" );
}

//---------------------------------------------------------
// DELETE THESE
//---------------------------------------------------------
old_locations()
{
/*QUAKED trigger_multiple_bcs_ns_acrosschasm (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="acrosschasm"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_acrosschasm", "acrosschasm" );

/*QUAKED trigger_multiple_bcs_ns_amcrt_stck (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="amcrt_stck"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_amcrt_stck", "amcrt_stck" );

/*QUAKED trigger_multiple_bcs_ns_barr_conc (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="barr_conc"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_barr_conc", "barr_conc" );

/*QUAKED trigger_multiple_bcs_ns_brls (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="brls"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_brls", "brls" );

/*QUAKED trigger_multiple_bcs_ns_catwlk (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="catwlk"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_catwlk", "catwlk" );

/*QUAKED trigger_multiple_bcs_ns_cell_l (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cell_l"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_cell_l", "cell_l" );

/*QUAKED trigger_multiple_bcs_ns_cell_r (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cell_r"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_cell_r", "cell_r" );

/*QUAKED trigger_multiple_bcs_ns_celldr_endhl (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="celldr_endhl"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_celldr_endhl", "celldr_endhl" );

/*QUAKED trigger_multiple_bcs_ns_corrgatedmtl (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="corrgatedmtl"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_corrgatedmtl", "corrgatedmtl" );

/*QUAKED trigger_multiple_bcs_ns_cot (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cot"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_cot", "cot" );

/*QUAKED trigger_multiple_bcs_ns_crt_stck (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="crt_stck"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_crt_stck", "crt_stck" );

/*QUAKED trigger_multiple_bcs_ns_crtstk_nrldge (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="crtstk_nrldge"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_crtstk_nrldge", "crtstk_nrldge" );

/*QUAKED trigger_multiple_bcs_ns_cv_cent (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cv_cent"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_cv_cent", "cv_cent" );

/*QUAKED trigger_multiple_bcs_ns_cv_cent_concsup (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cv_cent_concsup"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_cv_cent_concsup", "cv_cent_concsup" );

/*QUAKED trigger_multiple_bcs_ns_cv_cent_tv (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cv_cent_tv"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_cv_cent_tv", "cv_cent_tv" );

/*QUAKED trigger_multiple_bcs_ns_cv_small_l (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cv_small_l"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_cv_small_l", "cv_small_l" );

/*QUAKED trigger_multiple_bcs_ns_cv_wall_inside (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cv_wall_inside"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_cv_wall_inside", "cv_wall_inside" );

/*QUAKED trigger_multiple_bcs_ns_cv_wall_outside (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cv_wall_outside"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_cv_wall_outside", "cv_wall_outside" );

/*QUAKED trigger_multiple_bcs_ns_dpstr (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="dpstr"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_dpstr", "dpstr" );

/*QUAKED trigger_multiple_bcs_ns_drvwy (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="drvwy"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_drvwy", "drvwy" );

/*QUAKED trigger_multiple_bcs_ns_dsk_lg (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="dsk_lg"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_dsk_lg", "dsk_lg" );

/*QUAKED trigger_multiple_bcs_ns_dsk_stck (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="dsk_stck"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_dsk_stck", "dsk_stck" );

/*QUAKED trigger_multiple_bcs_ns_fuelcont (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="fuelcont"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_fuelcont", "fuelcont" );

/*QUAKED trigger_multiple_bcs_ns_fuelconts (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="fuelconts"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_fuelconts", "fuelconts" );

/*QUAKED trigger_multiple_bcs_ns_gbgcns (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="gbgcns"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_gbgcns", "gbgcns" );

/*QUAKED trigger_multiple_bcs_ns_hdghog (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="hdghog"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_hdghog", "hdghog" );

/*QUAKED trigger_multiple_bcs_ns_hesco_nrledge (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="hesco_nrledge"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_hesco_nrledge", "hesco_nrledge" );

/*QUAKED trigger_multiple_bcs_ns_hescobarr (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="hescobarr"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_hescobarr", "hescobarr" );

/*QUAKED trigger_multiple_bcs_ns_icemach (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="icemach"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_icemach", "icemach" );

/*QUAKED trigger_multiple_bcs_ns_intsec_3w (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="intsec_3w"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_intsec_3w", "intsec_3w" );

/*QUAKED trigger_multiple_bcs_ns_lckr_cntr (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="lckr_cntr"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_lckr_cntr", "lckr_cntr" );

/*QUAKED trigger_multiple_bcs_ns_lckr_l (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="lckr_l"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_lckr_l", "lckr_l" );

/*QUAKED trigger_multiple_bcs_ns_lckr_ne (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="lckr_ne"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_lckr_ne", "lckr_ne" );

/*QUAKED trigger_multiple_bcs_ns_lckr_r (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="lckr_r"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_lckr_r", "lckr_r" );

/*QUAKED trigger_multiple_bcs_ns_lckr_sw (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="lckr_sw"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_lckr_sw", "lckr_sw" );

/*QUAKED trigger_multiple_bcs_ns_lowwall_bwire (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="lowwall_bwire"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_lowwall_bwire", "lowwall_bwire" );

/*QUAKED trigger_multiple_bcs_ns_newsbox (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="newsbox"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_newsbox", "newsbox" );

/*QUAKED trigger_multiple_bcs_ns_phnbth (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="phnbth"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_phnbth", "phnbth" );

/*QUAKED trigger_multiple_bcs_ns_pipes_behind (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="pipes_behind"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_pipes_behind", "pipes_behind" );

/*QUAKED trigger_multiple_bcs_ns_pipes_nside (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="pipes_nside"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_pipes_nside", "pipes_nside" );

/*QUAKED trigger_multiple_bcs_ns_rappel_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="rappel_left"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_rappel_left", "rappel_left" );

/*QUAKED trigger_multiple_bcs_ns_samlnchr (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="samlnchr"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_samlnchr", "samlnchr" );

/*QUAKED trigger_multiple_bcs_ns_sentrygun (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="sentrygun"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_sentrygun", "sentrygun" );

/*QUAKED trigger_multiple_bcs_ns_shwr_cntr (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="shwr_cntr"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_shwr_cntr", "shwr_cntr" );

/*QUAKED trigger_multiple_bcs_ns_shwr_ne (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="shwr_ne"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_shwr_ne", "shwr_ne" );

/*QUAKED trigger_multiple_bcs_ns_shwr_sw (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="shwr_sw"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_shwr_sw", "shwr_sw" );

/*QUAKED trigger_multiple_bcs_ns_sndbgs (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="sndbgs"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_sndbgs", "sndbgs" );

/*QUAKED trigger_multiple_bcs_ns_stairs_down (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="stairs_down"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_stairs_down", "stairs_down" );

/*QUAKED trigger_multiple_bcs_ns_stairs_up (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="stairs_up"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_stairs_up", "stairs_up" );

/*QUAKED trigger_multiple_bcs_ns_stairs_ylw (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="stairs_ylw"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_stairs_ylw", "stairs_ylw" );

/*QUAKED trigger_multiple_bcs_ns_tun_leadoutside (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="tun_leadoutside"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_tun_leadoutside", "tun_leadoutside" );

/*QUAKED trigger_multiple_bcs_ns_vendmach (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="vendmach"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_vendmach", "vendmach" );

/*QUAKED trigger_multiple_bcs_ns_wirespl_lg (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="wirespl_lg"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_wirespl_lg", "wirespl_lg" );

/*QUAKED trigger_multiple_bcs_ns_wlkwy_abv_archs (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="wlkwy_abv_archs"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_ns_wlkwy_abv_archs", "wlkwy_abv_archs" );
	
/*QUAKED trigger_multiple_bcs_df_monument_courtyard (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="monument_courtyard"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_monument_courtyard", "monument_courtyard" );

/*QUAKED trigger_multiple_bcs_df_monument_top (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="monument_top"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_monument_top", "monument_top" );

/*QUAKED trigger_multiple_bcs_df_car_parked (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="car_parked"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_car_parked", "car_parked" );

/*QUAKED trigger_multiple_bcs_df_embassy (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="embassy"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_embassy", "embassy" );

/*QUAKED trigger_multiple_bcs_df_embassy_1st (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="embassy_1st"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_embassy_1st", "embassy_1st" );

/*QUAKED trigger_multiple_bcs_df_embassy_3rd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="embassy_3rd"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_embassy_3rd", "embassy_3rd" );

/*QUAKED trigger_multiple_bcs_df_vehicle_snowcat (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="vehicle_snowcat"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_vehicle_snowcat", "vehicle_snowcat" );

/*QUAKED trigger_multiple_bcs_df_vehicle_dumptruck (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="vehicle_dumptruck"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_vehicle_dumptruck", "vehicle_dumptruck" );

/*QUAKED trigger_multiple_bcs_df_building_red (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="building_red"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_building_red", "building_red" );

/*QUAKED trigger_multiple_bcs_df_vehicle_snowmobile (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="vehicle_snowmobile"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_vehicle_snowmobile", "vehicle_snowmobile" );

/*QUAKED trigger_multiple_bcs_df_scaffolding_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="scaffolding_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_scaffolding_generic", "scaffolding_generic" );

/*QUAKED trigger_multiple_bcs_df_container_red (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="container_red"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_container_red", "container_red" );

/*QUAKED trigger_multiple_bcs_df_tires_large (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="tires_large"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_tires_large", "tires_large" );

/*QUAKED trigger_multiple_bcs_df_memorial_building (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="memorial_building"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_memorial_building", "memorial_building" );

/*QUAKED trigger_multiple_bcs_df_stand_hotdog (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="stand_hotdog"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_stand_hotdog", "stand_hotdog" );

/*QUAKED trigger_multiple_bcs_df_stand_trading (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="stand_trading"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_stand_trading", "stand_trading" );

/*QUAKED trigger_multiple_bcs_df_subway_entrance (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="subway_entrance"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_subway_entrance", "subway_entrance" );

/*QUAKED trigger_multiple_bcs_df_rubble_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="rubble_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_rubble_generic", "rubble_generic" );

/*QUAKED trigger_multiple_bcs_df_cases_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cases_right"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_cases_right", "cases_right" );

/*QUAKED trigger_multiple_bcs_df_cases_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cases_left"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_cases_left", "cases_left" );

/*QUAKED trigger_multiple_bcs_df_cases_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="cases_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_cases_generic", "cases_generic" );

/*QUAKED trigger_multiple_bcs_df_barrier_orange (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="barrier_orange"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_barrier_orange", "barrier_orange" );

/*QUAKED trigger_multiple_bcs_df_barrier_hesco (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="barrier_hesco"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_barrier_hesco", "barrier_hesco" );

/*QUAKED trigger_multiple_bcs_df_stryker_destroyed (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="stryker_destroyed"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_stryker_destroyed", "stryker_destroyed" );

/*QUAKED trigger_multiple_bcs_df_fan_exhaust (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="fan_exhaust"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_fan_exhaust", "fan_exhaust" );

/*QUAKED trigger_multiple_bcs_df_tower_jamming (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="tower_jamming"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_tower_jamming", "tower_jamming" );

/*QUAKED trigger_multiple_bcs_df_ac_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="ac_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_ac_generic", "ac_generic" );

/*QUAKED trigger_multiple_bcs_df_table_computer (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="table_computer"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_table_computer", "table_computer" );

/*QUAKED trigger_multiple_bcs_df_bulkhead_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="bulkhead_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_bulkhead_generic", "bulkhead_generic" );

/*QUAKED trigger_multiple_bcs_df_bunk_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="bunk_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_bunk_generic", "bunk_generic" );

/*QUAKED trigger_multiple_bcs_df_console_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="console_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_console_generic", "console_generic" );

/*QUAKED trigger_multiple_bcs_df_deck_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="deck_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_deck_generic", "deck_generic" );


}

old_locations_mp()
{
/*QUAKED trigger_multiple_bcs_mp_dome_bunker (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="bunker"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_bunker", "bunker" );

/*QUAKED trigger_multiple_bcs_mp_dome_bunker_back (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="bunker_back"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_bunker_back", "bunker_back" );

/*QUAKED trigger_multiple_bcs_mp_dome_office (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="office"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_office", "office" );

/*QUAKED trigger_multiple_bcs_mp_dome_dome (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="dome"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_dome", "dome" );

/*QUAKED trigger_multiple_bcs_mp_dome_catwalk (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="catwalk"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_catwalk", "catwalk" );

/*QUAKED trigger_multiple_bcs_mp_dome_loadingbay (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="loadingbay"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_loadingbay", "loadingbay" );

/*QUAKED trigger_multiple_bcs_mp_dome_hallway (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="hallway"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_hallway", "hallway" );

/*QUAKED trigger_multiple_bcs_mp_dome_hallway_loadingbay (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="hallway_loadingbay"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_hallway_loadingbay", "hallway_loadingbay" );

/*QUAKED trigger_multiple_bcs_mp_dome_hallway_office (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="hallway_office"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_hallway_office", "hallway_office" );

/*QUAKED trigger_multiple_bcs_mp_dome_wall_broken (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="wall_broken"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_wall_broken", "wall_broken" );

/*QUAKED trigger_multiple_bcs_mp_dome_tank (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="tank"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_tank", "tank" );

/*QUAKED trigger_multiple_bcs_mp_dome_radar (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="radar"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_radar", "radar" );

/*QUAKED trigger_multiple_bcs_mp_dome_humvee (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="humvee"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_mp_dome_humvee", "humvee" );
}

/*EXAMPLEQUAKED trigger_multiple_bcs_df_parisAC130_lm_embassy (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_lm_embassy"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_df_parisAC130_lm_embassy", "lm_embassy" );