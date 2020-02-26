#include common_scripts\utility;
#include maps\_utility;
#include maps\_so_rts_support;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_so_rts.gsh;

#define POI_MAX_DISTANCE				7000
#define POI_WEIGHT_DIST_TO_SQUAD		2
#define POI_WEIGHT_DIST_TO_PLAYER_BASE	0.7
#define POI_WEIGHT_VACANCY				2
#define POI_WEIGHT_ENEMIES_PRESENT		1
#define POI_WEIGHT_BELONGS_TO_ENEMY		2
#define POI_WEIGHT_OBJECTIVE			1.2	
#define POI_SQUAD_PRESENCE_DIST_SQ		(512*512)
	
#define CONST_ENEMY_GOTO_GOAL_RADIUS	512

enemy_player()
{
	level endon( "rts_terminated" );
		
	level.rts.enemy_units	= [];
	level.rts.nag_units		= [];
	level.rts.nag_targets	= [];
	level.rts.enemy_units_nextID = 0;
	flag_init("rts_enemy_squad_spawner_enabled");
	flag_set("rts_enemy_squad_spawner_enabled");
	flag_wait( "start_rts_enemy" );
	level thread enemy_squad_spawner();
	
	while(!flag("rts_game_over"))
	{
		//what pkgs are available....
		packages_avail = maps\_so_rts_catalog::package_generateAvailable( "axis" );
		
		//what pkgs need to be reordered
		for(i=0;i<packages_avail.size;i++)
		{
			if ( !IS_TRUE(packages_avail[i].selectable) )
				continue;
				
			ref 	= packages_avail[i].ref;
			total 	= get_number_in_queue(ref);
			squad	= maps\_so_rts_squad::getSquadByPkg( ref, "axis" );
			if(isDefined(squad))
			{
				maps\_so_rts_squad::removeDeadFromSquad(squad.id);
				total+= squad.members.size;
			}
			
			total += (maps\_so_rts_catalog::getNumberOfPkgsBeingTransported("axis",ref) * packages_avail[i].numUnits);
			
			if ( total >= packages_avail[i].max_axis )
				continue;
				
			if ( total <= packages_avail[i].min_axis )//reorder
			{
				level.rts.enemy_squad_queue[level.rts.enemy_squad_queue.size] = ref;
				/#
				println("@@@@@@@@ AXIS ("+GetTIme()+") ORDERING:"+ref+" CURRENT:" + total + " MAX:" + packages_avail[i].max_axis  +" MIN:" + packages_avail[i].min_axis);
				#/
			}
		}
		
		wait 4;
		units			= unitsPrune();
		create_units_from_AllSquads();
		
	
		/#
			badguys = getAIArray("axis");
			aiNotInUnit = 0;
			foreach(guy in badguys)
			{
				if(!isDefined(guy.unitID))
					aiNotInUnit++;
			}
			badVeh = GetVehicleArray("axis");
			vehNotInUnit = 0;
			foreach(guy in badVeh)
			{
				if(!isDefined(guy.unitID))
					vehNotInUnit++;
			}
			get_best_poi_target( );
			units			= unitsPrune();
			enemyDeployed 		= 0;
			foreach( deployedunit in units )
			{
				enemyDeployed += deployedunit.members.size;
			}
			onPlayer = 0;
			if (isDefined(level.rts.player.ally))
			{
				foreach(unit in level.rts.nag_units)
				{
					if(isDefined(unit.target) && unit.target == level.rts.player)
						onPlayer++;					
				}
			}
			
		
			println( "\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\nENEMY THINK ("+GetTime()+")" );
			println( "\tACTIVE ALLY SQUADS:"+ maps\_so_rts_squad::getActiveSquads( "allies" ).size);
			println( "\n\tTOTAL AXIS SQUADS:"+ maps\_so_rts_squad::getActiveSquads( "axis" ).size);
			println( "\n\tTOTAL AXIS UNITS:"+ units.size);
			println( "\tTOTAL UNIT ENEMY:"+ enemyDeployed);
			println( "\tTOTAL AI ENEMY:"+ badguys.size + " ("+aiNotInUnit+")");
			println( "\tTOTAL VEH ENEMY:"+ badVeh.size + " ("+vehNotInUnit+")");
			println( "\tSQUAD QUEUE:"+ level.rts.enemy_squad_queue.size);
			println( "\tNAG UNITS:"+ level.rts.nag_units.size +"\tWANTED:"+level.rts.game_rules.num_nag_squads+"\tON PLAYER:"+onPlayer );
			println( "\POIs:");
			for(i=0;i<level.rts.poi.size;i++)
			{
				if (isDefined(level.rts.poi[i].score) )
				{
					println( "\t"+level.rts.poi[i].ref+" \t\tAI DEFENDING:"+ level.rts.poi[i].score.defenders + "\tSCORE:"+level.rts.poi[i].score.totalScore);
				}
				else
				{
					println( "\t"+level.rts.poi[i].ref);
				}
			}
			println( "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" );
		#/
	}
	
	
	//player has won
	//:
	//:
	
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
enemy_squad_spawnASquad(cb)
{
	if  (level.rts.enemy_squad_queue.size == 0 )
		return;
		
	ref 	= level.rts.enemy_squad_queue[0];
	pkg 	= maps\_so_rts_catalog::package_GetPackageByType(ref);
	squad	= maps\_so_rts_squad::getSquadByPkg( ref, "axis" );
	squadID = maps\_so_rts_catalog::spawn_package( ref, "axis", false, (isDefined(cb)?cb:(::order_new_squad)) );
	// remove from array
	ArrayRemoveIndex( level.rts.enemy_squad_queue, 0 );
	/#
	println("##### Spawning enemy squad ("+ref+")  Result="+(isDefined(squadID)?"success":"failed")+" at time ("+GetTime()+")");
	#/
}


enemy_squad_spawner()
{
	level endon( "rts_terminated" );
	
	level.rts.enemy_squad_queue = [];
	
	while( flag("rts_enemy_squad_spawner_enabled") )
	{
		/#
			// for testing only
			if( GetDvarInt( "scr_rts_enemyDisabled" ) == 1 )
			{
				wait(1);
				continue;
			}
		#/
		time = 1;	
		for( i=0; i < level.rts.enemy_squad_queue.size; i++ )
		{
			ref 	= level.rts.enemy_squad_queue[i];
			pkg 	= maps\_so_rts_catalog::package_GetPackageByType(ref);
			squad	= maps\_so_rts_squad::getSquadByPkg( ref, "axis" );
			total  	= 0;
			if(isDefined(squad))
			{
				maps\_so_rts_squad::removeDeadFromSquad(squad.id);
				total = squad.members.size;
			}
			
			total += (maps\_so_rts_catalog::getNumberOfPkgsBeingTransported("axis",ref) * pkg.numUnits);
			
			if ( total >= pkg.max_axis )
			{
				ArrayRemoveIndex( level.rts.enemy_squad_queue, i );
				continue;
			}

			squadID = maps\_so_rts_catalog::spawn_package( ref, "axis", false, ::order_new_squad );
			if( isDefined(squadID) )
			{
				// remove from array
				ArrayRemoveIndex( level.rts.enemy_squad_queue, i );
				time = .1;
				break;
			}
		}
				
		wait( time );
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
removeMeFromUnit()
{
	if (isDefined(self.unitID))
	{
		for (i=0;i<level.rts.enemy_units.size;i++)
		{
			unit = level.rts.enemy_units[i];
			if ( unit.unitID == self.unitID )
			{
				ArrayRemoveValue(unit.members,self);
				self.unitID  = undefined;
				return;
			}
		}
	}
}

createUnit(ai_array,center)
{
	if(!isDefined(ai_array) || ai_array.size==0)
		return;
	
		
	unit = spawnstruct();
	unit.members 	= ai_array;
	unit.unitID		= level.rts.enemy_units_nextID;
	unit.poi 		= undefined;
	unit.center		= (isDefined(center)?center:level.rts.enemy_center.origin);
	unit.destroyed	= false;
	for(i=0;i<unit.members.size;i++)
	{
		if(isDefined(unit.members[i]))
		{
			unit.members[i].unitID = unit.unitID;
		}
	}
	level.rts.enemy_units[level.rts.enemy_units.size] = unit;
	level.rts.enemy_units_nextID += 1;
	
	unitDefend(unit,unit.center);
	
	return unit;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
create_units_from_squad(squadID,centerSelfOrigin)
{
	squad 			= maps\_so_rts_squad::getSquad( squadID );
	unit			= [];
	
	if ( squad.pkg_ref.squad_type == "infantry" )
	{
		maxSize	= 2;
	}
	else
	{
		maxSize	= 1;
	}
	
	for(i=0;i<squad.members.size;i++)
	{
		if(isDefined(centerSelfOrigin))
			center = squad.members[i].origin;
		
		if (!isDefined(squad.members[i].unitID))
			unit[unit.size] = squad.members[i];
	
		if ( unit.size == maxSize )
			break;
	}
	if (unit.size == 0 )
		return undefined;
		
	return createUnit(unit,center);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
create_units_from_AllSquads()
{
	foreach(squad in level.rts.squads)
	{
		if (squad.team != "axis" )
			continue;

		unit = undefined;
		do
		{
			unit = create_units_from_squad(squad.id);
			if (isDefined(unit))
			{
				level thread unitThink(unit,undefined);
			}
			wait 0.05;
		}
		while(isDefined(unit));
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

getUnit(unitID)
{
	if(!isDefined(level.rts.enemy_units))
		return undefined;
		
	for(i=0;i<level.rts.enemy_units;i++)
	{
		if (level.rts.enemy_units[i].unitID == unitID)
			return level.rts.enemy_units[i];
	}
	return undefined;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
chase_DownSquads(unit,targetID=undefined)
{
	level endon("rts_terminated");

	if( !isDefined(unit) || IS_TRUE(unit.destroyed) )
	{
		return;
	}
	
	level notify("chase_DownSquads"+unit.unitID);
	level endon("chase_DownSquads"+unit.unitID);
	
	if(isDefined(level.rts.chase_logic_override))
	{
		[[level.rts.chase_logic_override]](unit);
		return;
	}
	
	valid = [];
	foreach(curUnit in level.rts.nag_units)
	{
		if ( isDefined(curUnit.target))
			valid[valid.size] = curUnit;
	}
	level.rts.nag_units = valid;
	
	if (isDefined(targetID))
	{
		target = maps\_so_rts_squad::getSquad( targetID );
		if ( isDefined(target) && target.members.size == 0 )
			target = undefined;
	}

	if (!isDefined(target) )
	{
		if ( level.rts.nag_units.size >= level.rts.game_rules.num_nag_squads )
		{
			chosenPoi 	= get_best_poi_target( unit );
			if(isDefined(chosenPoi))
			{
				level thread new_unit_init(unit,chosenPoi);
				return;
			}
			else
			{
				unitDisperse(unit,unit.center);
				wait 20;
				if(!isDefined(unit) || IS_TRUE(unit.destroyed))
				{
					ArrayRemoveValue(level.rts.nag_units,unit);
					return;
				}
				level thread new_unit_init(unit,undefined);
				return;
			}
		}
		
		if (level.rts.nag_targets.size > 0 )
		{
			target  = maps\_so_rts_squad::getSquad( level.rts.nag_targets[RandomInt(level.rts.nag_targets.size)] );
		}
		else
		{
			targets = maps\_so_rts_squad::getSquadsByType( undefined, "allies", true );
			if (targets.size>0)
			{
				target = targets[RandomInt(targets.size)];
				found  = false;
				if(isDefined(level.rts.player.ally))
				{
					for(i=0;i<level.rts.nag_units.size;i++)
					{
						if (level.rts.nag_units[i].target == level.rts.player )
						{
							found = true;
							break;
						}
					}
					
					if(!found)	//We want to make sure that the player is seeing some action.  Always check to see if the player has at least one nag squad on him.
					{
						if(!IS_TRUE(level.rts.squads[level.rts.player.ally.squadID].no_nag))
							target = level.rts.squads[level.rts.player.ally.squadID];
					}
				}
			}
			else
			{
				target = undefined;
			}
		}
				
		if ( isDefined(target) )
		{
			if (!IsInArray(level.rts.nag_units,unit))
			{
				level.rts.nag_units[level.rts.nag_units.size] = unit;
			}
			if ( isDefined(level.rts.player.ally) && target.id == level.rts.player.ally.squadID )
			{
				unit.target = level.rts.player;
			}
			else
			{			
				unit.target = target.members[RandomInt(target.members.size)];
			}
			unit.targetSquad = target.id;
		}
		else
		{
			unit.target = undefined;
		}
	}

	while(isDefined(unit.target))
	{
		if (unit.target == level.rts.player && (!isDefined(level.rts.player.ally) || level.rts.player.ally.squadID != unit.targetSquad) )
		{	//player switched out
			unit.target = undefined;
			break;
		}
		
		unit.center = unit.target.origin;
			
		// goto
		unitDefend(unit,unit.center);
		wait 5;
		if(!isDefined(unit) || IS_TRUE(unit.destroyed))
		{
			ArrayRemoveValue(level.rts.nag_units,unit);
			return;
		}
	}
	unitDisperse(unit,unit.center);
	wait 20;
	if(!isDefined(unit) || IS_TRUE(unit.destroyed))
	{
		ArrayRemoveValue(level.rts.nag_units,unit);
		return;
	}
	level thread new_unit_init(unit,undefined);
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

redeploy_on_poi_attemptedTakeover(unit)
{	
	level endon( "rts_terminated" );
	level notify("redeploy_on_poi_takeover"+unit.unitID);
	level endon("redeploy_on_poi_takeover"+unit.unitID);
	
	level waittill_any("poi_contested","poi_nolonger_contested");
	chosenPoi 	= get_best_poi_target( unit );
	
	level thread new_unit_init(unit,chosenPoi);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

redeploy_on_poi_lost(unit)
{
	level endon( "rts_terminated" );
	level notify("redeploy_on_poi_lost"+unit.unitID);
	level endon("redeploy_on_poi_lost"+unit.unitID);
	

	if(!isDefined(unit.poi))
		return;

	while(!IS_TRUE(unit.destroyed) )
	{
		if ( isDefined(unit.poi) && IsInArray(level.rts.poi,unit.poi) )
		{
			wait 2;
		}
		else
		{
			chosenPoi 	= get_best_poi_target( unit );
			if (isDefineD(chosenPoi))
			{
				level thread new_unit_init(unit,chosenPoi);
			}
			return;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

gotoPoint(goal)
{
	self notify("gotoPoint");
	self endon("gotoPoint");
	self endon("death");
	
	if ( is_corpse(self) )
	{
		self.at_goal = true;
		return;
	}
		
	self.at_goal 			= undefined;
	self.last_goalradius 	= self.goalradius;
	self.goalradius 		= CONST_ENEMY_GOTO_GOAL_RADIUS;
	if(!IS_VEHICLE(self) )
	{
		self SetGoalPos(goal);
		wait 1;
		self waittill("goal");
	}
	else
	{
		self thread maps\_vehicle::move_to(goal);
		self waittill("goal");
	}
	if (isDefined(self.last_goalradius))
	{
		self.goalradius = self.last_goalradius;
		self.last_goalradius = undefined;
	}
	self.at_goal = true;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
unitDefend(unit,position)
{
	unit.center = position;
	alive = [];
	for(i=0;i<unit.members.size;i++)
	{
		if(!isDefined(unit.members[i]))
			continue;
		if (is_corpse(unit.members[i]))
		{
			continue;
		}
		alive[alive.size] = unit.members[i];
	}
	unit.members = alive;
	
	foreach(guy in unit.members)
	{
		guy.goalradius = 512;	
		guy thread gotoPoint(position);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
unitDisperseToLocation(origin)
{
	self endon("death");
	/#
	thread maps\_so_rts_support::debug_sphere( origin, 10, (1,0,0), 0.6, 3 );
	#/
	self.goalradius = 512;	
	self gotoPoint(origin);
	self.unitID = undefined;
}
unitDisperse(unit,position)
{
	/#
	println("Unit "+unit.unitid+" dispersing at" + position);
	#/
	nodes = GetNodesInRadius( position, 2048, 0, 256);
	alive = [];
	for(i=0;i<unit.members.size;i++)
	{
		if(!isDefined(unit.members[i]))
			continue;
		if (is_corpse(unit.members[i]))
		{
			continue;
		}
		alive[alive.size] = unit.members[i];
	}
	unit.members = alive;
	
	foreach(guy in unit.members)
	{
		if(nodes.size>0)
		{
			guy thread unitDisperseToLocation(nodes[RandomInt(nodes.size)].origin);
		}
	}
	unit.destroyed= 1;
	unit.members = [];
	ArrayRemoveValue(level.rts.nag_units,unit);
	ArrayRemoveValue(level.rts.enemy_units,unit);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

new_unit_init(unit,poi)
{
	// go after it
	if( IsDefined( poi ) && isDefined(poi.entity) )
	{
		unit.center = poi.entity.origin;
		unit.poi	= poi;
		// goto
		level thread redeploy_on_poi_lost(unit);
		level thread redeploy_on_poi_attemptedTakeover(unit);
		level unitDefend( unit, unit.center);
	}
	else
	{
		unit.poi = undefined;
		level thread chase_DownSquads(unit);
	}
}

unitThink(unit, poi)
{
	level endon( "rts_terminated" );

	
	new_unit_init(unit,poi);

	while(unit.members.size>0)
	{
		alive = [];
		for(i=0;i<unit.members.size;i++)
		{
			if(!isDefined(unit.members[i]))
				continue;
			if (is_corpse(unit.members[i]))
				continue;
			if(unit.members[i].health<=0 )
				continue;
	
			alive[alive.size] = unit.members[i];
		}
		unit.members = alive;
		foreach(member in unit.members)
		{
			if (IS_TRUE(member.initialized) && !IS_TRUE(member.at_goal))
			{
				member.goalradius = 512;	
				member thread gotoPoint(unit.center);
			}
		}
		wait 1;
	}
	unit.destroyed = 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

unitsPrune()
{
	units = [];
	for(i=0;i<level.rts.enemy_units.size;i++)
	{
		if (IS_FALSE(level.rts.enemy_units[i].destroyed))
		{
			units[units.size] = level.rts.enemy_units[i];
		}
		else
		{
/#		
			println("$$$$ Unit destroyed:"+level.rts.enemy_units[i].unitid);
#/		
		}
	}
	level.rts.enemy_units = units;

	units = [];
	for(i=0;i<level.rts.nag_units.size;i++)
	{
		if (IS_FALSE(level.rts.nag_units[i].destroyed))
		{
			units[units.size] = level.rts.nag_units[i];
		}
		else
		{
/#		
			println("$$$$ NagUnit destroyed:"+level.rts.nag_units[i].unitid);
#/		
		}
	}
	level.rts.nag_units = units;

	return level.rts.enemy_units;
}



create_NagSquads(num)
{
	level.rts.game_rules.num_nag_squads = num;
	left = num;
	
	foreach(unit in level.rts.enemy_units)
	{
		new_unit_init(unit,undefined);
		left--;
		if (left==0)
		{
			break;
		}
	}
}

order_new_squad( squadID )
{
	squad 			= maps\_so_rts_squad::getSquad( squadID );
	squad.nextstate = SQUAD_STATE_MANAGED;

	unit = create_units_from_squad(squadID);

	if (!isDefined(unit) || unit.size == 0 )
		return;

	//current over ideal
	no_nagchance = (level.rts.nag_units.size / level.rts.game_rules.num_nag_squads)*100;
	chosenPoi 	= get_best_poi_target( unit );
	if(!isDefined(chosenPoi))
		no_nagchance = 0;

	if (RandomInt(100)>no_nagchance)
		chosenPoi = undefined;

	level thread unitThink(unit,chosenPoi);
}


// sorting criteria: dist to me, dist to home, ownership, other squad, conflict presence
get_best_poi_target( unit )
{
	// reset scores
	foreach( poi in level.rts.poi )
	{
		poi.score = SpawnStruct();
		poi.score.defenders = 0;
		poi.score.totalScore = 0;
	}
	
	
	
	activeUnits 		= unitsPrune();
	activeEnemySquads 	= maps\_so_rts_squad::getActiveSquads( "allies" );
	playerBasePoi 		= maps\_so_rts_poi::getPOIByRef("rts_base_player");
	enemyBasePoi 		= maps\_so_rts_poi::getPOIByRef("rts_base_enemy");
	
	poiOptions = [];

	enemyDeployed 		= 0;
	foreach( deployedunit in activeUnits )
	{
		enemyDeployed += deployedunit.members.size;
	}
	
	// score the pois
	foreach( poi in level.rts.poi )
	{
		// enemy base is no longer a reachable poi
		if( IsDefined( enemyBasePoi ) && poi == enemyBasePoi )
			continue;
		
		// captured only gets set in non-domination style poi games;  if captured is set, this poi cannot be retaken
		if( IS_TRUE(poi.captured) )
			continue;
			
		if (!isDefined(poi.entity))
			continue;
		
		// distance to squad
		poi.score.distToSquad = 1;
		if( IsDefined( unit ) )
		{
			// exclude the current poi
			if( IsDefined( unit.poi ) && unit.poi == poi )
			{
				poi.score.totalScore = 0;
				continue;
			}
			
			distToPoi = Distance( poi.entity.origin, unit.center );
			if( distToPoi > 0 )
				poi.score.distToSquad = 1 - Min( 1, distToPoi / POI_MAX_DISTANCE );
			else 
				poi.score.distToSquad = 1;
		}
		
		// is/will be occupied or not
		poi.score.defenders = 0;
		foreach( deployedunit in activeUnits )
		{
			if(!isDefined(deployedunit.poi))
				continue;
			if( DistanceSquared( deployedunit.center, poi.entity.origin ) < (64*64) )
			{
				poi.score.defenders += deployedunit.members.size;
			}
		}
		
		ideal  = 4;
		actual = poi.score.defenders/ideal;
		poi.score.vacant = 1.0 - actual;
			
		


		// move forward towards player's base
		if( IsDefined( playerBasePoi ) )
		{
			distToPoi = Distance( poi.entity.origin, playerBasePoi.entity.origin );
			if( distToPoi > 0 )
				poi.score.distToPlayerBase = 1 - Min( 1, distToPoi / POI_MAX_DISTANCE );
			else
				poi.score.distToPlayerBase = 1;
		}
		else
		{
			poi.score.distToPlayerBase = 0;
		}

		
		// enemies present
		poi.score.enemiesPresent = 0;
		foreach( activeEnemySquad in activeEnemySquads )
		{			
			squadCenter = getSquadCenter( activeEnemySquad );
			if( DistanceSquared( squadCenter, poi.entity.origin ) < POI_SQUAD_PRESENCE_DIST_SQ )
			{
				poi.score.enemiesPresent = 1;
				break;
			}
		}
		
		// go after pois that have a network intruder to destroy it
		poi.score.belongsToEnemy = 0;
		if ( IS_TRUE(poi.canbe_retaken) )
		{
			if( IS_TRUE( poi.has_intruder ) || poi.team == "allies" )
				poi.score.belongsToEnemy = 1;
		}
		else
		{
			if( IS_TRUE( poi.has_intruder ) )
				poi.score.belongsToEnemy = 0.65;
			if( poi.team == "allies" )
				poi.score.belongsToEnemy += 0.35;
		}
		
		poi.score.objective  = 0;
		objectives = maps\_so_rts_poi::getPOIObjectives();
		if (IsInArray(objectives,poi) )
		{
			poi.score.objective  = 1.0 / objectives.size;
		}
					
		poi.score.totalScore = 	poi.score.distToSquad 		*	POI_WEIGHT_DIST_TO_SQUAD +
								poi.score.distToPlayerBase 	* 	POI_WEIGHT_DIST_TO_PLAYER_BASE +
								poi.score.vacant 			* 	POI_WEIGHT_VACANCY +
								poi.score.enemiesPresent 	*	POI_WEIGHT_ENEMIES_PRESENT +
								poi.score.objective			*	POI_WEIGHT_OBJECTIVE +
								poi.score.belongsToEnemy 	*	POI_WEIGHT_BELONGS_TO_ENEMY;
		
		if ( isDefined(level.rts.max_poi_infantry) && poi.score.defenders > level.rts.max_poi_infantry )
		{
			poi.score.totalScore = 0;
			continue;
		}
		if ( poi.score.totalScore <= 0 )
		{
			poi.score.totalScore = 0;
			continue;
		}

		poiOptions[ poiOptions.size ] = poi;
		
	
/#
		if( GetDvarInt("scr_rts_enemyDebug") )
		{
			if(isDefined(unit))
			{
				recordLine( poi.entity.origin, unit.center, (1,1,1), "Script" );
			}
			recordEntText( "distToSquad: " + formatFloat( poi.score.distToSquad * POI_WEIGHT_DIST_TO_SQUAD, 2), poi.entity, (1,1,1), "Script" );
			recordEntText( "distToPlayerBase: " + formatFloat( poi.score.distToPlayerBase * POI_WEIGHT_DIST_TO_PLAYER_BASE, 2 ), poi.entity, (1,1,1), "Script" );
			recordEntText( "vacant: " + formatFloat( poi.score.vacant * POI_WEIGHT_VACANCY, 2 ), poi.entity, (1,1,1), "Script" );
			recordEntText( "defenders: " + poi.score.defenders, poi.entity, (1,1,1), "Script" );
			recordEntText( "enemiesPresent: " + formatFloat( poi.score.enemiesPresent * POI_WEIGHT_ENEMIES_PRESENT, 2 ), poi.entity, (1,1,1), "Script" );
			recordEntText( "belongsToEnemy: " + formatFloat( poi.score.belongsToEnemy * POI_WEIGHT_BELONGS_TO_ENEMY, 2 ), poi.entity, (1,1,1), "Script" );
			recordEntText( "objective: " + formatFloat( poi.score.objective * POI_WEIGHT_OBJECTIVE, 2 ), poi.entity, (1,1,1), "Script" );
			recordEntText( "total: " + formatFloat( poi.score.totalScore, 2 ), poi.entity, (1,1,1), "Script" );
			
			// hard to read text above, so print to console too
			if(isDefined(unit))
			{
				println( "\nUnit: " + unit.unitID + " POI: " + poi.ref );
			}
			else
			{
				println( "\nPOI: " + poi.ref );
			}
			
			println( "distToSquad: " + formatFloat( poi.score.distToSquad * POI_WEIGHT_DIST_TO_SQUAD, 2) );
			println( "distToPlayerBase: " + formatFloat( poi.score.distToPlayerBase * POI_WEIGHT_DIST_TO_PLAYER_BASE, 2 ) );
			println( "vacant: " + formatFloat( poi.score.vacant * POI_WEIGHT_VACANCY, 2 ) );
			println( "defenders: " + poi.score.defenders );
			println( "enemiesPresent: " + formatFloat( poi.score.enemiesPresent * POI_WEIGHT_ENEMIES_PRESENT, 2 ) );
			println( "belongsToEnemy: " + formatFloat( poi.score.belongsToEnemy * POI_WEIGHT_BELONGS_TO_ENEMY, 2 ) );
			println( "objective: " + formatFloat( poi.score.objective * POI_WEIGHT_OBJECTIVE, 2 ) );
			println( "total: " + formatFloat( poi.score.totalScore, 2 ) );
		}
#/
	}
	
	// if all occupied, choose a random one
	if(poiOptions.size>0)
	{
		// sort by total score
		poiOptions = maps\_utility_code::mergesort( poiOptions, ::poiScoreCompareFunc, undefined );
		chosenPoi = poiOptions[ 0 ];
		if(chosenPoi.score.totalscore > 0 )
			return chosenPoi;
		else
			return undefined;
	}
	return undefined;
}

poiScoreCompareFunc( e1, e2, param )
{
	return e1.score.totalScore > e2.score.totalScore;
}


get_num_ai()
{
	numAi = 0;
	activeUnits 		= unitsPrune();
	foreach (unit in activeUnits)
	{
		numAi += unit.members.size;
	}
	
	return numAi;
}


get_number_in_queue(ref)
{
	pkg_ref = package_GetPackageByType(ref);
	if (!isDefined(pkg_ref))
		return 0;
		
	count = 0;
	for (i=0;i<level.rts.enemy_squad_queue.size;i++)
	{
		if (level.rts.enemy_squad_queue[i] == ref )
		{
			count+= pkg_ref.numUnits;
		}
	}
	return count;
}

formatFloat( number, decimals )
{
	power = Pow( 10, decimals );
	temp = int( number * power );
	temp = float( temp / power );
	
	return temp;
}
