#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\stealth_aware;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
	            

#namespace stealth_behavior;

/*
	STEALTH - Behavior implementations
*/

/@
"Name: on_investigate( <eventPackage> )"
"Summary: handles investigation event"
"Module: Stealth"
"CallOn: Entity or Struct"
"SPMP: singleplayer"
@/
function on_investigate( eventPackage )
{
	if ( !isActor( self ) || !isAlive( self ) )
		return;
	
	v_origin = eventPackage.parms[0];
	e_originator = eventPackage.parms[1];	
	
	if ( isDefined( v_origin ) )
		self thread stealth_behavior::investigate_thread( v_origin, e_originator );
}

/@
"Name: get_random_investigation_point( <v_origin>, <desiredRadius>, <previousResult> )"
"Summary: Finds a random point to go to near the origin"
"Module: stealth"
"CallOn: Actor"
"Example: point = stealth_behavior::get_random_investigation_point( heardNoiseOrigin, 200 );"
@/
function get_random_investigation_point( v_origin, desiredRadius, previousResult )
{
	nearestPoint = undefined;
	goalPoint = undefined;
	searchRadius = desiredRadius;
	itterations = 0;
	
	// First find the closest possible nav mesh point
	while ( !isDefined( nearestPoint ) && itterations < 4 )
	{
		itterations++;
		searchRadius = searchRadius * 2;
		nearestPoint = GetClosestPointOnNavMesh( v_origin, searchRadius, 30 );
	}
	
	if ( isDefined( nearestPoint ) )
	{
		// Get a set of random points within desiredRadius or larger if need be
		distSq = DistanceSquared( nearestPoint, v_origin );
		if ( distSq > ( desiredRadius * desiredRadius ) )
			desiredRadius = searchRadius * 0.75;		
		pointList = GetNavPointsInRadius( v_origin, 0, desiredRadius, 64, 50 );
		
		// Choose a point randomly from the list but ignore any that are further away from the point of interest than I already am
		valid = 0.0;
		myDistSq = DistanceSquared( self.origin, v_origin );
		foreach ( point in pointList )
		{
			distSq = DistanceSquared( point, v_origin );
			if ( distSq > myDistSq )
				continue;
			
			valid = valid + 1.0;
			chance = 1.0 / valid;
			if ( randomfloat( 1.0 ) <= chance )
				goalPoint = point;
		}
	}
	
	return goalPoint;
}

/@
"Name: investigate_stop( <v_origin>, <e_originator> )"
"Summary: Terminates any active investigation"
"Module: stealth"
"CallOn: Actor"
"Example: self thread stealth_behavior::investigate_stop();"
@/
function investigate_stop()
{
	self.stealth.investigating = undefined;
	self notify( "investigate_stop" );
}

/@
"Name: investigate_thread( <v_origin>, <e_originator> )"
"Summary: Has ai go and investigate a location"
"Module: stealth"
"CallOn: Actor"
"Example: self thread stealth_behavior::investigate_thread( heardNoiseOrigin );"
@/
function investigate_thread( v_origin, e_originator )
{
	self notify( "investigate_thread" );
	self endon( "investigate_thread" );

	self endon("death");
	self endon("stop_stealth");
	self endon("investigate_stop");
	
	self stopanimscripted();
	
	self.stealth.investigating = true;
	
	/*
	if ( isDefined( v_origin ) )
		self LookAtPos( v_origin );
	if ( isDefined( e_originator ) )
		self LookAtEntity( e_originator );
	*/
	
	nearestNode = undefined;	
	goalRadius = 128;

	// Default AI_AWARENESS_LOW_ALERT
	investigations = 1;
	minTime = 4;
	maxTime = 8;
	fallbackWait = RandomFloatRange( 15, 20 );
	
	self notify( "stealth_vo", "alert" );

	// Stop patrolling when we begin investigating
	if ( self ai::has_behavior_attribute( "patrol" ) && self ai::get_behavior_attribute( "patrol" ) )
		self ai::end_and_clean_patrol_behaviors();
	
	if ( self stealth_aware::get_awareness() == "high_alert" )
	{
		// AI_AWARENESS_HIGH_ALERT
		
		// Spend less time at more points
		investigations = 3;
		minTime = 2;
		maxTime = 4;
	}
	
	result = "";
	
	while ( investigations > 0 && isDefined( v_origin ) )
	{
		// Find a point to go to near the point of interest
		investigatePoint = get_random_investigation_point( v_origin, 256, result );
	
		if ( isDefined( investigatePoint ) )
		{	
			/# self.stealth.debug_msg = undefined; #/
			self setgoalpos( investigatePoint, true, goalRadius );
			result = self util::waittill_any_timeout( fallbackWait, "goal", "near_goal", "bad_path" );
			if ( result == "bad_path" )
			{
				// couldnt get there, wait a while and continue
				wait fallbackwait; 
			}
			else
			{
				// wait till done with idle anim then continue
				if ( investigations == 1 )
					self.stealth_resume_after_idle = true;
				self waittill( "stealthIdleTerminate" ); 
			}
		}
		else
		{
			/# self.stealth.debug_msg = "(no investigate point found)"; #/
			self lookatpos( v_origin );
			wait fallbackWait;
		}
		
		investigations = investigations - 1;
	}
			
	if ( !isDefined( v_origin ) ) 
	{
		// We were unable to actually go and investigate anything
		// Just insert a delay before returning to unaware
		wait RandomFloatRange( minTime, maxTime );
	}
	
	self stealth_aware::set_awareness( "unaware" );

	self notify( "stealth_vo", "resume" );
	
	// MUST BE LAST LINE IN THE FUNCTION (terminates via endon)
	self stealth_behavior::investigate_stop();
}

