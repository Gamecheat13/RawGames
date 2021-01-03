
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\shared\stealth;
#using scripts\shared\stealth_aware;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
	            

#namespace stealth_vo;

/*
	STEALTH VO SYSTEM
 */
	
/@
"Name: init()"
"Summary: Initializes and starts up stealth vo system for an agent
"Module: Stealth"
"CallOn: AI or Player Entity or Level object"
"Example: aiGuy stealth_vo::init();"
"SPMP: singleplayer"
@/
function init( )
{
	assert( isDefined( self.stealth ) );
	
	self stealth_vo::set_stealth_mode( true );
	
	if ( isPlayer( self ) )
	{
		self thread stealth_vo::ambient_player_thread();
	}
	else if ( self == level )
	{
		self init_level_defaults();
		
		level.allowBattleChatter["stealth"] = true;
	}
}

/@
"Name: stop()"
"Summary: Terminates system on given object
"Module: Stealth"
"CallOn: AI or Player Entity or Level object"
"Example: enemy stealth_vo::stop();"
"SPMP: singleplayer"
@/
function stop( )
{
	assert( isDefined( self ) );
	
	if ( IsDefined( self.allowBattleChatter["stealth"] ) )
		self.allowBattleChatter["stealth"] = undefined;
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
	return IsDefined( self.stealth ) && IsDefined( self.allowBattleChatter ) && IsDefined( self.allowBattleChatter["stealth"] );
}

/@
"Name: get_stealth_mode()"
"Summary: Gets true/false indicating if agent is currently using stealth vo mode"
"Module: Stealth"
"CallOn: AI or Player Entity or Level object"
"Example: if ( aiGuy stealth_vo::get_stealth_mode() )"
"SPMP: singleplayer"
@/
function get_stealth_mode( bStealthMode )
{
	return IsDefined( self.stealth ) && IsDefined( self.allowBattleChatter ) && IsDefined( self.allowBattleChatter["stealth"] ) && self.allowBattleChatter["stealth"];
}

/@
"Name: set_stealth_mode( <bStealthMode> )"
"Summary: Sets the vo mode for a given agent to stealth or not"
"Module: Stealth"
"CallOn: AI or Player Entity or Level object"
"Example: aiGuy stealth_vo::set_stealth_mode( true );"
"SPMP: singleplayer"
@/
function set_stealth_mode( bStealthMode )
{
	self thread set_stealth_mode_internal_thread( bStealthMode );
}

function set_stealth_mode_internal_thread( bStealthMode )
{
	// do nothing if its already in the desired mode
	if ( isDefined( self.allowBattleChatter ) && isDefined( self.allowBattleChatter["stealth"] ) && self.allowBattleChatter["stealth"] == bStealthMode )
		return;
	
	self notify("set_stealth_mode_internal_thread");
	self endon("set_stealth_mode_internal_thread");

	if ( !isPlayer( self ) )
		self endon("death");

	// wait one frame always to allow self.stealth.vo_event_priority to be defined by a waiting notify
	{wait(.05);};
	
	if ( isDefined( self ) )
	{	
		// Wait until done saying any line we are already going to say or are saying
		while ( isDefined( self ) && isDefined( self.stealth ) && isDefined( self.stealth.vo_event_priority ) || ( isdefined( self.isSpeaking ) && self.isSpeaking ) )
			{wait(.05);};
	
		// Switch battlechatter category enabled flags
		self.allowBattleChatter["bc"] 		= !bStealthMode;
		self.allowBattleChatter["stealth"] 	=  bStealthMode;
	}
}

