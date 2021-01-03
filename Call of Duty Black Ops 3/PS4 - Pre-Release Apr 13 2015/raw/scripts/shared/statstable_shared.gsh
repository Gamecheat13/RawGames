#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\array_shared;
#using scripts\shared\stealth_level;
#using scripts\shared\stealth_actor;
#using scripts\shared\stealth_player;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_vehicle;
#using scripts\shared\stealth_interact;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
	            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace stealth;

function autoexec __init__sytem__() {     system::register("stealth",&stealth::__init__,undefined,undefined);    }

/*
	STEALTH SYSTEM
 	--------------
	
		stealth.gsc:			Stealth System Utilities
		stealth.gsh: 			Stealth System Constants
		stealth_actor.gsc:		Script to manage the state and setup of an Actor
		stealth_aware.gsc: 		Manages an agent's awareness state. 
		stealth_behavior.gsc: 	Handles specific behavior like investigating points of interest
		stealth_client.csc: 	Client side player stealth management
		stealth_event.gsc: 		Stealth event management
		stealth_interact.gsc: 	World interaction and distraction features
		stealth_player.gsc: 	Handles stealth state and setup for players
 		stealth_status.gsc:		Manages feedback about status of stealth agents
 		stealth_tagging.gsc:	Manages tagging(marking) enemies for all to see
 		stealth_vo.gsc:			Voice Over event handling and setup
 		
		stealth_debug.gsc: 		Manages drawing debug info about state of stealth
 		
 	TODO
 	--------------	
 	- SYSTEM
 		- add global level flag that level script can wait on for when it gets set and cleared for any AI alerted or in combat or not
 		- Require “script_stealth” key value pair on a spawner for guys that come in stealth mode
 		
 	- VO
		- conversation system
 			- Support for concept of conversation between two parties that only happens if both parties are present
 			- Register converstations
 			
 	- BUGS: 
 		- when unable to path your position (say on a roof) they fail to path anywhere (should path to somewhere as close as they can)

 	- Look into how best to have guys doing an activity at patrol stop points

 	- Shadow volumes
 	
 	- Foliage clip handling
		- do we need to make foliage volumes apply an automatic cost to pathing so AI avoid it unless specifically going in there?
 
 	- more melee kill animations
 	
 	- Pending Animation list
 	
		- Anims needing integration
			
			= corpse react - will need directional ones first =
			ai_patrol_54i_white_walk_react_corpse
			ai_patrol_54i_white_idle_react_corpse
			
			= corpse investigate - will need to be a scene? =
			ai_patrol_54i_orange_walk_to_search_corpse
					
	- Handle animation removal for any archtypes other than 
		enemy_54i_human_assault_ar & enemy_54i _human_sniper_sniperrifle

 	- CUT: 
		- Clean out old client side sighting display system
 */
	
function __init__()
{	
	stealth::init_client_field_callback_funcs();

	/# stealth_debug::init(); #/
}

/@
"Name: init_client_field_callback_funcs()"
"Summary: Initializes client fields and callback funcs"
"Module: Stealth"
"Example: stealth::init_client_field_callback_funcs();"
"SPMP: singleplayer"
@/
function init_client_field_callback_funcs()
{
	// clientfield setup
	clientfield::register( "toplayer", "stealth_sighting", 1, 2, "int" );
	clientfield::register( "toplayer", "stealth_alerted", 1, 1, "int" );

	// FIXME : Prototype directional indicators
	clientfield::register( "toplayer", "stealth_sight_ent_01", 1, 7, "int" );
	clientfield::register( "toplayer", "stealth_sight_ent_02", 1, 7, "int" );
	clientfield::register( "toplayer", "stealth_sight_ent_03", 1, 7, "int" );
	clientfield::register( "toplayer", "stealth_sight_ent_04", 1, 7, "int" );
	
	// FIXME : Prototype directional indicators
	clientfield::register( "toplayer", "stealth_sight_lvl_01", 1, 7, "int" );
	clientfield::register( "toplayer", "stealth_sight_lvl_02", 1, 7, "int" );
	clientfield::register( "toplayer", "stealth_sight_lvl_03", 1, 7, "int" );
	clientfield::register( "toplayer", "stealth_sight_lvl_04", 1, 7, "int" );
}

/@
"Name: init()"
"Summary: Initializes and starts up stealth system for a level
"Module: Stealth"
"CallOn: AI or Player Entity or Level object"
"Example: level stealth::init();"
"SPMP: singleplayer"
@/
function init( )
{
	level stealth::agent_init();
	
	thread stealth_interact::melee_setup();
}

