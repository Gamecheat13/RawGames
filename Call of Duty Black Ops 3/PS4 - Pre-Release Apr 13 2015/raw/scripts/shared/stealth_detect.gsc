#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_behavior;
#using scripts\shared\stealth_vo;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
	            

#namespace stealth_event;

/*
	STEALTH - Event Management
	
	All event handlers follow this same convention

		function on_my_stealth_event( eventPackage )
		
		eventPackage:
			eventPackage.name 		- the name of the event notify
			eventPackage.parms[0-4] - the parameters for the event
			
		*IMPORTANT*: Only one instance of the event package struct exists and is used to process all incoming events
				   	 Be sure to pull off the values needed from it before doing any waits in your handler
				   	 Do not hold onto a reference to it after initial event is triggered.
*/

/@
"Name: init()"
"Summary: Initialize stealth event manager"
"Module: Stealth"
"CallOn: Level"
"Example: level stealth_event::init();"
"SPMP: singleplayer"
@/
function init( )
{
	assert ( isDefined( self.stealth ) );

	if ( isDefined( self.stealth.event ) )
		return;
	
	if(!isdefined(self.stealth.event))self.stealth.event=SpawnStruct();
	if(!isdefined(self.stealth.event.package))self.stealth.event.package=SpawnStruct();
	
	self stealth_event::register_default_handlers();
}

/@
"Name: enabled()"
"Summary: returns if this system is enabled on the given object
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: if ( level stealth_level::enabled() )"
"SPMP: singleplayer"
@/
function enabled( )
{
	return isDefined( self.stealth ) && isDefined( self.stealth.event );
}

/@
"Name: register_default_handlers()"
"Summary: sets up default event handlers for stealth"
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: self stealth_event::register_default_handlers();"
"SPMP: singleplayer"
@/
function register_default_handlers()
{
	// ========================================================================
	// These events are handled through code and communicated back as an 
	// "alert" event when the sentient interest pool system responds to them
	
		/*
			"bullet"
			"bullet_react"
			"bulletwhizby"
			"death" (see body)
			"explode"
			"explosion"
			"footstep"
			"footsteprun"
			"footstepsprint"
			"footstepwalk"
			"grenade_ping"
			"gunshot"
			"new_enemy"
			"projectile_impact"
			"projectile_ping"
			"radio_found_enemy"
			"radio_high"
			"radio_low"
			"react"
			"script"
			"silenced_shot"
			"suppression"
		 */
	
	// ========================================================================
	// These events are script events or things we want to directly react to 
	// bypassing the interest pool system
	 
	// Taking damage
	self stealth_event::register_handler( "pain", 				&on_pain );
	self stealth_event::register_handler( "damage",				&on_pain );
	
	// Awareness events
	self stealth_event::register_handler( "alert", 				&stealth_aware::on_alert_changed );
	self stealth_event::register_handler( "stealth_sight_max",	&stealth_aware::on_sighted );
	self stealth_event::register_handler( "stealth_sight_end",	&stealth_aware::on_sight_end );
	self stealth_event::register_handler( "witness_combat",		&stealth_aware::on_witness_combat );

	// Behavior events
	self stealth_event::register_handler( "investigate",		&stealth_behavior::on_investigate );
	
	// VO
	self stealth_event::register_handler( "stealth_vo",			&stealth_vo::on_voice_event );
}
	
/@
"Name: register_handler( <eventName>, <func> )"
"Summary: sets up an event handler for a specific event"
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: self stealth_event::register_handler( "footstep", ::on_hear_noise );"
"SPMP: singleplayer"
@/
function register_handler( eventName, func )
{
	/#
	if ( !isDefined( self.stealth.event.handlers ) )
		self.stealth.event.handlers = [];
	self.stealth.event.handlers[eventName] = func;
	#/

	self thread handler_thread( eventName, func );
}