/@
"Name: on_voice_event( <eventPackage> )"
"Summary: handles voice event"
"Module: Stealth"
"CallOn: Entity or Struct"
"SPMP: singleplayer"
@/
function on_voice_event( eventPackage )
{
	self endon("death");
	
	if ( !isActor( self ) || !isAlive( self ) )
		return;
	
	str_event = eventPackage.parms[0];
	
	if ( !isDefined( str_event ) )
		return;

	alias_line		= self stealth_vo::get_line( str_event );
	alias_response	= self stealth_vo::get_line( str_event + "_" + alias_line + "_response" );
	
	if ( isDefined( alias_line ) )
	{
		// Make sure we are not already saying something of higher priority
		priority = level.stealth.vo_event_priority[str_event];
		if ( !isdefined( priority ) )
			priority = 0.0;

		if ( !isDefined( self.stealth.vo_event_priority ) || self.stealth.vo_event_priority <= priority )
		{
			// Mark that we have a pending vo event to resolve
			self.stealth.vo_event_priority = priority;
		}
		else
		{
			// Already have a higher priority stealth vo event going on
			return;
		}

		// Wait a small amount of time to allow any higher priority events to occur and randomize reaction times
		wait ( RandomFloatRange( 0.25, 0.75 ) );

		// Then play the vo if we are still the highest priority one to play interrupting anything else		
		if ( !isDefined( self.stealth.vo_event_priority ) || self.stealth.vo_event_priority <= priority )
		{
			self.stealth.vo_event_priority = priority;
			
			self battlechatter::bc_MakeLine( self, alias_line, alias_response, "stealth", true );
			
			while ( ( isdefined( self.isSpeaking ) && self.isSpeaking ) )
				{wait(.05);};
	
			if ( isDefined( self.stealth ) && isDefined( self.stealth.vo_event_priority ) && self.stealth.vo_event_priority == priority )
				self.stealth.vo_event_priority = undefined;
		}
	}
}

/@
"Name: get_line( <str_event>, [tableStruct] )"
"Summary: chooses a line to play for a given event"
"Module: Stealth"
"CallOn: Entity"
"Example: aiGuy stealth_vo::get_line( "alert" );"
"SPMP: singleplayer"
@/
function get_line( str_event, tableStruct )
{
	if ( !self stealth_vo::enabled() )
		return undefined;
	
	if ( !isDefined( level.stealth ) )
		return undefined;
	
	if ( !isDefined( tableStruct ) )
		tableStruct = level.stealth.vo_alias;

	if ( !isDefined( tableStruct.alias ) || !isDefined( tableStruct.alias[str_event] ) )
		return undefined;
	
	// Pick randomly from all matching lines
	line = undefined;
	count = 0.0;
	checkAwareness = [];
	checkAwareness[0] = "noncombat";
	if ( self stealth_aware::enabled() )
		checkAwareness[checkAwareness.size] = self stealth_aware::get_awareness();

	foreach ( awareness in checkAwareness )
	{
		if ( isDefined( tableStruct.alias[str_event][awareness] ) )
	    {
			foreach ( alias in tableStruct.alias[str_event][awareness] )
			{
				count = count + 1.0;
				if ( randomfloat( 1.0 ) <= ( 1.0 / count ) )
					line = alias;
			}
	    }
	}
	
	return line;
}

/@
"Name: init_level_defaults()"
"Summary: Initializes default aliases for normal stealth functionality"
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: level stealth_vo::init_level_defaults();"
"SPMP: singleplayer"
@/
function init_level_defaults()
{
	// Setup event priorities
	if(!isdefined(level.stealth))level.stealth=SpawnStruct();
	if(!isdefined(level.stealth.vo_event_priority))level.stealth.vo_event_priority=[];
	level.stealth.vo_event_priority["ambient"] 		= 0.00;
	level.stealth.vo_event_priority["resume"] 		= 0.25;
	level.stealth.vo_event_priority["alert"] 		= 0.50;
	level.stealth.vo_event_priority["explosion"] 	= 0.80;
	level.stealth.vo_event_priority["corpse"] 		= 0.90;
	level.stealth.vo_event_priority["enemy"] 		= 1.00;

	// Alerted
	stealth_vo::alias_register( "alert", 		"patrol_alerted",  	"response_backup" );
	
	// Ambience
	stealth_vo::alias_register( "ambient", 		"patrol_brief", 	"response_affirm" );	
	stealth_vo::alias_register( "ambient", 		"patrol_calm",		undefined,				"unaware" );
	stealth_vo::alias_register( "ambient", 		"patrol_clear",		undefined,				"unaware" );
	stealth_vo::alias_register( "ambient", 		"patrol_cough",		undefined,				"unaware" );
	stealth_vo::alias_register( "ambient", 		"patrol_humming",	undefined,				"unaware" );
	stealth_vo::alias_register( "ambient", 		"patrol_throat",	undefined,				"unaware" );
	stealth_vo::alias_register( "ambient", 		"patrol_whistle",	undefined,				"unaware" );
	stealth_vo::alias_register( "ambient", 		"patrol_yawn",		undefined,				"unaware" );
	
	// Return to patrolling
	stealth_vo::alias_register( "resume", 		"patrol_resume", 	"response_affirm" );
	stealth_vo::alias_register( "resume", 		"patrol_resume", 	"response_secure" );

	// Special
	stealth_vo::alias_register( "corpse", 		"spotted_corpse" );
	stealth_vo::alias_register( "enemy", 		"spotted_enemy" );
	stealth_vo::alias_register( "explosion", 	"spotted_explosion" );
}

