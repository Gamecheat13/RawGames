#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\spawner_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	

#using scripts\shared\system_shared;

function autoexec __init__sytem__() {     system::register("gadget_other",&__init__,undefined,undefined);    }

function __init__()
{
	ability_player::register_gadget_activation_callbacks( 1, &gadget_other_on_activate, &gadget_other_on_off );
	ability_player::register_gadget_possession_callbacks( 1, &gadget_other_on_give, &gadget_other_on_take );
	ability_player::register_gadget_flicker_callbacks( 1, &gadget_other_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 1, &gadget_other_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 1, &gadget_other_is_flickering );
	ability_player::register_gadget_ready_callbacks( 1, &gadget_other_ready );

	//callback::on_connect( &gadget_other_on_connect );
	//callback::on_spawned( &gadget_other_on_spawn );
}

function gadget_other_is_inuse( slot )
{
	// returns true when the gadget is on
	return self GadgetIsActive( slot );
}

function gadget_other_is_flickering( slot )
{
	// returns true when the gadget is flickering
	return self GadgetFlickering( slot );
}

function gadget_other_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function gadget_other_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
}

function gadget_other_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
}

//self is the player
function gadget_other_on_connect()
{	
	// setup up stuff on player connect	
}

//self is the player
function gadget_other_on_spawn()
{	
	// setup up stuff on player spawn	
}

function gadget_other_on_activate( slot, weapon )
{	
}

function gadget_other_on_off( slot, weapon )
{
}

function gadget_other_ready( slot, weapon )
{
	// unused
}

function set_gadget_other_status( weapon, status, time )
{
	timeStr = "";

	if ( IsDefined( time ) )
	{
		timeStr = "^3" + ", time: " + time;
	}
	
	if ( GetDvarInt( "scr_cpower_debug_prints" ) > 0 )
		self IPrintlnBold( "Gadget Other " + weapon.name + ": " + status + timeStr );
}