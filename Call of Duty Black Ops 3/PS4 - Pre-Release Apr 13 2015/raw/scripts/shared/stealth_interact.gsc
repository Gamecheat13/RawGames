#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_actor;
#using scripts\shared\stealth_player;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_vo;
#using scripts\shared\stealth_aware;
#using scripts\shared\flag_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
	            

#namespace stealth_level;

/*
	STEALTH - Level
*/

/@
"Name: init()"
"Summary: Initialize stealth on level object
"Module: Stealth"
"CallOn: Level"
"Example: level stealth_level::init();"
"SPMP: singleplayer"
@/
function init( )
{
	assert( !isDefined( self.stealth ) );
	
	if(!isdefined(self.stealth))self.stealth=SpawnStruct();

	self.stealth.enabled_level = true;
	
	self.stealth.enemies = [];
	
	self.stealth.awareness_index = [];
	self.stealth.awareness_index["unaware"] 		= 0;
	self.stealth.awareness_index["low_alert"]	= 1;
	self.stealth.awareness_index["high_alert"]	= 2;
	self.stealth.awareness_index["combat"]		= 3;

	level flag::init( "stealth_alert", 	false );
	level flag::init( "stealth_combat",	false );

	init_parms();

	spawner::add_global_spawn_function( "axis", &stealth::agent_init );

	self stealth_vo::init();
	
	self thread update_thread();

	/# self stealth_debug::init_debug( ); #/

	level.using_awareness = true;
		
//  dedwards - 2/26/2015 - disabled as it was only needed for stealth_tagging
//	// Disable player spotting enemies through normal sight
//	SetDvar( "player_tmodeSightEnabled", 0 );
	
	// Always see things with 90 degree fov within this range
	SetDvar( "ai_stumbleSightRange", 200 );

	// Enable the sentient event awareness system
	SetDvar( "ai_awarenessenabled", 1 );
	
	// Developer options for visual and audio feedback
	SetDvar( "stealth_display", 0 );
	SetDvar( "stealth_audio", 	0 );

	SetDvar( "stealth_group_radius", 1000 );
}

/@
"Name: stop()"
"Summary: Terminates stealth on this object
"Module: Stealth"
"CallOn: AI Entity"
"Example: ai stealth_level::stop();"
"SPMP: singleplayer"
@/
function stop( )
{
	spawner::remove_global_spawn_function( "axis", &stealth::agent_init );

	level.using_awareness = false;

//  dedwards - 2/26/2015 - disabled as it was only needed for stealth_tagging
//	// Enable player spotting enemies through normal sight
//	SetDvar( "player_tmodeSightEnabled", 1 );
	
	// Disable ai_stumbleSightRange
	SetDvar( "ai_stumbleSightRange", 0 );

	// Disable the sentient event awareness system
	SetDvar( "ai_awarenessenabled", 0 );
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
	return IsDefined( self.stealth ) && IsDefined( self.stealth.enabled_level );
}