/@
"Name: ambient_player_thread( )"
"Summary: Updates random ambient vo from nearby enemies for each player"
"Module: stealth"
"CallOn: Player"
"Example: player thread stealth_vo::ambient_player_thread();"
@/
function ambient_player_thread() // self = player
{
	assert( isPlayer( self ) );
	
	self notify("ambient_player_thread");
	self endon("ambient_player_thread");
	
	self endon("disconnect");
	self endon("stop_stealth");
	
	// NOTE: all players will hear it if nearby
	
	{wait(.05);};
	
	maxDist = 1000;
	maxDistSq = maxDist * maxDist;
	
	while ( 1 )
	{
		// One ambient vo in vicinity of each player every so often
		wait ( RandomFloatRange( 5, 8 ) );
		
		if ( !isdefined( level.stealth ) || !isDefined( level.stealth.enemies ) || !isDefined( self.team ) || !isDefined( level.stealth.enemies[self.team] ) )
			continue;
		
		candidates = [];
		
		foreach ( enemy in level.stealth.enemies[self.team] )
		{
			if ( !isAlive( enemy ) )
				continue;
			
			if ( !enemy stealth_vo::get_stealth_mode() )
				continue;
			
			if ( enemy.ignoreAll )
				continue; // enemies in a stealth kill interaction will be ignoring all
			
			distSq = DistanceSquared( enemy.origin, self.origin );
			if ( distSq > maxDistSq )
				continue;
			
			if ( isDefined( enemy.stealth.vo_next_ambient ) && GetTime() < enemy.stealth.vo_next_ambient )
				continue;
			
			candidates[candidates.size] = enemy;
		}

		candidates = ArraySortClosest( candidates, self.origin, 1, 0, maxDist );
	
		if ( isDefined( candidates ) && candidates.size > 0 )
		{
			candidates[0] notify( "stealth_vo", "ambient" );
			
			// Each actor has its own randomized debounce
			candidates[0].stealth.vo_next_ambient = GetTime() + RandomIntRange( 8000, 12000 );
		}
	}	
}

/@
"Name: alias_clear()"
"Summary: clears all registered aliases"
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: stealth_vo::alias_clear();
"SPMP: singleplayer"
@/
function alias_clear( )
{
	if ( isDefined( level.stealth ) )
		level.stealth.vo_alias = undefined;
}

/@
"Name: alias_register(<str_event>, <str_alias>, [str_alias_response], [str_awareness])"
"Summary: registers an alias for a given event with optional response and awareness requirement"
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: stealth_vo::alias_register( "alert", "patrol_alert", undefined, "low_alert" );
"SPMP: singleplayer"
@/
function alias_register( str_event, str_alias, str_alias_response, str_awareness )
{
	assert ( isString( str_event ) );
	assert ( isString( str_alias ) );
		
	if(!isdefined(level.stealth))level.stealth=SpawnStruct();
	
	if(!isdefined(level.stealth.vo_alias))level.stealth.vo_alias=SpawnStruct();
	struct_alias_register( level.stealth.vo_alias, str_event, str_alias, str_awareness );
	if ( isDefined( str_alias_response ) )
		struct_alias_register( level.stealth.vo_alias, str_event + "_" + str_alias + "_response", str_alias, str_awareness );
}

/@
"Name: struct_alias_register( <struct>, <str_event>, <str_alias>, [str_awareness])"
"Summary: registers an alias on a given struct for a given event with optional awareness requirement"
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: stealth_vo::struct_alias_register( level.vo_alias, "alert", "patrol_alert", "low_alert" );
"SPMP: singleplayer"
@/
function struct_alias_register( struct, str_event, str_alias, str_awareness )
{
	assert ( isDefined( struct ) );
	assert ( isString( str_event ) );
	assert ( isString( str_alias ) );
	
	if ( !isDefined( str_awareness ) )
		str_awareness = "noncombat";
	
	if(!isdefined(struct.alias))struct.alias=[];
	if(!isdefined(struct.alias[str_event]))struct.alias[str_event]=[];
	if(!isdefined(struct.alias[str_event][str_awareness]))struct.alias[str_event][str_awareness]=[];
	if ( !isDefined( struct.alias[str_event][str_awareness][str_alias] ) )
		struct.alias[str_event][str_awareness][str_alias] = str_alias;
}
