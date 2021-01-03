#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
                              	                               	                    	                                 	                                        	                            	                                                                  	                             
	
#using scripts\shared\system_shared;


function autoexec __init__sytem__() {     system::register("gadget_overdrive",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 28, &gadget_overdrive_on, &gadget_overdrive_off );
	ability_player::register_gadget_possession_callbacks( 28, &gadget_overdrive_on_give, &gadget_overdrive_on_take );
	ability_player::register_gadget_flicker_callbacks( 28, &gadget_overdrive_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 28, &gadget_overdrive_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 28, &gadget_overdrive_is_flickering );

	if ( !IsDefined( level.vsmgr_prio_visionset_overdrive ) )
	{
		level.vsmgr_prio_visionset_overdrive = 65;
	}
	
	visionset_mgr::register_info( "visionset", "overdrive", 1, level.vsmgr_prio_visionset_overdrive, 15, true, &visionset_mgr::ramp_in_out_thread_per_player, false );
	
	callback::on_connect( &gadget_overdrive_on_connect );
	
	clientfield::register( "toplayer", "overdrive_state", 1, 1, "int");
	
}

function gadget_overdrive_is_inuse( slot )
{
	// returns true when the gadget is on
	return self flagsys::get( "gadget_overdrive_on" );
}

function gadget_overdrive_is_flickering( slot )
{
	// returns true when the gadget is flickering
}

function gadget_overdrive_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function gadget_overdrive_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
	if(isDefined(level.cybercom) && isDefined(level.cybercom.overdrive))
	{
		self [[level.cybercom.overdrive._on_give]](slot, weapon);
	}
}

function gadget_overdrive_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
	if(isDefined(level.cybercom) && isDefined(level.cybercom.overdrive))
	{
		self [[level.cybercom.overdrive._on_take]](slot, weapon);
	}
//	gadget_overdrive_off( slot, weapon );
}

//self is the player
function gadget_overdrive_on_connect()
{
	// setup up stuff on player connect	
}

function gadget_overdrive_on( slot, weapon )
{
	if(isDefined(level.cybercom) && isDefined(level.cybercom.overdrive))
	{
		self thread [[level.cybercom.overdrive._on]](slot, weapon);
	}
}

function gadget_overdrive_off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self flagsys::clear( "gadget_overdrive_on" );
	if(isDefined(level.cybercom) && isDefined(level.cybercom.overdrive))
	{
		self thread [[level.cybercom.overdrive._off]](slot, weapon);
	}	
}
