#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_event;
#using scripts\shared\stealth_status;
#using scripts\shared\stealth_tagging;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
	            

#namespace stealth_vehicle;

/*
	STEALTH - Vehicle
*/

/@
"Name: init()"
"Summary: Initialize stealth on a vehicle agent
"Module: Stealth"
"CallOn: Vehicle Entity"
"Example: vehicle stealth_vehicle::init();"
"SPMP: singleplayer"
@/
function init( )
{
	assert( isVehicle( self ) );

	// Only those with script_stealth on them are in stealth mode
	if ( !( isdefined( self.script_stealth ) && self.script_stealth ) )
		return;

	if ( isDefined( self.stealth ) )
		return;
	
	if(!isdefined(self.stealth))self.stealth=SpawnStruct();
	
	self.stealth.enabled_vehicle = true;
		
	self stealth_status::init( );
	self stealth_aware::init( );
	self stealth_event::init( );
	
	// FIXME: no tagging for vehicles yet
	//self stealth_tagging::init();
		
	/# self stealth_debug::init_debug( ); #/
}

/@
"Name: stop()"
"Summary: Terminates stealth on this object
"Module: Stealth"
"CallOn: AI Entity"
"Example: ai stealth_vehicle::stop();"
"SPMP: singleplayer"
@/
function stop( )
{
}

/@
"Name: enabled()"
"Summary: returns if this system is enabled on the given object
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: if ( self stealth_vehicle::enabled() )"
"SPMP: singleplayer"
@/
function enabled( )
{
	return IsDefined( self.stealth ) && isDefined( self.stealth.enabled_vehicle );
}
