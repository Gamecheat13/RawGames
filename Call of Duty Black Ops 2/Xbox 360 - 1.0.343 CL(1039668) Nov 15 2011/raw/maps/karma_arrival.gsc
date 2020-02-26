#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
//	flag_init( "harper_in_hotel_room" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//    add_spawn_function( "intro_drone", ::intro_drone );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_intro()
{
	start_teleport( "skipto_arrival" );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	// Temp Development info
	/#
		IPrintLn( "Arrival" );
	#/

	// Initialization
	level.ai_harper 	= init_hero( "harper" );
	level.ai_han 		= init_hero( "han" );
	level.ai_salazar	= init_hero( "salazar" );
	level.redshirt1		= init_hero( "redshirt1" );
	level.redshirt2		= init_hero( "redshirt2" );

	// Additional event logic	
}

