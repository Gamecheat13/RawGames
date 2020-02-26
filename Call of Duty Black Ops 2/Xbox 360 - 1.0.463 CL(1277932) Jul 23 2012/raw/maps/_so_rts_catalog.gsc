#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_so_rts.gsh;



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// rts.csv table column defines 
#define TABLE_IDX					0
#define TABLE_PKG_REF 				1	// package type ref
#define TABLE_PKG_NAME 				2	// String name of pkg (localization)
#define TABLE_PKG_DESC 				3	// String description of the pkg (localization)
#define TABLE_PKG_COST 				4	// pkg cost   (int int)
#define TABLE_PKG_UNITS 			5	// pkg unit, this is ai_ref
#define TABLE_PKG_DELIVERY 			6	// how the units come into the map;  STANDARD,FASTROPE_HELO,FASTROPE_VTOL,ROPE
#define TABLE_PKG_MARKER			7	// model for unit marker
#define TABLE_PKG_POI_DEP			8	// POI dependancy
#define TABLE_PKG_SQUAD_TYPE		9	// infantry/mechanized /etc
#define TABLE_PKG_ICON				10	// material
#define TABLE_PKG_QTY				11	// # of this type available, -1 == infinite

#define TABLE_PKG_MIN_IN_PLAY		12	//minimum squads of this type before reorder occurs
#define TABLE_PKG_MAX_IN_PLAY		13	//minimum squads of this type before reorder occurs
#define TABLE_PKG_BINDING_BUY		14	//applies to friendly_player logic only,  reordered immediately upon button binding activation
#define TABLE_PKG_BINDING_COMMAND	15	//applies to friendly_player logic only,  unit commanded upon button binding activation (to move)
#define TABLE_PKG_BINDING_TAKEOVER	16	//applies to friendly_player logic only,  unit taken over immediately upon button binding activation
#define TABLE_PKG_NOTIFY			17	//notify sent to level when pkg becomes available
#define TABLE_PKG_GATEFLAG			18	//flag must be set for item to be selectable



#define TABLE_PACKAGE_INDEX_START 	100 // First index for package Table
#define TABLE_PACKAGE_INDEX_END 	120	// Last index for package Table

