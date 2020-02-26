#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_vehicle;
#include maps\_audio;
#include maps\_music;

#insert raw\maps\_so_rts.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;
//////////////////////////////////////////////////////////////////////////////////////////////////
///SCENARIO 1
//////////////////////////////////////////////////////////////////////////////////////////////////

precache()
{
	maps\_quadrotor::init();
	maps\_horse::precache_models();
	level._effect[ "ied_death" ] 	= loadfx("explosions/fx_exp_equipment");
	level._effect[ "ied_blink" ] 	= loadfx("misc/fx_equip_light_green");
	level._effect[ "ied_explode" ] 	= loadfx("explosions/fx_exp_bomb_huge");
	
	precachemodel("t6_wpn_hacking_device_world");
	PrecacheItem( "rts_missile_sp" );
	
}
//////////////////////////////////////////////////////////////////////////////////////////////////

afghanistan_level_scenario_one()
{
	//overrides default introscreen function
	//level.custom_introscreen = ::afghanistan_custom_introscreen;
	flag_set("rts_tutorial_not_ready");
	level.rts.endLocs_route1 = GetEntArray("rts_vtol_transport_loc1","targetname");
	level.rts.endLocs_route2 = GetEntArray("rts_vtol_transport_loc2","targetname");
	level.rts.iedLocs		 = GetStructArray("ied_location","targetname");

	flag_set("block_input");
	maps\_so_rts_rules::set_GameMode("afghanistan1");//game type attack
	flag_wait( "start_rts" );
	flag_Set("rts_event_ready");
	flag_clear("rts_enemy_squad_spawner_enabled");

	afghanistan_level_scenario_one_registerEvents();
	afghanistan_geo_changes();
	level.rts.codeSpawnCB = ::afghanistanCodeSpawner;
	level.rts.game_rules.num_nag_squads = 99;


	level thread afghanistan_convoyTriggerThink();
	////
	maps\_so_rts_catalog::package_select("infantry_ally_reg_pkg", true);//remove later
	////
	maps\_so_rts_catalog::package_select("quadrotor_pkg", true, ::afghanistan_level_player_startFPS);
	maps\_so_rts_catalog::package_select("missle_strike_pkg", true);
	maps\_so_rts_catalog::package_select("convoy_pkg", true);

	screen_fade_in(0.5);
}


_order_new_squad( squadID )
{
	squad 			= maps\_so_rts_squad::getSquad( squadID );
	unit 			= create_units_from_squad(squadID);

	if (!isDefined(unit) || unit.size == 0 )
		return;

	squad.nextstate = SQUAD_STATE_MANAGED;


	foreach(guy in unit.members)
	{
		guy.goalradius = 1024;
	}
	
	switch (squad.pkg_ref.ref)
	{
		case "infantry_enemy_ied_pkg":
			level thread unit_plant_IEDs(unit);
		break;
		default:
			target = getSquadByPkg( "convoy_pkg", "allies" );
			level thread maps\_so_rts_enemy::chase_DownSquads(unit,target.id);
		break;
	}
}

afghan_iedTriggerThink(ied)
{
	ied endon("death");
	self waittill("trigger",entity);
	convoy = getSquadByPkg( "convoy_pkg", "allies" );
	if (!isDefined(entity.squadID) || entity.squadID != convoy.id )
	{
		self thread afghan_iedTriggerThink();
		return;
	}
	maps\_so_rtS_event::trigger_event("fx_ied_explode",self.origin);

	maps\_so_rtS_event::trigger_event("sfx_ied_explode");
	Earthquake( 0.5, 2, self.origin, 1000);
	entity DoDamage(1500,self.origin,undefined,-1,"explosive");
	level notify("ied_exploded",entity);
	self delete();
	ied delete();
}

afghan_iedThink()
{
	self endon("death");
	
	/#
		println("@@@@ ("+GetTime()+") IED planted at " + self.origin);
	#/
	self.takedamage = true;
	self.health 	= 100;
	
	self thread blinky_light( level._effect[ "ied_blink" ], "tag_fx" );
	self.trigger = Spawn( "trigger_radius", self.origin, 24, 64, 128 );
	self.trigger thread afghan_iedTriggerThink(self);

	
	// monitor damage
	while(1)
	{
		self waittill( "damage", damage, attacker );
		if ( damage > self.health )
		{
			maps\_so_rtS_event::trigger_event("fx_ied_dead");
			self delete();
		}
		else
		{
			self.health -= damage;
		}
	}
}

