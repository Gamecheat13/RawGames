#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
	
#using scripts\shared\system_shared;

function autoexec __init__sytem__() {     system::register("gadget_ravage_core",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 22, &gadget_ravage_core_on, &gadget_ravage_core_off );
	ability_player::register_gadget_possession_callbacks( 22, &gadget_ravage_core_on_give, &gadget_ravage_core_on_take );
	ability_player::register_gadget_flicker_callbacks( 22, &gadget_ravage_core_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 22, &gadget_ravage_core_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 22, &gadget_ravage_core_is_flickering );

	callback::on_connect( &gadget_ravage_core_on_connect );
}

function gadget_ravage_core_is_inuse( slot )
{
	// returns true when the gadget is on
	return self flagsys::get( "gadget_ravage_core_on" );
}

function gadget_ravage_core_is_flickering( slot )
{
	// returns true when the gadget is flickering
	// returns true when the gadget is flickering
	if(isDefined(level.cybercom) && isDefined(level.cybercom.ravage_core))
	{
		return self [[level.cybercom.ravage_core._is_flickering]](slot);
	}
	
}

function gadget_ravage_core_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
	if(isDefined(level.cybercom) && isDefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._on_flicker]](slot, weapon);
	}
}

function gadget_ravage_core_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
	if(isDefined(level.cybercom) && isDefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._on_give]](slot, weapon);
	}
}

function gadget_ravage_core_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
	if(isDefined(level.cybercom) && isDefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._on_take]](slot, weapon);
	}
}

//self is the player
function gadget_ravage_core_on_connect()
{
	// setup up stuff on player connect	
	if(isDefined(level.cybercom) && isDefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._on_connect]]();
	}
}

function gadget_ravage_core_on( slot, weapon )
{
	// excecutes when the gadget is turned on
	self flagsys::set( "gadget_ravage_core_on" );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._on]](slot, weapon);
	}
}

function gadget_ravage_core_off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self flagsys::clear( "gadget_ravage_core_on" );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.ravage_core))
	{
		self [[level.cybercom.ravage_core._off]](slot, weapon);
	}
}