preload()
{
	assert(isdefined( level.rts) );
	assert(isdefined( level.rts_def_table ) );
		
	level.rts.packages			= [];
	level.rts.packages_avail	= [];
	level.rts.packages			= package_populate();
	foreach(pkg in level.rts.packages)
	{
		if (isDefined(pkg.marker) && pkg.marker != "")
		{
			PrecacheModel(pkg.marker);
		}
	}
	
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//"Name: TableLookup( <filename>, <search column num>, <search value>, <return value column num> )"
//"Summary: look up a row in a table and pull out a particular column from that row"
//"Module: Precache"
//"MandatoryArg: <filename> The table to look up"
//"MandatoryArg: <search column num> The column number of the stats table to search through"
//"MandatoryArg: <search value> The value to use when searching the <search column num>"
//"MandatoryArg: <return value column num> The column number value to return after we find the correct row"
//"Example: TableLookup( "mp/statstable.csv", 0, "INDEX_KILLS", 1 );"
lookup_value( ref, idx, column_index )
{
	assert( IsDefined(idx) );
	return tablelookup( level.rts_def_table, TABLE_IDX, idx, column_index );
}
pkg_exist( ref )
{
	return isdefined( level.rts.packages  ) && isdefined( level.rts.packages [ ref ] );
}
get_pkg_ref_by_index( idx )
{
	return tablelookup( level.rts_def_table, TABLE_IDX, idx, TABLE_PKG_REF );
}


// ==========================================================================
// AI INIT AND DATA TABLE POPULATION
// ==========================================================================
init()
{	
	level.rts.packages_avail	= package_generateAvailable("allies");
	
	assert(isDefined(level.rts.rules),"rules must be initialized first");
	
	level.rts.transport			= spawnstruct();
	level.rts.transport.helo 	= [];
	level.rts.transport.vtol 	= [];
	
	unitH = 0;
	unitV = 0;
	for(i=0;i<level.rts.game_rules.player_helo;i++)
	{
		unitH = level.rts.transport.helo.size;
		level.rts.transport.helo[unitH] 		= spawnstruct();
		level.rts.transport.helo[unitH].state 	= TRANSPORT_STATUS_AVAIL;
		level.rts.transport.helo[unitH].type	= "helo";
		level.rts.transport.helo[unitH].num		= unitH;
		level.rts.transport.helo[unitH].team	= "allies";
		
		level thread transportThink(level.rts.transport.helo[unitH]);
	}
	for(i=0;i<level.rts.game_rules.enemy_helo;i++)
	{
		unitH = level.rts.transport.helo.size;
		level.rts.transport.helo[unitH] 		= spawnstruct();
		level.rts.transport.helo[unitH].state 	= TRANSPORT_STATUS_AVAIL;
		level.rts.transport.helo[unitH].type	= "helo";
		level.rts.transport.helo[unitH].num		= unitH;
		level.rts.transport.helo[unitH].team	= "axis";
		level thread transportThink(level.rts.transport.helo[unitH]);
	}
	for(i=0;i<level.rts.game_rules.player_vtol;i++)
	{
		unitV = level.rts.transport.vtol.size;
		level.rts.transport.vtol[unitV] 		= spawnstruct();
		level.rts.transport.vtol[unitV].state 	= TRANSPORT_STATUS_AVAIL;
		level.rts.transport.vtol[unitV].type	= "vtol";
		level.rts.transport.vtol[unitV].num		= unitV;
		level.rts.transport.vtol[unitV].team	= "allies";
		level thread transportThink(level.rts.transport.vtol[unitV]);
	}
	for(i=0;i<level.rts.game_rules.enemy_vtol;i++)
	{
		unitV = level.rts.transport.vtol.size;
		level.rts.transport.vtol[unitV] 		= spawnstruct();
		level.rts.transport.vtol[unitV].state 	= TRANSPORT_STATUS_AVAIL;
		level.rts.transport.vtol[unitV].type	= "vtol";
		level.rts.transport.vtol[unitV].num		= unitV;
		level.rts.transport.vtol[unitV].team	= "axis";
		level thread transportThink(level.rts.transport.vtol[unitV]);
	}

}

package_populate()
{
	pkg_types	= [];

	for( i = TABLE_PACKAGE_INDEX_START; i <= TABLE_PACKAGE_INDEX_END; i++ )
	{		
		ref = get_pkg_ref_by_index( i );
		if ( !isdefined( ref ) || ref == "" )
			continue;
		
		pkg 			= spawnstruct();
		pkg.idx			= i;
		pkg.ref			= ref;
		pkg.name		= lookup_value( ref, i, TABLE_PKG_NAME );
		pkg.desc		= lookup_value( ref, i, TABLE_PKG_DESC );
		
	
		pkg.cost		= [];
		cost			= strtok(lookup_value( ref, i, TABLE_PKG_COST )," ");
		assert(cost.size >=1 && cost.size <=2, "unexpected cost parameters");
		if ( cost.size == 1 )
		{
			if ( cost[0] == "na" )
				cost[0] = -1;
				
			pkg.cost["axis"] 	= int(cost[0]);
			pkg.cost["allies"] 	= int(cost[0]);
		}
		else
		{
			if ( cost[0] == "na" )
				cost[0] = -1;
			if ( cost[1] == "na" )
				cost[1] = -1;
			pkg.cost["axis"] 	= int(cost[0]);
			pkg.cost["allies"] 	= int(cost[1]);
		}
		if (pkg.cost["axis"] != -1 )
			pkg.cost["axis"] = pkg.cost["axis"] * 1000;  //msec
		if (pkg.cost["allies"] != -1 )
			pkg.cost["allies"] = pkg.cost["allies"] * 1000;  //msec
		
		
		pkg.units		= [];
		pkg.units		 = strtok(lookup_value( ref, i, TABLE_PKG_UNITS )," ");
		pkg.numUnits	 = pkg.units.size;
		
		
		pkg.delivery	= lookup_value( ref, i, TABLE_PKG_DELIVERY );
		pkg.marker		= lookup_value( ref, i, TABLE_PKG_MARKER );
		pkg.selectable	= false;
		pkg.nextAvail	= [];
		pkg.nextAvail["axis"] = GetTime();
		pkg.nextAvail["allies"] = GetTime();
		pkg.poi_deps	= [];
		pkg.poi_deps	= strtok(lookup_value( ref, i, TABLE_PKG_POI_DEP )," ");
		assert(isDefined(pkg.name));
		assert(isDefined(pkg.desc));
		assert(isDefined(pkg.delivery));

		if ( pkg.delivery != "CODE" )
		{
			foreach(unit in pkg.units)
			{
				assert(isDefined(level.rts.ai[unit]),"Package is referencing undefined ai unit-->"+unit);
			}
		}
		pkg.enforce_deps = [];
		pkg.enforce_deps["axis"] 	= true;
		pkg.enforce_deps["allies"] 	= true;
		
		pkg.squad_type 		= lookup_value( ref, i, TABLE_PKG_SQUAD_TYPE );
		pkg.squad_material	= lookup_value( ref, i, TABLE_PKG_ICON );

		pkg.qty				= [];
		qty			= strtok(lookup_value( ref, i, TABLE_PKG_QTY )," ");
		assert(qty.size >=1 && qty.size <=2, "unexpected qty parameters");
		if ( qty.size == 1 )
		{
			if ( qty[0] == "inf" )
				qty[0] = -1;
			pkg.qty["axis"]	= -1;
			pkg.qty["allies"]	= int(qty[0]);
		}
		else
		{
			if ( qty[0] == "inf" )
				qty[0] = -1;
			if ( qty[1] == "inf" )
				qty[1] = -1;
			pkg.qty["axis"]		= int(qty[0]);;
			pkg.qty["allies"]	= int(qty[1]);
		}

		pkg.min_friendly	= int(lookup_value( ref, i, TABLE_PKG_MIN_IN_PLAY ));
		pkg.max_friendly	= int(lookup_value( ref, i, TABLE_PKG_MAX_IN_PLAY ));
		assert(pkg.min_friendly<=pkg.max_friendly,"Bad data");
		pkg.min_axis	= pkg.min_friendly;
		pkg.max_axis	= pkg.max_friendly;
		
		pkg.hot_key_buy			= lookup_value( ref, i, TABLE_PKG_BINDING_BUY );
		pkg.hot_key_command		= lookup_value( ref, i, TABLE_PKG_BINDING_COMMAND );
		pkg.hot_key_takeover	= lookup_value( ref, i, TABLE_PKG_BINDING_TAKEOVER );

		if (pkg.hot_key_buy != "" )
		{
			maps\_so_rts_support::registerKeyBinding(pkg.hot_key_buy,::package_BuyUnitPressed,pkg);
		}
		else
		{
			pkg.hot_key_buy = undefined;
		}
		if (pkg.hot_key_command != "" )
		{
			maps\_so_rts_support::registerKeyBinding(pkg.hot_key_command,::package_CommandUnitPressed,pkg);
		}
		else
		{
			pkg.hot_key_command = undefined;
		}
		if (pkg.hot_key_takeover != "" )
		{
			maps\_so_rts_support::registerKeyBinding(pkg.hot_key_takeover,::package_TakeOverUnitPressed,pkg);
		}
		else
		{
			pkg.hot_key_takeover = undefined;
		}


		pkg.notifyAvail		= lookup_value( ref, i, TABLE_PKG_NOTIFY);
		if(pkg.notifyAvail == "" )
			pkg.notifyAvail = undefined;
		
		
		pkg.gateFlag 		= lookup_value( ref, i, TABLE_PKG_GATEFLAG);  
		if(pkg.gateFlag == "" )
			pkg.gateFlag = undefined;

		pkg_types[ pkg_types.size ] = pkg;
	}
	return pkg_types;
}

package_CommandUnitPressed(pkg_ref)
{
	//deSelectAll();
	squad = maps\_so_rts_squad::getSquadByPkg( pkg_ref.ref, level.rts.player.team );
	if (isDefined(squad))
	{
		if ( !IS_TRUE(squad.selectable) )
			return;		
			
		direction 		= level.rts.player GetPlayerAngles();
		direction_vec 	= AnglesToForward( direction );
		eye 			= level.rts.player.origin + (0,0,60);
		trace 			= BulletTrace( eye, eye + VectorScale( direction_vec, 100000 ), true, level.rts.player );
		hitEnt			= trace["entity"];
		tracePoint 		= trace["position"];

		/#
		thread maps\_so_rts_support::debugLine( eye, tracePoint, (0,0,1),3  );
		thread maps\_so_rts_support::debug_sphere( tracePoint, 10, (0,0,1), 0.6, 3 );
		#/

		if (flag("fps_mode"))
		{
			level.rts.targetPOI = undefined;
			level.rts.targetTeamEnemy = undefined;
		}

		if (isDefined(hitEnt))
		{
			if ( isDefined(maps\_so_rts_poi::isPOIEnt(hitEnt)) )
			{
				level.rts.targetPOI = hitEnt;
				level.rts.targetTeamEnemy = undefined;
			}
			else
			{
				if (!isDefined(hitEnt.team))
				{
					return; //some random script model or something
				}
				if (hitEnt.team != level.rts.player.team)
				{
					level.rts.targetTeamEnemy = hitEnt;
					level.rts.targetPOI = undefined;
				}
				else
				{
					level.rts.targetTeamEnemy = undefined;
					level.rts.targetPOI = undefined;
				}
			}
		}
		
		if(isDefineD(level.rts.targetTeamEnemy))
		{
			/#
			thread maps\_so_rts_support::debug_sphere( tracePoint, 8, (1,0,0), 0.6, 3 );
			#/
			maps\_so_rts_squad::OrderSquadAttack(squad.id,level.rts.targetTeamEnemy);
		}
		else
		if (isDefined(level.rts.targetPOI) )
		{
			/#
			thread maps\_so_rts_support::debug_sphere( tracePoint, 8, (0,0,1), 0.6, 3 );
			#/
			maps\_so_rts_squad::OrderSquadDefend(level.rts.targetPOI.origin,squad.id);
			if ( level.rts.targetPOI.team != level.rts.player.team )
			{
				if (level.rts.targetPOI.ref.obj_zoff > 0 )
				{
					LUINotifyEvent( &"rts_squad_start_attack", 3, squad.id, level.rts.targetPOI GetEntityNumber(), int(level.rts.targetPOI.ref.obj_zoff) );
				}
				else
				{
					LUINotifyEvent( &"rts_squad_start_attack", 3, squad.id, level.rts.targetPOI GetEntityNumber(), 0 );
				}
				if (flag("fps_mode"))
				{
					maps\_so_rts_event::trigger_event("dlg_target_"+level.rts.targetPOI.ref.ref);
				}
				else
				{
					maps\_so_rts_event::trigger_event(level.rts.targetPOI.ref.ref+"_"+squad.pkg_ref.ref);
				}
			}
		}
		else
		if(isDefineD(level.rts.targetTeamMate))
		{
			/#
			thread maps\_so_rts_support::debug_sphere( tracePoint, 8, (1,0,0), 0.6, 3 );
			#/
			maps\_so_rts_squad::OrderSquadFollowAI(squad.id,level.rts.targetTeamMate);
		}
		else
		if (flag("rts_mode"))
		{
			maps\_so_rts_event::trigger_event("move_"+squad.pkg_ref.ref);
			point = maps\_so_rts_support::playerLinkObj_getTargetGroundPos();
			maps\_so_rts_squad::OrderSquadDefend(point,squad.id);
		}
		else
		{
			level thread maps\_so_rts_squad::rts_move_squadsTocursor(squad.id);
		}
	}
}
package_TakeOverUnitPressed(pkg_ref)
{
	squad = maps\_so_rts_squad::getSquadByPkg( pkg_ref.ref, level.rts.player.team );
	if (isDefined(squad))
	{
		maps\_so_rts_squad::removeDeadFromSquad(squad.id);
		if ( squad.members.size == 0 ||!IS_TRUE(squad.selectable) )
			return;		
		
		maps\_so_rts_event::trigger_event("switch_character");
		maps\_so_rts_event::trigger_event("switch_"+squad.pkg_ref.ref);
		if (flag("rts_mode"))
		{
			//get the closest dude to the cursor of this squad type
			//switch to that dude
			point = maps\_so_rts_support::playerLinkObj_getTargetGroundPos();
			
			closest		= undefined;
			sortedUnits	= sortArrayByClosest(point, squad.members ); 
			for (i=0;i<sortedUnits.size;i++)
			{
				unit = sortedUnits[i];
				if (!maps\_so_rts_ai::ai_IsSelectable(unit))
					continue;
				closest = unit;
				break;			
			}
			level.rts.targetTeamMate = closest;
			thread maps\_so_rts_main::player_in_control();
		}
		else
		{
			direction 		= level.rts.player GetPlayerAngles();
			direction_vec 	= AnglesToForward( direction );
			eye 			= level.rts.player GetEye();
			trace 			= BulletTrace( eye, eye + VectorScale( direction_vec, 10000 ), true, level.rts.player );
			hitEnt			= trace["entity"];
			
			if (isDefined(hitEnt) && isDefined(hitEnt.squadID) && hitEnt.squadID == squad.id)
			{
				thread maps\_so_rts_squad::squadSelectNextAIandTakeOver(squad.id,undefined,hitEnt);
			}
			else
			{
				thread maps\_so_rts_squad::squadSelectNextAIandTakeOver(squad.id);
			}
		}
	}
}


package_BuyUnitPressed(pkg_ref)
{
	level.rts.packages_avail = package_generateAvailable(level.rts.player.team);		
	if (IsInArray(level.rts.packages_avail,pkg_ref) && pkg_ref.selectable)
	{
		package_select(pkg_ref.ref);
	}
	else
	{
		return;
		/*
		switch(pkg_ref.ref)
		{
			case "airstrike_pkg":
				level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_AIRSTRIKE_NOTAVAIL");
				break;
			default:
				level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_UNIT_NOTAVAIL");
			break;
		}
		*/
	}
}


package_GetNumTeamResources(team)
{
	resources = 0;
	
	for(i=0;i<level.rts.packages_avail.size;i++)
	{
		if ( level.rts.packages_avail[i].selectable == false )//cannot use this unit
		{
			continue;
		}
		else
		{	
			resources += (level.rts.packages_avail[i].qty[team]==-1?1:level.rts.packages_avail[i].qty[team]);
		}
	}

	resources += numTransportsInboundForTeam(team);
	foreach (squad in level.rts.squads)
	{
		if (squad.team != team )
			continue;
		resources += squad.members.size;
	}
	
	if (isDefined(level.rts.player.ally))
		resources += 1;
		
	return resources;
}



package_select(pkg_ref,initial=false,cb)
{
	if (!isDefined(pkg_ref) )
	{
		if ( level.rts.packages_avail[ level.rts.package_index ].selectable)
		{
			thread spawn_package( level.rts.packages_avail[ level.rts.package_index ].ref, "allies", initial,cb, level.rts.package_index );
		}
		else
		{
			level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_UNIT_NOTAVAIL");
		}
	}
	else
	{
		for(i=0;i<level.rts.packages_avail.size;i++)
		{
			if (level.rts.packages_avail[ i ].ref == pkg_ref )
			{
				level.rts.package_index = i;
				thread spawn_package( pkg_ref, "allies", initial, cb, level.rts.package_index  );
				break;
			}
		}
	}
}

package_GetPackageByType(ref)
{
	for(i=0;i<level.rts.packages.size;i++)
	{
		if (level.rts.packages[i].ref == ref )
			return level.rts.packages[i];
	}
	return undefined;
}

package_generateAvailable(myteam,forceAll)
{
	if(!isDefined(myteam) )
		myteam = "allies";
		
		
	available_pkgs = [];
	time = GetTime();
	for(i=0;i<level.rts.packages.size;i++)
	{
		pkg = level.rts.packages[i];
	
		if ( pkg.cost[myteam] == -1 )
			continue;
			
		if ( pkg.qty[myteam] == 0 && !IS_TRUE(forceAll) )
			continue;

		if ( isDefined(pkg.gateFlag) && !flag(pkg.gateFlag))
			continue;
			
		pkg.lastSelectableState = pkg.selectable;
		pkg.selectable = (GetTime()> pkg.nextAvail[myteam]);
		if ( IS_TRUE(pkg.enforce_deps[myteam]) && pkg.poi_deps.size > 0 )
		{
			foreach(dep in pkg.poi_deps)					//check to see if all the requisites are owned by player
			{
				poi = strtok(dep,"|");

				hasOne = false;
				for(j=0;j<poi.size;j++)
				{
					actualPoi = maps\_so_rts_poi::getPOIByRef(poi[j]);
					if(!isDefined(actualPoi) || (isDefined(actualPoi) && actualPoi.team == myteam))
					{
						hasOne = true;
						break;
					}
				}

				if (!hasOne )
				{
					pkg.selectable = false;
					break;
				}
			}
		}
		
		available_pkgs[available_pkgs.size] = pkg; 		//add pkg even if not selectable. 
	}
	if(!isDefineD(forceAll))
	{
		foreach(pkg in available_pkgs)
		{
			if ( isDefined(pkg.notifyAvail) && pkg.selectable == true && pkg.selectable != pkg.lastSelectableState)
			{
				level notify(pkg.notifyAvail);
			}
		}
	}
	
	return available_pkgs;
}


setPkgDelivery(ref,delivery)
{
	assert(isDefined(delivery));
	assert(delivery == "STANDARD" || delivery == "CODE" || delivery == "FASTROPE_HELO" || delivery == "FASTROPE_VTOL" || delivery == "CARGO_VTOL", "Unknown delivery option");
	
	pkg_ref = package_GetPackageByType(ref);
	if(isDefined(pkg_ref))
	{
		pkg_ref.delivery = delivery;
	}
}

setPkgQty(ref,team,qty)
{
	pkg_ref = package_GetPackageByType(ref);
	if(isDefined(pkg_ref))
	{
		pkg_ref.qty[team] = qty;
		/#
			println("Setting pkg quantity for ("+ref+") of team:"+team+" to:"+qty);
		#/
	}
}

setPkgDependancyEnforcement(ref,team,state)
{
	pkg_ref = package_GetPackageByType(ref);
	if(isDefined(pkg_ref))
	{
		pkg_ref.enforce_deps[team] = state;
	}
}


canDeliverPkg(team,delivery,pkg_ref)
{
	if ( pkg_ref.delivery == "CODE" || pkg_ref.delivery == "STANDARD" )
	{
		if ( pkg_ref.nextAvail["allies"] > GetTime() )
		{
			return "not_ready";
		}
	}
	
	if ( pkg_ref.qty[team] != -1 )
	{ 
		if ( pkg_ref.qty[team] > 0 ) 
			return "ok";
		else
			return "not_ready";
	}
	return "ok";
}



spawn_package(package_name, team, initial, callback, slotidx)
{
	pkg_ref = maps\_so_rts_catalog::package_GetPackageByType(package_name);
	assert(isDefined(pkg_ref));
	
	delivery = pkg_ref.delivery;
	if ( IS_TRUE(initial) && delivery !="CODE" )
	{
		delivery = "STANDARD";
	}
	
	
	//get the newly spawned units into the battle field
	if (delivery=="STANDARD"||delivery=="CODE")
	{
		if ( IS_TRUE(initial) || (pkg_ref.selectable && GetTime()> pkg_ref.nextAvail[team]))
		{
			if (pkg_ref.qty[team] > 0 )
				pkg_ref.qty[team]--;
				
			if (team == level.rts.player.team )
			{
				level.rts.last_pkg = pkg_ref.ref;
			}
			pkg_ref.nextAvail[team] = GetTime() + pkg_ref.cost[team];

			switch(delivery)
			{
				case "STANDARD": //spawn around team bases
					squadID = maps\_so_rts_ai::spawn_ai_package_standard(pkg_ref, team, callback);
					if (isDefined(squadID) && squadID == -1 )
						squadID = undefined;
					return squadID;

				break;
				case "CODE":
					squadID = maps\_so_rts_catalog::spawn_package_code(pkg_ref, team, callback);
					if (isDefined(squadID) && squadID == -1 )
						squadID = undefined;
						return squadID;
				break;
			}
		}
		else
		{
			return undefined;
		}
	}
		

	result = canDeliverPkg(team,delivery,pkg_ref);
	if ( result == "ok" )
	{
		
		//get the newly spawned units into the battle field
		cb = undefined;
		type = "helo";
		switch(delivery)
		{
			case "FASTROPE_HELO":
				cb = maps\_so_rts_ai::spawn_ai_package_helo;
			break;
			case "FASTROPE_VTOL":
				cb = maps\_so_rts_ai::spawn_ai_package_helo;
				type = "vtol";
			break;
			case "CARGO_VTOL":
				cb = maps\_so_rts_ai::spawn_ai_package_cargo;
				type = "vtol";
			break;
			default:
				assert(0,"Unhandled case");
			break;
		}

		unit = allocateTransport(team, type, pkg_ref,cb, callback, slotidx);
		if (isDefined(unit) )
		{
			if (team == level.rts.player.team )
			{
				level.rts.last_pkg = pkg_ref.ref;
			}
			if (pkg_ref.qty[team] > 0 )
				pkg_ref.qty[team]--;
		}
	}
	if (result == "ok" && IsDefined(unit) )
		return unit.squadID;
		
		
	return undefined;
}

spawn_package_code(pkg_ref, team, callback)		//special case
{
	if(isDefined(level.rts.codeSpawnCB))
	{
		squadID = [[level.rts.codeSpawnCB]](pkg_ref,team,callback);
		assert(isDefined(squadID),"Custom Code must return squadID");
		return squadID;
	}
		
	foreach(unit in pkg_ref.units)
	{
		switch(unit)
		{
			case "airstrike":
				thread maps\_so_rts_support::fire_missile();
			break;
			default:
				assert(0,"Unhandled case");
			break;
		}
	}
	return -1;
}



transportThink(unit)
{
	level endon("rts_terminated");
	flag_wait("start_rts");

	unit.state 		= TRANSPORT_STATUS_AVAIL;
	unit.refuelTime = 0;
	unit.loadTime 	= 0;

	waittillframeend;

	while(1)
	{
		switch(unit.state)
		{
			case TRANSPORT_STATUS_AVAIL:
			break;
			case TRANSPORT_STATUS_REFUELING:
				if (GetTime() > unit.refuelTime)
				{
					unit.delivered_pkg 	= undefined;
					unit.state 			= TRANSPORT_STATUS_AVAIL;
					unit.refuelTime 	= 0;
					unit.loadTime 		= 0;
				}
				else
				{
					if(!IS_TRUE(level.rts.blockFastDelivery) && unit.team != level.rts.player.team && level.rts.squads[unit.squadID].members.size == 0 )
					{
						unit.refuelTime = GetTime();
						/#
						println("@@@@@@@@@@@@@@@@@@@  Transport refuel time for ["+unit.delivered_pkg.ref+"] zero'd out due to insufficient units (0)");
						#/
					}
				}
			break;
			case TRANSPORT_STATUS_BEINGLOADED:
				if (GetTime() > unit.loadTime)
				{
					if (unit.team == "allies")
					{
						maps\_so_rts_event::trigger_event("inc_"+unit.pkg_ref.ref);
					}
					unit.state = TRANSPORT_STATUS_INFLIGHT;
					if ([[unit.cb]](unit) == -1 )
					{
						unit.delivered_pkg 	= undefined;
						unit.state 			= TRANSPORT_STATUS_AVAIL;
						unit.refuelTime 	= 0;
						unit.loadTime 		= 0;
					}
					unit.flightAnnounce = GetTime()+4000;
				}
				else
				{
					if(!IS_TRUE(level.rts.blockFastDelivery) && unit.team != level.rts.player.team && level.rts.squads[unit.squadID].members.size == 0 )
					{
						unit.loadTime = GetTime();
						/#
						println("@@@@@@@@@@@@@@@@@@@  Transport loadTime for ["+unit.pkg_ref.ref+"] zero'd out due to insufficient units (0)");
						#/
					}
				}
			break;
			case TRANSPORT_STATUS_INFLIGHT:
				if ( isDefined(unit.flightAnnounce) && GetTime() > unit.flightAnnounce && unit.team == "allies" )
				{
					unit.flightAnnounce = undefined;
					maps\_so_rts_event::trigger_event("fly_"+unit.pkg_ref.ref);
				}
			break;
		}
	
		wait 0.25;
	}
}

getNumTransports(type,team,avail)
{
	count = 0;
	
	if (type == "helo" )
		transports = level.rts.transport.helo;
	else	
	if (type == "vtol" )
		transports = level.rts.transport.vtol;
		
	for(i=0;i<transports.size;i++)
	{
		if ( transports[i].team == team )
		{
			if (isDefined(avail) )
			{
				if ( transports[i].state == TRANSPORT_STATUS_AVAIL )
					count ++;
			}
			else
			{
				count ++;
			}
			
		}
	}
	return count;
}

///////////////////////////////////////////////////////////////////////////////////////
units_delivered(team,squadID)
{
	maps\_so_rts_squad::squad_unloaded(squadID);
	if (team == level.rts.player.team )
	{
		level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_DELIVERY_ARRIVED");
		level.rts.squads[squadID].selectable = true;
	}
	else
	{
		level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_ENEMY_ARRIVED");
	}
}


unloadTransport(unit)
{
	unit.delivered_pkg 	= unit.pkg_ref;
	unit.cb 	 		= undefined;
	unit.param			= undefined;
	unit.pkg_ref		= undefined;
}

deallocateTransport(unit)
{
	unit.refuelTime = GetTime() + level.rts.transport_refuel_delay;
	unit.state 		= TRANSPORT_STATUS_REFUELING;
	
}

isTransportAvailable(team,type)
{
	availtransport = undefined;

	if (type == "helo" )
		transports = level.rts.transport.helo;
	else	
	if (type == "vtol" )
		transports = level.rts.transport.vtol;
	else
		assert(0,"bad type passed");


	for(i=0;i<transports.size;i++)
	{
		if ( transports[i].team == team && transports[i].state == TRANSPORT_STATUS_AVAIL )
		{
			availtransport = transports[i];
			break;
		}
	}
	return (isDefined(availtransport));
}

allocateTransport(team,type,pkg_ref,cb,paramCB, slotidx)
{
	availtransport = undefined;

	if (type == "helo" )
		transports = level.rts.transport.helo;
	else	
	if (type == "vtol" )
		transports = level.rts.transport.vtol;
	else
		assert(0,"bad type passed");


	for(i=0;i<transports.size;i++)
	{
		if ( transports[i].team == team && transports[i].state == TRANSPORT_STATUS_AVAIL )
		{
			availtransport = transports[i];
			break;
		}
	}
	
	if ( isDefined(availtransport) )
	{
		availtransport.cb 	 		= cb;
		availtransport.param		= paramCB;
		availtransport.pkg_ref		= pkg_ref;
		availtransport.type			= type;
		availtransport.state 		= TRANSPORT_STATUS_BEINGLOADED;
		availtransport.loadTime 	= GetTime() + pkg_ref.cost[team];
		availtransport.dropTarget 	= get_package_drop_target( team );
		availtransport.squadID 		= maps\_so_rts_squad::createSquad( availtransport.dropTarget, team, pkg_ref ); //every PACKAGE spawned should have a unique identifyer
		if (team==level.rts.player.team)
		{
			startLoc 	= maps\_so_rts_support::get_transport_startLoc(availtransport.dropTarget );
			lastNode 	= startLoc;
			unloadNode 	= undefined;
			while ( isdefined( lastNode.target ) )
			{
				if ( !isDefined(unloadNode) && isdefined( lastNode.script_unload ) )
				{
					unloadNode = lastNode;
				}
				
				lastNode = GetVehicleNode( lastNode.target, "targetname" );
			}

			assert(isDefined(unloadNode),"no script_unload was found");
			timeTo 		= GetTimeFromVehicleNodeToNode( startLoc, unloadNode )*1000 + pkg_ref.cost[team];	
			timeBack 	= GetTimeFromVehicleNodeToNode( unloadNode, lastNode )*1000 + level.rts.transport_refuel_delay;

   	/#
     		 PrintLn( "**** transport - timeTo: (" + timeTo + ")   timeBack: (" + timeBack + ")" );
   #/
//	   		if ( level.rts.squads[availtransport.squadID].members.size == 0  )
			if (team=="allies" && isDefined(pkg_ref.hot_key_takeover) )
   			{
   				LUINotifyEvent( &"rts_add_squad", 3, availtransport.squadID, pkg_ref.idx, int( timeTo ) );
   			}
		}
		
	}
	return availtransport;
}

getNumberOfPkgsBeingTransported(team,ref)
{
	transports = ArrayCombine(level.rts.transport.helo,level.rts.transport.vtol, false, false);
	
	count = 0;
	for(i=0;i<transports.size;i++)
	{
		if ( transports[i].team == team && 
			 transports[i].state != TRANSPORT_STATUS_AVAIL && 
			 isDefined(transports[i].pkg_ref) && transports[i].pkg_ref.ref == ref 
		   )
		{
			count++;
		}
	}
	return count;
}

getNumberOfTypeBeingTransported(team,pkgType)
{
	transports = ArrayCombine(level.rts.transport.helo,level.rts.transport.vtol, false, false);
	
	count = 0;
	for(i=0;i<transports.size;i++)
	{
		if ( transports[i].team == team && 
			 transports[i].state != TRANSPORT_STATUS_AVAIL && 
			 isDefined(transports[i].pkg_ref) && transports[i].pkg_ref.squad_type == pkgType 
		   )
		{
			count++;
		}
	}
	return count;
}

numTransportsInboundForTeam(team)
{
	transports = ArrayCombine(level.rts.transport.helo,level.rts.transport.vtol, false, false);
	
	count = 0;
	for(i=0;i<transports.size;i++)
	{
		if ( transports[i].team == team && transports[i].state != TRANSPORT_STATUS_AVAIL && isDefined(transports[i].pkg_ref) )
		{
			count ++;
		}
	}
	return count;
}
