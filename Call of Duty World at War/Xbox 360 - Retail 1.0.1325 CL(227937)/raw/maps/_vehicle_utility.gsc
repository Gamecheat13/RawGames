#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;

advance_then_retreat_one_path( startPath, retreatPathName, speed, accel, damage_percent, retreatNotify )
{
	self endon( "death" );
	if( !isDefined( damage_percent ) )
		damage_percent = 0.0;
		
	self advance_then_stop( startPath, speed, accel );
	
	self thread check_for_damage_notify( damage_percent );
	
	if( isDefined( retreatNotify ) )
	{
		self waittill_either( retreatNotify, "damage reached" );
	}
	else
	{
		self waittill( "damage reached" );
	}
	
	retreatPath = GetVehicleNode( retreatPathName, "targetname" ); 
	
	//self setVehGoalPos( retreatPath.origin );
	self setSpeed( speed, accel );
	//self waittill( "goal" );
	self attachPath( retreatPath );
	self.attachedpath = retreatPath;
	self thread goPath( self );
}

advance_then_retreat_multiple_paths( path1start, path2startarray, speed, accel, damage_percent, retreatNotify )
{
	self endon( "death" );
	retreatPathNode = path2startArray[ randomint( path2startarray.size - 1 ) ];
	advance_then_retreat_one_path( path1start, retreatPathNode, speed, accel, damage_percent, retreatNotify );
}

advance_then_stop( path1start, speed, accel )
{
	self endon( "death" );
	goalNode = GetVehicleNode( path1start, "targetname" );
	self setSpeed( speed, accel );
	//self setVehGoalPos( goalNode.origin );
	
	//self waittill( "goal" );
	self attachPath( goalNode );
	self.attachedpath = goalNode;
	self thread goPath( self );
}

patrol_loop( path1start, path1end, path2start, path2end, speed, accel )
{
	self endon( "death" );
	goalnodes = [];
	goalnodes[0] = GetVehicleNode( path1start, "targetname" );
	goalnodes[1] = GetVehicleNode( path1end, "targetname" );
	goalnodes[2] = GetVehicleNode( path2start, "targetname" );
	goalnodes[3] = GetVehicleNode( path2end, "targetname" );
	
	currNode = 1;
	nextNode = 2;
	
	self setSpeed( speed, accel );
	//self setVehGoalPos( goalnodes[0].origin, 0 );
	//self waittill( "goal" );	
	//wait(0.05);
	self attachPath( goalnodes[0] );
	self.attachedpath = goalnodes[0];
	self thread goPath( self );
	while( 1 )
	{		
		wait( 0.05 );
		self setswitchnode( goalnodes[currNode], goalnodes[nextNode] ); 
		self setWaitNode( goalnodes[nextNode] );
  	self waittill( "reached_wait_node" );	
		currNode += 2;
		currNode = currNode % 4;
		nextNode += 2;
		nextNode = nextNode % 4;
	}
}

patrol_loop_then_retreat( path1start, path1end, path2start, path2end, startretreatnode, retreatpathnode, speed, accel, damage_percent, retreatNotify )
{
	self endon( "death" );
	if( !isDefined( damage_percent ) )
		damage_percent = 0.0;
	
	reachNode = GetVehicleNode( startretreatnode, "targetname" );
	switchNode = GetVehicleNode( retreatpathnode, "targetname" );
	
	self thread patrol_loop( path1start, path1end, path2start, path2end, speed, accel );
	self thread check_for_damage_notify( damage_percent );
	
	if( isDefined( retreatNotify ) )
	{
		self waittill_either( "damage reached", retreatNotify );
	}
	else
	{
		self waittill( "damage reached" );
	}
	
	self thread switch_path_when_node_reached( reachNode, switchNode, speed, accel );
}

switch_path_when_node_reached( reachNode, switchNode, speed, accel )
{
	self endon( "death" );
	distanceSq = 25.0 * 25.0;
	
	goal_pos = reachNode.origin;
	while( 1 )
	{
		if( distanceSquared( self.origin, goal_pos ) < distanceSq )
		{
			self setSpeed( speed, accel );
			self SetVehGoalPos( goal_pos );
			self waittill( "goal" );
			break;
		}
	}
	self SetVehGoalPos( switchNode.origin );
	self waittill( "goal" );
	self attachPath( switchNode );
	self.attachedPath = switchNode;
}

check_for_damage_notify( damage_percent )
{
	self endon( "death" );
	while( 1 )
	{
		if( (self.health / self.maxhealth) <= damage_percent )
		{
			self notify( "damage reached" );
			return;
		}
		wait( 0.05 );
	}
}