afghan_plant_IEDs()
{
	self endon("death");
	iedLocs = maps\_so_rts_support::sortArrayByClosest(self.origin,	level.rts.iedLocs );
	if (iedLocs.size == 0 )
	{
		self.ied_planted = true;
		return;
	}
	iedSpot = iedLocs[0];
	ArrayRemoveIndex(level.rts.iedLocs,0);
	
	self.goalradius = 16;
	self.ignoreall  = 1;
	self setgoalpos(iedSpot.origin);
	self waittill("goal");
	self allowedstances( "crouch" );
	wait 7;
	self.goalradius = 1024;
	self.ignoreall  = 0;
	self.ied_planted = true;
	
	ied = Spawn( "script_model", self.origin );
	ied SetModel( "t6_wpn_hacking_device_world" );
	ied thread afghan_iedThink();
	self allowedstances( "crouch","stand" );
}

unit_plant_IEDs(unit)
{
	assert(unit.members.size <=2,"more than two probably wont work very well");
	foreach(guy in unit.members)
	{
		guy thread afghan_plant_IEDs();
	}
	
	while(1)
	{
		done = true;
		foreach(guy in unit.members)
		{
			if (!isDefined(guy))
				continue;
			if (!IS_TRUE(guy.ied_planted))
			{
				done = false;
				break;
			}
		}
		if(done)
			break;
		wait 0.1;
	}
	//all dudes planted	
	target = getSquadByPkg( "convoy_pkg", "allies" );
	level thread maps\_so_rts_enemy::chase_DownSquads(unit,target.id);
	
}

_convoy_Watch()
{

	self waittill("trigger",entity);
	convoy = getSquadByPkg( "convoy_pkg", "allies" );
	if (!isDefined(entity.squadID) || entity.squadID != convoy.id )
	{
		self thread _convoy_Watch();
		return;
	}
	
	level.rts.enemy_spawn_locs = GetEntArray(self.script_noteworthy,"script_noteworthy");
	ArrayRemoveValue(level.rts.enemy_spawn_locs,self,false);	
	for(i=0;i<level.rts.enemy_spawn_locs.size;i++)
	{
		maps\_so_rts_enemy::enemy_squad_spawnASquad(::_order_new_squad);
	}
	
	self delete();
	level.rts.enemy_spawn_locs  = [];
}

afghanistan_convoyTriggerThink()
{
	level.rts.convoy_triggers = GetEntArray("convoy_trigger","targetname");
	foreach(trigger in level.rts.convoy_triggers)
	{
		trigger thread _convoy_Watch();
	}
}
afghanistan_Convoy(squadID)
{
	return false;
}

afghanistan_MissilePlatform(squadID)
{
	origin	= GetStruct("ai_apache_loc","targetname").origin;
	squad 	= maps\_so_rts_squad::getSquad( squadID );
	centerPoint  =level.rts.squads[squadID].centerPoint;
	
	squad.centerPoint = (squad.centerPoint[0],squad.centerPoint[1],origin[2]);
	ret 	= true;	
	switch(squad.nextstate)
	{
		case SQUAD_STATE_ATTACK:
			if ( afghanistan_MissilePlatformAttack(squadID,level.rts.squads[squadID].target.origin) )
			{
				ret = false;
			}
		break;	
		case SQUAD_STATE_MOVE:
		case SQUAD_STATE_DEFEND:
			if ( afghanistan_MissilePlatformAttack(squadID,centerPoint))
			{
				ret = false;
			}
		break;	
		case SQUAD_STATE_PATROL:
		case SQUAD_STATE_MOVEWITHPLAYER:
		case SQUAD_STATE_MANAGED:
			maps\_so_rts_squad::ReIssueSquadLastOrders(squadID);
			ret = false;
			break;
	}
	return ret;
}
afghanistan_MissilePlatformAttack(squadID,hitDest)
{
 	squad 	= level.rts.squads[squadID];
	origin	= GetStruct("ai_apache_loc","targetname").origin;
	
	if(!isDefined(hitDest) || hitDest[2] == origin[2])
		return;
	
	squad.centerPoint = (hitDest[0],hitDest[1],origin[2]);

	cost = squad.pkg_ref.cost[squad.team];
	time = GetTime();
	if (squad.nextAvailAttack > time)
		return false;
	squad.nextAvailAttack = time + cost;
		
	foreach(unit in level.rts.squads[squadID].members)
	{
			
		unit.goalradius = 1024;	
		unit SetVehGoalPos(squad.centerPoint,true);
		unit waittill_any( "goal", "near_goal" );
		rocket = MagicBullet( "rts_missile_sp", unit.origin+(0,0,-256), hitDest, unit );
		rocket.owner = level.rts.player;
	}
	maps\_so_rts_squad::moveSquadMarker(squadID,true);
	return true;
}

