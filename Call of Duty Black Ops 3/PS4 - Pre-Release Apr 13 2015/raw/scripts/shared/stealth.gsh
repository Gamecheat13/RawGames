#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_event;
#using scripts\shared\stealth_status;
#using scripts\shared\stealth_tagging;
#using scripts\shared\stealth_vo;
#using scripts\shared\ai_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
	            

#namespace stealth_actor;

/*
	STEALTH - AI
*/

/@
"Name: init()"
"Summary: Initialize stealth on an Actor agent
"Module: Stealth"
"CallOn: AI Entity"
"Example: ai stealth_actor::init();"
"SPMP: singleplayer"
@/
function init( )
{
	assert( isActor( self ) );
	
	// Only	those with script_stealth on them are in stealth mode
	if ( !( isdefined( self.script_stealth ) && self.script_stealth ) )
		return;

	if ( isDefined( self.stealth ) )
		return;
	
	if(!isdefined(self.stealth))self.stealth=SpawnStruct();
	
	self.stealth.enabled_actor = true;
		
	self stealth_status::init( );
	self stealth_aware::init( );
	self stealth_event::init( );
	self stealth_tagging::init();
	self stealth_vo::init();
		
	/# self stealth_debug::init_debug( ); #/
}

/@
"Name: stop()"
"Summary: Terminates stealth on this object
"Module: Stealth"
"CallOn: AI Entity"
"Example: ai stealth_actor::stop();"
"SPMP: singleplayer"
@/
function stop( )
{
	if ( self stealth_aware::enabled() ) 
		self stealth_aware::set_awareness( "combat" );
}

/@
"Name: enabled()"
"Summary: returns if this system is enabled on the given object
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: if ( stealth_actor::enabled() )"
"SPMP: singleplayer"
@/
function enabled( )
{
	return IsDefined( self.stealth ) && isDefined( self.stealth.enabled_actor );
}
