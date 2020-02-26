#include common_scripts\utility;
#include maps\mp\_utility;

#insert raw\maps\mp\bots\_bot.gsh;

#define KILL_CONFIRMED_RADIUS_AWARE 200
#define KILL_CONFIRMED_CONE_AWARE 1200

bot_conf_think()
{
	if ( !IsDefined( level.bot_fov ) )
	{
		fov = GetDvarFloat( "bot_Fov" );
		level.bot_fov = Cos( fov );
	}

	goal = self GetGoal( "conf_dogtag" );

	if ( IsDefined( goal ) )
	{
		if ( !conf_tag_in_radius( goal, 64 ) )
		{
			self CancelGoal( "conf_dogtag" );
		}
	}

	conf_get_tag_in_sight();
}

conf_get_tag_in_sight()
{
	angles = self GetPlayerAngles();
	forward = AnglesToForward( angles );
	forward = VectorNormalize( forward );

	closest = 999999;

	foreach( tag in level.dogtags )
	{
		distSq = DistanceSquared( tag.curOrigin, self.origin );
		
		if ( distSq > closest )
		{
			continue;
		}
		
		delta = tag.curOrigin - self.origin;
		delta = VectorNormalize( delta );

		dot = VectorDot( forward, delta );

		if ( dot < level.bot_fov && distSq > KILL_CONFIRMED_RADIUS_AWARE * KILL_CONFIRMED_RADIUS_AWARE )
		{
			continue;
		}
		
		if ( dot > level.bot_fov && distSq > KILL_CONFIRMED_CONE_AWARE * KILL_CONFIRMED_CONE_AWARE )
		{
			continue;
		}

		closest = distSq;
		closeTag = tag;
	}

	if( isdefined( closeTag ) )
	{
		self AddGoal( closeTag.curOrigin, 16, PRIORITY_HIGH, "conf_dogtag" );
	}
	
}

conf_tag_in_radius( origin, radius )
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