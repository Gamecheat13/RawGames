#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_so_rts.gsh;



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// rts.csv table column defines 
#define TABLE_IDX					0
#define TABLE_POI_REF 				1	// package type ref
#define TABLE_POI_MODEL				2	// model to represent
#define TABLE_POI_HEALTH			3	// hitpoints
#define TABLE_POI_CAPTIME			4	// capture time if applicable
#define TABLE_POI_INTRUDERCAP		5	// requires intruder device to cap
#define TABLE_POI_TEAM 				6	// deafult team
#define TABLE_POI_OBJECTIVE			7	// objective text
#define TABLE_POI_OBJ_ZOFF			8	// objective text offset(z)
#define TABLE_POI_RETAKE			9	// 0 one time, 1 domination retake
#define TABLE_POI_SHOWCOMPASS		10	// compass icon
#define TABLE_POI_INDEX_START 		200 // First index for POI Table
#define TABLE_POI_INDEX_END 		210	// Last index for POI Table
#define POI_THINK_TIME	1
	
#define POI_CAPTURE_RADIUS			450

preload()
{
	assert(isdefined( level.rts) );
	assert(isdefined( level.rts_def_table ) );
		
	level.rts.poi			= [];
	level.rts.poi			= poi_populate();	
	
	foreach(poi in level.rts.poi)
	{
		if (isDefined(poi.model) && poi.model !="" )
		{
			precacheModel(poi.model);
		}
		if (isDefined(poi.compassIcon) && poi.compassIcon !="" )
		{
			precacheShader(poi.compassIcon);
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
get_poi_ref_by_index( idx )
{
	return tablelookup( level.rts_def_table, TABLE_IDX, idx, TABLE_POI_REF );
}

init()
{	
	InitPOIs();
}

poi_populate()
{
	poi_types	= [];

	for( i = TABLE_POI_INDEX_START; i <= TABLE_POI_INDEX_END; i++ )
	{		
		ref = get_poi_ref_by_index( i );
		if ( !isdefined( ref ) || ref == "" )
			continue;
		
		poi 				= spawnstruct();
		poi.idx				= i;
		poi.ref				= ref;
		poi.model			= lookup_value( ref, i, TABLE_POI_MODEL );
		poi.health			= int(lookup_value( ref, i, TABLE_POI_HEALTH ));
		poi.capture_time	= int(lookup_value( ref, i, TABLE_POI_CAPTIME ));
		poi.need_device		= int(lookup_value( ref, i, TABLE_POI_INTRUDERCAP ));
		poi.team			= lookup_value( ref, i, TABLE_POI_TEAM );
		poi.objtext			= lookup_value( ref, i, TABLE_POI_OBJECTIVE );
		poi.obj_zoff		= int(lookup_value( ref, i, TABLE_POI_OBJ_ZOFF ));
		poi.canbe_retaken	= int(lookup_value( ref, i, TABLE_POI_RETAKE ));
		poi.compassIcon		= lookup_value( ref, i, TABLE_POI_SHOWCOMPASS );



		if ( poi.model == "" )
			poi.model = undefined;
		if ( poi.objtext == "" )
			poi.objtext = undefined;
		if ( poi.compassIcon == "" )
			poi.compassIcon = undefined;

		poi_types[ poi_types.size ] = poi;
	}
	return poi_types;
}

///////////////////////////////////////////////////////////////////////////////////////
checkpoint_save_restored()
{
	wait 3;
	numPOIsWithCaptureTime = 0;
	foreach (poi in level.rts.poi)
	{
		if (!isDefined(poi.entity) )
		{
			poi.entity		= GetEnt(poi.ref,"targetname");
		}
		
		if ( isDefined(poi.entity) )
		{
			poiNum = 0;
			if ( poi.capture_time > 0 )
			{
				numPOIsWithCaptureTime++;
				poiNum = numPOIsWithCaptureTime;
			}
			
			LUINotifyEvent( &"rts_add_poi", 2, poi.entity GetEntityNumber(), poiNum );
			
		
			if (poi.entity.team == "allies" )
			{
				LUINotifyEvent( &"rts_protect_poi", 1, poi.entity GetEntityNumber() );
			}
			if ( poi.capture_time > 0 )
			{
				LUINotifyEvent( &"rts_secure_poi", 1, poi.entity GetEntityNumber() );
			}

		}
	}
}

deleteAllPoi(substr)
{
	valid = [];
	for(i=0;i<level.rts.poi.size;i++)
	{
		poi = level.rts.poi[i];
		if (isDefined(substr))
		{
			if (!issubstr(poi.ref,substr))
			{
				valid[valid.size] = poi;
				continue;
			}
		}
		level notify( "poi_deleted_"+poi.ref);
		
		if(isDefined(poi.entity))
		{
			poi.entity maps\_so_rts_support::set_gpr(maps\_so_rts_support::make_gpr_opcode(GPR_OP_CODE_BAR) + 0);
			poi.entity notify("taken_perm");
			LUINotifyEvent( &"rts_captured_poi", 1, poi.entity GetEntityNumber() );
			poi.entity delete();
		}
		if(isDefined(poi.trigger))
			poi.trigger delete();
	}
	level.rts.poi = valid;
}

add_poi(ref,entity,team,ui=true)
{
	poi 	= getPOIByRef(ref);
	
	if ( isDefined(poi) && isDefined(entity) )
	{
		poi.entity	= entity;
		poi.origin  = poi.entity.origin;
		poi.angles  = poi.entity.angles;
		if (isDefined(poi.model) && poi.model != "")
		{
			poi.entity SetModel( poi.model );
			poi.entity DisconnectPaths();
		}
		ClaimPOI(poi,poi.team);
		poi.entity.ref 	= poi;
		if ( poi.health > 0 )
		{
			poi.entity.health 		= poi.health;
			poi.entity.takedamage 	= true;
		}
		else
		{
			poi.entity.health 		= 100;
			poi.entity.takedamage 	= false;
		}
		poiNum = 0;
		if ( poi.capture_time > 0 )
		{
			level.numPOIsWithCaptureTime++;
			poiNum = level.numPOIsWithCaptureTime;
		}
		/#
		println("$$$$ Adding POI("+poiNum+"): " +ref+" at ("+entity.origin+") EntNum: "+(entity GetEntityNumber()));
		#/
		if (IS_TRUE(ui))
		{
			LUINotifyEvent( &"rts_add_poi", 2, poi.entity GetEntityNumber(), poiNum );
			if (poi.entity.team == "allies" )
			{
				LUINotifyEvent( &"rts_protect_poi", 1, poi.entity GetEntityNumber() );
			}
			if ( poi.capture_time > 0 )
			{
				LUINotifyEvent( &"rts_secure_poi", 1, poi.entity GetEntityNumber() );
			}
		}
		level thread poiThink(poi);
	}
}



InitPOIs()
{
	level.poiObjectiveNum = 0;

	//choose random bases
	level.rts.allied_center = GetEnt("rts_player_center","targetname");
	level.rts.enemy_center =  GetEnt("rts_enemy_center","targetname");
	assert(isDefined(level.rts.allied_center),"spawn center not defined");
	assert(isDefined(level.rts.enemy_center),"spawn center not defined");
	assert(maps\_so_rts_support::clampEntToMapBoundary(level.rts.allied_center),"This location is out of boundary");
	assert(maps\_so_rts_support::clampEntToMapBoundary(level.rts.enemy_center),"This location is out of boundary");
	
	level.numPOIsWithCaptureTime = 0;

	if (level.rts.game_mode == "attack" )
	{
		level.rts.allied_base = getPOIByRef("rts_base_player");
		level.rts.enemy_base =  getPOIByRef("rts_base_enemy");
		baseEntities 	= [];
		baseEntities[0] = GetEnt("rts_base_enemy","targetname");
		baseEntities[1] = GetEnt("rts_base_player","targetname");
		baseEntities 	= ArrayCombine(baseEntities,GetEntArray("rts_base","targetname"), false, false);
		if (level.rts.game_rules.randomize_side!= 0)
		{
			baseEntities = array_randomize(GetEntArray("rts_base","targetname"));
		}
		assert(baseEntities.size>=2,"Not enough script origins with targetname 'rts_base'");
		level.rts.enemy_base.entity 	= baseEntities[0];
		level.rts.allied_base.entity 	= baseEntities[1];
		ClaimPOI(level.rts.allied_base,"allies");
		ClaimPOI(level.rts.enemy_base,"axis");
	}


	foreach (poi in level.rts.poi)
	{
		if (!isDefined(poi.entity) )
		{
			poi.entity		= GetEnt(poi.ref,"targetname");
		}
		
		if ( isDefined(poi.entity) )
		{
			assert (isDefined(poi.model),"Entity declared as POI but no model specified");
			ent 		= poi.entity;
			poi.entity 	= Spawn( "script_model", ent.origin, 1); // spawnflag for dynamicpath
			poi.entity.angles = ent.angles;
			poi.entity.targetname = ent.targetname;
			ent Delete();
			
			poi.entity.ref 	= poi;
			poi.origin = poi.entity.origin;
			if ( poi.health > 0 )
			{
				poi.entity.health 		= poi.health;
				poi.entity.takedamage 	= true;
			}
			else
			{
				poi.entity.health 		= 100;
				poi.entity.takedamage 	= false;
			}

			add_poi(poi.ref,poi.entity,poi.team,true);
		}
	}
	
	// enemies should shoot at the player's base
	if ( isDefined(level.rts.allied_base) && isDefined(level.rts.allied_base.entity) )
	{
		level.rts.allied_base.entity maps\_so_rts_support::set_as_target( "allies" );
	}
}


ClaimPOI(poi,team)
{
	poi.team = team;
	if(isDefined(poi.entity))
	{
		poi.entity.team = team;
	}
	
	if ( team == "axis" )
	{
		poi.dominate_weight = -poi.capture_time;
	}
	else
	if ( team == "allies" )
	{
		poi.dominate_weight = poi.capture_time;
	}
	else
	{
		poi.dominate_weight = 0;
	}

	if( IsDefined( poi.claimCallback ) )
	{
		poi thread [[ poi.claimCallback ]]( team );
	}
}

getPOIByRef(refName)
{
	foreach(poi in level.rts.poi)
	{
		if (poi.ref == refName)
			return poi;
	}
	return undefined;
}
getPOIEnts()
{
	ents = [];
	foreach(poi in level.rts.poi)
	{
		if (isDefined(poi.entity) )
			ents[ents.size] = poi.entity;
	}
	return ents;
}

poi_AddObjective(poi)
{
	if( !isDefined(poi.objtext) && !isDefined(poi.compassIcon) )
		return;
	
	// add compass objective
	if( isDefined(poi.objtext) )
	{
		Objective_Add( level.poiObjectiveNum, "active", poi.objtext, poi.entity );	
	}
	if( isDefined(poi.compassIcon) )
	{
		Objective_Icon( level.poiObjectiveNum, poi.compassIcon );
		Objective_Size( level.poiObjectiveNum, poi.trigger GetEntityNumber() );
	}
	poi.objectiveNum = level.poiObjectiveNum;
	level.poiObjectiveNum++;
}


getPOIObjectives()
{
	pois = [];
	
	foreach(poi in level.rts.poi)
	{
		if (poi.capture_time > 0 )
			pois[pois.size] = poi;
	}
	return pois;
}

poi_DeathWatch(poi)
{
	level endon( "rts_terminated" );
	level endon( "poi_deleted_"+poi.ref);
	//got to tickle it twice to get bar up
	
	team 	= self.team;
	origin 	= self.origin;
	entNum 	= self GetEntityNumber();
	if ( team == "axis" )
	{
		enemy_team = "allies";
	}
	else
	{
		enemy_team = "axis";
		LUINotifyEvent( &"rts_protect_poi", 1, entNum );
	}
	
	dmg_stage_1 = false;
	dmg_stage_2 = false;
	max_health 	= self.health;
	next_dmg_alert	= 0;
	
	while(isDefined(self) && self.health>0)
	{
		self waittill("damage");
		if ( team == level.rts.player.team )
		{
			if ( GetTime() > next_dmg_alert )
			{
				maps\_so_rts_event::trigger_event("base_damaged");
				level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_ALLY_BASE_DAMAGE");	
				next_dmg_alert = GetTime() + 15000;
			}
		    else
		    {
				maps\_so_rts_event::trigger_event("base_attacked");
		    }
		}
		
		if (!dmg_stage_1 && (self.health<(max_health*0.9)))
		{
			next_dmg_alert = GetTime();
			dmg_stage_1 = true;
			maps\_so_rts_event::trigger_event("fx_base_damage_1",origin);
		}
		if (!dmg_stage_2 && (self.health<(max_health*0.5)))
		{
			next_dmg_alert = GetTime();
			dmg_stage_2 = true;
			maps\_so_rts_event::trigger_event("fx_base_damage_2",origin);
		}
		
		health = self.health;
		if ( health < 0 )
			health = 0;
	}

	level notify(poi.ref+"_destroyed",poi.entity);
	LUINotifyEvent( &"rts_protect_poi", 1, entNum );//TODO MATTIS, protect shoudl turn off.. this didnt work.

	if ( team != level.rts.player.team  )
	{
		maps\_so_rts_rules::mission_complete(true);
	}
	else
	if ( team == level.rts.player.team )
	{
		maps\_so_rts_event::trigger_event("player_base_destroyed");
		level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_ALLY_BASE_DESTROYED");
		maps\_so_rts_rules::mission_complete(false,true);
		maps\_so_rts_ai::removeBaseAsThreat();
	}

	maps\_so_rts_event::trigger_event("multi_base_destruction_"+team,origin);
	ArrayRemoveValue(level.rts.poi,poi);
}
	
poi_DominationWatch(poi)
{
	level endon( "rts_terminated" );
	level endon( "poi_deleted_"+poi.ref);

	LUINotifyEvent( &"rts_secure_poi", 1, poi.entity GetEntityNumber() );
	
	poi.trigger = spawn("trigger_radius", poi.entity.origin, 0, POI_CAPTURE_RADIUS, 64);
	time_required_to_dominate 	=  poi.capture_time;
	time_required_to_dominate2x = time_required_to_dominate+time_required_to_dominate;

	lastVal = 0;

	while(1)
	{
		poi.touchers["axis"] 	= 0;
		poi.touchers["allies"] 	= 0;
		aiTouchers 				= poi.trigger maps\_so_rts_support::get_ents_touching_trigger();

		foreach (ai in aiTouchers )
		{
			if (ai.team == "allies")
			{				
				poi.dominate_weight += POI_THINK_TIME;
			}
			else
			{
				poi.dominate_weight -= POI_THINK_TIME;
			}
			
			poi.touchers[ai.team]++;
		}
		
		if (poi.dominate_weight >= time_required_to_dominate )
		{
			poi.dominate_weight = time_required_to_dominate;
			if(poi.entity.team != "allies" )
			{
				ClaimPOI(poi,"allies");
				level notify("poi_captured_allies",poi.entity);
			}
		}
		else
		if (poi.dominate_weight <= -time_required_to_dominate )
		{
			poi.dominate_weight = -time_required_to_dominate;
			if(poi.entity.team != "axis" )
			{
				ClaimPOI(poi,"axis");
				level notify("poi_captured_axis",poi.entity);
			}
		}
		else
		{
			if ( poi.entity.team != "none")
			{
				ClaimPOI(poi,"none");
				level notify("poi_contested",poi.entity);
			}
		}

		wait (POI_THINK_TIME);
	}
}


poi_CaptureWatch(poi)
{
	level endon( "rts_terminated" );
	level endon( "poi_deleted_"+poi.ref);
	
	LUINotifyEvent( &"rts_secure_poi", 1, poi.entity GetEntityNumber() );
	
	poi.trigger = spawn("trigger_radius", poi.entity.origin, 0, POI_CAPTURE_RADIUS, 64);
	time_required_to_dominate 	=  poi.capture_time;
	time_required_to_dominate2x = time_required_to_dominate+time_required_to_dominate;
	
	poi_AddObjective(poi);
	
	// network intruder hint trigger
	poi.intruder_trigger = spawn("trigger_radius", poi.entity.origin, 0, POI_CAPTURE_RADIUS / 2, 64);
	poi.intruder_trigger thread watchNetworkIntruder( poi );
	poi.has_intruder = false;

	lastVal = 0;

	while(1)
	{
		networkIntruders = poi.trigger maps\_so_rts_support::get_ents_touching_trigger( level.rts.networkIntruders );
		
		// dominate if there's a network intruder present
		if( networkIntruders.size > 0 )
		{				
			poi.dominate_weight += POI_THINK_TIME;
			if (!IS_TRUE(poi.has_intruder) )
			{
				poi.has_intruder = true;
				level notify("poi_contested",poi.entity);
			}
		}
		else // have AI place a network intruder if there isn't one already
		{
			// have the enemy take it back over
			if( poi.dominate_weight != -time_required_to_dominate && poi.dominate_weight < time_required_to_dominate )
			{
				ClaimPOI(poi,"axis");
				if (IS_TRUE(poi.has_intruder))
				{
					level notify("poi_nolonger_contested",poi.entity);
				}
			}
			poi.has_intruder = false;
				
			//AI only plant in RTS mode;
			if(flag("rts_mode") && !IS_TRUE( poi.intruder_being_planted ) )//player plant sets this
			{
				aiTouchers = poi.trigger maps\_so_rts_support::get_ents_touching_trigger( GetAIArray("allies") );
				foreach( ai in aiTouchers )
				{
					if( ai != level.rts.player && ai.ai_ref.species != "human" )
						continue;
						
					if( ai.team == "allies")
					{
						if (!isDefined(poi.ai_intruder_plant_attempt) || GetTime() > poi.ai_intruder_plant_attempt )
						{
							ai maps\_so_rts_support::ai_plant_network_intruder(poi);
						}
						break;
					}
				}
			}
		}
	
		if (poi.dominate_weight >= time_required_to_dominate )
		{
			poi.dominate_weight = time_required_to_dominate;
			if( poi.entity.team != "allies" )
			{
				ClaimPOI(poi,"allies");
				level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_INFRA_WON");
				level notify("poi_captured_allies",poi.ref);
				maps\_so_rts_event::trigger_event("poi_captured");
				poi.captured = true;
				poi.trigger delete();
				poi.trigger = undefined;
				val = maps\_so_rts_support::make_gpr_opcode(GPR_OP_CODE_BAR) + 0;
				poi.entity thread maps\_so_rts_support::set_gpr(val);
				poi.entity notify("taken_perm");
				LUINotifyEvent( &"rts_captured_poi", 1, poi.entity GetEntityNumber() );
				
				// remove the network intruders
				foreach( unit in networkIntruders )
				{
					unit DoDamage( 10000, unit.origin, unit );
				}
				
				ArrayRemoveValue(level.rts.poi,poi);
				if( IsDefined( poi.objectiveNum ) )
				{
					Objective_Delete( poi.objectiveNum );
				}
				
				return;
			}
		}
		else
		if( poi.dominate_weight <= -time_required_to_dominate )
		{
			poi.dominate_weight = -time_required_to_dominate;
		}

		wait (POI_THINK_TIME);
		if (poi.dominate_weight!=lastVal )
		{
			//ent #, currentProg
			progress = (poi.dominate_weight + time_required_to_dominate) / ( time_required_to_dominate*2);  //the bar starts at -time (fully controlled by axis, 0 is neurtral, +time = ally)
			//LUINotifyEvent( &"rts_poi_prog", 2, poi.entity GetEntityNumber(), progress ); 
			lastVal = poi.dominate_weight;
			val = maps\_so_rts_support::make_gpr_opcode(GPR_OP_CODE_BAR) + ((time_required_to_dominate*2)<<8) + (poi.dominate_weight + time_required_to_dominate);
			poi.entity thread maps\_so_rts_support::set_gpr(val);
		}
	}
}



poi_Watch(poi)
{
	level endon( "rts_terminated" );
	level endon( "poi_deleted_"+poi.ref);

	LUINotifyEvent( &"rts_secure_poi", 1, poi.entity GetEntityNumber() );
	
	poi.trigger = spawn("trigger_radius", poi.entity.origin, 0, POI_CAPTURE_RADIUS, 64);
	time_required_to_dominate 	=  poi.capture_time;
	time_required_to_dominate2x = time_required_to_dominate+time_required_to_dominate;

	lastVal = 0;

	while(isDefined(poi.trigger))
	{
		poi.touchers["axis"] 	= 0;
		poi.touchers["allies"] 	= 0;
		aiTouchers 				= poi.trigger maps\_so_rts_support::get_ents_touching_trigger();

		foreach (ai in aiTouchers )
		{
			if ( ai.team == "neutral" )
				continue;
				
			if (ai.team == "allies")
			{				
				poi.dominate_weight += POI_THINK_TIME;
			}
			else
			{
				poi.dominate_weight -= POI_THINK_TIME;
			}
			
			poi.touchers[ai.team]++;
		}
		if (poi.dominate_weight >= time_required_to_dominate )
		{
			poi.dominate_weight = time_required_to_dominate;
			if( poi.entity.team != "allies" )
			{
				ClaimPOI(poi,"allies");
				level notify("poi_captured_allies",poi.ref);
				maps\_so_rts_event::trigger_event("poi_captured");
				poi.captured = true;
				poi.trigger delete();
				poi.trigger = undefined;
				val = maps\_so_rts_support::make_gpr_opcode(GPR_OP_CODE_BAR) + 0;
				poi.entity thread maps\_so_rts_support::set_gpr(val);
				poi.entity notify("taken_perm");
				LUINotifyEvent( &"rts_captured_poi", 1, poi.entity GetEntityNumber() );
				
				ArrayRemoveValue(level.rts.poi,poi);
				return;
			}
		}
		else
		if( poi.dominate_weight <= -time_required_to_dominate )
		{
			poi.dominate_weight = -time_required_to_dominate;
		}

		wait (POI_THINK_TIME);
		if (poi.dominate_weight!=lastVal )
		{
			//ent #, currentProg
			progress = (poi.dominate_weight + time_required_to_dominate) / ( time_required_to_dominate*2);  //the bar starts at -time (fully controlled by axis, 0 is neurtral, +time = ally)
			//LUINotifyEvent( &"rts_poi_prog", 2, poi.entity GetEntityNumber(), progress ); 
			lastVal = poi.dominate_weight;
			val = maps\_so_rts_support::make_gpr_opcode(GPR_OP_CODE_BAR) + ((time_required_to_dominate*2)<<8) + (poi.dominate_weight + time_required_to_dominate);
			poi.entity thread maps\_so_rts_support::set_gpr(val);
		}
	}
}


isPOIEnt(ent)
{	
	foreach(poi in level.rts.poi)
	{
		if ( isDefined(poi.entity) && ent == poi.entity )
		{
			return poi.ref;
		}
	}
	return undefined;
}


poiThink(poi)
{
	if ( IS_TRUE(poi.entity.takedamage) )
	{//this POI has hitpoints;
		assert(isDefined(poi.entity.health) && poi.entity.health < 65535,"POI health is set beyond maximum");
		poi.entity thread poi_DeathWatch(poi);
	}
	else
	if ( poi.capture_time > 0 && poi.canbe_retaken != 0 ) //domination style poi
	{
		level thread poi_DominationWatch(poi);
	}
	else
	if ( poi.capture_time > 0 && poi.canbe_retaken == 0 ) //domination style poi
	{
		if ( IS_TRUE(poi.need_device) )
		{
			level thread poi_CaptureWatch(poi);
		}
		else
		{
			level thread poi_Watch(poi);
		}
	}
	else
	{
		assert(0,"unhandled POI logic");
	}
}

getClosestPOI(myOrigin,myTeam,threshSQ)
{
	closest	 		= undefined;
	closestSQ		= 9999999;
	foreach (poi in level.rts.poi)
	{
		if (isDefined(myTeam))
		{
			if (poi.team == myTeam )
				continue;
		}
			
		distSQ = distanceSquared(poi.entity.origin, myOrigin );
		if (isDefined(threshSQ) && distSQ>threshSQ)
			continue;
			
		if ( distSQ < closestSQ )
		{
			closestSQ = distSQ;
			closest   = poi;
		}
	}

	return closest;
}

poi_AI_AttemptTakeover(poi)//self == ai
{
	level endon( "rts_terminated" );
	self endon("death");
	self endon("new_squad_orders");
	self notify("poi_AI_AttemptTakeover");
	self endon ("poi_AI_AttemptTakeover");
	self endon("taken_perm");

	wait (RandomFloat(2));

	if (!isDefined(self.last_goalradius) )
	{
		self.last_goalradius 	= self.goalradius;
		self.goalradius 		= 96;
		self.last_goalpos		= self.goalpos;
	}

	self.poi = poi;
	self SetGoalPos(poi.entity.origin);
	self waittill("goal");

	while(!isDefined(self.enemy) && poi.team != self.team )
	{
		wait 1;
	}
	if (isDefined(self.last_goalradius) )
	{
		self.goalradius = self.last_goalradius;
		self.last_goalradius = undefined;
	}
	if (isDefined(self.last_goalpos) )
	{
		self SetGoalPos(self.last_goalpos);
	}
}


watchNetworkIntruder( poi )
{
	level endon( "rts_terminated" );
	self endon("death");
	
	intruderHintElem = maps\_hud_util::createFontString( "default", 1.5 );
	intruderHintElem.color = (1,1,1);
	intruderHintElem setText( &"SO_RTS_PLANT_INTRUDER" );
	intruderHintElem.x = 0;
	intruderHintElem.y = 20;
	intruderHintElem.alignX = "center";
	intruderHintElem.alignY = "middle";
	intruderHintElem.horzAlign = "center";
	intruderHintElem.vertAlign = "middle";
	intruderHintElem.foreground = true;
	intruderHintElem.alpha = 0;
	
	while( IsDefined( poi.trigger ) )
	{
		networkIntruders = poi.trigger maps\_so_rts_support::get_ents_touching_trigger( level.rts.networkIntruders );
		
		if( self IsTouching( level.rts.player ) && networkIntruders.size == 0 && isDefined(level.rts.player.ally) && !isDefined(level.rts.player.ally.vehicle) )
		{
			if( !IS_TRUE( level.rts.player.plantingNetworkIntruder ) )
				intruderHintElem.alpha = 1;
			else
				intruderHintElem.alpha = 0;
			
			if( level.rts.player UseButtonPressed() )
			{
				intruderHintElem.alpha = 0;
				level.rts.player maps\_so_rts_support::player_plant_network_intruder(poi);
			}
		}
		else
		{
			intruderHintElem.alpha = 0;
		}
		
		wait(0.05);
	}
	
	intruderHintElem maps\_hud_util::destroyElem();
}
