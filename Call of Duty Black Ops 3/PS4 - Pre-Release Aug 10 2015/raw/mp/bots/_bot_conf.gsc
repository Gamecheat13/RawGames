#using scripts\codescripts\struct;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

                                               	               	               	                	                                                               



	
#namespace bot_conf;

function conf_think()
{
	time = GetTime();

	if ( time < self.bot.update_objective )
	{
		return;
	}

	self.bot.update_objective = time + RandomIntRange( 500, 1500 );

	goal = self GetGoal( "conf_dogtag" );

	if ( isdefined( goal ) )
	{
		if ( !conf_tag_in_radius( goal, 64 ) )
		{
			self CancelGoal( "conf_dogtag" );
		}
	}

	conf_get_tag_in_sight();
}

function conf_get_tag_in_sight()
{
	angles = self GetPlayerAngles();
	forward = AnglesToForward( angles );
	forward = VectorNormalize( forward );

	closest = 999999;

	foreach( tag in level.dogtags )
	{
		if ( ( isdefined( tag.unreachable ) && tag.unreachable ) )
		{
			continue;
		}
		
		distSq = DistanceSquared( tag.curOrigin, self.origin );
		
		if ( distSq > closest )
		{
			continue;
		}
		
		delta = tag.curOrigin - self.origin;
		delta = VectorNormalize( delta );

		dot = VectorDot( forward, delta );

		if ( dot < self.bot.fov && distSq > 200 * 200 )
		{
			continue;
		}
		
		if ( dot > self.bot.fov && distSq > 1200 * 1200 )
		{
			continue;
		}

		nearest = GetNearestNode( tag.curOrigin );

		if ( !isdefined( nearest ) )
		{
			tag.unreachable = true;
			continue;
		}

		if ( tag.curOrigin[2] - nearest.origin[2] > 18 )
		{
			tag.unreachable = true;
			continue;
		}

		if ( !isdefined( tag.unreachable ) && !self FindPath( self.origin, tag.curOrigin, false, true ) )
		{
			tag.unreachable = true;
		}
		else
		{
			tag.unreachable = false;
		}

		closest = distSq;
		closeTag = tag;
	}

	if( isdefined( closeTag ) )
	{
		self AddGoal( closeTag.curOrigin, 16, 3, "conf_dogtag" );
	}
	
}

function conf_tag_in_radius( origin, radius )
{
	foreach( tag in level.dogtags )
	{
		if ( DistanceSquared( origin, tag.curOrigin ) < radius * radius )
		{
			return true;
		}
	}

	return false;
}