/@
"Name: stop()"
"Summary: Terminates stealth system on given object
"Module: Stealth"
"CallOn: AI or Player Entity or Level object"
"Example: enemy stealth::stop();"
"SPMP: singleplayer"
@/
function stop( )
{
	assert( isDefined( self ) );
	
	if ( !IsDefined( self.stealth ) )
		return;

	self notify( "stop_stealth" );
	
	if ( isDefined( self.stealth.agents ) )
	{
		foreach( agent in self.stealth.agents )
		{
			if ( !isDefined( agent ) ) 
				continue;
			
			if ( agent == self ) 
				continue;

			agent stealth::agent_stop();
		}
	}

	self stealth::agent_stop();

	self.stealth = undefined;
}

/@
"Name: register_agent()"
"Summary: Keeps track of stealth agents in an array for later processing
"Module: Stealth"
"Example: stealth::register_agent( object );"
"SPMP: singleplayer"
@/
function register_agent( object )
{
	if ( isDefined( level.stealth ) )
	{
		if ( !isDefined( level.stealth.agents ) )
			level.stealth.agents = [];
	
		for ( i = 0; ; i++ )
		{
			if ( !isDefined( level.stealth.agents[i] ) )
			{
				level.stealth.agents[i] = object;
				return;
			}
		}
	}
}

/@
"Name: agent_init()"
"Summary: Initializes an object for stealth (can be vehicle, player, actor, level)"
"Module: Stealth"
"CallOn: Entity"
"Example: self stealth::agent_init();"
"SPMP: singleplayer"
@/
function agent_init( )
{
	object = self;
	
	if ( !isDefined( object ) || isDefined( object.stealth ) )
		return false;

	if ( isPlayer( object ) )
		object stealth_player::init();
	else if ( isActor( object ) )
		object stealth_actor::init();
	else if ( isVehicle( object ) )
		object stealth_vehicle::init();
	else if ( object == level )
		object stealth_level::init();

	stealth::register_agent( object );
}

/@
"Name: agent_stop()"
"Summary: Cleans up an object after stealth (can be vehicle, player, actor, level)"
"Module: Stealth"
"CallOn: Entity"
"Example: self stealth::agent_stop();"
"SPMP: singleplayer"
@/
function agent_stop( )
{
	object = self;
	
	if ( !isDefined( object ) )
		return false;
	
	if ( isPlayer( object ) )
		return object stealth_player::stop();
	
	if ( isActor( object ) )
		return object stealth_actor::stop();
	
	if ( isVehicle( object ) )
		return object stealth_vehicle::stop();

	if ( object == level )
		return object stealth_level::stop();

	return false;
}

/@
"Name: is_enemy( <entity> )"
"Summary: Returns true if other entity is enemy of self"
"Module: Stealth"
"CallOn: Entity"
"Example: if ( ai stealth::is_enemy( entity ) )"
"SPMP: singleplayer"
@/
function is_enemy( entity )
{
	if ( !isDefined( entity ) )
		return false;
	
	if ( !isDefined( entity.team ) )
		return false;
	
	return entity.team != self.team;
}

/@
"Name: enemy_team()"
"Summary: Gets the enemy team for a given unit"
"Module: Stealth"
"CallOn: Entity"
"Example: enemy stealth::enemy_team();"
"SPMP: singleplayer"
@/
function enemy_team( )
{
	assert( isDefined( self.team ) );
	
	switch ( self.team ) 
	{
		case "allies":
			return "axis";
		case "axis":
			return "allies";
	}
	
	return "allies";
}

/@
"Name: can_see( <entity> )"
"Summary: Returns true if this entity can see another entity"
"Module: Stealth"
"CallOn: Entity"
"Example: if ( ai stealth::can_see( entity ) )"
"SPMP: singleplayer"
@/
function can_see( entity )
{
	if ( isActor( self ) )
		return self CanSee( entity );
	else
		return SightTracePassed( self.origin + (0,0,30), entity.origin + (0,0,30), false, undefined );
}

/@
"Name: awareness_delta( <str_awarenessA>, <str_awarenessB> )"
"Summary: Gets the integer difference between two awareness levels"
"Module: Stealth"
"CallOn: Entity"
"Example: diff = stealth::awareness_delta( newAwareness, oldAwareness );"
"SPMP: singleplayer"
@/
function awareness_delta( str_awarenessA, str_awarenessB )
{
	return level.stealth.awareness_index[str_awarenessA] - level.stealth.awareness_index[str_awarenessB];
}

