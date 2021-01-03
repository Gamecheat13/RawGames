#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_behavior;
#using scripts\shared\stealth_player;
#using scripts\shared\stealth_event;
#using scripts\shared\stealth_level;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_vo;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
	            

#namespace stealth_aware;

/*
	STEALTH - Awareness state manager
*/

/@
"Name: init()"
"Summary: Initialize stealth awareness on an entity or struct
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: ai stealth_aware::init();"
"SPMP: singleplayer"
@/
function init( )
{
	assert( isDefined( self.stealth ) );
	
	self.stealth.aware_combat = [];
	self.stealth.aware_alerted = [];
	self.stealth.aware_sighted = [];

	/# self.stealth.debug_ignore = []; #/

	self stealth_aware::set_awareness( "unaware" );
}

/@
"Name: enabled()"
"Summary: returns true if this system is enabled on the given object
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: ai stealth_aware::enabled();"
"SPMP: singleplayer"
@/
function enabled( )
{
	return IsDefined( self.stealth ) && isDefined( self.stealth.aware_combat );
}

/@
"Name: set_awareness( str_awareness )"
"Summary: Sets up an ai agents's awareness state"
"Module: stealth"
"CallOn: Entity or struct"
"MandatoryArg: <str_awareness> The state name being set ( 'unaware', 'low_alert', 'high_alert', 'combat' )"
"Example: ai stealth_aware::set_awareness( "combat" );"
@/
function set_awareness( str_awareness )
{
	assert( self stealth_aware::enabled() );
	
	prevAwareness = self.awarenesslevelcurrent;
	if ( !isDefined( prevAwareness ) )
		prevAwareness = "unaware";

	self.awarenesslevelcurrent = str_awareness;

	bStealthMode = self.awarenesslevelcurrent != "combat";
	
	parms = stealth_level::get_parms( str_awareness );

	self.fovcosine = parms.fovcosine;
	self.fovcosineZ = parms.fovcosineZ;
	self.maxsightdist = parms.maxsightdist;
	self.maxsightdistsqrd = self.maxsightdist * self.maxsightdist;
	self.quiet_death = bStealthMode;
	
	// Update stealth sight state - only allowing decay if not in combat by default
	self SetStealthSightAwareness( self.awarenesslevelcurrent, bStealthMode );

	// Remember if we were on patrol before changing states
	if ( self ai::has_behavior_attribute( "patrol" ) && self ai::get_behavior_attribute( "patrol" ) )
		self.stealth.was_patrolling = true;
	
	switch ( self.awarenesslevelcurrent )
	{
		case "unaware":
		case "low_alert":
		case "high_alert":
			self set_ignore_sentient_all( true );
			break;
	}

	if ( str_awareness == "unaware" )
	{
		// Forget about anyone we were in combat with or alerted to
		self.stealth.aware_combat = [];
		self.stealth.aware_alerted = [];
		self.stealth.aware_sighted = [];
		
		// Clear all events in my interest pool
		self ServiceEventsInRadius( self.origin, -1 );
		
		if ( isActor( self ) )
			self ClearEnemy();

		// Return to patrolling if thats what they were doing before
		if ( ( isdefined( self.stealth.was_patrolling ) && self.stealth.was_patrolling ) && isDefined( self.currentgoal ) )
			self thread ai::patrol( self.currentgoal );
	}
	
	// Use stealth behavior tree as long as we are not in combat
	if ( self ai::has_behavior_attribute( "stealth" ) )
		self ai::set_behavior_attribute( "stealth", bStealthMode );
	
	// Don't do normal cover arrivals when in stealth mode
	if ( self ai::has_behavior_attribute( "disablearrivals" ) )
		self ai::set_behavior_attribute( "disablearrivals", bStealthMode );

	// Use stealth VO as long as we are not in combat
	if ( self stealth_vo::enabled() )
		self stealth_vo::set_stealth_mode( bStealthMode );
}