/@
"Name: handler_thread( <eventName>, <func> )"
"Summary: waits for event and processes the handler function"
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: self stealth_event::register_handler( "footstep", ::on_hear_noise );"
"SPMP: singleplayer"
@/
function handler_thread( eventName, func )
{
	self notify("handler_thread_" + eventName );
	self endon("handler_thread_" + eventName );
	self endon("stop_stealth");

	// Special case for "death"	
	if ( eventName != "death" )
		self endon("death");

	assert( isDefined( eventName ) );
	assert( isDefined( func ) );
	
	while ( 1 )
	{
		self waittill( eventName, arg1, arg2, arg3, arg4, arg5 );		

		if ( self.ignoreall && eventName != "death" )
			continue;		
/#		
		if ( stealth_debug::enabled() && isDefined( self ) && isEntity( self ) )
		{
			args = "";
			
/*			if ( isdefined( arg5 ) )
				args = " " + stealth_debug::debug_text(arg5) + args;
			if ( isdefined( arg4 ) )
				args = " " + stealth_debug::debug_text(arg4) + args;
			if ( isdefined( arg3 ) )
				args = " " + stealth_debug::debug_text(arg3) + args;
			if ( isdefined( arg2 ) )
				args = " " + stealth_debug::debug_text(arg2) + args;
*/
			if ( isdefined( arg1 ) )
				args = " " + stealth_debug::debug_text(arg1) + args;

			self thread stealth_debug::rising_text( eventName + " <" + args + " >", (0.75,0.75,0.75), 1, 0.5, self.origin + (0, 0, 30), 3.0 );
		}
#/
		// TODO: Could maintain a queue of packages if need be
		self.stealth.event.package.name = eventName;
		self.stealth.event.package.parms[0] = arg1;
		self.stealth.event.package.parms[1] = arg2;
		self.stealth.event.package.parms[2] = arg3;
		self.stealth.event.package.parms[3] = arg4;
		self.stealth.event.package.parms[4] = arg5;
		
		self thread [[ func ]]( self.stealth.event.package );

		// Special case for "death"	
		if ( eventName == "death" )
			return;
	}
}

/@
"Name: on_pain( <eventPackage> )"
"Summary: handles being damaged by an attacker"
"Module: Stealth"
"CallOn: Entity or Struct"
"SPMP: singleplayer"
@/
function on_pain( eventPackage )
{
	if ( !isDefined( self ) )
		return;
	
	e_attacker = eventPackage.parms[0];
	if ( !isEntity( e_attacker ) )
		e_attacker = eventPackage.parms[1];
	
	if ( isDefined( e_attacker ) && e_attacker.team != self.team )
	{
		// Notify myself
		if ( isAlive( self ) )
			self notify( "alert", "combat", e_attacker.origin, e_attacker, "took_damage" );
		
		// Notify all allies who can see me from a ways away according to their alertness level
		self stealth_event::broadcast_to_team( self.team, self.origin, 1000, 128, true, "witness_combat", e_attacker, "saw_combat" );
	}
}
	
/@
"Name: broadcast_to_team( <str_team>, <v_origin>, <radius>, <maxHeightDiff>, <requireSight>, <eventName>, <arg1>, <arg2>, <arg3>, <arg4>, <arg5> )"
"Summary: broadcast an event to a team (when called on an entity it excludes that entity)"
"Module: Stealth"
"Example: aiGuy stealth_event::broadcast_to_team( aiGuy.origin, aiGuy.team, 300, 128, false, "witness_combat", attacker );"
"SPMP: singleplayer"
@/
function broadcast_to_team( str_team, v_origin, radius, maxHeightDiff, requireSight, eventName, arg1, arg2, arg3, arg4, arg5 )
{
	radiusSq = radius * radius;
	
	agentList = GetAIArray();

	foreach ( agent in agentList )
	{
		if ( ( !isDefined( self ) || !( agent === self ) ) && DistanceSquared( v_origin, agent.origin ) < radiusSq )
		{
			if ( agent stealth_aware::get_awareness() == "combat" )
				continue;
			
			if ( abs( agent.origin[2] - self.origin[2] ) > maxHeightDiff ) 
				continue;
			
			bValidTarget = !requireSight;
			if ( requireSight )
				bValidTarget = agent stealth::can_see( self );
			
			if ( bValidTarget && requireSight )
				agent notify( eventName, arg1, arg2, arg3, arg4, arg5 );
			else if ( bValidTarget )
				agent notify( eventName, arg1, arg2, arg3, arg4, arg5 );
		}
	}
}
