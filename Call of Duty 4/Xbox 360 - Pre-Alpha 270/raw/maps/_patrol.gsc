#include maps\_utility;

#using_animtree( "generic_human" );
patrol()
{
	if( isdefined( self.enemy ) )
		return;

	self endon( "death" );

	self.old_walkdist = self.walkdist;
	self.walkdist = 9999;
	self thread waittill_combat();
	assert( !isdefined( self.enemy ) );
	self endon( "enemy" );
	self.goalradius = 0;
	self allowedStances( "stand" );
	self.disableArrivals = true;

	patrolwalk[ 0 ] = %patrolwalk_bounce;
	patrolwalk[ 1 ] = %patrolwalk_tired;
	patrolwalk[ 2 ] = %patrolwalk_swagger;
	
	self.walk_noncombatanim = maps\_utility::random( patrolwalk );
	self.walk_noncombatanim2 = maps\_utility::random( patrolwalk );
	
	// NOTE add combat call back and force patroller to walk

	// true is for script_origins, false is for nodes
	get_target_func[ true ] = ::get_target_ent;
	get_target_func[ false ] = ::get_target_node;
	set_goal_func[ true ] = ::set_goal_pos;
	set_goal_func[ false ] = ::set_goal_node;
	
	targetnode = getent( self.target, "targetname" );
	
	goal_type = isdefined( targetnode );
	if( !goal_type )
	{
		targetnode = getnode( self.target, "targetname" );
		assertEx( isdefined( targetnode ), "Patroller has no target node." );
	}
	
	for( ;; )
	{
		[[ set_goal_func[ goal_type ] ]]( targetnode );
		self waittill( "goal" );

		if( isdefined( targetnode.script_animation ) )
		{
			assert( targetnode.script_animation == "pause" || targetnode.script_animation == "turn180" );

			if( targetnode.script_animation == "pause" )
				self.nodeanim = getGenericAnim( "patrolwalk_pause" );
			else if( targetnode.script_animation == "turn180" )
				self.nodeanim = getGenericAnim( "patrolwalk_turn_180" );

			self animscripted( "scripted_animdone", self.origin, self.angles, self.nodeanim );
			self waittill( "scripted_animdone" );
		}

		if( isdefined( targetnode.target ) )
			targetnode = [[ get_target_func[ goal_type ] ]]( targetnode.target );
		else
			break;
	}
}

waittill_combat()
{
	assert( !isdefined( self.enemy ) );
	self waittill( "enemy" );
	self.walkdist = self.old_walkdist;
}

get_target_ent( target )
{
	return getent( target, "targetname" );
}

get_target_node( target )
{
	return getnode( target, "targetname" );
}
