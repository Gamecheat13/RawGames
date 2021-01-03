#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
	                               	                    	                                 	                                        	                            	                                                                  	                               
	


#namespace speedburst;

function autoexec __init__sytem__() {     system::register("gadget_speed_burst",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "toplayer", "speed_burst" , 1, 1, "int" );
	
	ability_player::register_gadget_activation_callbacks( 13, &gadget_speed_burst_on, &gadget_speed_burst_off );
	ability_player::register_gadget_possession_callbacks( 13, &gadget_speed_burst_on_give, &gadget_speed_burst_on_take );
	ability_player::register_gadget_flicker_callbacks( 13, &gadget_speed_burst_on_flicker );
	ability_player::register_gadget_is_inuse_callbacks( 13, &gadget_speed_burst_is_inuse );
	ability_player::register_gadget_is_flickering_callbacks( 13, &gadget_speed_burst_is_flickering );
	
	if ( !IsDefined( level.vsmgr_prio_visionset_speedburst ) )
	{
		level.vsmgr_prio_visionset_speedburst = 60;
	}
	
	visionset_mgr::register_info( "visionset", "speed_burst", 1, level.vsmgr_prio_visionset_speedburst, 9, true, &visionset_mgr::ramp_in_out_thread_per_player, false );

	callback::on_connect( &gadget_speed_burst_on_connect );
}

function gadget_speed_burst_is_inuse( slot )
{
	// returns true when local script gadget state is on
	return self flagsys::get( "gadget_speed_burst_on" );
}

function gadget_speed_burst_is_flickering( slot )
{
	// returns true when local script gadget state is flickering
	return self GadgetFlickering( slot );
}

function gadget_speed_burst_on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
	self thread gadget_speed_burst_flicker( slot, weapon );	
}

function gadget_speed_burst_on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
	flagsys::set( "speed_burst_on" ); 
	self clientfield::set_to_player( "speed_burst", 0 );
}

function gadget_speed_burst_on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
	flagsys::clear( "speed_burst_on" ); 
	self clientfield::set_to_player( "speed_burst", 0 );
}

//self is the player
function gadget_speed_burst_on_connect()
{
	// setup up stuff on player connec
}

function gadget_speed_burst_on( slot, weapon )
{
	// excecutes when the gadget is turned on
	self flagsys::set( "gadget_speed_burst_on" );
	self GadgetSetActivateTime( slot, GetTime() );
	self clientfield::set_to_player( "speed_burst", 1 );
	visionset_mgr::activate( "visionset", "speed_burst", self, 0.4, .1, 1.35 );
	self.speedburstLastOnTime = getTime();
	self.speedburstOn = true;
	self.speedburstDialogSuccess = false;
}

function gadget_speed_burst_off( slot, weapon )
{
	self notify( "gadget_speed_burst_off" );
	
	// excecutes when the gadget is turned off
	self flagsys::clear( "gadget_speed_burst_on" );
	self clientfield::set_to_player( "speed_burst", 0 );
	self.speedburstLastOnTime = getTime();
	
	self.speedburstOn = false;
}

function gadget_speed_burst_flicker( slot, weapon )
{
	self endon( "disconnect" );	

	if ( !self gadget_speed_burst_is_inuse( slot ) )
	{
		return;
	}

	eventTime = self._gadgets_player[slot].gadget_flickertime;

	self set_gadget_status( "Flickering", eventTime );

	while( 1 )
	{		
		if ( !self GadgetFlickering( slot ) )
		{
			self set_gadget_status( "Normal" );
			return;
		}

		wait( 0.5 );
	}
}

function set_gadget_status( status, time )
{
	timeStr = "";

	if ( IsDefined( time ) )
	{
		timeStr = "^3" + ", time: " + time;
	}
	
	if ( GetDvarInt( "scr_cpower_debug_prints" ) > 0 )
		self IPrintlnBold( "Vision Speed burst: " + status + timeStr );
}