#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\postfx_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\shared\util_shared;

function autoexec __init__sytem__() {     system::register("ramses_util",&__init__,undefined,undefined);    }

function __init__()
{
	// initialize clientfields
	// To Player
	clientfield::register( "toplayer", "ramses_sun_color", 1, 1, "int", &callback_sun_color_set, !true, !true );
	clientfield::register( "toplayer", "postfx_dni_interrupt", 1, 1, "counter", &postfx_dni_interrupt, !true, !true );
	clientfield::register( "toplayer", "postfx_futz", 1, 1, "counter", &postfx_futz, !true, !true );
}

function callback_sun_color_set( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = player 
{
	if ( newVal )
	{
		// set custom sun color
		SetDvar( "r_sunTweak", 1 );
		SetDvar( "r_sunColor", "1 0.8549 0.6235 1" );  // R:255 G:218 B:159 A:1
	}
	else
	{
		// reset sun color
		SetDvar( "r_sunTweak", 0 );
	}
}

function postfx_dni_interrupt( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		self thread postfx::PlayPostfxBundle( "pstfx_dni_interrupt" );
		//Play DNI Interrupt Sound
		playsound( 0, "evt_dni_interrupt", (0,0,0) );
	}
}	

function postfx_futz( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		self thread postfx::PlayPostfxBundle( "pstfx_dni_screen_futz" );
		//Play DNI Interrupt Sound
		playsound( 0, "evt_dni_interrupt", (0,0,0) ); //TODO: put new sound here
	}
}	

function postfx_igc( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		self thread postfx::PlayPostfxBundle( "pstfx_igc" );
		//Play DNI Interrupt Sound
		//playsound( 0, "evt_dni_interrupt", (0,0,0) ); //TODO: put new sound here
	}
}	