afghanistanCodeSpawner(pkg_ref, team, callback, squadID)
{
	switch(pkg_ref.ref)
	{
		case "missle_strike_pkg":
			origin	= GetStruct("ai_apache_loc","targetname").origin;
			squadID = maps\_so_rts_squad::createSquad(origin,team,pkg_ref); 
			LUINotifyEvent( &"rts_add_squad", 3, squadID, pkg_ref.idx, 0 );
			foreach(unit in pkg_ref.units)
			{
				ai_ref	= level.rts.ai[unit];
				ai 		= maps\_so_rts_support::placeVehicle( ai_ref.ref, origin, team );
				ai.ai_ref = ai_ref;
				ai maps\_so_rts_squad::addAIToSquad(squadID);
			}
			level.rts.squads[squadID].squad_execute_cb = ::afghanistan_MissilePlatform;
			level.rts.squads[squadID].nextAvailAttack = 0;
			maps\_so_rts_catalog::units_delivered(team,squadID);
		break;
		case "convoy_pkg":
			origin	= GetEnt("rts_player_start","targetname").origin;
			squadID = maps\_so_rts_squad::createSquad(origin,team,pkg_ref); 
			level.rts.squads[squadID].squad_execute_cb = ::afghanistan_Convoy;
			LUINotifyEvent( &"rts_add_squad", 3, squadID, pkg_ref.idx, 0 );

			spots = GetStructArray("convoy_gaz_spawn","targetname");
			assert(spots.size >= pkg_ref.units.size);
			i = 0;
			foreach(unit in pkg_ref.units)
			{
				spot 	= spots[i];
				i++;
				ai_ref	= level.rts.ai[unit];
				ai 		= maps\_so_rts_support::placeVehicle( ai_ref.ref, spot.origin, team );
				ai.angles = spot.angles;
				ai.ai_ref = ai_ref;
				ai maps\_so_rts_squad::addAIToSquad(squadID);
				if(isDefined(spot.script_noteworthy))
				{
					ai.script_noteworthy = spot.script_noteworthy;
				}
				ai thread afghanistan_vehicle_think();
				//maps\_so_rts_poi::add_poi("rts_poi_convoy_"+i,ai,"allies",false);
			}
			maps\_so_rts_catalog::units_delivered(team,squadID);
		break;
		
		case "hourse_enemy_pkg":
			origin	= 	afghanistan_GetSpawnLocationForEnemyHorses();
			if (!isDefined(origin))
				return -1;
			squadID = maps\_so_rts_squad::createSquad(origin,team,pkg_ref); 
			foreach(unit in pkg_ref.units)
			{
				ai_ref	= level.rts.ai[unit];
				ai 		= maps\_so_rts_support::placeVehicle( ai_ref.ref, origin, team );
				if (isDefined(ai))
				{
					ai.ai_ref = ai_ref;
					ai maps\_so_rts_squad::addAIToSquad(squadID);
					ai thread afghanistan_horse_init();			
				}
			}
			maps\_so_rts_catalog::units_delivered(team,squadID);
		break;
		case "infantry_enemy_reg_pkg":
		case "infantry_enemy_ied_pkg":
		case "infantry_enemy_rpg_pkg":
			origin	= 	afghanistan_GetSpawnLocationForEnemyInfantry();
			if (!isDefined(origin))
				return -1;
				
			squadID = maps\_so_rts_squad::createSquad(origin,team,pkg_ref); 
			foreach(unit in pkg_ref.units)
			{
				ai_ref	= level.rts.ai[unit];
				ai 		= simple_spawn_single(ai_ref.ref, undefined, undefined, undefined, undefined, undefined, undefined, true);
				if (isDefined(ai))
				{
	
					ai forceTeleport(origin);
					node = ai FindBestCoverNode();
					if (isDefined(node))
					{
						ai forceTeleport(node.origin);
						ai UseCoverNode(node);
					}
					ai.ai_ref = ai_ref;
					ai maps\_so_rts_squad::addAIToSquad(squadID);
					ai.dropweapon = false;
				}
			}
			maps\_so_rts_catalog::units_delivered(team,squadID);
		break;
		default:
			assert(0,"Unhandled code spawn");
		break;
	}

	// finish spawning callback
	if( IsDefined( callback ) )
		thread [[ callback ]]( squadID );
	return squadID;

}

