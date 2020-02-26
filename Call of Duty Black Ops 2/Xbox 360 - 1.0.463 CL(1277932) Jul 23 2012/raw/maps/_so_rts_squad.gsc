#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#insert raw\maps\_utility.gsh;

#insert raw\maps\_so_rts.gsh;



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
// SQUAD RELATED 


#define ICON_SIZE_SELECTED		8
#define ICON_SIZE_HIGHLIGHTED	6
#define ICON_SELECTED_COLOR		(0.6,0.3,0.3)
#define ICON_HIGHLIGHTED_COLOR	(0.1,0.6,0.1)
#define ICON_SELECTED_ALPHA		0.8
#define ICON_HIGHLIGHTED_ALPHA	0.3

#define PATROL_WAIT_MIN			20
#define PATROL_WAIT_MAX			40




init()
{
	level.rts.squads				= [];
	level.rts.nextSquadID = 0;
	level.rts.selectedUnits = [];
	
	level thread squadThink();


	//what pkgs are available....
	packages_avail = maps\_so_rts_catalog::package_generateAvailable( "allies", true );
	center = level.rts.player.origin;
	if(isDefined(level.rts.allied_base) && isDefined(level.rts.allied_base.entity))
		center = level.rts.allied_base.entity.origin;
	if (isDefined(level.rts.allied_center))
		center = level.rts.allied_center.origin;
		
	for(i=0;i<packages_avail.size;i++)
	{
		if (packages_avail[i].delivery == "CODE")
			continue;
	
		maps\_so_rts_squad::createSquad(center,"allies",packages_avail[i]);
	}
	

	//what pkgs are available....
	center = undefined;
	packages_avail = maps\_so_rts_catalog::package_generateAvailable( "axis",true );
	if(isDefined(level.rts.enemy_base) && isDefined(level.rts.enemy_base.entity))
		center = level.rts.enemy_base.entity.origin;
	if(isDefined(level.rts.enemy_center))
		center = level.rts.enemy_center.origin;
		
	assert(isDefined(center),"Enemy center not defined");
	for(i=0;i<packages_avail.size;i++)
	{
		if (packages_avail[i].delivery == "CODE")
			continue;
		maps\_so_rts_squad::createSquad(center,"axis",packages_avail[i]);
	}
}


///////////////////////////////////////////////////////////////////////////////////////
rallySquadToLoc(spot,id)
{
	OrderSquadDefend(spot,id);	
	maps\_so_rts_event::trigger_event("squad_move_fps");
	maps\_so_rts_event::trigger_event("move_"+level.rts.squads[id].pkg_ref.ref);
}

///////////////////////////////////////////////////////////////////////////////////////

rts_move_squadsTocursor(squadID)
{
	direction 		= level.rts.player GetPlayerAngles();
	direction_vec 	= AnglesToForward( direction );
	eye 			= level.rts.player.origin + (0,0,60);
	trace 			= BulletTrace( eye, eye + VectorScale( direction_vec, 100000 ), true, level.rts.player );
	tracePoint 		= trace["position"];
	/#
	thread maps\_so_rts_support::debug_sphere( tracePoint, 10, (0,0,1), 0.6, 3 );
	#/
	nodes = GetNodesInRadiusSorted( tracePoint, 512, 0, 128);


	if (nodes.size == 0 )
	{
		level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_UNIT_CANT_MOVE_THERE");
		/#
			println("SQUAD: No Nodes located");
			thread maps\_so_rts_support::debug_circle( tracePoint, 512, (1,0,0), 3000 );
		#/
		return;
	}
	if ( !isDefined(squadID) )
	{
		if (isDefined(level.rts.player.ally) )
		{
			squadID = level.rts.player.ally.squadID;
		}
		else
		{
			return;
		}
	}

	i = 0;
	while ( i < nodes.size  )
	{
		if (FindPath( tracePoint, nodes[i].origin ))
	    {
			rallySquadToLoc(tracePoint,squadID);	
			return;
	    }
	    i++;
	}
	level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_UNIT_CANT_MOVE_THERE");
	/#
		println("SQUAD: No path to node located  (nodes tested="+nodes.size+")");
	#/
}


