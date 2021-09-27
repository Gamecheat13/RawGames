#include common_scripts\utility;
#include maps\_utility;

bcs_location_trigs_init()
{
	ASSERT( !IsDefined( level.bcs_location_mappings ) );
	level.bcs_location_mappings = [];
	
	bcs_location_trigger_mapping();	
	bcs_trigs_assign_aliases();
	
	// now that the trigger ents have their aliases set on them, clear out our big array
	//  so we can save on script variables
	level.bcs_location_mappings = undefined;
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
		ASSERT( IsDefined( level.bcs_location_mappings[ trig.classname ] ), "Couldn't find bcs location mapping for battlechatter trigger with classname " + trig.classname );
		
		aliases = ParseLocationAliases( level.bcs_location_mappings[ trig.classname ] );
		if( aliases.size > 1 )
		{
			aliases = array_randomize( aliases );
		}
		
		trig.locationAliases = aliases;
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
	vehicles();
	landmarks();

	// Levels
	tibet();
	ny_manhattan();
	ny_harbor();
	hijack();
	warlord();
	london();
	payback();
	hamburg();
	paris_a();
	paris_b();
	paris_ac130();
	prague();
	berlin();
	dubai();
}

//---------------------------------------------------------
// GENERICS
//---------------------------------------------------------

