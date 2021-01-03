#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
	
#using scripts\shared\system_shared;

function autoexec __init__sytem__() {     system::register("gadget_immolation",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 34, &gadget_immolation_on, &gadget_immolation_off );
	ability_player::register_gadget_possession_callbacks( 34, &gadget_immolation_on_give, &gadget_immolation_on_take );
	ability_player::register_gadget_flicker_callbacks( 34, &gadget_immolation_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 34, &gadget_immolation_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 34, &gadget_immolation_is_flickering );
	ability_player::register_gadget_primed_callbacks( 34, &gadget_immolation_is_primed );

	callback::on_connect( &gadget_immolation_on_connect );
}

function gadget_immolation_is_inuse( slot )
{
	// returns true when the gadget is on
	return self flagsys::get( "gadget_immolation_on" );
}

function gadget_immolation_is_flickering( slot )
{
	// returns true when the gadget is flickering
	if(isDefined(level.cybercom) && isDefined(level.cybercom.immolation))
	{
		return self [[level.cybercom.immolation._is_flickering]](slot);
	}
	return false;
	
}

function gadget_immolation_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
	// excuted when the gadget flickers
	if(isDefined(level.cybercom) && isDefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._on_flicker]](slot, weapon);
	}
}

function gadget_immolation_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
	if(isDefined(level.cybercom) && isDefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._on_give]](slot, weapon);
	}
}

function gadget_immolation_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
	if(isDefined(level.cybercom) && isDefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._on_take]](slot, weapon);
	}
}

//self is the player
function gadget_immolation_on_connect()
{
	// setup up stuff on player connect	
	if(isDefined(level.cybercom) && isDefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._on_connect]]();
	}
}

function gadget_immolation_on( slot, weapon )
{
	// excecutes when the gadget is turned on
	self flagsys::set( "gadget_immolation_on" );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._on]](slot, weapon);
	}
}

function gadget_immolation_off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self flagsys::clear( "gadget_immolation_on" );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._off]](slot, weapon);
	}
}


function gadget_immolation_is_primed( slot, weapon )
{
	// excecutes when the gadget is turned off`
	if(isDefined(level.cybercom) && isDefined(level.cybercom.immolation))
	{
		self [[level.cybercom.immolation._is_primed]](slot, weapon);
	}
}