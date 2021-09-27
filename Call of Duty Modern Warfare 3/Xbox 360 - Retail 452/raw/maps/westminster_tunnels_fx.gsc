#include common_scripts\utility;
#include maps\_utility;

main()
{
	thread precacheFX();
}

precacheFX()
{

	if ( getdvarint( "sm_enable" ) && getdvar( "r_zfeather" ) != "0" )
		level._effect[ "spotlight_truck_player" ]						 = loadfx( "misc/london_player_truck_spotlight" );
	else
		level._effect[ "spotlight_truck_player" ]						 = loadfx( "misc/london_player_truck_spotlight_cheap" );
		
	if ( getdvarint( "sm_enable" ) && getdvar( "r_zfeather" ) != "0" )
		level._effect[ "spotlight_train" ]						 = loadfx( "misc/train_spot_light" );
	else
		level._effect[ "spotlight_train" ]						 = loadfx( "misc/train_spot_light_cheap" );
		
		
    level._effect[ "spotlight_train_cheap" ]						 = loadfx( "misc/docks_heli_spotlight_model_cheap" );
    level._effect[ "spotlight_truck_player_cheap" ] = loadfx( "misc/london_player_truck_spotlight_cheap" );

    level._effect[ "sparks_subway_scrape_line" ] = loadfx( "misc/sparks_subway_scrape_line" );
    level._effect[ "sparks_subway_scrape_line_short" ] = loadfx( "misc/sparks_subway_scrape_line_short" );


    level._effect[ "spotlight_train_cheap" ]						 = loadfx( "misc/docks_heli_spotlight_model_cheap" );

    level._effect[ "copypaper_box_exp" ]						 = loadfx( "props/copypaper_box_exp" );
    
    level._effect[ "vehicle_scrape_sparks" ]			= loadfx( "misc/vehicle_scrape_sparks" );
    
    level._effect[ "subway_cart_guy_damage" ] 				 = loadfx( "impacts/flesh_hit_head_fatal_exit_exaggerated" );
}

