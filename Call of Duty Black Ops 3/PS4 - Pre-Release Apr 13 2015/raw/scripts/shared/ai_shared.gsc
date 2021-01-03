#using scripts\shared\util_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace ai_sniper;

function autoexec __init__sytem__() {     system::register("ai_sniper",&ai_sniper::__init__,undefined,undefined);    }

function __init__()
{	
	spawner::add_global_spawn_function( "axis", &ai_sniper::agent_init );
	
	thread init_node_scan();
}

/@
"Name: init_node_scan( [targetName] )"
"Summary: Puts an actor into a state where they target an invisible entity that travels from point to point in a loop."
"Module: AI"
"CallOn: an actor"
"Example: ai_sniper::init_node_scan();"
"OptionalArg: [targetName] : targetname of script origins or structs to check (default "ai_sniper_node_scan")
"SPMP: singleplayer"
@/
function init_node_scan( targetName )
{
	{wait(.05);};
	
	if ( !isDefined( targetName ) )
		targetName = "ai_sniper_node_scan";
	
	structList = struct::get_array( targetName, "targetname" );
	pointList =  GetEntArray( targetName, "targetname" );
	foreach ( struct in structList ) 
		pointList[pointlist.size] = struct;
	
	foreach ( point in pointList )
	{
		if ( isDefined( point.target ) )
		{
			node = getnode( point.target, "targetname" );
			if ( isDefined( node ) )
			{
				if ( !isDefined( node.lase_points ) )
					node.lase_points = [];
				node.lase_points[node.lase_points.size] = point;
			}
		}
	}
}


/@
"Name: agent_init( )"
"Summary: Initializes an actor on spawn for support of ai_sniper behavior."
"Module: AI"
"CallOn: an actor"
"SPMP: singleplayer"
@/
function agent_init( )
{
	self thread ai_sniper::patrol_lase_goal_waiter();
}


function patrol_lase_goal_waiter()
{
	self endon("death");
	
	while ( 1 )
	{
		was_stealth = false;
		
		self waittill ("patrol_goal", node );
		
		if ( isDefined( node ) && isDefined( node.lase_points ) )
		{
			// FIXME: needs better transitions and polish
			
			if ( self ai::has_behavior_attribute( "stealth" ) )
			{
				was_stealth = self ai::get_behavior_attribute( "stealth" );
				self ai::set_behavior_attribute( "stealth", false );
			}
			
			self ai::end_and_clean_patrol_behaviors();
	
			self thread actor_lase_points_behavior( node.lase_points );
			
			self waittill( "lase_points_loop" );
			
			self notify("lase_points");
			self LaserOff();			
			self ai::stop_shoot_at_target();

			if ( isDefined( self.currentgoal ) )
			{
				self ai::patrol_next_node();
				if ( isDefined( self.currentgoal ) )
					self thread ai::patrol( self.currentgoal );
			}

			if ( was_stealth && self ai::has_behavior_attribute( "stealth" ) )
				self ai::set_behavior_attribute( "stealth", self.awarenesslevelcurrent != "combat" );
		}
	}
}

/@
"Name: actor_lase_points_behavior( <entity_or_point_array> )"
"Summary: Puts an actor into a state where they target an invisible entity that travels from point to point in a loop."
"Module: AI"
"CallOn: an actor"
"Example: guy thread actor_lase_points_behavior( sniper_target_points );"
"MandatoryArg: <point_array> : series of vector points or entities to lase"
"SPMP: singleplayer"
@/
function actor_lase_points_behavior( entity_or_point_array )
{
	self notify("lase_points");
	self endon("lase_points");
	self endon("death");
	
	// dont actually pull the trigger
	self.holdfire = true;		
	
	// aim at target even when visually obstructed
	self.blindaim = true;

	// dont relocate just stay put
	self.goalradius = 8;
	
	if ( !isDefined( self.lase_ent ) )
	{
		self.lase_ent = Spawn( "script_model", lase_point( entity_or_point_array[0] ) );
		self.lase_ent SetModel("tag_origin");
		self thread util::delete_on_death( self.lase_ent );
	}
	
	// so shoot_at_target doesnt think its dead and stop
	if ( self.lase_ent.health <= 0 )
		self.lase_ent.health = 1; 	
	self thread ai::shoot_at_target( "shoot_until_target_dead", self.lase_ent );

	self.lase_ent thread target_lase_points( entity_or_point_array, self );
	self.lase_ent thread target_lase_points_player_track( self GetEye(), entity_or_point_array, self );
	
	self thread actor_lase_force_laser_on();
}

function actor_lase_force_laser_on()
{
	self endon("death");
	self endon("lase_points");

	while ( 1 )
	{
		// Turn on laser all the time even if it is turned off elsewhere through normal logic
		self LaserOn();
		
		{wait(.05);};
	}
}

function lase_point( entity_or_point )
{
	result = entity_or_point;
	
	if ( !isVec( entity_or_point ) && isDefined( entity_or_point.origin ) )
	{
		result = entity_or_point.origin;
		
		if ( isPlayer( entity_or_point ) || isActor( entity_or_point ) )
			result = entity_or_point GetEye(); // TagOrigin( "j_spinelower" );
	}
	
	return result;
}