/@
"Name: init_parms()"
"Summary: Initialize stealth system parameters on level object"
"Module: Stealth"
"CallOn: Level"
"Example: level stealth_level::init_parms();"
"SPMP: singleplayer"
@/
function init_parms()
{
	assert( self stealth_level::enabled() );
	
	if(!isdefined(self.stealth.parm))self.stealth.parm=SpawnStruct();

	self.stealth.parm.awareness["unaware"] 		= SpawnStruct();
	self.stealth.parm.awareness["low_alert"] 	= SpawnStruct();
	self.stealth.parm.awareness["high_alert"]	= SpawnStruct();
	self.stealth.parm.awareness["combat"] 		= SpawnStruct();

	// -----------------------------------------------------------------------	
	// AI_AWARENESS_UNAWARE --------------------------------------------------
	vals = self.stealth.parm.awareness["unaware"];
	vals.fovcosine				= Cos( 45 );
	vals.fovcosineZ 			= Cos( 10 );
	vals.maxSightDist			= 800;
	
	SetStealthSight( "unaware", 		4.0, 	1.0, 	5.0, 100,  800 );

	// -----------------------------------------------------------------------	
	// AI_AWARENESS_LOW_ALERT ------------------------------------------------
	vals = self.stealth.parm.awareness["low_alert"];
	vals.fovcosine				= Cos( 60 );
	vals.fovcosineZ 			= Cos( 20 );
	vals.maxSightDist			= 1000;
	
	SetStealthSight( "low_alert", 	4.0, 	0.75,  	2.0, 100, 1000 );

	// -----------------------------------------------------------------------	
	// AI_AWARENESS_HIGH_ALERT -----------------------------------------------
	vals = self.stealth.parm.awareness["high_alert"];
	vals.fovcosine				= Cos( 60 );
	vals.fovcosineZ 			= Cos( 45 );
	vals.maxSightDist			= 1000;
	
	SetStealthSight( "high_alert",	10.0, 	0.50,  	2.0, 100, 1000 );

	// -----------------------------------------------------------------------	
	// AI_AWARENESS_COMBAT ---------------------------------------------------
	vals = self.stealth.parm.awareness["combat"];
	vals.fovcosine				= 0;
	vals.fovcosineZ 			= 0;
	vals.maxSightDist			= 1500;
	
	SetStealthSight( "combat", 		20.0, 	0.01,  	0.01, 100, 1500 );
}

/@
"Name: get_parms( <strAwareness> )"
"Summary: Gets an awareness state parameters for a given level name"
"Module: stealth"
"CallOn: Actor"
"Example: parms = level stealth_level::get_parms( myawareness );"
@/
function get_parms( strAwareness )
{
	assert( isDefined( level.stealth ) );
	
	return level.stealth.parm.awareness[strAwareness];
}

/@
"Name: update_thread()"
"Summary: Runs per frame maintainance for stealth in the level"
"Module: Stealth"
"CallOn: Level"
"Example: level thread stealth_level::update_thread();"
"SPMP: singleplayer"
@/
function update_thread()
{
	assert( self stealth_level::enabled() );
	
	self endon( "stop_stealth" );
	
	while ( 1 )
	{
		self.stealth.enemies["axis"] = [];
		self.stealth.enemies["allies"] = [];
			
		playerList = GetPlayers();
		foreach ( player in playerList ) 
		{
			// Init stealth for any new players that join
			if ( !isDefined( player.stealth ) )
				player stealth::agent_init( );
		}

		self stealth_level::update_arrays();

		wait 0.25;
	}
}


/@
"Name: update_arrays()"
"Summary: Updates shared global arrays for stealth purposes"
"Module: Stealth"
"CallOn: Level"
"Example: level thread stealth_level::update_arrays();"
"SPMP: singleplayer"
@/
function update_arrays()
{
	assert( self stealth_level::enabled() );
	
	self.stealth.enemies["axis"] = [];
	self.stealth.enemies["allies"] = [];
		
	playerList = GetPlayers();
	foreach ( player in playerList ) 
	{
		if ( ( isdefined( player.ignoreme ) && player.ignoreme ) )
			continue;

		if ( player.team == "allies" )
			self.stealth.enemies["axis"][player GetEntityNumber()] = player;
	}

	alertCount = 0;
	combatCount = 0;
	
	actorList = GetAIArray();
	foreach ( actor in actorList ) 
	{
		if ( ( isdefined( actor.ignoreme ) && actor.ignoreme ) )
			continue;
		
		actorEntNum = actor GetEntityNumber();
		
		if ( actor stealth_aware::enabled() )
		{
			if ( actor stealth_aware::get_awareness() != "unaware" )
				alertCount = alertCount + 1;
			if ( actor stealth_aware::get_awareness() == "combat" )
				combatCount = combatCount + 1;
		}
		
		if ( actor.team == "allies" )
			self.stealth.enemies["axis"][actorEntNum] = actor;
		else if ( actor.team == "axis" )
			self.stealth.enemies["allies"][actorEntNum] = actor;
	}
	
	if ( alertCount > 0 )
		level flag::set( "stealth_alert" );
	else
		level flag::clear( "stealth_alert" );
	
	if ( combatCount > 0 )
		level flag::set( "stealth_combat" );
	else
		level flag::clear( "stealth_combat" );
}