/@
"Name: get_awareness( )"
"Summary: Gets an actor's awareness state"
"Module: stealth"
"CallOn: Actor"
"Example: str_awareness = ai stealth_aware::get_awareness( );"
@/
function get_awareness( )
{
	return self.awarenesslevelcurrent;
}

/@
"Name: was_alerted( entity )"
"Summary: Returns true if this agent was ever alerted by the entity"
"Module: stealth"
"CallOn: Actor"
"Example: investigated = ai stealth_aware::was_alerted( corpse );"
@/
function was_alerted( entity )
{
	return isDefined( self.stealth.aware_alerted[entity GetEntityNumber()] );
}

/@
"Name: change_awareness( delta )"
"Summary: Offsets an agents's awareness state with integer step count"
"Module: stealth"
"CallOn: Entity or struct"
"MandatoryArg: <delta> integer awareness levels to change +/-"
"Example: ai stealth_aware::change_awareness( -1 );"
@/
function change_awareness( delta )
{
	assert( self stealth_aware::enabled() );

	prevAware = self.awarenesslevelcurrent;
	
	abs_offset = abs( delta );
	if ( abs_offset > 1 )
	{
		for ( i = 0; i < abs_offset; i++ )
		{
			if ( delta > 0 )
				change_awareness( 1 );
			else
				change_awareness( -1 );
		}
		
		return ( prevAware != self.awarenesslevelcurrent );
	}
		    
	if ( delta > 0 )
	{
		// Advance
		switch ( self.awarenesslevelcurrent )
		{
			case "unaware":
				// TODO: skipping low_alert for now
				self set_awareness( "high_alert" ); 
				break;
			case "low_alert":
				self set_awareness( "high_alert" );
				break;
			case "high_alert":
				self set_awareness( "combat" );
				break;
		}
	}
	else
	{
		// Fall off
		switch ( self.awarenesslevelcurrent )
		{
			case "low_alert":
				self set_awareness( "unaware" );
				break;
			case "high_alert":
				// TODO: skipping low_alert for now
				self set_awareness( "unaware" ); 
				break;
			case "combat":
				self set_awareness( "high_alert" );
				break;
		}
	}	
	
	return ( prevAware != self.awarenesslevelcurrent );
}

/@
"Name: set_ignore_sentient_all( ignore )"
"Summary: Makes this agent ignore all enemies or not
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: aiGuy stealth_aware::set_ignore_sentient_all( true );"
"SPMP: singleplayer"
@/
function set_ignore_sentient_all( ignore )
{
	assert( self stealth_aware::enabled() );

	// All enemies if specific sentient is not defined
	foreach ( enemy in level.stealth.enemies[self.team] )
	{
		if ( !isDefined( enemy ) )
			continue;
		
		self set_ignore_sentient( enemy, ignore );
	}
}

/@
"Name: set_ignore_sentient( sentient, ignore )"
"Summary: Makes this agent ignore a specific other sentient or not
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: aiGuy stealth_aware::set_ignore_sentient( player, true );"
"SPMP: singleplayer"
@/
function set_ignore_sentient( sentient, ignore )
{
	assert( self stealth_aware::enabled() );

	if ( isSentient( self ) && isSentient( sentient ) )
		self SetIgnoreEnt( sentient, ignore );
	
	/#
	if ( ignore )
		self.stealth.debug_ignore[sentient GetEntityNumber()] = sentient;
	else
		self.stealth.debug_ignore[sentient GetEntityNumber()] = undefined;
	#/
}

