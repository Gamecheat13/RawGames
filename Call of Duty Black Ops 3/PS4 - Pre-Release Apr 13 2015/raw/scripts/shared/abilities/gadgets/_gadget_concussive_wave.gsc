#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	
	
#using scripts\shared\system_shared;

function autoexec __init__sytem__() {     system::register("gadget_concussive_wave",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 27, &gadget_concussive_wave_on, &gadget_concussive_wave_off );
	ability_player::register_gadget_possession_callbacks( 27, &gadget_concussive_wave_on_give, &gadget_concussive_wave_on_take );
	ability_player::register_gadget_flicker_callbacks( 27, &gadget_concussive_wave_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 27, &gadget_concussive_wave_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 27, &gadget_concussive_wave_is_flickering );
	ability_player::register_gadget_primed_callbacks( 27, &gadget_concussive_wave_is_primed );

	callback::on_connect( &gadget_concussive_wave_on_connect );
}

function gadget_concussive_wave_is_inuse( slot )
{
	// returns true when the gadget is on
	return self flagsys::get( "gadget_concussive_wave_on" );
}

function gadget_concussive_wave_is_flickering( slot )
{
	if(isDefined(level.cybercom) && isDefined(level.cybercom.concussive_wave))
	{
		return self [[level.cybercom.concussive_wave._is_flickering]](slot);
	}
	return false;
}

function gadget_concussive_wave_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
	if(isDefined(level.cybercom) && isDefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._on_flicker]](slot, weapon);
	}
}

function gadget_concussive_wave_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
	if(isDefined(level.cybercom) && isDefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._on_give]](slot, weapon);
	}
}

function gadget_concussive_wave_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
	if(isDefined(level.cybercom) && isDefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._on_take]](slot, weapon);
	}
}

//self is the player
function gadget_concussive_wave_on_connect()
{
	// setup up stuff on player connect	
	if(isDefined(level.cybercom) && isDefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._on_connect]]();
	}
}

function gadget_concussive_wave_on( slot, weapon )
{
	// excecutes when the gadget is turned on
	self flagsys::set( "gadget_concussive_wave_on" );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._on]](slot, weapon);
	}
}

function gadget_concussive_wave_off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self flagsys::clear( "gadget_concussive_wave_on" );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._off]](slot, weapon);
	}
}

function gadget_concussive_wave_is_primed( slot, weapon )
{
	// excecutes when the gadget is turned off`
	if(isDefined(level.cybercom) && isDefined(level.cybercom.concussive_wave))
	{
		self [[level.cybercom.concussive_wave._is_primed]](slot, weapon);
	}
}