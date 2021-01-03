#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
	
#using scripts\shared\system_shared;

function autoexec __init__sytem__() {     system::register("gadget_unstoppable_force",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 29, &gadget_unstoppable_force_on, &gadget_unstoppable_force_off );
	ability_player::register_gadget_possession_callbacks( 29, &gadget_unstoppable_force_on_give, &gadget_unstoppable_force_on_take );
	ability_player::register_gadget_flicker_callbacks( 29, &gadget_unstoppable_force_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 29, &gadget_unstoppable_force_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 29, &gadget_unstoppable_force_is_flickering );

	callback::on_connect( &gadget_unstoppable_force_on_connect );
	
	clientfield::register( "toplayer", "unstoppableforce_state", 1, 1, "int");
}

function gadget_unstoppable_force_is_inuse( slot )
{
	// returns true when the gadget is on
	return self flagsys::get( "gadget_unstoppable_force_on" );
}

function gadget_unstoppable_force_is_flickering( slot )
{
	if(isDefined(level.cybercom) && isDefined(level.cybercom.unstoppable_force))
	{
		return self [[level.cybercom.unstoppable_force._is_flickering]](slot);
	}
	return false;
}


function gadget_unstoppable_force_on_flicker( slot, weapon )
{
	if(isDefined(level.cybercom) && isDefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._on_flicker]](slot, weapon);
	}
}

function gadget_unstoppable_force_on_give( slot, weapon )
{
	if(isDefined(level.cybercom) && isDefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._on_give]](slot, weapon);
	}
}

function gadget_unstoppable_force_on_take( slot, weapon )
{
	if(isDefined(level.cybercom) && isDefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._on_take]](slot, weapon);
	}
}

//self is the player
function gadget_unstoppable_force_on_connect()
{
	if(isDefined(level.cybercom) && isDefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._on_connect]]();
	}
}

function gadget_unstoppable_force_on( slot, weapon )
{
	// excecutes when the gadget is turned on
	self flagsys::set( "gadget_unstoppable_force_on" );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._on]](slot, weapon);
	}
}

function gadget_unstoppable_force_off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self flagsys::clear( "gadget_unstoppable_force_on" );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._off]](slot, weapon);
	}
}

function gadget_firefly_is_primed( slot, weapon )
{
	// excecutes when the gadget is turned off`
	if(isDefined(level.cybercom) && isDefined(level.cybercom.unstoppable_force))
	{
		self [[level.cybercom.unstoppable_force._is_primed]](slot, weapon);
	}
}