generic_locations()
{


// ----------- BUILDINGS -----------
/*QUAKED trigger_multiple_bcs_uk_building_1stfloor (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_1st_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_1stfloor", "loc_1st_report" );

/*QUAKED trigger_multiple_bcs_uk_building_2ndfloor (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_2nd_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_2ndfloor", "loc_2nd_report" );

/*QUAKED trigger_multiple_bcs_uk_building_1stfloor_door_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_door_1st_left_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_1stfloor_door_left", "loc_door_1st_left_report" );

/*QUAKED trigger_multiple_bcs_uk_building_1stfloor_door (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_door_1st_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_1stfloor_door", "loc_door_1st_report" );

/*QUAKED trigger_multiple_bcs_uk_building_1stfloor_door_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_door_1st_right_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_1stfloor_door_right", "loc_door_1st_right_report" );

/*QUAKED trigger_multiple_bcs_uk_building_2ndfloor_door (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_door_2nd_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_2ndfloor_door", "loc_door_2nd_report" );

/*QUAKED trigger_multiple_bcs_uk_building_door (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_door_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_door", "loc_door_report" );

/*QUAKED trigger_multiple_bcs_uk_building_1stfloor_window_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_wndw_1st_left_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_1stfloor_window_left", "loc_wndw_1st_left_report" );

/*QUAKED trigger_multiple_bcs_uk_building_1stfloor_window (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_wndw_1st_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_1stfloor_window", "loc_wndw_1st_report" );

/*QUAKED trigger_multiple_bcs_uk_building_1stfloor_window_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_wndw_1st_right_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_1stfloor_window_right", "loc_wndw_1st_right_report" );

/*QUAKED trigger_multiple_bcs_uk_building_2ndfloor_window_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_wndw_2nd_left_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_2ndfloor_window_left", "loc_wndw_2nd_left_report" );

/*QUAKED trigger_multiple_bcs_uk_building_2ndfloor_window (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_wndw_2nd_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_2ndfloor_window", "loc_wndw_2nd_report" );

/*QUAKED trigger_multiple_bcs_uk_building_2ndfloor_window_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_callout_loc_wndw_2nd_right_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_building_2ndfloor_window_right", "loc_wndw_2nd_right_report" );
/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_door (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_door_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_door", "callout_loc_door_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_door_1st (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_door_1st_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_door_1st", "callout_loc_door_1st_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_door_1st_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_door_1st_right_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_door_1st_right", "callout_loc_door_1st_right_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_door_1st_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_door_1st_left_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_door_1st_left", "callout_loc_door_1st_left_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_door_2nd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_door_2nd_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_door_2nd", "callout_loc_door_2nd_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_wndw_1st (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_wndw_1st_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_wndw_1st", "callout_loc_wndw_1st_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_wndw_1st_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_wndw_1st_left_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_wndw_1st_left", "callout_loc_wndw_1st_left_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_wndw_1st_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_wndw_1st_right_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_wndw_1st_right", "callout_loc_wndw_1st_right_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_1st (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_1st_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_1st", "callout_loc_1st_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_2nd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_2nd_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_2nd", "callout_loc_2nd_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_wndw_2nd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_wndw_2nd_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_wndw_2nd", "callout_loc_wndw_2nd_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_wndw_2nd_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_wndw_2nd_left_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_wndw_2nd_left", "callout_loc_wndw_2nd_left_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_wndw_2nd_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_wndw_2nd_right_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_wndw_2nd_right", "callout_loc_wndw_2nd_right_report" );

/*QUAKED trigger_multiple_bcs_df_generic_callout_loc_wndw_3rd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_callout_loc_wndw_3rd_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_callout_loc_wndw_3rd", "callout_loc_wndw_3rd_report" );


}

//---------------------------------------------------------
// LANDMARKS
//---------------------------------------------------------

landmarks()
{
// MW2 EXAMPLES
/*EXAMPLEQUAKED trigger_multiple_bcs_us_landmark_desk_large (0 0.25 0.5) ?
defaulttexture="bcs"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_us_landmark_desk_large", "lm_dsk_lg" );

/*EXAMPLEQUAKED trigger_multiple_bcs_us_landmark_fuelcontainers (0 0.25 0.5) ?
defaulttexture="bcs"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_us_landmark_fuelcontainers", "lm_fuelconts" );

//---------------------------------------------------------
// DELTA FORCE
//---------------------------------------------------------

/*QUAKED trigger_multiple_bcs_df_generic_loc_ac_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_ac_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_ac_generic", "loc_ac_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_airdrop_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_airdrop_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_airdrop_generic", "loc_airdrop_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_alley_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_alley_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_alley_generic", "loc_alley_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_balcony_2nd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_balcony_2nd"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_balcony_2nd", "loc_balcony_2nd" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_balcony_3rd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_balcony_3rd"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_balcony_3rd", "loc_balcony_3rd" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_bank_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_bank_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_bank_generic", "loc_bank_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_bar_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_bar_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_bar_generic", "loc_bar_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_barrels_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_barrels_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_barrels_generic", "loc_barrels_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_barricade_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_barricade_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_barricade_generic", "loc_barricade_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_barrier_hesco (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_barrier_hesco"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_barrier_hesco", "loc_barrier_hesco" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_barrier_orange (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_barrier_orange"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_barrier_orange", "loc_barrier_orange" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_bin_recycle (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_bin_recycle"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_bin_recycle", "loc_bin_recycle" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_bookcase_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_bookcase_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_bookcase_generic", "loc_bookcase_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_building_red (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_building_red"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_building_red", "loc_building_red" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_bulkhead_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_bulkhead_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_bulkhead_generic", "loc_bulkhead_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_bunk_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_bunk_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_bunk_generic", "loc_bunk_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_bus_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_bus_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_bus_generic", "loc_bus_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_bus_inside (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_bus_inside"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_bus_inside", "loc_bus_inside" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_car_blue (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_car_blue"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_car_blue", "loc_car_blue" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_car_burning (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_car_burning"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_car_burning", "loc_car_burning" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_car_destroyed (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_car_destroyed"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_car_destroyed", "loc_car_destroyed" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_car_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_car_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_car_generic", "loc_car_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_car_green (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_car_green"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_car_green", "loc_car_green" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_car_overturned (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_car_overturned"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_car_overturned", "loc_car_overturned" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_car_parked (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_car_parked"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_car_parked", "loc_car_parked" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_car_police (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_car_police"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_car_police", "loc_car_police" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_car_yellow (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_car_yellow"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_car_yellow", "loc_car_yellow" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_catwalk_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_catwalk_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_catwalk_generic", "loc_catwalk_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_chair_blue (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_chair_blue"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_chair_blue", "loc_chair_blue" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_column_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_column_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_column_generic", "loc_column_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_console_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_console_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_console_generic", "loc_console_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_container_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_container_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_container_generic", "loc_container_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_container_red (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_container_red"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_container_red", "loc_container_red" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_couch_blue (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_couch_blue"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_couch_blue", "loc_couch_blue" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_couch_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_couch_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_couch_generic", "loc_couch_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_crates_ammo (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_crates_ammo"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_crates_ammo", "loc_crates_ammo" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_crates_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_crates_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_crates_generic", "loc_crates_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_cubicles_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_cubicles_left"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_cubicles_left", "loc_cubicles_left" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_cubicles_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_cubicles_right"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_cubicles_right", "loc_cubicles_right" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_deck_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_deck_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_deck_generic", "loc_deck_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_door_back (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_door_back"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_door_back", "loc_door_back" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_door_front (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_door_front"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_door_front", "loc_door_front" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_dumpster_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_dumpster_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_dumpster_generic", "loc_dumpster_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_embassy_1st (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_embassy_1st"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_embassy_1st", "loc_embassy_1st" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_embassy_3rd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_embassy_3rd"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_embassy_3rd", "loc_embassy_3rd" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_engine_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_engine_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_engine_generic", "loc_engine_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_fan_exhaust (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_fan_exhaust"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_fan_exhaust", "loc_fan_exhaust" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_gate_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_gate_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_gate_generic", "loc_gate_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_hill_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_hill_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_hill_generic", "loc_hill_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_machine_copy (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_machine_copy"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_machine_copy", "loc_machine_copy" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_mg_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_mg_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_mg_generic", "loc_mg_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_patio_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_patio_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_patio_generic", "loc_patio_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_pipe_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_pipe_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_pipe_generic", "loc_pipe_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_planter_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_planter_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_planter_generic", "loc_planter_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_rack_bike (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_rack_bike"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_rack_bike", "loc_rack_bike" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_railing_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_railing_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_railing_generic", "loc_railing_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_ramp_down (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_ramp_down"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_ramp_down", "loc_ramp_down" );



/*QUAKED trigger_multiple_bcs_df_generic_loc_rooftop_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_rooftop_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_rooftop_generic", "loc_rooftop_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_room_conf (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_room_conf"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_room_conf", "loc_room_conf" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_room_middle (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_room_middle"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_room_middle", "loc_room_middle" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_rubble_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_rubble_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_rubble_generic", "loc_rubble_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_sandbags_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_sandbags_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_sandbags_generic", "loc_sandbags_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_scaffolding_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_scaffolding_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_scaffolding_generic", "loc_scaffolding_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_car_black (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_car_black"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_car_black", "loc_car_black" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_shop_book (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_shop_book"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_shop_book", "loc_shop_book" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_shop_cafe (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_shop_cafe"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_shop_cafe", "loc_shop_cafe" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_shop_coffee (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_shop_coffee"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_shop_coffee", "loc_shop_coffee" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_shop_restaurant (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_shop_restaurant"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_shop_restaurant", "loc_shop_restaurant" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_shop_souvenir (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_shop_souvenir"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_shop_souvenir", "loc_shop_souvenir" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_staircase_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_staircase_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_staircase_generic", "loc_staircase_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_stairs_bottom (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_stairs_bottom"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_stairs_bottom", "loc_stairs_bottom" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_stairs_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_stairs_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_stairs_generic", "loc_stairs_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_stairs_top (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_stairs_top"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_stairs_top", "loc_stairs_top" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_stand_hotdog (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_stand_hotdog"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_stand_hotdog", "loc_stand_hotdog" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_stand_news (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_stand_news"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_stand_news", "loc_stand_news" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_stand_trading (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_stand_trading"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_stand_trading", "loc_stand_trading" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_statue_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_statue_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_statue_generic", "loc_statue_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_stryker_destroyed (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_stryker_destroyed"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_stryker_destroyed", "loc_stryker_destroyed" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_subway_entrance (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_subway_entrance"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_subway_entrance", "loc_subway_entrance" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_table_computer (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_table_computer"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_table_computer", "loc_table_computer" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_table_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_table_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_table_generic", "loc_table_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_tanks_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_tanks_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_tanks_generic", "loc_tanks_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_taxi_destroyed (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_taxi_destroyed"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_taxi_destroyed", "loc_taxi_destroyed" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_taxi_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_taxi_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_taxi_generic", "loc_taxi_generic" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_tires_large (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_tires_large"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_tires_large", "loc_tires_large" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_tower_jamming (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_tower_jamming"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_tower_jamming", "loc_tower_jamming" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_truck_white (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_truck_white"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_truck_white", "loc_truck_white" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_van_blue (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_van_blue"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_van_blue", "loc_van_blue" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_vehicle_btr (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_vehicle_btr"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_vehicle_btr", "loc_vehicle_btr" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_vehicle_dumptruck (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_vehicle_dumptruck"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_vehicle_dumptruck", "loc_vehicle_dumptruck" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_vehicle_gaz (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_vehicle_gaz"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_vehicle_gaz", "loc_vehicle_gaz" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_vehicle_hind (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_vehicle_hind"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_vehicle_hind", "loc_vehicle_hind" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_vehicle_snowcat (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_vehicle_snowcat"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_vehicle_snowcat", "loc_vehicle_snowcat" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_vehicle_snowmobile (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_vehicle_snowmobile"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_vehicle_snowmobile", "loc_vehicle_snowmobile" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_wall_low (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_wall_low"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_wall_low", "loc_wall_low" );

/*QUAKED trigger_multiple_bcs_df_generic_loc_water_cooler (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_water_cooler"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_generic_loc_water_cooler", "loc_water_cooler" );

//---------------------------------------------------------
// PMC
//---------------------------------------------------------

/*QUAKED trigger_multiple_bcs_pc_generic_wndw_3rd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_callout_loc_wndw_3rd_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_wndw_3rd", "callout_loc_wndw_3rd" );

/*QUAKED trigger_multiple_bcs_pc_generic_alley_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_alley_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_alley_generic", "loc_alley_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_arch_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_arch_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_arch_generic", "loc_arch_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_balcony_2nd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_balcony_2nd"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_balcony_2nd", "loc_balcony_2nd" );

/*QUAKED trigger_multiple_bcs_pc_generic_balcony_3rd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_balcony_3rd"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_balcony_3rd", "loc_balcony_3rd" );

/*QUAKED trigger_multiple_bcs_pc_generic_balcony_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_balcony_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_balcony_generic", "loc_balcony_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_barrels_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_barrels_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_barrels_generic", "loc_barrels_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_boat_wooden (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_boat_wooden"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_boat_wooden", "loc_boat_wooden" );

/*QUAKED trigger_multiple_bcs_pc_generic_car_burning (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_car_burning"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_car_burning", "loc_car_burning" );

/*QUAKED trigger_multiple_bcs_pc_generic_car_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_car_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_car_generic", "loc_car_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_car_green (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_car_green"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_car_green", "loc_car_green" );

/*QUAKED trigger_multiple_bcs_pc_generic_car_overturned (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_car_overturned"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_car_overturned", "loc_car_overturned" );

/*QUAKED trigger_multiple_bcs_pc_generic_car_yellow (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_car_yellow"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_car_yellow", "loc_car_yellow" );

/*QUAKED trigger_multiple_bcs_pc_generic_carport_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_carport_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_carport_generic", "loc_carport_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_cart_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_cart_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_cart_generic", "loc_cart_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_catwalk_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_catwalk_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_catwalk_generic", "loc_catwalk_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_container_cargo (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_container_cargo"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_container_cargo", "loc_container_cargo" );

/*QUAKED trigger_multiple_bcs_pc_generic_couch_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_couch_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_couch_generic", "loc_couch_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_counter_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_counter_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_counter_generic", "loc_counter_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_crates_ammo (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_crates_ammo"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_crates_ammo", "loc_crates_ammo" );

/*QUAKED trigger_multiple_bcs_pc_generic_crates_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_crates_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_crates_generic", "loc_crates_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_door_back (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_door_back"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_door_back", "loc_door_back" );

/*QUAKED trigger_multiple_bcs_pc_generic_door_front (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_door_front"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_door_front", "loc_door_front" );

/*QUAKED trigger_multiple_bcs_pc_generic_hull_3rd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_hull_3rd"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_hull_3rd", "loc_hull_3rd" );

/*QUAKED trigger_multiple_bcs_pc_generic_market_stalls (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_market_stalls"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_market_stalls", "loc_market_stalls" );

/*QUAKED trigger_multiple_bcs_pc_generic_pier_far (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_pier_far"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_pier_far", "loc_pier_far" );

/*QUAKED trigger_multiple_bcs_pc_generic_pier_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_pier_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_pier_generic", "loc_pier_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_rock_big (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_rock_big"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_rock_big", "loc_rock_big" );

/*QUAKED trigger_multiple_bcs_pc_generic_rooftop_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_rooftop_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_rooftop_generic", "loc_rooftop_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_stairs_bottom (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_stairs_bottom"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_stairs_bottom", "loc_stairs_bottom" );

/*QUAKED trigger_multiple_bcs_pc_generic_stairs_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_stairs_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_stairs_generic", "loc_stairs_generic" );

/*QUAKED trigger_multiple_bcs_pc_generic_stairs_top (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_stairs_top"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_stairs_top", "loc_stairs_top" );

/*QUAKED trigger_multiple_bcs_pc_generic_tank_welding (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_tank_welding"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_tank_welding", "loc_tank_welding" );

/*QUAKED trigger_multiple_bcs_pc_generic_truck_white (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_truck_white"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_truck_white", "loc_truck_white" );

/*QUAKED trigger_multiple_bcs_pc_generic_wall_broken (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_wall_broken"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_wall_broken", "loc_wall_broken" );

/*QUAKED trigger_multiple_bcs_pc_generic_wall_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_wall_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_generic_wall_generic", "loc_wall_generic" );


// **************************************************
// TASKFORCE
// **************************************************

/*QUAKED trigger_multiple_bcs_tf_generic_1st (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_1st_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_1st", "callout_loc_1st" );

/*QUAKED trigger_multiple_bcs_tf_generic_2nd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_2nd_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_2nd", "callout_loc_2nd" );

/*QUAKED trigger_multiple_bcs_tf_generic_door_1st_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_door_1st_left_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_door_1st_left", "callout_loc_door_1st_left" );

/*QUAKED trigger_multiple_bcs_tf_generic_door_1st_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_door_1st_right_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_door_1st_right", "callout_loc_door_1st_right" );

/*QUAKED trigger_multiple_bcs_tf_generic_door_1st (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_door_1st_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_door_1st", "callout_loc_door_1st" );

/*QUAKED trigger_multiple_bcs_tf_generic_door_2nd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_door_2nd_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_door_2nd", "callout_loc_door_2nd" );

/*QUAKED trigger_multiple_bcs_tf_generic_door (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_door_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_door", "callout_loc_door" );

/*QUAKED trigger_multiple_bcs_tf_generic_wndw_1st_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_wndw_1st_left_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_wndw_1st_left", "callout_loc_wndw_1st_left" );

/*QUAKED trigger_multiple_bcs_tf_generic_wndw_1st_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_wndw_1st_right_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_wndw_1st_right", "callout_loc_wndw_1st_right" );

/*QUAKED trigger_multiple_bcs_tf_generic_wndw_1st (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_wndw_1st_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_wndw_1st", "callout_loc_wndw_1st" );

/*QUAKED trigger_multiple_bcs_tf_generic_wndw_2nd_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_wndw_2nd_left_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_wndw_2nd_left", "callout_loc_wndw_2nd_left" );

/*QUAKED trigger_multiple_bcs_tf_generic_wndw_2nd_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_wndw_2nd_right_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_wndw_2nd_right", "callout_loc_wndw_2nd_right" );

/*QUAKED trigger_multiple_bcs_tf_generic_wndw_2nd (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_callout_loc_wndw_2nd_report"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_wndw_2nd", "callout_loc_wndw_2nd" );

/*QUAKED trigger_multiple_bcs_tf_generic_container_cargo (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_container_cargo"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_container_cargo", "loc_container_cargo" );

/*QUAKED trigger_multiple_bcs_tf_generic_balcony_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_balcony_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_balcony_generic", "loc_balcony_generic" );

/*QUAKED trigger_multiple_bcs_tf_generic_boat_wooden (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_boat_wooden"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_boat_wooden", "loc_boat_wooden" );

/*QUAKED trigger_multiple_bcs_tf_generic_tanks_welding (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_tanks_welding"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_tanks_welding", "loc_tanks_welding" );

/*QUAKED trigger_multiple_bcs_tf_generic_carport_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_carport_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_carport_generic", "loc_carport_generic" );

/*QUAKED trigger_multiple_bcs_tf_generic_rock_big (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_rock_big"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_rock_big", "loc_rock_big" );

/*QUAKED trigger_multiple_bcs_tf_generic_wall_broken (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_wall_broken"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_wall_broken", "loc_wall_broken" );

/*QUAKED trigger_multiple_bcs_tf_generic_bin_trash (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_bin_trash"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_bin_trash", "loc_bin_trash" );

/*QUAKED trigger_multiple_bcs_tf_generic_fridge_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_fridge_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_fridge_generic", "loc_fridge_generic" );

/*QUAKED trigger_multiple_bcs_tf_generic_washing_machine (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_washing_machine"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_washing_machine", "loc_washing_machine" );

/*QUAKED trigger_multiple_bcs_tf_generic_tire_stack (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_tire_stack"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_tire_stack", "loc_tire_stack" );

/*QUAKED trigger_multiple_bcs_tf_generic_mattress_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_mattress_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_mattress_generic", "loc_mattress_generic" );

/*QUAKED trigger_multiple_bcs_tf_generic_umbrella_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_umbrella_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_generic_umbrella_generic", "loc_umbrella_generic" );



}

//---------------------------------------------------------
// VEHICLES
//---------------------------------------------------------
vehicles()
{
/*EXAMPLEQUAKED trigger_multiple_bcs_us_vehicle_humvee_parked (0 0.25 0.5) ?
defaulttexture="bcs"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_us_vehicle_humvee_parked", "vh_hmv_pkd" );

/*EXAMPLEQUAKED trigger_multiple_bcs_us_vehicle_car_hatchback_green (0 0.25 0.5) ?
defaulttexture="bcs"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_us_vehicle_car_hatchback_green", "vh_car_hb_grn" );
}

//---------------------------------------------------------
//
//
// LEVEL SPECIFIC SECTION
//
//
//---------------------------------------------------------
tibet()
{
}

ny_manhattan()
{
/*QUAKED trigger_multiple_bcs_df_ny_manhattan_lm_memorial_building (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_lm_memorial_building"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_ny_manhattan_lm_memorial_building", "lm_memorial_building" );

/*QUAKED trigger_multiple_bcs_df_ny_manhattan_loc_cases_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_cases_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_ny_manhattan_loc_cases_generic", "loc_cases_generic" );

/*QUAKED trigger_multiple_bcs_df_ny_manhattan_loc_cases_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_cases_left"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_ny_manhattan_loc_cases_left", "loc_cases_left" );

/*QUAKED trigger_multiple_bcs_df_ny_manhattan_loc_cases_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_cases_right"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_ny_manhattan_loc_cases_right", "loc_cases_right" );
	
}

ny_harbor()
{
/*QUAKED trigger_multiple_bcs_df_ny_harbor_loc_reactor_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_reactor_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_ny_harbor_loc_reactor_generic", "loc_reactor_generic" );
}

hijack()
{
}

warlord()
{
/*QUAKED trigger_multiple_bcs_tf_warlord_church_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_church_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_warlord_church_generic", "loc_church_generic" );

/*QUAKED trigger_multiple_bcs_tf_warlord_shop_butcher (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_shop_butcher"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_warlord_shop_butcher", "loc_shop_butcher" );

/*QUAKED trigger_multiple_bcs_tf_warlord_shop_pharmacy (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_shop_pharmacy"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_warlord_shop_pharmacy", "loc_shop_pharmacy" );


}

london()
{
/*QUAKED trigger_multiple_bcs_uk_landmark_barrels (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_barrels_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_barrels", "loc_barrels_generic" );

/*QUAKED trigger_multiple_bcs_uk_landmark_barrier (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_barrier_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_barrier", "loc_barrier_generic" );

/*QUAKED trigger_multiple_bcs_uk_landmark_bulldozer (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_bulldozer_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_bulldozer", "loc_bulldozer_generic" );

/*QUAKED trigger_multiple_bcs_uk_vehicle_car_black (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_car_black"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_vehicle_car_black", "loc_car_black" );

/*QUAKED trigger_multiple_bcs_uk_landmark_catwalk (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_catwalk_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_catwalk", "loc_catwalk_generic" );

/*QUAKED trigger_multiple_bcs_uk_landmark_cinder_blocks (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_cinder_blocks"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_cinder_blocks", "loc_cinder_blocks" );

/*QUAKED trigger_multiple_bcs_uk_landmark_container (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_container_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_container", "loc_container_generic" );

/*QUAKED trigger_multiple_bcs_uk_landmark_container_open (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_container_open"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_container_open", "loc_container_open" );

/*QUAKED trigger_multiple_bcs_uk_landmark_container_small (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_container_small"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_container_small", "loc_container_small" );

/*QUAKED trigger_multiple_bcs_uk_landmark_crate_blue (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_crate_blue"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_crate_blue", "loc_crate_blue" );

/*QUAKED trigger_multiple_bcs_uk_landmark_crate (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_crate_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_crate", "loc_crate_generic" );

/*QUAKED trigger_multiple_bcs_uk_landmark_dumpster_red (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_dumpster_red"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_dumpster_red", "loc_dumpster_red" );

/*QUAKED trigger_multiple_bcs_uk_landmark_flatbed (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_flatbed_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_flatbed", "loc_flatbed_generic" );

/*QUAKED trigger_multiple_bcs_uk_landmark_loading_bay (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_loading_bay"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_loading_bay", "loc_loading_bay" );

/*QUAKED trigger_multiple_bcs_uk_landmark_pipe_cement (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_pipe_cement"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_pipe_cement", "loc_pipe_cement" );

/*QUAKED trigger_multiple_bcs_uk_landmark_platform_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_platform_left"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_platform_left", "loc_platform_left" );

/*QUAKED trigger_multiple_bcs_uk_landmark_porta_john (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_porta_john"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_porta_john", "loc_porta_john" );

/*QUAKED trigger_multiple_bcs_uk_landmark_scaffolding (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_scaffolding_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_scaffolding", "loc_scaffolding_generic" );

/*QUAKED trigger_multiple_bcs_uk_landmark_stairs_down (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_stairs_down"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_stairs_down", "loc_stairs_down" );

/*QUAKED trigger_multiple_bcs_uk_landmark_stairs (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_stairs_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_stairs", "loc_stairs_generic" );

/*QUAKED trigger_multiple_bcs_uk_landmark_stairs_top (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_stairs_top"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_stairs_top", "loc_stairs_top" );

/*QUAKED trigger_multiple_bcs_uk_vehicle_truck_charity (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_truck_charity"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_vehicle_truck_charity", "loc_truck_charity" );

/*QUAKED trigger_multiple_bcs_uk_vehicle_truck (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_truck_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_vehicle_truck", "loc_truck_generic" );

/*QUAKED trigger_multiple_bcs_uk_vehicle_target (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_vehicle_target"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_vehicle_target", "loc_vehicle_target" );

/*QUAKED trigger_multiple_bcs_uk_landmark_wall_low (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_wall_low"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_wall_low", "loc_wall_low" );

/*QUAKED trigger_multiple_bcs_uk_landmark_warehouse (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_warehouse_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_warehouse", "loc_warehouse_generic" );

/*QUAKED trigger_multiple_bcs_uk_landmark_warehouse_south (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_warehouse_south"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_warehouse_south", "loc_warehouse_south" );

/*QUAKED trigger_multiple_bcs_uk_landmark_warehouse_west (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="UK_0_loc_warehouse_west"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_uk_landmark_warehouse_west", "loc_warehouse_west" );
}

payback()
{
/*QUAKED trigger_multiple_bcs_pc_payback_lm_building_tall (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_lm_building_tall"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_payback_lm_building_tall", "lm_building_tall" );

/*QUAKED trigger_multiple_bcs_pc_payback_lm_building_white (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_lm_building_white"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_payback_lm_building_white", "lm_building_white" );

/*QUAKED trigger_multiple_bcs_pc_payback_ship_cargo (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_ship_cargo"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_payback_ship_cargo", "loc_ship_cargo" );

/*QUAKED trigger_multiple_bcs_pc_payback_shipwreck_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="PC_0_co_loc_shipwreck_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_pc_payback_shipwreck_generic", "loc_shipwreck_generic" );


}

hamburg()
{
}

paris_a()
{
}

paris_b()
{
}

paris_ac130()
{
/*QUAKED trigger_multiple_bcs_df_parisAC130_lm_embassy (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_lm_embassy"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_parisAC130_lm_embassy", "lm_embassy" );

/*QUAKED trigger_multiple_bcs_df_parisAC130_lm_monument_courtyard (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_lm_monument_courtyard"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_parisAC130_lm_monument_courtyard", "lm_monument_courtyard" );

/*QUAKED trigger_multiple_bcs_df_parisAC130_loc_monument_top (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_loc_monument_top"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_parisAC130_loc_monument_top", "loc_monument_top" );

}

prague()
{
/*QUAKED trigger_multiple_bcs_tf_prague_sign_large (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_mct_co_loc_sign_large"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_prague_sign_large", "loc_sign_large" );

/*QUAKED trigger_multiple_bcs_tf_prague_car_white (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_mct_co_loc_car_white"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_prague_car_white", "loc_car_white" );

/*QUAKED trigger_multiple_bcs_tf_prague_shops_east (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_mct_co_loc_shops_east"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_prague_shops_east", "loc_shops_east" );

/*QUAKED trigger_multiple_bcs_tf_prague_btr_crashed (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_mct_co_loc_btr_crashed"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_prague_btr_crashed", "loc_btr_crashed" );

/*QUAKED trigger_multiple_bcs_tf_prague_bldg_west (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_mct_co_loc_bldg_west"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_prague_bldg_west", "loc_bldg_west" );

/*QUAKED trigger_multiple_bcs_tf_prague_cafe_tables (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_mct_co_loc_cafe_tables"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_prague_cafe_tables", "loc_cafe_tables" );

/*QUAKED trigger_multiple_bcs_tf_prague_bldg_north (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_mct_co_loc_bldg_north"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_prague_bldg_north", "loc_bldg_north" );

/*QUAKED trigger_multiple_bcs_tf_prague_antique_shop (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_mct_co_loc_antique_shop"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_prague_antique_shop", "loc_antique_shop" );

/*QUAKED trigger_multiple_bcs_tf_prague_pillars (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_mct_co_loc_pillars"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_prague_pillars", "loc_pillars" );

/*QUAKED trigger_multiple_bcs_tf_prague_barricades (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_mct_co_loc_barricades"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_prague_barricades", "loc_barricades" );


}

berlin()
{
/*QUAKED trigger_multiple_bcs_df_berlin_lm_kitchen_back (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="DF_1_lm_kitchen_back"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_df_berlin_lm_kitchen_back", "lm_kitchen_back" );


}

rescue()
{
}

rescue_2()
{
/*QUAKED trigger_multiple_bcs_tf_rescue_snowcat_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_snowcat_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_rescue_snowcat_generic", "loc_snowcat_generic" );

/*QUAKED trigger_multiple_bcs_tf_rescue_dumptruck_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_dumptruck_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_rescue_dumptruck_generic", "loc_dumptruck_generic" );

/*QUAKED trigger_multiple_bcs_tf_rescue_building_red (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_building_red"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_rescue_building_red", "loc_building_red" );

/*QUAKED trigger_multiple_bcs_tf_rescue_snowmobile_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_snowmobile_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_rescue_snowmobile_generic", "loc_snowmobile_generic" );

/*QUAKED trigger_multiple_bcs_tf_rescue_scaffolding_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_scaffolding_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_rescue_scaffolding_generic", "loc_scaffolding_generic" );

/*QUAKED trigger_multiple_bcs_tf_rescue_container_red (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_container_red"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_rescue_container_red", "loc_container_red" );

/*QUAKED trigger_multiple_bcs_tf_rescue_tires_large (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_pri_co_loc_tires_large"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_rescue_tires_large", "loc_tires_large" );


}

dubai()
{
/*QUAKED trigger_multiple_bcs_tf_dubai_arch_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_arch_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_arch_generic", "loc_arch_generic" );

/*QUAKED trigger_multiple_bcs_tf_dubai_bar (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_bar"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_bar", "loc_bar" );

/*QUAKED trigger_multiple_bcs_tf_dubai_barricades (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_barricades"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_barricades", "loc_barricades" );

/*QUAKED trigger_multiple_bcs_tf_dubai_car_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_car_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_car_generic", "loc_car_generic" );

/*QUAKED trigger_multiple_bcs_tf_dubai_chair_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_chair_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_chair_generic", "loc_chair_generic" );

/*QUAKED trigger_multiple_bcs_tf_dubai_couch_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_couch_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_couch_generic", "loc_couch_generic" );

/*QUAKED trigger_multiple_bcs_tf_dubai_counter_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_counter_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_counter_generic", "loc_counter_generic" );

/*QUAKED trigger_multiple_bcs_tf_dubai_doorway (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_doorway"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_doorway", "loc_doorway" );

/*QUAKED trigger_multiple_bcs_tf_dubai_escalator_coming_down (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_escalator_coming_down"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_escalator_coming_down", "loc_escalator_coming_down" );

/*QUAKED trigger_multiple_bcs_tf_dubai_escalator_near_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_escalator_near_right"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_escalator_near_right", "loc_escalator_near_right" );

/*QUAKED trigger_multiple_bcs_tf_dubai_escalator_near_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_escalator_near_left"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_escalator_near_left", "loc_escalator_near_left" );

/*QUAKED trigger_multiple_bcs_tf_dubai_escalator_top (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_escalator_top"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_escalator_top", "loc_escalator_top" );

/*QUAKED trigger_multiple_bcs_tf_dubai_fountain_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_fountain_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_fountain_generic", "loc_fountain_generic" );

/*QUAKED trigger_multiple_bcs_tf_dubai_lamppost_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_lamppost_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_lamppost_generic", "loc_lamppost_generic" );

/*QUAKED trigger_multiple_bcs_tf_dubai_pillar_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_pillar_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_pillar_generic", "loc_pillar_generic" );

/*QUAKED trigger_multiple_bcs_tf_dubai_pillar_left (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_pillar_left"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_pillar_left", "loc_pillar_left" );

/*QUAKED trigger_multiple_bcs_tf_dubai_pillar_right (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_pillar_right"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_pillar_right", "loc_pillar_right" );

/*QUAKED trigger_multiple_bcs_tf_dubai_planter_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_planter_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_planter_generic", "loc_planter_generic" );

/*QUAKED trigger_multiple_bcs_tf_dubai_sedan_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_sedan_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_sedan_generic", "loc_sedan_generic" );

/*QUAKED trigger_multiple_bcs_tf_dubai_suv_generic (0 0.25 0.5) ?
defaulttexture="bcs"
soundalias="TF_yri_co_loc_suv_generic"
*/
	add_bcs_location_mapping( "trigger_multiple_bcs_tf_dubai_suv_generic", "loc_suv_generic" );
}