/@
"Name: on_sighted( <eventPackage> )"
"Summary: handles event of seeing something of interest"
"Module: Stealth"
"CallOn: Entity or Struct"
"SPMP: singleplayer"
@/
function on_sighted( eventPackage )
{
	e_originator = eventPackage.parms[0];
	
	if ( !isdefined( e_originator ) )

	if ( !isDefined( e_originator ) )
		return;

	debugReason = "";
	maxSightAwareness = "unaware";
	curAwareness = self stealth_aware::get_awareness();
	
	// Only allow going into combat from seeing something if its an enemy, or an ally in combat.
	if ( self stealth::is_enemy( e_originator ) && isAlive( e_originator ) )
	{
		maxSightAwareness = "combat";
		/# debugReason = "saw_enemy" ; #/
	}
	else if ( e_originator stealth_aware::enabled() && e_originator stealth_aware::get_awareness() == "combat" )
	{
		maxSightAwareness = "high_alert";
		/# debugReason = "saw_combat"; #/
	}
	
	if ( stealth::awareness_delta( curAwareness, maxSightAwareness ) < 0 && self stealth_aware::change_awareness( 1 ) )
	{				
		curAwareness = self stealth_aware::get_awareness();
		
		self notify( "alert", curAwareness, e_originator.origin + (0, 0, 20), e_originator, debugReason );
		
		// Reset stealth sight to start ramping up in the new awareness level
		if ( curAwareness != "combat" )
			self SetStealthSightValue( e_originator, 0.0 );
	}
	
	if ( isDefined( e_originator ) && self stealth::is_enemy( e_originator ) )
	{
		self.stealth.aware_alerted[e_originator GetEntityNumber()] = e_originator;
		self.stealth.aware_sighted[e_originator GetEntityNumber()] = e_originator;
	}
}

/@
"Name: on_sight_end( <eventPackage> )"
"Summary: handles event of sight dropping back to zero on something of interest"
"Module: Stealth"
"CallOn: Entity or Struct"
"SPMP: singleplayer"
@/
function on_sight_end( eventPackage )
{
	self endon("death");
	self endon("disconnect");
	
	e_originator = eventPackage.parms[0];
	
	// Make sure we never have more than one of these waiting per entity of interest
	sightName = "on_sight_end";
	if ( isDefined( e_originator ) )
		sightName = sightName + "_" + e_originator GetEntityNumber();
	self notify( sightName );
	self endon( sightName );

	// Dont fall back on awareness until we are done investigating
	if ( ( isdefined( self.stealth.investigating ) && self.stealth.investigating ) )
		self waittill("investigate_stop");
	
	maxSightValue = 0.0;
	foreach ( index, enemy in self.stealth.aware_alerted )
	{
		if ( !isDefined( enemy ) )
			continue;
		
		maxSightValue = max( maxSightValue, self GetStealthSightValue( enemy ) );
	}

	if ( maxSightValue <= 0.0 && isDefined( e_originator ) && self stealth_aware::change_awareness( -1 ) )
	{
		if ( self stealth_aware::get_awareness() != "unaware" )
		{
			// Reset sight back to 1 so next level can begin dropping
			self SetStealthSightValue( e_originator, 1.0 );
		}
	}
}

