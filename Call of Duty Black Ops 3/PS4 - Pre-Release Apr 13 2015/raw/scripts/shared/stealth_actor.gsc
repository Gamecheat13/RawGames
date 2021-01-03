#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_detect;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_event;
#using scripts\shared\stealth_status;
#using scripts\shared\stealth_tagging;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	            	    	   	                           	                               	                                	                                                              	                                                                          	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	              	                  	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                          	                                   	                                   	                                                    	                                    
        	      

#namespace stealth_ai;

/*
	STEALTH - AI
*/

/@
"Name: init()"
"Summary: Initialize stealth on an Actor agent
"Module: Stealth"
"CallOn: AI Entity"
"Example: ai stealth_ai::init();"
"SPMP: singleplayer"
@/
function init( )
{
	assert( isActor( self ) );

	if ( isDefined( self.stealth ) )
		return;
	
	if(!isdefined(self.stealth))self.stealth=SpawnStruct();
	
	self.stealth.enabled_ai = true;
	self.stealth.str_tag_eye = "TAG_EYE";
		
	self stealth_detect::init( );	
	self stealth_status::init( );
	self stealth_aware::init( );
	self stealth_event::init( );
	self stealth_tagging::init();

	self thread think_thread( );
	
	/# self stealth_debug::init_debug( ); #/
}

/@
"Name: enabled()"
"Summary: returns if this system is enabled on the given object
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: if ( stealth_ai::enabled() )"
"SPMP: singleplayer"
@/
function enabled( )
{
	return IsDefined( self.stealth ) && isDefined( self.stealth.enabled_ai );
}

/@
"Name: think_thread()"
"Summary: Updates a given AI agent for stealth"
"Module: stealth"
"CallOn: Actor"
"Example: ai thread stealth_ai::think_thread();"
@/
function think_thread( )
{
	self notify( "stealth_ai_think_thread" );
	self endon( "stealth_ai_think_thread" );
	self endon( "death" );
		
	while ( 1 ) 
	{	
		awarenessParms = level.stealth.parm.awareness[self stealth_aware::get_awareness()];
		
		vEyeOrigin = self GetTagOrigin( self.stealth.str_tag_eye );
		vEyeAngles = self GetTagAngles( self.stealth.str_tag_eye );
		
		self.stealth.enemies = self stealth::get_enemies();

		self stealth_detect::update( awarenessParms, vEyeOrigin, vEyeAngles );
		
		self stealth_aware::update( );

		self stealth_status::update( self.stealth.detect );
		
		wait 0.05;
	}
}