// MW2 Level Specific Examples

//-------------------------
// OILRIG (tfstealth)
//-------------------------
/*EXAMPLEQUAKED trigger_multiple_bcs_tfstealth_building_2ndfloor_windows (0 0.25 0.5) ?
defaulttexture="bcs"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_tfstealth_building_2ndfloor_windows", "blg_2f_wndws" );

//-------------------------
// GULAG (tfstealth)
//-------------------------
/*EXAMPLEQUAKED trigger_multiple_bcs_tfstealth_landmark_lowwall_underbarbedwire (0 0.25 0.5) ?
defaulttexture="bcs"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_tfstealth_landmark_lowwall_underbarbedwire", "lm_lowwall_bwire" );

//-------------------------
// FAVELA ESCAPE (taskforce)
//-------------------------
/*EXAMPLEQUAKED trigger_multiple_bcs_taskforce_building_shack_left (0 0.25 0.5) ?
defaulttexture="bcs"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_taskforce_building_shack_left", "blg_shack_left" );


//-------------------------
// ESTATE (taskforce)
//-------------------------
/*EXAMPLEQUAKED trigger_multiple_bcs_taskforce_landmark_haybale (0 0.25 0.5) ?
defaulttexture="bcs"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_taskforce_landmark_haybale", "lm_haybale" );


//-------------------------
// CONTINGENCY (taskforce)
//-------------------------
/*EXAMPLEQUAKED trigger_multiple_bcs_taskforce_landmark_wall_barbwire (0 0.25 0.5) ?
defaulttexture="bcs"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_taskforce_landmark_wall_barbwire", "lm_wall_barbwire" );


//-------------------------
// AFGHAN CAVES (taskforce)
//-------------------------
/*EXAMPLEQUAKED trigger_multiple_bcs_tfstealth_building_guardtower (0 0.25 0.5) ?
defaulttexture="bcs"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_tfstealth_building_guardtower", "blg_grdtwr" );


//-------------------------
// INVASION (US)
//-------------------------
/*EXAMPLEQUAKED trigger_multiple_bcs_us_building_diner_inside (0 0.25 0.5) ?
defaulttexture="bcs"
*/
//	add_bcs_location_mapping( "trigger_multiple_bcs_us_building_diner_inside", "blg_diner_ins" );