leastCompareFunc( e1, e2, val)
{
	return e1.spawnTime < e2.spawnTime;
}

afghanistan_GetSpawnLocationForEnemyInfantry()
{
	if ( level.rts.enemy_spawn_locs.size == 0 )
		return undefined;
		
	time = GetTime();
	foreach(spot in level.rts.enemy_spawn_locs)
	{
		if(!isDefined(spot.spawnTime) )
			spot.spawnTime = 0;
	}
	
	spots = maps\_utility_code::mergesort( level.rts.enemy_spawn_locs, ::leastCompareFunc);
	spot  = spots[0];
	spot.spawnTime = time;
	return spot.origin;
}
afghanistan_GetSpawnLocationForEnemyHorses()
{
	if ( level.rts.enemy_spawn_locs.size == 0 )
		return undefined;
		
	time = GetTime();
	valid= [];
	foreach(spot in level.rts.enemy_spawn_locs)
	{
		if(!isDefined(spot.spawnTime) )
			spot.spawnTime = 0;
		if(!isDefined(spot.script_parameters))
			continue;
		
		if ( (time - spot.spawnTime) < 5000 )
			continue;

		hasStr = issubstr(spot.script_parameters,"horse");
		if (hasStr)
		{		
			valid[valid.size] = spot;	
		}
	}
	if (valid.size == 0 )
		return undefined;
		
	spots = maps\_utility_code::mergesort( valid, ::leastCompareFunc);
	spot  = spots[0];
	spot.spawnTime = time;
	return spot.origin;
}


ai_mount_immediate( vh_horse )
{
	self enter_vehicle( vh_horse );
	vh_horse notify( "groupedanimevent", "ride" );
	self maps\_horse_rider::ride_and_shoot( vh_horse );
}

ai_mount_horse( vh_horse )  //self = ai
{
    self endon( "death" );
    
    self run_to_vehicle_load( vh_horse );
    while( !IsDefined( vh_horse get_driver() ) )
    {
        wait 0.05;    
    }
    self notify( "on_horse" );
    vh_horse notify( "groupedanimevent", "ride" );
    wait 0.1;
    self maps\_horse_rider::ride_and_shoot( vh_horse );
}

ai_dismount_horse( vh_horse )  //self = ai
{
    self endon( "death" );
    
    self notify( "stop_riding" );
    self notify( "off_horse" );
    vh_horse vehicle_unload( 0.1 );
    vh_horse waittill( "unloaded" );    
}



afghanistan_horse_init()
{
	self endon("death");

	self SetNearGoalNotifyDist( 300 );
	self MakeVehicleUnusable();
	self SetSpeedImmediate( 25 );
	
	//add a rider to this horse...
	ai_rider = simple_spawn_single( "ai_afghan_assault_spawner", undefined, undefined, undefined, undefined, undefined, undefined, true);
	if(isdefined(ai_rider))
	{
		ai_rider.team = "axis";
		//ai_rider thread ai_mount_horse( self );
		ai_rider thread ai_mount_immediate(self);
	}
	
	self waittill( "no_driver" );
	//driver died, maybe i should too....
	self dodamage(self.health+69,self.origin);
}