///////////////////////////////////////////////////////////////////////////////////////
getNextValidSquad(curSquad,direction)
{
	validSquads = [];
	
	if (!isDefined(curSquad) )
	{
		curSquad = 0;
	}
	else
	{
		if (curSquad<0)
			curSquad = level.rts.squads.size-1;
		if (curSquad > level.rts.squads.size-1 )
			curSquad = 0;
	}
	
	maps\_so_rts_squad::removeDeadFromSquad(curSquad);
	if (!isDefined(direction) )
	{
		direction = 1;
	}
	assert(direction==1||direction==-1);
	
	for(i=0;i<level.rts.squads.size;i++)
	{
		if ( level.rts.squads[i].team == "allies" && level.rts.squads[i].members.size > 0 && IS_TRUE(level.rts.squads[i].selectable) )
		{
			validSquads[validSquads.size] = level.rts.squads[i];
		}
	}
	

	if (validSquads.size == 0 )
		return -1;
	
	lastSquad = validSquads.size-1;
	for(i=0;i<validSquads.size;i++)
	{
		if ( validSquads[i].id == curSquad )
		{
			if (direction == 1 )
			{
				if(i+1<validSquads.size)
				{
					return validSquads[i+1].id;
				}
				else
				{
					//return first index	
					return validSquads[0].id;
				}
			}
			if (direction == -1 )
			{
				return(validSquads[lastSquad].id);
			}
		}
		lastSquad = i;
	}
	
	return validSquads[0].id;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

squadSelectNextAIandTakeOver(nextSquad,noRestore,targetEnt)
{
	if (isDefined(level.rts.squadSelectNext) )
		return;
	if ( isDefined(level.rts.player.attacked_by_dog) )
		return;
	
	//if the player is trying to switch into another unit in his current squad, and that squad only has one unit in it, then get a different squadID	
	if ( isDefined(nextSquad) && isDefined(level.rts.player.ally) &&
	 	 level.rts.player.ally.squadID == nextSquad &&
	 	 level.rts.squads[nextSquad].members.size == 1 )
	{
		nextSquad = undefined;
	}
	 	 
		
	level.rts.squadSelectNext = true;
	level notify("switch_and_takeover");
	
	if(!isDefined(nextSquad))
	{
		if ( isDefined(level.rts.player.ally) )
			curSquad = level.rts.player.ally.squadID;
		else
			curSquad = undefined;
		
		nextSquad = getNextValidSquad(curSquad);
	}
	
	if ( nextSquad != -1 )
	{
		if ( !maps\_so_rts_ai::ai_IsSelectable(targetEnt) )
		{
			targetEnt = undefined;
		}

		if (!isDefined(targetEnt))
		{
			maps\_so_rts_squad::removeDeadFromSquad(nextSquad);
			sortedMemberList = maps\_so_rts_support::sortArrayByClosest(level.rts.player.origin, level.rts.squads[nextSquad].members );
		
			for(i = 0; i<sortedMemberList.size;i++ )
			{
				guy = sortedMemberList[i];
				
				if(isDefined(level.rts.player.ally.vehicle) && guy == level.rts.player.ally.vehicle)
				{
					continue;
				}
			
				if ( maps\_so_rts_ai::ai_IsSelectable(guy) )
				{
					targetEnt = guy;
					break;				
				}
			}
		}
		
		if ( isDefined(targetEnt) )
		{
			flag_set("block_input");
			level.rts.player EnableInvulnerability(); // so the player doesn't get killed by the hurt trigger in mp maps
			if (IS_VEHICLE(targetEnt) )
			{
				targetEnt veh_magic_bullet_shield(true);
			}
			else
			{
				targetEnt.takedamage = false;
			}
			
			level clientnotify( "chr_swtch_start" );
			level.rts.player thread maps\_so_rts_support::do_switch_transition();
			targetEnt notify("taken_control_over");
			level waittill("switch_fullstatic");
	
			if(!isDefined(noRestore))
			{
				level.rts.player maps\_so_rts_ai::restoreReplacement(); 
			}
			/////////////
			//take over target.....
			/// /// /// 
			level.rts.player unlink();
			targetEnt = level.rts.player maps\_so_rts_ai::takeOverSelected(targetEnt);
			if ( !(IS_VEHICLE(targetEnt) || maps\_so_rts_ai::IS_MECHANICAL(targetEnt)) )
			{
				level.rts.player showViewModel();
				level.rts.player enableweapons();
			}
			/////////////
			level clientnotify( "chr_swtch_end" );
			wait .5;
			flag_clear("block_input");
			if (!IS_VEHICLE(targetEnt))
			{
				level.rts.player DisableInvulnerability(); // so the player doesn't get killed by the hurt trigger in mp maps
			}
			else
			{
				targetEnt veh_magic_bullet_shield(false);
			}
		}
		else//no valid targetent
		{
			level.rts.lastFPSpoint = level.rts.player.origin;
			level thread player_eyeInTheSky();
			level.rts.player.ally = undefined;
			/#
			println("**** Player attempted to switch into squad:" + nextSquad+" but no units were acceptible to switch into.");
			#/
		}
	}
	else
	{	//nothing acceptable to switch into, bail upstairs
		level.rts.lastFPSpoint = level.rts.player.origin;
		level thread maps\_so_rts_main::player_eyeInTheSky();
		level.rts.player.ally = undefined;
		/#
		println("**** Player attempted to switch into squad but no valid squads found.");
		#/
	}
	level.rts.squadSelectNext = undefined;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
isSquadAlreadyCreated(team,pkg_ref)
{
	for (i=0;i<level.rts.squads.size;i++)
	{
		if ( level.rts.squads[i].team == team && level.rts.squads[i].pkg_ref == pkg_ref )
			return level.rts.squads[i];
	}
	return undefined;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
hasSquadMakeupChanged(squadID)
{
	squad = level.rts.squads[squadID];
	if (!isDefined(squad))
		return;
	if (IS_TRUE(squad.dirty))
	{
		squad.lastSquadCheckSum = -1;
		squad.dirty = false;
	}
	
	chksum = 0;
	foreach(guy in squad.members)
	{
		if (isDefined(guy) && IS_TRUE(guy.initialized) )
	    {
			chksum += guy GetEntityNumber();
		}
	}
	changed = (chksum==squad.lastSquadCheckSum?false:true);
	squad.lastSquadCheckSum = chksum;
	
	return (changed);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
createSquad(center,team,pkg_ref)
{
	squad = isSquadAlreadyCreated(team,pkg_ref);
	if(!isDefined(squad))
	{
		squadID = level.rts.nextSquadID;
		level.rts.nextSquadID += 1;
		squad 				= spawnstruct();
		squad.members 		= [];
		squad.state 		= SQUAD_STATE_DEFEND;
		squad.laststate 	= SQUAD_STATE_INVALID;
		squad.nextstate 	= (team==level.rts.player.team?SQUAD_STATE_MOVEWITHPLAYER:SQUAD_STATE_MANAGED);
		squad.centerPoint 	= center + (0,0,12);
		squad.id 			= squadID;
		squad.team 			= team;
		squad.think 		= ::squadDoNothing;
		squad.pkg_ref 		= pkg_ref;
		squad.base_origin 	= center;
		squad.lastSquadCheckSum = -1;
		
		if (isDefined(pkg_ref.marker) )
		{
			squad.marker = Spawn("script_model",center);
			squad.marker SetModel(pkg_ref.marker);
			squad.marker Hide();
			squad.marker.hidden = true;
		}
		
		level.rts.squads[squadID] = squad;

		ai_ref = level.rts.ai[pkg_ref.units[0]];
		foreach(unit in pkg_ref.units )
		{
			ai_ref2 = level.rts.ai[unit];
			assert(ai_ref2.health == ai_ref.health,"these must be the same");
		}
		maxHP = pkg_ref.max_friendly * ai_ref.health;
		/#
		println("@@@@@@@@@@@@@@@@@@@@@  SQUAD CREATED ("+squadID+") for type: "+pkg_ref.ref+" on team: "+team);
		#/
	}
	squad.dirty = true;
	
	return squad.id;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
removeSquadMarker(squadID, onEmpty)
{
	if (IS_TRUE(onEmpty))
	{
		while(1)
		{
			wait 1;
			maps\_so_rts_squad::removeDeadFromSquad(squadID);
			if(isDefined(level.rts.player.ally) && level.rts.player.ally.squadID == squadID )
			{
				continue;
			}
			if(level.rts.squads[squadID].members.size == 0 )
				break;
		}
	}
	
	LUINotifyEvent( &"rts_remove_squad", 1, squadID);
}

moveSquadMarker(squadID,hide=false,point)
{
	if (!isDefined(level.rts.squads[squadID].marker) )
		return;
	
	if(!isDefined(point))
		point = level.rts.squads[squadID].centerPoint;
	
	if ( level.rts.squads[squadID].team == "axis" )
	{
		hide = true;
	}
	
	level.rts.squads[squadID].marker.angles = (0,squadID*70,0);
	level.rts.squads[squadID].marker.origin = point;
	level.rts.squads[squadID].marker.hidden = hide;
	if(IS_TRUE(hide) )
	{
		LUINotifyEvent( &"rts_move_squad_marker", 1, squadID );
	}
	else
	{
		LUINotifyEvent( &"rts_move_squad_marker", 4, squadID, int( point[0] ), int( point[1] ), int( point[2] ) );
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
squad_unloaded(squadID)
{
	level.rts.squads[squadID].dirty = true;
	foreach(guy in level.rts.squads[squadID].members)
	{
		if (isDefined(guy))
		{
			if (!IS_TRUE(guy.initialized) )
			{
				guy maps\_so_rts_ai::ai_initialize(guy.ai_ref,level.rts.squads[squadID].team, (isDefined(guy.initNode)?guy.initNode.origin:undefined),squadID,(isDefined(guy.initNode)?guy.initNode.angles:undefined), level.rts.squads[squadID].pkg_ref);
			}
			guy maps\_so_rts_ai::ai_postInitialize();
			guy.rts_unloaded = true;
		}
	}
	if (level.rts.squads[squadID].team == "allies")
	{
		maps\_so_rts_event::trigger_event("ack_"+level.rts.squads[squadID].pkg_ref.ref);
		maps\_so_rts_event::trigger_event("unload_"+level.rts.squads[squadID].pkg_ref.ref);
	}
	level notify("squad_unloaded",squadID);
	ReIssueSquadLastOrders(squadID);
	
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
swapSquads(fromSquadID,toSquadID)
{
	removeDeadFromSquad(fromSquadID);
	removeDeadFromSquad(toSquadID);
	
	ArrayRemoveValue(level.rts.squads[fromSquadID].members,self);
	if (!IsInArray(level.rts.squads[toSquadID].members,self))
	{
		level.rts.squads[toSquadID].members[level.rts.squads[toSquadID].members.size] = self;
	}
	self.squadID = toSquadID;
}

addAIToSquad(squadID)
{
	if (!IsInArray(level.rts.squads[squadID].members,self))
	{
		self maps\_so_rts_ai::ai_preInitialize(self.ai_ref,level.rts.squads[squadID].pkg_ref,level.rts.squads[squadID].team,squadID);
		level.rts.squads[squadID].members[level.rts.squads[squadID].members.size] = self;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
removeDeadFromSquad(squadID)
{
	alive = [];
	
	for(i=0;i<level.rts.squads[squadID].members.size;i++)
	{
		ai = level.rts.squads[squadID].members[i];
		if ( isDefined(ai) && isAlive(ai) )
		{	
			alive[alive.size] = ai;
		}
	}
	
	level.rts.squads[squadID].members 		= alive;
	found = false;
	foreach(guy in level.rts.squads[squadID].members)
	{
		if ( IS_TRUE(guy.rts_unloaded) )
		{
			found = true;
			break;
		}
	}
	level.rts.squads[squadID].selectable = found;

}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
getSquadListFromSelected()
{
	squads = [];
	ArrayRemoveValue(level.rts.selectedUnits, undefined);
	foreach(guy in level.rts.selectedUnits)
	{
		squadID 	= guy.squadID;
		inAlready 	= false;
		for(i=0;i<squads.size;i++)
		{
			if ( squads[i].id == squadID )
			{
				inAlready = true;
				break;
			}
		}
		if (!inAlready )
		{
			squads[squads.size] = level.rts.squads[squadID];
		}
	}
	return squads;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
notifySquadMembersOfNewOrders(squadID)
{
	level notify("new_squad_orders"+squadID);
	level.rts.squads[squadID].dirty = true;
	foreach(guy in level.rts.squads[squadID].members)
	{
		/*
		if(!IS_VEHICLE(guy))
		{
			guy ClearEnemy();
		}*/
		guy notify("new_squad_orders");
		if(isDefined(guy.last_goalradius) )
		{
			guy.goalradius = guy.last_goalradius;
			guy.last_goalradius = undefined;
		}
		if(isDefined(self.last_goalpos) )
		{
			/# self squadDebug( "New Orders", self.last_goalpos ); #/
				
			self SetGoalPos(self.last_goalpos);
			self.last_goalpos = undefined;
		}

		guy.poi = undefined;
	}
	wait 0.05;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
isSquadMoving(squadID)
{
	return (level.rts.squads[squadID].state	== SQUAD_STATE_MOVE);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
doesSquadHaveAnySpeciesOfType(squadID,speciesType)
{
	squad 		= maps\_so_rts_squad::getSquad( squadID );
	if (!isDefined(squad))
		return false;
		
	if ( IS_TRUE(squad.destroyed) )
		return false;
			
	foreach(guy in squad.members)
	{
		if ( guy.ai_ref.species == speciesType )
			return true;
	}
	
	return false;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
GetTeamSquads(team)
{
	squads = [];
	foreach(squad in level.rts.squads)
	{
		if (squad.team == team )
		{
			squads[squads.size] = squad;
		}
	}
	return squads;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
gotoPoint(goal)
{
	self endon("new_squad_orders");
	self endon("death");
	self endon("taken_control_over");
	self notify("gotoPoint",goal);
	self endon("gotoPoint");

	if (isDefined(self.last_goalradius))
	{
		self.goalradius = self.last_goalradius;
		self.last_goalradius = undefined;
	}

	self.at_goal 			= undefined;
	self.last_goalradius 	= self.goalradius;
	self.goalradius 		= 512;
	if(!IS_VEHICLE(self) )
	{
		/# self squadDebug( "gotoPoint", goal ); #/
			
		self SetGoalPos(goal);
		wait 1;
		self waittill("goal");
	}
	else
	{
		if(!IsSentient(self))
		{
			self SetVehGoalPos(goal,true);
			self waittill_any( "goal", "near_goal" );
		}
		else
		{
			self thread maps\_vehicle::move_to(goal);
			self waittill("goal");
		}
	}
	if (isDefined(self.last_goalradius))
	{
		self.goalradius = self.last_goalradius;
		self.last_goalradius = undefined;
	}
	
	self.at_goal = true;
}
moveOut()
{
	if (isDefined(self))
	{
		self thread  gotoPoint(level.rts.squads[self.squadID].centerPoint);
	}
}
squadMove(squadID)
{
	if ( hasSquadMakeupChanged(squadID) )
	{
		foreach(guy in level.rts.squads[squadID].members)
		{
			guy thread moveOut();
		}
	}
}
ExecuteSquadMoveTo(squadID)
{
	notifySquadMembersOfNewOrders(squadID);

	if ( level.rts.squads[squadID].state != level.rts.squads[squadID].nextstate )
	{
		level.rts.squads[squadID].laststate		= level.rts.squads[squadID].state;
		level.rts.squads[squadID].state			= level.rts.squads[squadID].nextstate;
	}
	level.rts.squads[squadID].think			= ::squadMove;
	level.rts.squads[squadID].nextstate		= SQUAD_STATE_INVALID;
}
OrderSquadMoveTo(point,squadID)
{
	if (!isDefined(point) )
	{
		point = maps\_so_rts_support::playerLinkObj_getTargetGroundPos();
	}
	
	if(isDefineD(squadID))
	{
		level.rts.squads[squadID].nextstate		= SQUAD_STATE_MOVE;
		level.rts.squads[squadID].centerPoint 	= point + (0,0,12);
		moveSquadMarker(squadID,false,point);
	}
	else
	{
		squads = getSquadListFromSelected();
	
		for(i=0;i<squads.size;i++)
		{
			squadID = squads[i].id;
			level.rts.squads[squadID].nextstate		= SQUAD_STATE_MOVE;
			level.rts.squads[squadID].centerPoint 	= point + (0,0,12);
			moveSquadMarker(squadID,false,point);
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
OrderSquadDefend(point,squadID,hideMarker=false)
{
	if (!isDefined(point) )
	{
		point = maps\_so_rts_support::playerLinkObj_getTargetGroundPos();
	}
	
	if( flag( "rts_mode" ) && !flag( "fps_mode" ) )
		maps\_so_rts_event::trigger_event("squad_move_cmd");
	
	
	if ( isDefined(squadID) )
	{
		level.rts.squads[squadID].state			= SQUAD_STATE_DEFEND;
		level.rts.squads[squadID].nextstate		= SQUAD_STATE_MOVE;
		level.rts.squads[squadID].centerPoint 	= point + (0,0,12);
		moveSquadMarker(squadID,hideMarker);
	}
	else
	{
		squads = getSquadListFromSelected();
	
		for(i=0;i<squads.size;i++)
		{
			squadID = squads[i].id;
			level.rts.squads[squadID].state			= SQUAD_STATE_DEFEND;
			level.rts.squads[squadID].nextstate		= SQUAD_STATE_MOVE;
			level.rts.squads[squadID].centerPoint 	= point + (0,0,12);
			moveSquadMarker(squadID,hideMarker);
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
patrolPoint(point)
{
	self endon("new_squad_orders");
	self endon("death");
	self endon("taken_control_over");
	self notify("patrolPoint");
	self endon("patrolPoint");
	
	nodes = GetNodesInRadius( point, STANDARD_PATROL_RADIUS, 0, 700, "Cover" );

	if (nodes.size>8)
	{
		while(1)
		{
			if ( !isDefined(self.poi) )//guy is currently at point of interest attempting a take over.  dont send if anywhere
			{
				if( !(isDefined( self.enemy ) && self canSee( self.enemy )) )
				{
					pnode = nodes[RandomInt(nodes.size)];
					if( IsNodeOccupied( pnode ) )
					{
						wait 0.05;
						continue;
					}
					
					/# self squadDebug( "patrolPoint", pnode.origin ); #/
						
					self setGoalNode(pnode);
					self setGoalPos(pnode.origin);
					self waittill("goal");
				}
			}
			wait (RandomIntRange(PATROL_WAIT_MIN,PATROL_WAIT_MAX));
		}
	}
}
patrol()
{
	if ( !IS_VEHICLE(self) )
	{
		self thread patrolPoint(level.rts.squads[self.squadID].centerPoint);
	}
	else
	{
		self thread maps\_vehicle::patrol(level.rts.squads[self.squadID].centerPoint,VEHICLE_GOALRADIUS_PATROL);
	}
}

squadPatrol(squadID)
{
	if ( hasSquadMakeupChanged(squadID) )
	{
		foreach(guy in level.rts.squads[squadID].members)
		{
			if (!IS_TRUE(guy.initialized))
				continue;
			guy thread patrol();
		}
	}
}


ExecuteOrderSquadPatrol(squadID)
{
	notifySquadMembersOfNewOrders(squadID);

	if ( level.rts.squads[squadID].state != level.rts.squads[squadID].nextstate )
	{
		level.rts.squads[squadID].laststate		= level.rts.squads[squadID].state;
		level.rts.squads[squadID].state			= level.rts.squads[squadID].nextstate;
	}
	level.rts.squads[squadID].think			= ::squadPatrol;
	level.rts.squads[squadID].nextstate		= SQUAD_STATE_INVALID;
}

OrderSquadPatrol(point,squadID)
{
	if (!isDefined(point) )
	{
		point = maps\_so_rts_support::playerLinkObj_getTargetGroundPos();
	}
	
	if(isDefined(squadID))
	{
		level.rts.squads[squadID].state			= SQUAD_STATE_PATROL;
		level.rts.squads[squadID].nextstate		= SQUAD_STATE_MOVE;
		level.rts.squads[squadID].centerPoint 	= point + (0,0,12);
		moveSquadMarker(squadID);
	}
	else
	{
		squads = getSquadListFromSelected();
	
		for(i=0;i<squads.size;i++)
		{
			squadID = squads[i].id;
			level.rts.squads[squadID].state			= SQUAD_STATE_PATROL;
			level.rts.squads[squadID].nextstate		= SQUAD_STATE_MOVE;
			level.rts.squads[squadID].centerPoint 	= point + (0,0,12);
			moveSquadMarker(squadID);
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
attackOrderWatcher(target)
{
	self endon("death");
	self endon("taken_control_over");
	self notify("targetOrderWatcher");
	self endon("targetOrderWatcher");

	self waittill("new_squad_orders");
	if ( !IS_VEHICLE(self) )
	{
		self ClearEntityTarget();
	}
	else
	if( IsSentient( self ) )
	{
		self VehClearEntityTarget();
	}
//	moveSquadMarker(self.squadID, false);
}


targetWatcher(target)
{
	self endon("new_squad_orders");
	self endon("death");
	self endon("taken_control_over");
	self notify("targetWatcher");
	self endon("targetWatcher");
	
	target waittill("death");
	if ( !IS_VEHICLE(self) )
	{
		self ClearEntityTarget();
	}
	else
	if( IsSentient( self ) )
	{
		self VehClearEntityTarget();
	}
	moveSquadMarker(self.squadID,false);
}

attack()
{
	self endon ("death");
	
	if (isDefined(self.squadID) && isDefined(level.rts.squads[self.squadID].target) && is_alive(level.rts.squads[self.squadID].target))
	{
		self gotoPoint(level.rts.squads[self.squadID].target.origin);
		if(isDefined(level.rts.squads[self.squadID].target) && is_alive(level.rts.squads[self.squadID].target))
		{
			self thread targetWatcher(level.rts.squads[self.squadID].target);
			self thread attackOrderWatcher();

			if ( !IS_VEHICLE(self) )
			{
				self SetEntityTarget(level.rts.squads[self.squadID].target);
			}
			else
			if (IsSentient(self))
			{
				
				self VehSetEntityTarget(level.rts.squads[self.squadID].target);
			}
		}
	}
}


squadAttackTarget(squadID)
{
	if ( hasSquadMakeupChanged(squadID) )
	{
		foreach(guy in level.rts.squads[squadID].members)
		{
			if (!IS_TRUE(guy.initialized))
				continue;
			guy thread attack();
		}
	}
}

ExecuteOrderSquadAttack(squadID)
{
	notifySquadMembersOfNewOrders(squadID);

	if (!isDefined(level.rts.squads[squadID].target) )
	{
		level.rts.squads[squadID].state			= SQUAD_STATE_DEFEND;
		level.rts.squads[squadID].nextstate		= SQUAD_STATE_MOVE;
		return;
	}


	if ( level.rts.squads[squadID].state != level.rts.squads[squadID].nextstate )
	{
		level.rts.squads[squadID].laststate		= level.rts.squads[squadID].state;
		level.rts.squads[squadID].state			= level.rts.squads[squadID].nextstate;
	}
	level.rts.squads[squadID].think			= ::squadAttackTarget;
}

OrderSquadAttack(squadID,ent,allSquads,height = 50)
{
	if (!isDefined(ent) )
	{
		level.rts.squads[squadID].nextstate	= SQUAD_STATE_DEFEND;
		return;
	}


	if( flag( "fps_mode" ) )
	{
		maps\_so_rts_event::trigger_event("squad_attack_fps");
	}
	else
	{
		maps\_so_rts_event::trigger_event("squad_attack_cmd");
	}

	if ( !IS_TRUE(allSquads) )
	{
		if(isDefined(squadID))
		{
			level.rts.squads[squadID].nextstate		= SQUAD_STATE_ATTACK;
	
			if ( isDefined(level.rts.squads[squadID].target) && level.rts.squads[squadID].target != ent )
		    {
				LUINotifyEvent( &"rts_squad_stop_attack", 2, squadID, level.rts.squads[squadID].target GetEntityNumber() );
		    }
		    
			level.rts.squads[squadID].target	 	= ent;
			LUINotifyEvent( &"rts_squad_start_attack", 3, squadID, ent GetEntityNumber(), height );
			
			if(isDefined(ent.pkg_ref))
			{
				if( flag( "fps_mode" ) )
				{
					maps\_so_rts_event::trigger_event("targetfps_"+ent.pkg_ref.ref);
				}
				else
				{
					maps\_so_rts_event::trigger_event("target_"+ent.pkg_ref.ref);
				}
			}
		}
	}
	else
	{
		squads = GetTeamSquads(level.rts.player.team);
		for(i=0;i<squads.size;i++)
		{
			if ( !IS_TRUE(squads[i].selectable) )
				continue;
				
			squadID = squads[i].id;
			
			level.rts.squads[squadID].nextstate		= SQUAD_STATE_ATTACK;
			if ( isDefined(level.rts.squads[squadID].target) && level.rts.squads[squadID].target != ent )
		    {
				LUINotifyEvent( &"rts_squad_stop_attack", 2, squadID, level.rts.squads[squadID].target GetEntityNumber() );
		    }
			level.rts.squads[squadID].target	 	= ent;
			LUINotifyEvent( &"rts_squad_start_attack", 3, squadID, ent GetEntityNumber(), height );
		}
	}
}

ReIssueSquadLastOrders(squadID)
{	
	switch(level.rts.squads[squadID].state)
	{
		case SQUAD_STATE_ATTACK:
			level.rts.squads[squadID].nextstate		= SQUAD_STATE_ATTACK;
		break;
		case SQUAD_STATE_DEFEND:
			level.rts.squads[squadID].nextstate		= SQUAD_STATE_MOVE;		//move logic will pop and set squad state to whatever squad state currently is.
		break;
		case SQUAD_STATE_PATROL:
			level.rts.squads[squadID].nextstate		= SQUAD_STATE_MOVE;		//move logic will pop and set squad state to whatever squad state currently is.
		break;
		case SQUAD_STATE_MOVEWITHPLAYER:
			level.rts.squads[squadID].nextstate 	= SQUAD_STATE_MOVEWITHPLAYER;
		break;
		case SQUAD_STATE_MOVEWITHAI:
			level.rts.squads[squadID].nextstate 	= SQUAD_STATE_MOVEWITHAI;
		break;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

moveWithAI(target)
{
	self endon("new_squad_orders");
	self endon("death");
	self endon("taken_control_over");
	self notify("moveWithAI");
	self endon("moveWithAI");
	
	while(1)
	{
		if ( IS_TRUE(self.rts_unloaded) && isDefined(target) )
		{
			if ( IS_VEHICLE(self) )
			{
				self thread vehGoalEntity(target);
			}
			else
			{
				self thread aiGoalEntity(target);
			}
			return;
		}
		wait 0.2;
	}
}

squadMoveWithAI(squadID)
{
	if ( hasSquadMakeupChanged(squadID) )
	{
		foreach(guy in level.rts.squads[squadID].members)
		{
			if (!IS_TRUE(guy.initialized))
				continue;
				
			guy thread moveWithAI(level.rts.squads[squadID].target);
		}
	}
}

ExecuteOrderMoveWithAI(squadID)
{
	notifySquadMembersOfNewOrders(squadID);

	if ( level.rts.squads[squadID].state != level.rts.squads[squadID].nextstate )
	{
		level.rts.squads[squadID].laststate		= level.rts.squads[squadID].state;
		level.rts.squads[squadID].state			= level.rts.squads[squadID].nextstate;
	}
	level.rts.squads[squadID].think			= ::squadMoveWithAI;
	level.rts.squads[squadID].nextstate			= SQUAD_STATE_INVALID;
}
OrderSquadFollowAI(squadID,ent,allSquads,showMarker=true,height=60)
{
	if (!isDefined(ent) )
	{
		level.rts.squads[squadID].nextstate	= SQUAD_STATE_DEFEND;
		return;
	}

	if( flag( "fps_mode" ) )
	{
		maps\_so_rts_event::trigger_event("squad_attack_fps");
	}
	else
	{
		maps\_so_rts_event::trigger_event("squad_attack_cmd");
	}

	if ( !IS_TRUE(allSquads) )
	{
		if(isDefined(squadID))
		{
			level.rts.squads[squadID].nextstate		= SQUAD_STATE_MOVEWITHAI;
	
			if ( isDefined(level.rts.squads[squadID].target) && level.rts.squads[squadID].target != ent )
		    {
				LUINotifyEvent( &"rts_squad_stop_attack", 2, squadID, level.rts.squads[squadID].target GetEntityNumber() );
		    }
		    
			level.rts.squads[squadID].target	 	= ent;
			if(IS_TRUE(showMarker))
			{
				LUINotifyEvent( &"rts_squad_start_attack", 3, squadID, ent GetEntityNumber(), height );
			}
			
			if( flag( "fps_mode" ) )
			{
				maps\_so_rts_event::trigger_event("targetfps_"+ent.pkg_ref.ref);
			}
			else
			{
				maps\_so_rts_event::trigger_event("target_"+ent.pkg_ref.ref);
			}
		}
	}
	else
	{
		squads = GetTeamSquads(level.rts.player.team);
		for(i=0;i<squads.size;i++)
		{
			if ( !IS_TRUE(squads[i].selectable) )
				continue;
				
			squadID = squads[i].id;
			
			level.rts.squads[squadID].nextstate		= SQUAD_STATE_MOVEWITHAI;
			if ( isDefined(level.rts.squads[squadID].target) && level.rts.squads[squadID].target != ent )
		    {
				LUINotifyEvent( &"rts_squad_stop_attack", 2, squadID, level.rts.squads[squadID].target GetEntityNumber() );
		    }
			level.rts.squads[squadID].target	 	= ent;
			LUINotifyEvent( &"rts_squad_start_attack", 3, squadID, ent GetEntityNumber(), height );
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
vehGoalEntity(entity)
{
	self endon("new_squad_orders");
	self endon("death");
	self endon("taken_control_over");
	while(isDefined(entity))
	{
		if (entity == level.rts.player)
		{
			if (!isDefined(level.rts.player.ally))//if player gets killed, .ally will be undefined
				break;
		}
		self maps\_vehicle::move_to(entity.origin);
		wait 2;
	}
}

aiGoalEntity(entity)
{
	// only one at a time
	self notify( "aiGoalEntity" );
	self endon( "aiGoalEntity" );
	
	self endon("new_squad_orders");
	self endon("death");
	self endon("taken_control_over");

	while( isDefined(entity) )
	{
		if (entity == level.rts.player)
		{
			if (!isDefined(level.rts.player.ally)) //if player gets killed, .ally will be undefined
				break;
		}
		
		/# 
			if( IsDefined( self.enemy ) )
				self squadDebug( "enemy", self.enemy.origin, (1,0,0) );
		#/
		
		const goalRadiusThreshold = 1.0;
		goalRadiusSquared = (self.goalradius * goalRadiusThreshold) * (self.goalradius * goalRadiusThreshold);
		outsideGoalRadius = DistanceSquared( self.origin, entity.origin ) > goalRadiusSquared;
		
		findNewNode = true;
		if( IsDefined( self.node ) && DistanceSquared( entity.origin, self.node.origin ) < self.goalradius*self.goalradius )
		{
			// if already on a node, stay there
			findNewNode = false;
		}
		else if ( IS_TRUE(self.fixednode) )
		{
			findNewNode = false;
		}
		else if ( self GetPathLength() > 0 )
		{
			// if on a path, finish it first, otherwise looks very indecisive
			findNewNode = false;
		}
		
		if( findNewNode )
		{			
			// only update goalpos if the actor's outside of the goalradius
			if( outsideGoalRadius )
			{
				/# self squadDebug( "aiGoalEntity", entity.origin ); #/		
				self SetGoalPos( entity.origin );
			}
		}
				
		wait RandomFloatRange( 1.5, 2.5 );
	}
}

moveToIntruder()
{
	self endon("new_squad_orders");
	self endon("death");
	self endon("taken_control_over");
	self notify("moveToIntruder");
	self endon("moveToIntruder");
	
	assert( self != level );	
	

	level waittill("poi_contested",poi);
	if(isDefined(poi))
	{
		if ( self.ai_ref.species == "vehicle" )
		{
			self thread vehGoalEntity(poi);
		}
		else
		{
			self thread aiGoalEntity( poi );
		}
	}
}

moveWithPlayer()
{
	self endon("new_squad_orders");
	self endon("death");
	self endon("taken_control_over");
	self notify("moveWithPlayer");
	self endon("moveWithPlayer");
	
	while(1)
	{
		if ( IS_TRUE(self.rts_unloaded) )
		{
			if (flag("rts_mode") )
			{
				if ( self.ai_ref.species == "vehicle" )
				{
					self maps\_vehicle::move_to(level.rts.lastFPSpoint);
				}
				else
				if(isDefined(level.rts.lastFPSpoint))
				{
					/# self squadDebug( "moveWithPlayer", level.rts.lastFPSpoint ); #/
						
					self setgoalpos(level.rts.lastFPSpoint);
				}
			}
			else
			if ( isDefined(level.rts.player.ally) )// && level.rts.player.ally.squadID == self.squadID )
			{
				if ( IS_VEHICLE(self) )
				{
					self thread vehGoalEntity(level.rts.player);
				}
				else
				{
					self thread aiGoalEntity(level.rts.player);
				}
				return;
			}
		}
		wait 0.2;
	}
}

squadMoveWithPlayer(squadID)
{
	if ( hasSquadMakeupChanged(squadID) )
	{
		foreach(guy in level.rts.squads[squadID].members)
		{
			if (!IS_TRUE(guy.initialized))
				continue;
				
			guy thread moveWithPlayer();
			guy thread moveToIntruder();
		}
	}
}

ExecuteOrderMoveWithPlayer(squadID)
{
	notifySquadMembersOfNewOrders(squadID);

	if ( level.rts.squads[squadID].state != level.rts.squads[squadID].nextstate )
	{
		level.rts.squads[squadID].laststate		= level.rts.squads[squadID].state;
		level.rts.squads[squadID].state			= level.rts.squads[squadID].nextstate;
	}
	level.rts.squads[squadID].think			= ::squadMoveWithPlayer;
	level.rts.squads[squadID].nextstate		= SQUAD_STATE_INVALID;
}

squadDoNothing(squadID)
{
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
OrderSquadManaged(squadID)
{
	if(isDefined(squadID))
	{
		level.rts.squads[squadID].nextstate		= SQUAD_STATE_MANAGED;
	}
}

ExecuteSquadManaged(squadID)
{
	notifySquadMembersOfNewOrders(squadID);
	if ( level.rts.squads[squadID].state != level.rts.squads[squadID].nextstate )
	{
		level.rts.squads[squadID].laststate		= level.rts.squads[squadID].state;
		level.rts.squads[squadID].state			= level.rts.squads[squadID].nextstate;
	}
	level.rts.squads[squadID].think			= ::squadDoNothing;
	level.rts.squads[squadID].nextstate			= SQUAD_STATE_INVALID;
}

squadFollowPlayer(allSquads)
{
	if(isDefined(level.rts.player.ally) )
	{
		if(allSquads)
		{
			foreach(squad in level.rts.squads)
			{
				if (squad.team != level.rts.player.team )
					continue;
				squad.nextstate = SQUAD_STATE_MOVEWITHPLAYER;
				moveSquadMarker(squad.id,true);
			}
			maps\_so_rts_event::trigger_event("dlg_all_units_on_me");
		}
		else
		{
			squadID = level.rts.player.ally.squadID;
			maps\_so_rts_event::trigger_event("squad_rally");
			maps\_so_rts_event::trigger_event("dlg_follow_"+level.rts.squads[squadID].pkg_ref.ref);
			
			level.rts.squads[squadID].nextstate = SQUAD_STATE_MOVEWITHPLAYER;
			moveSquadMarker(squadID,true);
		}
	
		return;
	}
}




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
squadThink()
{
	level endon( "rts_terminated" );
	
	
	while(1)
	{
		foreach (squad in level.rts.squads)
		{
			removeDeadFromSquad(squad.id);
			
			if(squad.members.size == 0)
			{
				continue;
			}
			if ( squad.team == level.rts.player.team && !IS_TRUE(squad.selectable))
			{
				continue;
			}
			
			if ( squad.nextstate != SQUAD_STATE_INVALID && squad.nextstate != squad.state )
			{
				squad.lastSquadCheckSum  = -1;
			}

			if (isDefined(squad.squad_execute_cb))
			{
				if ( [[squad.squad_execute_cb]](squad.id) == false )
				{
					squad.nextstate = SQUAD_STATE_INVALID;
					continue;
				}
			}
			switch(squad.nextstate)
			{
				case SQUAD_STATE_INVALID:
				break;
				case SQUAD_STATE_MOVE:
				case SQUAD_STATE_DEFEND://defend move currently same thing
					/#
					println("$$$$$$ SQUAD ("+squad.id+") SQUAD_STATE_MOVE");
					#/
					ExecuteSquadMoveTo(squad.id);
				break;
				case SQUAD_STATE_PATROL:
					/#
					println("$$$$$$ SQUAD ("+squad.id+") SQUAD_STATE_PATROL");
					#/
					ExecuteOrderSquadPatrol(squad.id);
				break;
				case SQUAD_STATE_ATTACK:
					/#
					println("$$$$$$ SQUAD ("+squad.id+") SQUAD_STATE_ATTACK");
					#/
					ExecuteOrderSquadAttack(squad.id);
				break;
				case SQUAD_STATE_MOVEWITHPLAYER:
					/#
					println("$$$$$$ SQUAD ("+squad.id+") SQUAD_STATE_MOVEWITHPLAYER");
					#/
					ExecuteOrderMoveWithPlayer(squad.id);
				break;
				case SQUAD_STATE_MOVEWITHAI:
					/#
					println("$$$$$$ SQUAD ("+squad.id+") SQUAD_STATE_MOVEWITHAI");
					#/
					ExecuteOrderMoveWithAI(squad.id);
				break;
				case SQUAD_STATE_MANAGED:
					/#
					println("$$$$$$ SQUAD ("+squad.id+") SQUAD_STATE_MANAGED");
					#/	
					ExecuteSquadManaged(squad.id);
				break;
				default:
					assert(0,"squad in unknown think state");
				break;
			}
			
			
			assert(isDefined(squad.think),"squad in unknown think state");
			[[squad.think]](squad.id);
		}
	
		wait 0.5;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
getSquadsByType( type, team, onlyWithMembers = false )
{
	squads = [];
	foreach (squad in level.rts.squads)
	{
		if( squad.team == team)
		{
			if ( IS_TRUE(squad.no_nag))
				continue;
			if ( isDefined(type) && squad.pkg_ref.squad_type != type )
				continue;
				
			if (IS_TRUE(onlyWithMembers))
			{
				if (!isDefined(squad.members) || squad.members.size == 0 )
					continue;
			}
			squads[ squads.size ] = squad;
		}
	}
	
	return squads;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
getSquadByPkg( ref, team )
{
	foreach (squad in level.rts.squads)
	{
		if( squad.team == team && squad.pkg_ref.ref  == ref )
		{
			return squad;
		}
	}
	
	return undefined;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
getActiveSquads( team )
{
	activeSquads = [];
	
	foreach (squad in level.rts.squads)
	{
		if( squad.team == team && squad.members.size>0 )
		{
			activeSquads[ activeSquads.size ] = squad;
		}
	}
	
	return activeSquads;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
getInactiveSquads( team )
{
	activeSquads = [];
	
	foreach (squad in level.rts.squads)
	{
		if( squad.team == team && squad.members.size == 0 )
		{
			activeSquads[ activeSquads.size ] = squad;
		}
	}
	
	return activeSquads;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
getSquad(squadID)
{
	if( IsDefined( level.rts.squads[squadID] ) )
		return level.rts.squads[squadID];
	
	return undefined;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
getSquadCenter( squad )
{
	assert( IsDefined( squad ) );
	
	squadCenter = (0,0,0);
	squadCount = 0;
	foreach( guy in squad.members )
	{
		if( IsAlive( guy ) )
		{
			squadCenter += guy.origin;
			squadCount++;
		}
	}
	
	if( squadCount > 0 )
	{
		squadCenter = VectorScale( squadCenter, 1 / squadCount );
	}
	
	return squadCenter;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
/#
squadDebug( text, origin, color )
{
	if( GetDvarInt( "scr_rts_squadDebug" ) )
	{
		if( !IsDefined( color ) )
			color = (0,1,0);
		
		RecordEntText( text, self, color, "Script" );
		
		if( IsDefined( origin ) )
		{
			RecordLine( self.origin, origin, color, "Script" );
		}
	}
}
#/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