/@
"Name: on_alert_changed( <eventPackage> )"
"Summary: handles alert level changing from sentient interest pool"
"Module: Stealth"
"CallOn: Entity or Struct"
"SPMP: singleplayer"
@/
function on_alert_changed( eventPackage )
{
	eventInterestPos = self GetEventPointOfInterest();
	v_origin = eventInterestPos;
	e_originator = self GetCurrentEventOriginator();
	i_id = self GetCurrentEventId();
	str_typeName = self GetCurrentEventTypeName();
	
	str_newalert = eventPackage.parms[0];

	if ( isDefined( eventPackage.parms[1] ) )
		v_origin = eventPackage.parms[1];

	if ( isDefined( eventPackage.parms[2] ) )
		e_originator = eventPackage.parms[2];
	
	if ( stealth::awareness_delta( str_newalert, self stealth_aware::get_awareness() ) >= 0 )
	{
		if ( isDefined( v_origin ) )
		{
			if ( !isDefined( eventInterestPos ) || DistanceSquared( v_origin, eventInterestPos ) > 0.1 )
			{
				// Override the reaction yaw to something other that what is defined by GetEventPointOfInterest()
				deltaOrigin = v_origin - self.origin;
				deltaAngles = VectorToAngles( deltaOrigin );
				self.react_yaw = AbsAngleClamp360( self.angles[1] - deltaAngles[1] );
			}
			
			// Look directly at that spot when possible during reaction
			if ( isActor( self ) )
				self thread react_head_look( v_origin, 1.25 );
		}
				
		/#
		debugReason = self GetCurrentEventTypeName() + self GetCurrentEventName();
		if ( !isdefined( debugReason ) || debugReason == "" )
			debugReason = "code";
		if ( isDefined( e_originator ) && isCorpse( e_originator ) )
			debugReason = "saw_body";
		if ( eventPackage.parms.size > 1 )
			debugReason = eventPackage.parms[eventPackage.parms.size-1];
		if ( isDefined( debugReason ) && isString( debugReason ) )
			self.stealth.debug_reason = debugReason;
		#/

		if ( str_typeName == "explosion" ) 
			self notify( "stealth_vo", "explosion" );
		else if ( isDefined( e_originator ) && isCorpse( e_originator ) )
			self notify( "stealth_vo", "corpse" );
		
		self stealth_aware::set_awareness( str_newalert );
	
		switch ( str_newalert )
		{
			case "low_alert":
			case "high_alert":
				self notify( "investigate", v_origin, e_originator );
				break;
		}

		if ( isDefined( i_id ) && isDefined( e_originator ) && isCorpse( e_originator ) )
			self thread delayed_service_event( 8, i_id );
		
		if ( isDefined( self.script_aigroup ) )
			self stealth_aware::alert_group( self.script_aigroup, str_newalert, v_origin, e_originator );
	}
	
	if ( isDefined( e_originator ) && self stealth::is_enemy( e_originator ) )
	{
		self.stealth.aware_alerted[e_originator GetEntityNumber()] = e_originator;
		
		if ( str_newalert == "combat" )
			self stealth_aware::enter_combat_with( e_originator );	
	}
}

/@
"Name: alert_group( <str_group>, <str_awareness>, <origin>, <e_originator> )"
"Summary: Makes other actors in the matching ai group aware at same level of awareness"
"Module: Stealth"
"CallOn: Actor"
"SPMP: singleplayer"
@/
function alert_group( group, str_newalert, v_origin, e_originator )
{
	group = GetAIArray( group, "script_aigroup" );
	
	maxDistSq = GetDvarInt( "stealth_group_radius", 1000 );
	maxDistSq = maxDistSq * maxDistSq;
	
	foreach ( guy in group )
	{
		if ( guy == self ) 
			continue;
		
		if ( !isAlive( guy ) )
			continue;
		
		if ( DistanceSquared( guy.origin, self.origin ) > maxDistSq )
			continue;
		
		if ( stealth::awareness_delta( str_newalert, guy stealth_aware::get_awareness() ) <= 0 )
			continue;
		
		guy util::delay_notify( randomfloatrange( 0.33, 0.66 ), "alert", undefined, str_newalert, v_origin, e_originator );
	}
}

/@
"Name: react_head_look( <location> )"
"Summary: Makes AI look directly at a point while reacting (within tolerances of head look)"
"Module: Stealth"
"CallOn: Actor"
"SPMP: singleplayer"
@/
function react_head_look( location, delay )
{
	self notify("react_head_look");
	self endon("react_head_look");
	
	// Not using self.stealth struct to avoid danger of it being pulled out from under us
	
	if ( !isdefined( self.stealth_head_look_ent ) )
		self.stealth_head_look_ent = spawn( "script_model", location );
	
	ent = self.stealth_head_look_ent;
	ent.origin = location;
	startTime = GetTime();
	delayMs = delay * 1000;
	
	while ( isAlive( self ) && ( isdefined( self.stealth_reacting ) && self.stealth_reacting ) )
	{
		if ( ( GetTime() - startTime ) >= delayMs )
		{
			self LookAtEntity( ent );
		
			/# 
			if ( stealth_debug::enabled() )
			{
				Line( self GetEye(), ent.origin + (0, 0, 20), (0,0,1), 1, true, 1 );
				DebugStar( ent.origin + (0, 0, 20), 1, (0,0,1) ); 
			}
			#/
		}			
			
		{wait(.05);};
	}
	
	if ( isdefined( self ) )
	{
		self LookAtEntity();
		self.stealth_head_look_ent = undefined;
	}

	ent Delete();
}