afghanistan_vehicle_takeoverWatch()
{
	self endon("death");
	while(1)
	{
		self waittill("taken_control_over");
	}
}

afghanistan_vehicle_IED_Watch()
{
	self endon("death");
	speed = self GetSpeedMPH();
	while(1)
	{
		level waittill("ied_exploded",entity);
		if(entity!=self)
			continue;
		self pathvariableoffset((80, 80, 0), 2);
		wait 10;
		self pathvariableoffset((50, 50, 0), 20);
		
		/*
		wait RandomFloatRange(0,1);
		self SetSpeed( 0, 1, 1 );
		wait 20;
		self SetSpeed( speed, 1, 1 );
		*/
	}
}

afghanistan_vehicle_CollsionWatch()
{
	self endon("death");
	speed = self GetSpeedMPH();
	while(1)
	{
		level waittill("veh_collision",hitpoints,loc,vel,type,entity);
		if(isDefined(entity) && entity.squadID==self.squadID)
		{
			if ( self.pathdistancetraveled > entity.pathdistancetraveled )
			{
				self SetSpeed( speed+2, 1, 1 );
				entity SetSpeed( speed-2, 1, 1 );
			}
			else
			{
				self SetSpeed( speed-2, 1, 1 );
				entity SetSpeed( speed+2, 1, 1 );
			}
			wait 2;
		}
	}
}
afghanistan_vehicle_think()
{
    self endon( "death" );
	flag_wait("introscreen_complete");
	self thread afghanistan_vehicle_IED_Watch();	
	self thread afghanistan_vehicle_takeoverWatch();
	self thread afghanistan_vehicle_CollsionWatch();

	if(isDefined(self.script_noteworthy))
	{
		self thread afghanistan_convoy_switch_node_think();
	}

	self.drivepath = true;
	self pathvariableoffset((50, 50, 0), RandomIntRange(15,30));
	self thread go_path(GetVehicleNode("rts_convoy_start","targetname"));
	
	self waittill( "reached_end_node" );

	if (IS_TRUE(self.route2))
	{
		assert(isDefined(level.rts.endLocs_route2[0]));
		spot = level.rts.endLocs_route2[0];
		ArrayRemoveIndex( level.rts.endLocs_route2, 0 );
	}
	else
	{
		assert(isDefined(level.rts.endLocs_route1[0]));
		spot = level.rts.endLocs_route1[0];
		ArrayRemoveIndex( level.rts.endLocs_route1, 0 );
	}

	self.drivepath = false;
	self SetVehGoalPos(spot.origin,true);
	self waittill_any( "goal");
	spot delete();
}

afghanistan_convoy_switch_node_think()
{
	self.route2 = true;
    self endon( "death" );
    self waittill( "switch_node" );
    self.switchNode = GetVehicleNode( self.script_noteworthy, "targetname" );
    self SetSwitchNode( self.nextNode, self.switchNode );
}

