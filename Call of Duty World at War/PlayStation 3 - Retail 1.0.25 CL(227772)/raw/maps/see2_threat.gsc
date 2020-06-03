#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;
#include maps\_vehicle_utility;

/////////////////////////////////
// FUNCTION: create_see2_threat_group
// CALLED ON: level
// PURPOSE: Creates a threat bias group that can be used to calculate threat bias for vehicles
// ADDITIONS NEEDED: None
/////////////////////////////////
create_see2_threat_group( group )
{
	if( !isDefined( level.see2_threat_groups ) )
	{
		level.see2_threat_groups = [];
		level.see2_threat = [];
	}
	if( !array_check_for_dupes( level.see2_threat_groups, group ) )
	{
		for( i = 0; i < level.see2_threat_groups; i++ )
		{
			level.see2_threat[i] = array_add( level.see2_threat[i], 0 );
		}
		level.see2_threat_groups = array_add( level.see2_threat_groups, group );
		empty_array = [];
		level.see2_threat = array_add( level.see2_threat, empty_array );
		for( i = 0; i < level.see2_threat_groups; i++ )
		{
			level.see2_threat[ level.see2_threat.size-1 ] = 0;
		}
	}
}

/////////////////////////////////
// FUNCTION: set_see2_threat_bias
// CALLED ON: level
// PURPOSE: Sets the threat of one group against another
// ADDITIONS NEEDED: None
/////////////////////////////////
set_see2_threat_bias( againstGroup, group, threatval )
{
	group1index = -1;
	group2index = -1;
	
	for( i = 0; i < level.see2_threat_groups; i++ )
	{
		if( level.see2_threat_groups[i] == againstGroup )
		{
			group1index = i;
		}
		if( level.see2_threat_groups[i] == group )
		{
			group2index = i;
		}
	}
	if( group1index < 0 )
	{
		create_see2_threat_group( againstGroup );
		group1index = level.see2_threat_groups.size - 1;
	}
	if( group2index < 0 )
	{
		create_see2_threat_group( group );
		group2index = level.see2_threat_groups.size - 1;
	}
	level.see2_threat[ group1index ][ group2index ] = threatval;
}

/////////////////////////////////
// FUNCTION: set_ent_see2_bias_group
// CALLED ON: an entity
// PURPOSE: Adds an entity to a threat bias group
// ADDITIONS NEEDED: None
/////////////////////////////////
set_ent_see2_bias_group( group )
{
	if( !array_check_for_dupes( level.see2_threat_groups, group ) )
	{
		create_see2_threat_group( group );
	}
	self.my_group = group;
}

/////////////////////////////////
// FUNCTION: get_threat
// CALLED ON: level
// PURPOSE: Gets the threat for one entity against another
// ADDITIONS NEEDED: None
/////////////////////////////////
get_threat( againstEnt, ent )
{
	ASSERTEX( isDefined( ent.my_group ), "Cannot get threat, entity "+ent.classname+" has no threat group" );
	ASSERTEX( isDefined( againstEnt.my_group ), "Cannot get threat, entity "+againstEnt.classname+" has no threat group" );
	threat = get_group_threat(  againstEnt.my_group, ent.my_group );
	threat += get_distance_threat( distanceSquared( ent.origin, againstEnt.origin ) );
	threat += get_curr_target_threat( ent, againstEnt );	
}

/////////////////////////////////
// FUNCTION: get_group_threat
// CALLED ON: level
// PURPOSE: gets the threat value of one group against another
// ADDITIONS NEEDED: None
/////////////////////////////////
get_group_threat( againstGroup, group )
{
	group1index = -1;
	group2index = -1;
	
	for( i = 0; i < level.see2_threat_groups.size; i++ )
	{
		if( level.see2_threat_groups[i] == againstGroup )
		{
			group1index = i;
		}
		if( level.see2_threat_groups[i] == group )
		{
			group2index = i;
		}
	}
	if( group1index < 0 || group2index < 0 )
	{
		return "ignore";
	}
	else
	{
		return level.see2_threat[group1index][group2index];
	}
}

/////////////////////////////////
// FUNCTION: get_distance_threat
// CALLED ON: level
// PURPOSE: gets the threat added by the distance to target
// ADDITIONS NEEDED: None
/////////////////////////////////
get_distance_threat( distanceSq )
{
	if( !isDefined( level.see2_max_dist ) )
	{
		level.see2_max_dist = 2500;
	}
	if( !isDefined( level.see2_max_dist_threat ) )
	{
		level.see2_max_dist_threat = 5000;
	}
	
	max_dist = (level.see2_max_dist * level.see2_max_dist);
	
	if( distanceSq > max_dist )
	{
		return 0;
	}
	
	return (distanceSq/max_dist);
}

/////////////////////////////////
// FUNCTION: get_curr_target_threat
// CALLED ON: level
// PURPOSE: Returns the threat value for being the current target of an entity
// ADDITIONS NEEDED: Make sure curr_target is used by the vehicle targeting script
/////////////////////////////////
get_curr_target_threat( ent, againstEnt )
{
	if( isDefined( ent.curr_target ) && ent.curr_target == againstEnt )
	{
		return 300;
	}
	return 0;
}