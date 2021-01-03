#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

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

	callback::on_connect( &gadget_overdrive_on_connect );
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
}

function gadget_overdrive_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
}

//self is the player
function gadget_overdrive_on_connect()
{
	// setup up stuff on player connect	
}

function gadget_overdrive_on( slot, weapon )
{
	if( self.health < self.maxHealth * GetDvarFloat( "scr_overdrive_min_health", 0.35 ) )
	{
		self setnormalhealth( GetDvarFloat( "scr_overdrive_min_health", 0.35 ) );
	}
	// excecutes when the gadget is turned on
	self flagsys::set( "gadget_overdrive_on" );
}

function gadget_overdrive_off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self flagsys::clear( "gadget_overdrive_on" );
}