/@
"Name: level_wait_notify()"
"Summary: Waits for an event on the level then notifies self of same event
"Module: Stealth"
"Example: self thread level_wait_notify( "skipto_init" );"
"SPMP: singleplayer"
@/
function level_wait_notify( waitFor )
{
	self notify("level_wait_notify_" + waitFor);
	self endon("level_wait_notify_" + waitFor);
	if ( isPlayer( self ) )
		self endon("disconnect");
	else
		self endon("death");
	self endon("stop_stealth");
	
	level waittill( waitFor );
	
	self notify( waitFor );
}

/@
"Name: weapon_can_be_reloaded()"
"Summary: Returns true if pressing reload will result in reloading weapon"
"Module: Stealth"
"Example: if ( player stealth::weapon_can_be_reloaded() )"
"SPMP: singleplayer"
@/
function weapon_can_be_reloaded() // self = player
{
	assert( isPlayer( self ) );
	
	w_weapon = self GetCurrentWeapon();
	i_clip = self GetWeaponAmmoClip( w_weapon );
	i_stock = self GetWeaponAmmoStock( w_weapon );
	
	return ( i_clip < w_weapon.clipSize ) && ( i_stock > 0 );
}

/@
"Name: get_closest_enemy_in_view( <maxDistance>, <fovDegrees> )"
"Summary: Gets the closest enemy in view from an ai or player"
"Module: Stealth"
"Example: enemy = self get_closest_enemy_in_view( 600, 45 );"
"SPMP: singleplayer"
@/
function get_closest_enemy_in_view( distance, fov ) // self = entity
{
	level.stealth.enemies[self.team] = array::remove_dead( level.stealth.enemies[self.team] );
	
	enemies = ArraySort( level.stealth.enemies[self.team], self.origin, 20, distance );
	
	cosFov = cos( fov );
	eyePos = self.origin;
	eyeAngles = self.angles;

	if ( isPlayer( self ) )
	{
		eyePos = self GetEye();
		eyeAngles = self GetPlayerAngles();
	}
	else if ( isActor( self ) )
	{
		eyePos = self GetTagOrigin( "TAG_EYE" );
		eyeAngles = self GetTagAngles( "TAG_EYE" );
	}
		
	foreach ( enemy in enemies )
	{
		if ( util::within_fov( eyePos, eyeAngles, enemy.origin + (0, 0, 30), cosFov ) )
			return enemy;
	}
}

/@
"Name: get_closest_player( <v_origin>, <maxDist> )"
"Summary: Gets the closest player to a point in space up to a maximum distance"
"Module: Stealth"
"Example: player = stealth::get_closest_player( aiGuy.origin, 600 );"
"SPMP: singleplayer"
@/
function get_closest_player( v_origin, maxDist )
{
	playerList = GetPlayers();
	playerList = ArraySortClosest( playerList, v_origin, 1, 0, maxDist );
	
	if ( isDefined( playerList ) && playerList.size > 0 && isAlive( playerList[0] ) )
		return playerList[0];
}


/@
"Name: awareness_color( <awareness>, <bNext> )"
"Summary: Get Color for given level of awareness"
"Module: Stealth"
"Example: color = stealth::awareness_color( self.awarenesslevelcurrent );"
"SPMP: singleplayer"
@/
function awareness_color( str_awareness, bNext )
{
	if(!isdefined(level.stealth))level.stealth=SpawnStruct();

	if ( !isdefined( level.stealth.awareness_color ) )
	{
		level.stealth.awareness_color = [];
		level.stealth.awareness_color["unaware"]			= (0.50, 0.50, 0.50);
		level.stealth.awareness_color["low_alert"]		= (1.00, 1.00, 0.00);
		level.stealth.awareness_color["high_alert"]		= (1.00, 0.50, 0.00);
		level.stealth.awareness_color["combat"]			= (1.00, 0.00, 0.00);

		level.stealth.awareness_color_next = [];
		level.stealth.awareness_color_next["unaware"]	= (1.00, 1.00, 0.00);
		level.stealth.awareness_color_next["low_alert"]	= (1.00, 0.50, 0.00);
		level.stealth.awareness_color_next["high_alert"]	= (1.00, 0.00, 0.00);
		level.stealth.awareness_color_next["combat"]		= (1.00, 0.00, 0.00);
	}
	
	if ( !isdefined( bNext ) || !bNext )
		return level.stealth.awareness_color[str_awareness];
	else
		return level.stealth.awareness_color_next[str_awareness];
}
