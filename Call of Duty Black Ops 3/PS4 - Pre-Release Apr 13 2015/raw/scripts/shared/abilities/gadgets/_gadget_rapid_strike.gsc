#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	
	
#using scripts\shared\system_shared;

function autoexec __init__sytem__() {     system::register("gadget_rapid_strike",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 30, &gadget_rapid_strike_on, &gadget_rapid_strike_off );
	ability_player::register_gadget_possession_callbacks( 30, &gadget_rapid_strike_on_give, &gadget_rapid_strike_on_take );
	ability_player::register_gadget_flicker_callbacks( 30, &gadget_rapid_strike_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 30, &gadget_rapid_strike_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 30, &gadget_rapid_strike_is_flickering );

	callback::on_connect( &gadget_rapid_strike_on_connect );
}

function gadget_rapid_strike_is_inuse( slot )
{
	// returns true when the gadget is on
	return self flagsys::get( "gadget_rapid_strike_on" );
}

function gadget_rapid_strike_is_flickering( slot )
{
	// returns true when the gadget is flickering
}

function gadget_rapid_strike_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function gadget_rapid_strike_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
}

function gadget_rapid_strike_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
}

//self is the player
function gadget_rapid_strike_on_connect()
{
	// setup up stuff on player connect	
}

function gadget_rapid_strike_on( slot, weapon )
{
	// excecutes when the gadget is turned on
	self flagsys::set( "gadget_rapid_strike_on" );
}

function gadget_rapid_strike_off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self flagsys::clear( "gadget_rapid_strike_on" );
}