/@
"Name: target_lase_points_player_track( v_eye, entity_or_point_array, [a_owner] )"
"Summary: Interrupts normal point lasing behavior to track a particular player when they come near and are in view."
"Module: AI"
"CallOn: an entity"
"Example: guy.targetEnt thread actor_lase_points_player_track();"
"SPMP: singleplayer"
@/
function target_lase_points_player_track( v_eye, entity_or_point_array, a_owner )
{
	self notify("actor_lase_points_player_track");
	self endon("actor_lase_points_player_track");
	
	self endon("death");
	          
	while ( 1 ) 
	{
		playerList = GetPlayers();

		foreach ( player in playerList )
		{
			if ( DistanceSquared( player.origin, self.origin ) < 300 * 300 )
			{
				if ( SightTracePassed( v_eye, lase_point( player ), false, undefined ) )
				{
					if ( isActor( a_owner ) )
						a_owner.holdfire = false;
					self target_lase_override( v_eye, player, 7 );
					if ( isActor( a_owner ) )
						a_owner.holdfire = true;
				}
			}			
		}
		
		{wait(.05);};
	}
}

/@
"Name: target_lase_points( <entity_or_point_array>, [e_owner] )"
"Summary: Puts an targeting entity into a state where it travels from point to point pausing at each."
"Module: AI"
"CallOn: an entity"
"Example: guy.targetEnt thread target_lase_points( entity_or_point_array );"
"MandatoryArg: <point_array> : series of vector points or entities to lase"
"OptionalArg: <e_owner> : for notification when finished with each loop"
"SPMP: singleplayer"
@/
function target_lase_points( entity_or_point_array, e_owner )
{
	self notify("lase_points");
	self endon("lase_points");
	self endon("death");
	
	// Constants - turn into parameters?
	pauseTime = 3.5;

	if ( entity_or_point_array.size <= 0 )
		return;

	index = 0;

	while ( entity_or_point_array.size )
	{	
		while ( ( isdefined( self.lase_override ) && self.lase_override ) )
		{
			{wait(.05);};
			continue;
		}
		
		self target_lase_transition( entity_or_point_array[index] );
				
		wait( pauseTime );

		index = index + 1;
		if ( index >= entity_or_point_array.size )
		{
			index = 0;
			self notify("lase_points_loop");
			if ( isDefined( e_owner ) )
				e_owner notify("lase_points_loop");				
		}
	}
}

/@
"Name: target_lase_transition( <entity_or_point>, [sight_timeout]  )"
"Summary: Moves the lase target from where it is to a destination point or entity."
"Module: AI"
"CallOn: an entity"
"Example: guy.targetEnt thread target_lase_transition( point );"
"MandatoryArg: <entity_or_point> : new destination"
"OptionalArg: <sight_timeout> : after this many seconds without line of sight to the ent/point, terminate the thread"
"SPMP: singleplayer"
@/
function target_lase_transition( entity_or_point, sight_timeout )
{
	self notify("target_lase_transition");
	self endon("target_lase_transition");
	self endon("death");	
		
	while ( 1 ) 
	{
		moving = isEntity( entity_or_point );		
		point = lase_point( entity_or_point );
		
		delta = point - self.origin;
		delta = delta * 0.1;
		self.origin += delta;

		// /# DebugStar( self.origin, 1, (1, 0, 0) ); #/
		
		if ( !moving && DistanceSquared( self.origin, point ) < 10 )
			return;
		
		{wait(.05);};
	}
}

/@
"Name: target_lase_override( <v_eye>, <entity_or_point>, [sight_timeout] )"
"Summary: Puts targeting entity to lock onto a given entiry or point pausing any target_lase_points() sequence."
"Module: AI"
"CallOn: an entity"
"Example: guy.targetEnt thread target_lase_override( player2, 8.0 );"
"MandatoryArg: <v_eye> : the eye point to check for line of sight"	
"MandatoryArg: <entity_or_point> : an entity to track or a point to track"
"OptionalArg: <sight_timeout> : after this many seconds without line of sight to the ent/point, terminate the thread"
"SPMP: singleplayer"
@/
function target_lase_override( v_eye, entity_or_point, sight_timeout )
{
	self notify("target_lase_override");
	self endon("target_lase_override");
	self endon("death");
	
	self.lase_override = true;
	
	self thread target_lase_transition( entity_or_point, sight_timeout );
	
	outOfSightTime = 0.0;
	
	while ( 1 )
	{
		if ( !isDefined( entity_or_point ) || outOfSightTime >= sight_timeout )
		{
			self notify("target_lase_transition");
			break;
		}			

		if ( !SightTracePassed( v_eye, lase_point( entity_or_point ), false, undefined ) )
			outOfSightTime += .05;
		else
			outOfSightTime = 0.0;
		
		{wait(.05);};
	}
	
	self.lase_override = undefined;
}