function delayed_service_event( delay, id )
{
	self endon("death");
	
	wait ( delay );
	
	self ServiceEvent( id );
}

/@
"Name: on_witness_combat( <eventPackage> )"
"Summary: handles being damaged"
"Module: Stealth"
"CallOn: Entity or Struct"
"SPMP: singleplayer"
@/
function on_witness_combat( eventPackage )
{
	self endon("death");
	
	e_attacker 	= eventPackage.parms[0];
	
	debugReason = eventPackage.parms[1];
		
	if ( isDefined( e_attacker ) )
	{
		if ( stealth::awareness_delta( self stealth_aware::get_awareness(), "high_alert" ) < 0 )
			self notify ( "alert", "high_alert", e_attacker.origin, e_attacker, debugReason );
	}
}

/@
"Name: combat_alert_event( <e_attacker> )"
"Summary: react to being part of or witnessing combat"
"Module: Stealth"
"CallOn: Entity or Struct"
"SPMP: singleplayer"
@/
function combat_alert_event( e_attacker )
{
	self endon("death");
	
	if ( isDefined( e_attacker ) && self stealth_aware::enabled() )
	{
		// Give it a second to soak in
		wait ( RandomFloatRange( 0.25, 0.75 ) );
		
		// Become alerted to this attacker
		self stealth_aware::enter_combat_with( e_attacker );
	}
}

function enter_combat_with( enemy )
{
	if ( !isdefined( enemy ) || !self stealth::is_enemy( enemy ) )
		return;
	
	self stealth_behavior::investigate_stop();
	
	enemyEntNum = enemy GetEntityNumber();
			
	self stealth_aware::set_awareness( "combat" );
	self stealth_aware::set_ignore_sentient( enemy, false );
	if ( !isDefined( self.stealth.aware_combat[enemyEntNum] ) )
	{
		self.stealth.aware_combat[enemyEntNum] = enemy;		
		self.stealth.aware_alerted[enemyEntNum] = enemy;
		self thread combat_spread_thread( enemy );

		self notify( "stealth_vo", "enemy" );
	}
	
	self SetStealthSightValue( enemy, 1.0 );
}

function combat_spread_thread( enemy )
{
	self notify( "combat_spread_thread_" + enemy GetEntityNumber() );
	self endon( "combat_spread_thread_" + enemy GetEntityNumber() );
	self endon( "death" );
	
	idleTime = 0;

	while ( 1 )
	{
		wait 1;
		
		if ( !isDefined( enemy ) || enemy.health <= 0 || self stealth_aware::get_awareness() != "combat" )			
			break;
		
		// Notify any allies right next to me while I am in combat
		self stealth_event::broadcast_to_team( self.team, self.origin, 200, 100, false, "alert", "combat", enemy.origin, enemy, "close_combat" );
		
// 		// Notify any allies who can see me at a reasonable range while I am in combat
//		self stealth_event::broadcast_to_team( self.team, self.origin, 800, 300, true, "alert", AI_AWARENESS_COMBAT, enemy.origin, enemy, "close_combat" );
		
		if ( !isDefined( self.enemy ) || !self stealth::can_see( self.enemy ) )
			self SetStealthSightAwareness( self.awarenesslevelcurrent, true );
		else
			self SetStealthSightAwareness( self.awarenesslevelcurrent, false );
	}
}