afghanistan_convoy_leadDeath()
{
	self endon("afghanistan_convoy_leadUpdate");
	squadID = self.squadID;
	self waittill("death");
	maps\_so_rtS_squad::removeDeadFromSquad(squadID);
	if (level.rts.squads[squadID].size>0)
	{
		if (isDefined(level.rts.squads[squadID].members[0]))
		{
			level.rts.squads[squadID].members[0] thread afghanistan_convoy_leadUpdate();
		}
	}
}
afghanistan_convoy_leadUpdate()
{
	self endon("death");
	self notify("afghanistan_convoy_leadUpdate");
	self endon("afghanistan_convoy_leadUpdate");
	self thread afghanistan_convoy_leadDeath();
	while(1)
	{
		level.rts.squads[self.squadID].centerPoint = self.origin;
		wait 0.5;
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////
afghanistan_level_player_startFPS()
{
	nextSquad = getSquadByPkg( "quadrotor_pkg", "allies" );
	assert(isdefined(nextSquad),"player squad should be created");
	level.rts.targetTeamMate =	nextSquad.members[0];
	if( IS_VEHICLE(level.rts.targetTeamMate))
	{
		level.rts.targetTeamMate.origin = level.rts.player.origin + (0,0,100);
		level.rts.targetTeamMate.angles = level.rts.player.angles;
	}
	else
	{
		level.rts.targetTeamMate forceteleport(level.rts.player.origin,level.rts.player.angles);
	}
	level waittill("controls_active");
	if( IS_VEHICLE(level.rts.targetTeamMate))
	{
		level.rts.targetTeamMate.origin = level.rts.player.origin + (0,0,100);
		level.rts.targetTeamMate.angles = level.rts.player.angles;
	}
	else
	{
		level.rts.targetTeamMate forceteleport(level.rts.player.origin,level.rts.player.angles);
	}
	maps\_so_rts_main::player_in_control();
	
	convoy = getSquadByPkg( "convoy_pkg", "allies" );
	maps\_so_rts_squad::OrderSquadFollowAI(nextSquad.id,convoy.members[0]);
	convoy.members[0] thread afghanistan_convoy_leadUpdate();
	
	level thread maps\_so_rts_support::flag_set_inNSeconds("start_rts_enemy",8);
	level.rts.player.ignoreme = false;
	level.rts.player DisableInvulnerability();
	flag_set("rts_start_clock");
	flag_clear("rts_tutorial_not_ready");
}

afghanistan_custom_introscreen( string1, string2, string3, string4, string5 )
{
	level.introstring = []; 
	
	introblack = NewHudElem(); 
	introblack.x = 0; 
	introblack.y = 0; 
	introblack.horzAlign = "fullscreen"; 
	introblack.vertAlign = "fullscreen"; 
	introblack.foreground = true;
	introblack SetShader( "black", 640, 480 );

	flag_wait("all_players_connected");

	// Fade out black
	wait 0.1;
	introblack Destroy();

	flag_wait("all_players_connected");

	level.introstring = []; 
	
	letter_time = 0.05;
	decay_duration = 0.5;
	pausetime = 1;
	totaltime = 14.25;
	color = ( 1, 1, 1 );
	
	letter_time 		= Int( 1000 * letter_time );  		// convert to milliseconds
	decay_duration 		= Int( 1000 * decay_duration );		// convert to milliseconds
	decay_start 		= Int( 1000 * totaltime ); 			// convert to milliseconds
	totalpausetime		= 0; 								// track how much time we've waited so we can wait total desired waittime

	if( IsDefined( string1 ) )
	{
		level thread maps\_introscreen::introscreen_create_typewriter_line( string1, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 
		
		wait( pausetime );
		totalpausetime += pausetime;
	}

	if( IsDefined( string2 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread maps\_introscreen::introscreen_create_typewriter_line( string2, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}

	if( IsDefined( string3 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread maps\_introscreen::introscreen_create_typewriter_line( string3, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}
	
	if( IsDefined( string4 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread maps\_introscreen::introscreen_create_typewriter_line( string4, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}		
	
	if( IsDefined( string5 ) )
	{
		decay_start = Int( 1000 * ( totaltime - totalpausetime ) );
		level thread maps\_introscreen::introscreen_create_typewriter_line( string5, letter_time, decay_start, decay_duration, color, undefined, "objective" ); 

		wait( pausetime );
		totalpausetime += pausetime;
	}

	// Fade out text
	maps\_introscreen::introscreen_fadeOutText(); 

	flag_set( "introscreen_complete" ); // Notify when complete
}
//////////////////////////////////////////////////////////////////////////////////////////////////

level_fade_in( player )
{
	screen_fade_in(0.5);
}
//////////////////////////////////////////////////////////////////////////////////////////////////

afghanistan_mission_complete_s1(success,baseJustLost)
{
	screen_fade_out(0);
	
	wait 16;
	level notify( "fade_mission_complete" );
	//fade out the sound
	level clientnotify ("rts_fd");
	wait 1;
	
	screen_fade_out( 1 );
	SetDvar("lui_enabled","1");
	maps\_so_rts_support::toggle_damage_indicators(true);
	
	nextmission();
}
//////////////////////////////////////////////////////////////////////////////////////////////////

afghanistan_geo_changes()
{
	delobjs = GetEntArray( "rts_obj_remove", "targetname" );	
	foreach( item in delobjs )
	{
		//item ConnectPaths();
		item Delete();
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////

afghanistan_level_scenario_one_registerEvents()
{
}
//////////////////////////////////////////////////////////////////////////////////////////////////
