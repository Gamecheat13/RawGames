#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	level.flagmodel["neutral"] = "prop_flag_neutral";
	level.flagmodel["allies"] = "prop_flag_american";
	level.flagmodel["axis"] = "prop_flag_opfor";
	precacheModel(level.flagmodel["neutral"]);
	precacheModel(level.flagmodel["allies"]);
	precacheModel(level.flagmodel["axis"]);
	
	precacheItem( "radar_mp" );
	precacheItem( "airstrike_mp" );
	precacheItem( "helicopter_mp" );
	
	makeDvarServerInfo( "ui_uav_allies", 0 );
	makeDvarServerInfo( "ui_uav_axis", 0 );
	setDvar( "ui_uav_allies", 0 );
	setDvar( "ui_uav_axis", 0 );
	
	level.hardpointItems = [];
	priority = 0;
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowuav" ) )
	{
		level.hardpointItems["radar_mp"] = priority;
		priority++;
	}
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowartillery" ) )
	{
		level.hardpointItems["airstrike_mp"] = priority;
		priority++;
	}
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowhelicopter" ) )
	{
		level.hardpointItems["helicopter_mp"] = priority;
		priority++;
	}

	level.hardpointHints["radar_mp"] = &"MP_EARNED_RADAR";
	level.hardpointHints["airstrike_mp"] = &"MP_EARNED_AIRSTRIKE";
	level.hardpointHints["helicopter_mp"] = &"MP_EARNED_HELICOPTER";

	level.hardpointHints["radar_mp_not_available"] = &"MP_RADAR_NOT_AVAILABLE";
	level.hardpointHints["airstrike_mp_not_available"] = &"MP_AIRSTRIKE_NOT_AVAILABLE";
	level.hardpointHints["helicopter_mp_not_available"] = &"MP_HELICOPTER_NOT_AVAILABLE";

	level.streakHints[3] = &"MP_KILLSTREAK_3";
	level.streakHints[5] = &"MP_KILLSTREAK_5";
	level.streakHints[7] = &"MP_KILLSTREAK_7";

	level.hardpointInforms["radar_mp"] = "mp_killstreak_radar";
	level.hardpointInforms["airstrike_mp"] = "mp_killstreak_jet";
	level.hardpointInforms["helicopter_mp"] = "mp_killstreak_heli";
	level.hardpointInforms["radar_mp_voice"] = "US_1mc_uavrecon";
	level.hardpointInforms["airstrike_mp_voice"] = "US_1mc_airstrike";
	level.hardpointInforms["helicopter_mp_voice"] = "US_1mc_helisupport";

	maps\mp\gametypes\_rank::registerScoreInfo( "hardpoint", 10, &"" );
	
	precacheString( level.hardpointHints["radar_mp"] );	
	precacheString( level.hardpointHints["airstrike_mp"] );	
	precacheString( level.hardpointHints["helicopter_mp"] );	

	precacheString( level.streakHints[3] );	
	precacheString( level.streakHints[5] );	
	precacheString( level.streakHints[7] );	
	precacheString( &"MP_KILLSTREAK_N" );	

	precacheLocationSelector("map_artillery_selector");

	precacheString(&"MP_WAR_WAITING_FOR_AIRSTRIKE");
	precacheString(&"PLATFORM_PRESS_TO_USE_AIRSTRIKE");
	precacheString(&"MP_WAR_AIRSTRIKE_CROSSHAIR");
	
	precacheString(&"MP_WAR_AIRSTRIKE_INSTRUCTIONS1");
	precacheString(&"MP_WAR_AIRSTRIKE_INSTRUCTIONS2");
	precacheString(&"MP_WAR_AIRSTRIKE_INSTRUCTIONS3");

	precacheString(&"MP_WAR_AIRSTRIKE_INBOUND");
	precacheString(&"MP_WAR_AIRSTRIKE_INBOUND_NEAR_YOUR_POSITION");
	
	precacheString(&"MP_HELICOPTER_INBOUND");
	
	precacheString(&"MP_WAR_WAITING_FOR_COPTER_TO_BE_READY_FOR_ORDERS");
	precacheString(&"MP_WAR_WAITING_FOR_COPTER_TO_REACH_DESTINATION");
	precacheString(&"MP_WAR_WAITING_FOR_COPTER_TO_BE_AVAILABLE");
	precacheString(&"PLATFORM_PRESS_TO_USE_COPTER");

	precacheString(&"MP_WAR_WAITING_FOR_AMMO");
	precacheString(&"MP_WAR_PRESS_TO_REPLENISH_AMMO");

	precacheString(&"MP_WAR_COPTER_INSTRUCTIONS1");
	precacheString(&"MP_WAR_COPTER_INSTRUCTIONS2");

	precacheString(&"MP_WAR_WAITING_FOR_RADAR");
	precacheString(&"MP_WAR_RADAR_ACQUIRED");
	precacheString(&"MP_WAR_RADAR_ACQUIRED_ENEMY");
	precacheString(&"MP_WAR_RADAR_EXPIRED");
	precacheString(&"MP_WAR_RADAR_EXPIRED_ENEMY");
	precacheString(&"PLATFORM_PRESS_TO_USE_RADAR");
	
	precacheItem( "artillery_mp" );	

	level.airstrikefx = loadfx ("explosions/clusterbomb");
	level.mortareffect = loadfx ("explosions/artilleryExp_dirt_brown");
	level.bombstrike = loadfx ("explosions/wall_explosion_pm_a");
	
	level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
	level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");
	
	level.fx_heli_dust = loadfx ("treadfx/heli_dust_default");
	level.fx_heli_water = loadfx ("treadfx/heli_water");

	game["dialog"]["uav_online"] = "ouruavonline";
	game["dialog"]["uav_offline"] = "";
	game["dialog"]["enemy_uav_online"] = "enemyuavair";
	game["dialog"]["enemy_uav_offline"] = "";
	game["dialog"]["airstrike_inbound"] = "friendlyair";
	game["dialog"]["enemy_airstrike_inbound"] = "enemyair";
	game["dialog"]["helicopter_inbound"] = "friendlyheli";
	game["dialog"]["enemy_helicopter_inbound"] = "enemyheli";

	game["dialog"]["radar_mp"] = "uavrecon";
	game["dialog"]["airstrike_mp"] = "airstrike";
	game["dialog"]["helicopter_mp"] = "helisupport";

	//level.copterInterval = 120;
	//level.copterFightTime = 30; // length of time the helicopter sticks around once it arrives

	level.artilleryInterval = 20; // time between allowed uses of artillery
	
	// time interval between usage of helicopter hardpoint
	if ( getdvar( "scr_heli_hardpoint_interval" ) != "" )
		level.helicopterInterval = getdvarfloat( "scr_heli_hardpoint_interval" );
	else
	{
		setdvar( "scr_heli_hardpoint_interval" , 180 );
		level.helicopterInterval = 180; // time between allowed uses of helicopter
	}
	
	level.artillerylikelyrange = 256 + 128;
	level.artilleryunlikelyrange = level.artillerylikelyrange*2;
	
	level.artilleryDangerMaxRadius = level.artilleryunlikelyrange;
	level.artilleryDangerMinRadius = level.artillerylikelyrange;
	
	level.artilleryDangerMaxRadiusSq = level.artilleryDangerMaxRadius * level.artilleryDangerMaxRadius;
	
	level.artilleryDangerCenters = [];
	
	level.radarInterval = 30; // time between allowed uses of radar
	
	level.radarViewTime = 30; // time radar remains active

	level.objProgressBarHeight = 12;
	if(level.splitscreen)
		level.objProgressBarWidth = 152;
	else
		level.objProgressBarWidth = 192;
	
	
	level.numHardpointReservedObjectives = 0;

	if ( !maps\mp\gametypes\_tweakables::getTweakableValue( "hud", "showobjicons" ) )
		level.suppressHardpoint3DIcons = true;
	
	thread objectives();
}

nullfunc() {}

objectives()
{
	objTypes = [];
	objTypes[0] = "artillery_obj";
	objTypes[1] = "radar_obj";
	objTypes[2] = "armor_obj";
	objTypes[3] = "heli_obj";
	objTypes[4] = "ammo_obj";

	objThinkFuncs = [];
	objThinkFuncs[objTypes[0]] = ::obj_artillery_think;
	objThinkFuncs[objTypes[1]] = ::obj_radar_think;
	objThinkFuncs[objTypes[2]] = ::nullfunc;
	objThinkFuncs[objTypes[3]] = ::obj_heli_think;	//::obj_copter_think;
	objThinkFuncs[objTypes[4]] = ::obj_ammo_think;

	objTeamSeparated[objTypes[0]] = true;
	objTeamSeparated[objTypes[1]] = true;
	objTeamSeparated[objTypes[2]] = false;
	objTeamSeparated[objTypes[3]] = true;
	objTeamSeparated[objTypes[4]] = false;
	
	// artillery
	level.objwaypointshader[objTypes[0]]["available"] = "waypoint_airstrike_white";
	level.objwaypointshader[objTypes[0]]["used_enemy"] = "waypoint_airstrike_red";
	level.objwaypointshader[objTypes[0]]["used_friendly"] = "waypoint_airstrike_green";
	level.objwaypointshadercompass[objTypes[0]]["available"] = "compass_objpoint_airstrike";
	level.objwaypointshadercompass[objTypes[0]]["used_enemy"] = "compass_objpoint_airstrike_busy";
	level.objwaypointshadercompass[objTypes[0]]["used_friendly"] = "compass_objpoint_airstrike_friendly";

	// radar
	level.objwaypointshader[objTypes[1]]["available"] = "waypoint_radar_white";
	level.objwaypointshader[objTypes[1]]["used_enemy"] = "waypoint_radar_red";
	level.objwaypointshader[objTypes[1]]["used_friendly"] = "waypoint_radar_green";
	level.objwaypointshadercompass[objTypes[1]]["available"] = "compass_objpoint_satallite";
	level.objwaypointshadercompass[objTypes[1]]["used_enemy"] = "compass_objpoint_satallite_busy";
	level.objwaypointshadercompass[objTypes[1]]["used_friendly"] = "compass_objpoint_satallite_friendly";

	// helicopter
	level.objwaypointshader[objTypes[3]]["available"] = "waypoint_heli_white";
	level.objwaypointshader[objTypes[3]]["used_enemy"] = "waypoint_heli_red";
	level.objwaypointshader[objTypes[3]]["used_friendly"] = "waypoint_heli_green";
	level.objwaypointshadercompass[objTypes[3]]["available"] = "compass_objpoint_helicopter";
	level.objwaypointshadercompass[objTypes[3]]["used_enemy"] = "compass_objpoint_helicopter_busy";
	level.objwaypointshadercompass[objTypes[3]]["used_friendly"] = "compass_objpoint_helicopter_friendly";

	objs = [];
	for (i = 0; i < objTypes.size; i++)
	{
		theseobjs = getentarray(objTypes[i], "targetname");
		
		// precache what we'll use
		if (theseobjs.size > 0)
		{
			if ( !maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowartillery" ) && objTypes[i] == "artillery_obj" )
			{
				for ( index = 0; index < theseObjs.size; index++ )
					theseObjs[index] delete_hardpoint();

				theseObjs = [];
			}
			else if ( !maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowuav" ) && objTypes[i] == "radar_obj" )
			{
				for ( index = 0; index < theseObjs.size; index++ )
					theseObjs[index] delete_hardpoint();

				theseObjs = [];
			}
			else if ( !maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowsupply" ) && objTypes[i] == "ammo_obj" )
			{
				for ( index = 0; index < theseObjs.size; index++ )
					theseObjs[index] delete_hardpoint();
					
				theseObjs = [];
			}
			else if ( !maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowhelicopter" ) && objTypes[i] == "heli_obj" )
			{
				for ( index = 0; index < theseObjs.size; index++ )
					theseObjs[index] delete_hardpoint();

				theseObjs = [];
			}
			else if (isdefined(level.objwaypointshader[objTypes[i]]))
			{
				if ( isdefined(    level.objwaypointshader[objTypes[i]]["available"] ) )
					precacheShader(level.objwaypointshader[objTypes[i]]["available"]);
				if ( isdefined(    level.objwaypointshader[objTypes[i]]["unavailable"] ) )
					precacheShader(level.objwaypointshader[objTypes[i]]["unavailable"]);
				if ( isdefined(    level.objwaypointshader[objTypes[i]]["used_enemy"] ) )
					precacheShader(level.objwaypointshader[objTypes[i]]["used_enemy"]);
				if ( isdefined(    level.objwaypointshader[objTypes[i]]["used_friendly"] ) )
					precacheShader(level.objwaypointshader[objTypes[i]]["used_friendly"]);

				if ( isdefined(    level.objwaypointshadercompass[objTypes[i]]["available"] ) )
					precacheShader(level.objwaypointshadercompass[objTypes[i]]["available"]);
				if ( isdefined(    level.objwaypointshadercompass[objTypes[i]]["unavailable"] ) )
					precacheShader(level.objwaypointshadercompass[objTypes[i]]["unavailable"]);
				if ( isdefined(    level.objwaypointshadercompass[objTypes[i]]["used_enemy"] ) )
					precacheShader(level.objwaypointshadercompass[objTypes[i]]["used_enemy"]);
				if ( isdefined(    level.objwaypointshadercompass[objTypes[i]]["used_friendly"] ) )
					precacheShader(level.objwaypointshadercompass[objTypes[i]]["used_friendly"]);
			}
		}
		
		for (j = 0; j < theseobjs.size; j++)
		{
			obji = objs.size;
			objs[obji] = theseobjs[j];
			objs[obji].objtype = objTypes[i];
			objs[obji].id = obji;
		}
	}
	
	for (i = 0; i < objs.size; i++)
	{
		// objs[i] is a trigger.
		
		if (isdefined(objs[i].target)) {
			targetent = getent(objs[i].target, "targetname");
			if (targetent.classname == "script_model")
				objs[i].flag = targetent;
		}
		
		objs[i] thread createObj(level.numHardpointReservedObjectives, objTeamSeparated[objs[i].objtype]);
		if (objTeamSeparated[objs[i].objtype])
			level.numHardpointReservedObjectives += 2;
		else
			level.numHardpointReservedObjectives++;
		
		objs[i] thread [[ objThinkFuncs[objs[i].objtype] ]]();
		
		// no longer using flags
		if (isdefined(objs[i].flag)) objs[i].flag delete();
	}
	
	level.objs = objs;

	maps\mp\_helicopter::init();
	//maps\mp\gametypes\_copter::init();
	//thread ammo();
}

createObj(firstobj, teamseparated)
{
	self endon ( "death" );
	waittillframeend; // make sure level.numGametypeReservedObjectives has a chance to be defined
	
	self.objectiveid = [];
	if (!teamseparated) {
		self.objectiveid["all"] = firstobj;
		if (isdefined(level.objwaypointshader[self.objtype]))
			objective_add(self.objectiveid["all"], "active", self.origin, level.objwaypointshadercompass[self.objtype]["available"]);
	}
	else {
		self.objectiveid["axis"] = firstobj;
		self.objectiveid["allies"] = firstobj + 1;
		if (isdefined(level.objwaypointshader[self.objtype])) {
			objective_add(self.objectiveid["axis"], "active", self.origin, level.objwaypointshadercompass[self.objtype]["available"]);
			objective_team(self.objectiveid["axis"], "axis");
			objective_add(self.objectiveid["allies"], "active", self.origin, level.objwaypointshadercompass[self.objtype]["available"]);
			objective_team(self.objectiveid["allies"], "allies");
		}
	}
	
	self notify("objective_created");
}

updateObjStatus(team, status)
{
	if (isdefined(level.objwaypointshader[self.objtype]))
	{
		objective_icon(self.objectiveid[team], level.objwaypointshadercompass[self.objtype][status]);
		if (!isdefined(level.suppressHardpoint3DIcons))
			maps\mp\gametypes\_objpoints::createTeamObjPoint( "hardpoint_" + team + "_" + self.id, self.origin, team, level.objwaypointshader[self.objtype][status] );
	}
}

teamHasRadar(team)
{
	return getTeamRadar(team);
}

delete_hardpoint()
{
	if ( isDefined( self.flag ) )
	{
		if ( isDefined( self.flag.target ) )
			getEnt( self.flag.target, "targetname" ) delete();

		self.flag delete();
	}
	self delete();
}

// hardpoint think
obj_heli_think()
{
	self.trig = getent(self.flag.target, "targetname");
	self.trig setHintString(&"PLATFORM_PRESS_TO_USE_COPTER");

	self.trig.originalorigin = self.trig.origin;
	
	self.lastusage = gettime() - 1000*60*60;
	
	self thread timedHardpointHUD( &"MP_WAR_WAITING_FOR_COPTER_TO_BE_AVAILABLE", level.helicopterInterval );

	self waittill("objective_created");
	
	for( ;; )
	{
		self updateObjStatus("axis", "available");
		self updateObjStatus("allies", "available");
		self.trig waittill ( "trigger", player );
		
		self.trig.origin += (0,0,-50000);
		self.lastusage = gettime();
		
		assertex( ( isdefined( player ) && isdefined( player.pers["team"] ) ), "Invalid player triggered helicopter" );
		
		if ( player.pers["team"] == "allies" )
		{
			self updateObjStatus("axis", "used_enemy");
			self updateObjStatus("allies", "used_friendly");			
			helicopter_team = "allies";
			maps\mp\gametypes\_globallogic::leaderDialog( "helicopter_inbound", "allies" );
			maps\mp\gametypes\_globallogic::leaderDialog( "enemy_helicopter_inbound", "axis" );
		}
		else
		{
			self updateObjStatus("allies", "used_enemy");
			self updateObjStatus("axis", "used_friendly");
			helicopter_team = "axis";
			maps\mp\gametypes\_globallogic::leaderDialog( "helicopter_inbound", "axis" );
			maps\mp\gametypes\_globallogic::leaderDialog( "enemy_helicopter_inbound", "allies" );
		}
		
		assertex( isdefined( level.heli_paths ), "There are no helicopter paths in this map" );
		
		destination = 0;
		random_path = randomint( level.heli_paths[destination].size );
		startnode = level.heli_paths[destination][random_path];
		
		thread maps\mp\_helicopter::heli_think( player, startnode, helicopter_team );
		
		wait( level.helicopterInterval );
		self.trig.origin = self.trig.originalOrigin;
	}
}

obj_artillery_think()
{
	self.trig = getent(self.flag.target, "targetname");
	self.trig.originalOrigin = self.trig.origin;
	self.trig.origin += (0,0,-50000);
	self.trig setHintString(&"PLATFORM_PRESS_TO_USE_AIRSTRIKE");
	
	self.lastusage = gettime() - 1000*60*60;

	self thread obj_locationSelect(::artilleryUsed);
	self thread timedHardpointHUD( &"MP_WAR_WAITING_FOR_AIRSTRIKE", level.artilleryInterval );
	
	// no longer owned by a specific team, so let anyone use it
	self.trig.origin = self.trig.originalOrigin;
	
	self waittill("objective_created");
	
	self updateObjStatus("axis", "available");
	self updateObjStatus("allies", "available");
}
obj_locationSelect(usedCallback)
{
	while(1)
	{
		self.trig waittill("trigger", guy);
		if (isalive(guy) /*&& guy.pers["team"] == self.team*/)
		{
			guy thread startLocationSelection(self, usedCallback);
			self.trig.origin += (0,0,-50000);
			
			thread returnTrigAfterTime( self.trig );
			
			self waittill("allow_other_players_to_use");
		}
	}
}
returnTrigAfterTime( trig )
{
	self endon("allow_other_players_to_use");
	wait 10;
	trig.origin = trig.originalorigin;
	self notify("allow_other_players_to_use");
}

startLocationSelection(obj, usedCallback)
{
	self beginLocationSelection("map_artillery_selector", level.artilleryunlikelyrange * 1.2);

	self thread allowLocationEnd(obj, "cancel_location");
	self thread allowLocationEnd(obj, "death");
	self thread allowLocationEnd(obj, "disconnect");
	self thread endLocationSelectionOnUse(obj);

	self endon("stop_location_selection");
	self waittill("confirm_location", location);

	self thread finishUsage(location, usedCallback, obj);
}

finishUsage(location, usedCallback, obj)
{
	self notify( "used" );
	self thread stopLocationSelection(obj, false);
	obj thread [[usedCallback]](location, self);
}

allowLocationEnd(obj, waitfor)
{
	self endon("stop_location_selection");
	
	self waittill(waitfor);

	obj.trig.origin = obj.trig.originalorigin;
	self thread stopLocationSelection(obj, (waitfor == "disconnect"));
}

endLocationSelectionOnUse(obj)
{
	self endon("stop_location_selection");
	
	obj waittill("used");
	
	self thread stopLocationSelection(obj, false);
}

stopLocationSelection( obj, disconnected )
{
	if ( !disconnected )
		self endLocationSelection();
	
	obj notify("allow_other_players_to_use");
	self notify("stop_location_selection");
}

artilleryUsed(pos, player)
{
	trace = bullettrace(self.origin + (0,0,10000), self.origin, false, undefined);
	pos = (pos[0], pos[1], trace["position"][2] - 514);

	team = player.pers["team"];
	otherteam = "allies";
	if ( team == "allies" )
		otherteam = "axis";

	thread doArtillery(pos, player, /*self.team*/ team);
	
	self notify("used_artillery");

	self.trig.origin += (0,0,-50000);
	
	self.lastusage = gettime();
	
	
	if ( player.pers["team"] == "allies" )
	{
		self updateObjStatus("axis", "used_enemy");
		self updateObjStatus("allies", "used_friendly");			
	}
	else
	{
		self updateObjStatus("allies", "used_enemy");
		self updateObjStatus("axis", "used_friendly");
	}
	//self thread unavailableOnArtilleryHit(otherteam);
	
	wait(level.artilleryInterval);
	
	self.trig.origin = self.trig.originalOrigin;
	
	players = getentarray("players", "classname");
	for (i = 0; i < players.size; i++)
		players[i] timedHardpointHUDHide(self);
	
	self updateObjStatus("axis", "available");
	self updateObjStatus("allies", "available");
}
unavailableOnArtilleryHit(otherteam)
{
	level waittill( "artillery_hit" );
	self updateObjStatus(otherteam, "unavailable");
}
distance2d(a,b)
{
	return distance((a[0],a[1],0), (b[0],b[1],0));
}


doArtillery(origin, owner, team)
{
	num = 17 + randomint(3);
	
	level.artilleryDangerCenters[ level.artilleryDangerCenters.size ] = origin;
	level.airstrikeInProgress = true;
	
	if ( level.teambased )
	{
		players = level.players;
		if ( !level.hardcoreMode )
		{
			for(i = 0; i < players.size; i++)
			{
				if(isalive(players[i]) && (isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team)) {
					if (distance2d(players[i].origin, origin) <= level.artilleryunlikelyrange * 1.25)
						players[i] iprintlnbold(&"MP_WAR_AIRSTRIKE_INBOUND_NEAR_YOUR_POSITION");
				}
			}
		}
		
		maps\mp\gametypes\_globallogic::leaderDialog( "airstrike_inbound", team );
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln( &"MP_WAR_AIRSTRIKE_INBOUND", owner );
			}
		}
	}
	else
	{
		owner maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "airstrike_inbound" );
		if ( !level.hardcoreMode )
		{
			if ( distance2d( owner.origin, origin ) <= level.artilleryunlikelyrange * 1.25 )
				owner iprintlnbold(&"MP_WAR_AIRSTRIKE_INBOUND_NEAR_YOUR_POSITION");
		}
	}
	
	wait 2;
	
	if ( !isDefined( owner ) )
	{
		level.airstrikeInProgress = undefined;
		return;
	}
	
	trace = bullettrace(origin, origin + (0,0,-10000), false, undefined);
	targetpos = trace["position"];
	
	owner notify ( "begin_airstrike" );
	
	callStrike( owner, targetpos );
	
	wait 2.5;
	
	found = false;
	newarray = [];
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		if ( !found && level.artilleryDangerCenters[i] == origin )
		{
			found = true;
			continue;
		}
		
		newarray[ newarray.size ] = level.artilleryDangerCenters[i];
	}
	assert( found );
	assert( newarray.size == level.artilleryDangerCenters.size - 1 );
	level.artilleryDangerCenters = newarray;

	wait ( 4.0 );
	level.airstrikeInProgress = undefined;
}

artilleryDrop(targetpos, owner, team, timeremaining)
{
    projectile = spawn("script_model", (0,0,0));
    projectile setModel("weapon_m67_grenade");
	projectile.origin = targetpos + (0,0,2000);
	projectile.modelscale = 2.5;

	//projectile playsound("fast_artillery_round");
	projectile movez(-2000, 1);
	wait(1);
	
	projectile maps\mp\gametypes\_shellshock::artillery_earthQuake();
	thread playsoundinspace("artillery_impact", targetpos);
	playfx (level.mortareffect, targetpos);
	//projectile.team = team;
	losRadiusDamage(targetpos + (0,0,16), 650, 300, 0, owner); // targetpos, radius, maxdamage, mindamage, player causing damage
	
	level notify( "artillery_hit" );
	
	// no more shellshock
	/*
    maxduration = timeremaining + 9;
	minduration = timeremaining*.5 + 5;
	if (maxduration < 5) maxduration = 5;
	if (minduration < 3) minduration = 3;
	if (maxduration > 15) maxduration = 15;
	if (minduration > 5) minduration = 5;
	radiusArtilleryShellshock(targetpos, 512*1.5, maxduration,minduration);
    */
	
	wait(1);
	projectile delete();
}


losRadiusDamage(pos, radius, max, min, owner, eInflictor)
{
	//oldff = level.friendlyfire;
	//level.friendlyfire = "1";
	
	ents = maps\mp\gametypes\_weapons::getDamageableEnts(pos, radius, true);

	for (i = 0; i < ents.size; i++)
	{
		if (ents[i].entity == self)
			continue;
		
		dist = distance(pos, ents[i].damageCenter);
		
		if ( ents[i].isPlayer )
		{
			// check if there is a path to this entity 130 units above his feet. if not, they're probably indoors
			indoors = !maps\mp\gametypes\_weapons::weaponDamageTracePassed( ents[i].entity.origin, ents[i].entity.origin + (0,0,130), 0, undefined );
			if ( !indoors )
			{
				indoors = !maps\mp\gametypes\_weapons::weaponDamageTracePassed( ents[i].entity.origin + (0,0,130), pos + (0,0,130 - 16), 0, undefined );
				if ( indoors )
				{
					// give them a distance advantage for being indoors.
					dist *= 4;
					if ( dist > radius )
						continue;
				}
			}
		}

		ents[i].damage = int(max + (min-max)*dist/radius);
		ents[i].pos = pos;
		ents[i].damageOwner = owner;
		ents[i].eInflictor = eInflictor;
		level.airStrikeDamagedEnts[level.airStrikeDamagedEntsCount] = ents[i];
		level.airStrikeDamagedEntsCount++;
	}
	
	thread airstrikeDamageEntsThread();
}


airstrikeDamageEntsThread()
{
	self notify ( "airstrikeDamageEntsThread" );
	self endon ( "airstrikeDamageEntsThread" );

	for ( ; level.airstrikeDamagedEntsIndex < level.airstrikeDamagedEntsCount; level.airstrikeDamagedEntsIndex++ )
	{
		if ( !isDefined( level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] ) )
			continue;

		ent = level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex];
		
		if ( !isDefined( ent.entity ) )
			continue; 
			
		if ( !ent.isPlayer || isAlive( ent.entity ) )
		{
			ent maps\mp\gametypes\_weapons::damageEnt(
				ent.eInflictor, // eInflictor = the entity that causes the damage (e.g. a claymore)
				ent.damageOwner, // eAttacker = the player that is attacking
				ent.damage, // iDamage = the amount of damage to do
				"MOD_PROJECTILE_SPLASH", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
				"artillery_mp", // sWeapon = string specifying the weapon used (e.g. "claymore_mp")
				ent.pos, // damagepos = the position damage is coming from
				vectornormalize(ent.damageCenter - ent.pos) // damagedir = the direction damage is moving in
			);			

			level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] = undefined;
			
			if ( ent.isPlayer )
				wait ( 0.05 );
		}
		else
		{
			level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] = undefined;
		}
	}
}


radiusArtilleryShellshock(pos, radius, maxduration,minduration)
{
	players = level.players;
	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]))
			continue;
		
		playerpos = players[i].origin + (0,0,32);
		dist = distance(pos, playerpos);
		if (dist < radius) {
			duration = int(maxduration + (minduration-maxduration)*dist/radius);
			
			players[i] thread artilleryShellshock("default", duration);
		}
	}
}

artilleryShellshock(type, duration)
{
	if (isdefined(self.beingArtilleryShellshocked) && self.beingArtilleryShellshocked)
		return;
	self.beingArtilleryShellshocked = true;
	
	self shellshock(type, duration);
	wait(duration + 1);
	
	self.beingArtilleryShellshocked = false;
}

/#
airstrikeLine( start, end, color, duration )
{
	frames = duration * 20;
	for ( i = 0; i < frames; i++ )
	{
		line(start,end,color);
		wait .05;
	}
}

traceBomb()
{
	self endon("death");
	prevpos = self.origin;
	while(1)
	{
		thread airstrikeLine( prevpos, self.origin, (.5,1,0), 20 );
		prevpos = self.origin;
		wait .1;
	}
}
#/

doPlaneStrike( owner, requiredDeathCount, bombsite, startPoint, endPoint, bombTime, flyTime, direction )
{
	// plane spawning randomness = up to 125 units, biased towards 0
	// radius of bomb damage is 512
	
	if ( !isDefined( owner ) ) 
		return;
	
	startPathRandomness = 100;
	endPathRandomness = 150;
	
	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );
	
	// Spawn the planes
	plane = spawnplane( owner, "script_model", pathStart );
	plane setModel( "vehicle_mig29_desert" );
	plane.angles = direction;
	
	plane thread playContrail();
	
	plane moveTo( pathEnd, flyTime, 0, 0 );
	
	/#
	if ( getdvar("scr_airstrikedebug") == "1" )
		thread airstrikeLine( pathStart, pathEnd, (1,1,1), 10 );
	#/
	
	thread callStrike_planeSound( plane, bombsite );
	
	// callStrike_bomb( bomb time, bomb location, number of bombs )
	thread callStrike_bombEffect( plane, bombTime - 1.0, owner, requiredDeathCount );
	//thread callStrike_bomb( bombTime, bombsite, 2, owner );
	
	// Delete the plane after its flyby
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}

callStrike_bombEffect( plane, launchTime, owner, requiredDeathCount )
{
	wait ( launchTime );
	
	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	
	bomb = spawnbomb( plane.origin, plane.angles );
	bomb moveGravity( vector_scale( anglestoforward( plane.angles ), 7000/1.5 ), 3.0 );
	
	bomb.ownerRequiredDeathCount = requiredDeathCount;
	
	/#
	if ( getdvar("scr_airstrikedebug") == "1" )
		 bomb thread traceBomb();
	#/
	
	wait ( 0.85 );
	/*
	bomb.killCamEnt = spawn( "script_model", bomb.origin + (0,0,200) );
	bomb.killCamEnt.angles = bomb.angles;
	bomb.killCamEnt thread deleteAfterTime( 10.0 );
	bomb.killCamEnt moveTo( bomb.killCamEnt.origin + vector_scale( anglestoforward( plane.angles ), 1000 ), 3.0 );
	*/
	wait ( 0.15 );

	newBomb = spawn( "script_model", bomb.origin );
 	newBomb setModel( "tag_origin" );
  	newBomb.origin = bomb.origin;
  	newBomb.angles = bomb.angles;

	bomb setModel( "tag_origin" );
	//plane moveTo( endPoint + ( (randomint( 300 ) - 150 ), (randomint( 300 ) - 150 ), 0 ), flyTime, 0, 0 );
	wait (0.05);
	
	bombOrigin = newBomb.origin;
	bombAngles = newBomb.angles;
	playfxontag( level.airstrikefx, newBomb, "tag_origin" );
	
	wait ( 0.5 );
	repeat = 12;
	minAngles = 5;
	maxAngles = 55;
	angleDiff = (maxAngles - minAngles) / repeat;
	
	for( i = 0; i < repeat; i++ )
	{
		traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * i),randomInt( 10 )-5,0) );
		traceEnd = bombOrigin + vector_scale( traceDir, 10000 );
		trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
		
		traceHit = trace["position"];
		
		/#
		if ( getdvar("scr_airstrikedebug") == "1" )
			thread airstrikeLine( bombOrigin, traceHit, (1,0,0), 20 );
		#/
		
		thread losRadiusDamage( traceHit + (0,0,16), 512, 200, 30, owner, bomb ); // targetpos, radius, maxdamage, mindamage, player causing damage, entity that player used to cause damage
	
		if ( i%3 == 0 )
		{
			thread playsoundinspace( "artillery_impact", traceHit );
			playRumbleOnPosition( "artillery_rumble", traceHit );
			earthquake( 0.7, 0.75, traceHit, 1000 );
		}
		
		wait ( 0.05 );
	}
	wait ( 5.0 );
	newBomb delete();
	bomb delete();
}


spawnbomb( origin, angles )
{
	bomb = spawn( "script_model", origin );
	bomb.angles = angles;
	bomb setModel( "projectile_cbu97_clusterbomb" );

	return bomb;
}


deleteAfterTime( time )
{
	self endon ( "death" );
	wait ( 10.0 );
	
	self delete();
}


drawLine( start, end, timeSlice )
{
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, (1,0,0),false, 1 );
		wait ( 0.05 );
	}
}


playContrail()
{
	self endon ( "death" );
	
	if ( !isDefined( level.mapCenter ) )
		mapCenter = (0,0,0);
	else
		mapCenter = level.mapCenter;
	
	while ( isdefined( self ) )
	{
		if ( distance( self.origin , mapCenter ) <= 4000 )
		{
			playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
			playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
			return;
		}
		wait 0.05;
	}
}

callStrike( owner, coord )
{	
	// Get starting and ending point for the plane
	direction = ( 0, randomint( 360 ), 0 );
	planeHalfDistance = 24000;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;

	startPoint = coord + vector_scale( anglestoforward( direction ), -1 * planeHalfDistance );
	startPoint += ( 0, 0, planeFlyHeight );

	endPoint = coord + vector_scale( anglestoforward( direction ), planeHalfDistance );
	endPoint += ( 0, 0, planeFlyHeight );
	
	// Make the plane fly by
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );
	
	// bomb explodes planeBombExplodeDistance after the plane passes the center
	d = abs( d/2 + planeBombExplodeDistance  );
	bombTime = ( d / planeFlySpeed );
	
	assert( flyTime > bombTime );
	
	owner endon("disconnect");
	
	requiredDeathCount = owner.deathCount;
	
	level.airstrikeDamagedEnts = [];
	level.airStrikeDamagedEntsCount = 0;
	level.airStrikeDamagedEntsIndex = 0;
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 2.5 );
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 2.5 );
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
}

callStrike_bomb( bombTime, coord, repeat, owner )
{
	accuracyRadius = 512;
	
	for( i = 0; i < repeat; i++ )
	{
		randVec = ( 0, randomint( 360 ), 0 );
		bombPoint = coord + vector_scale( anglestoforward( randVec ), accuracyRadius );
		
		wait bombTime;
		
//		playfx( level.bombstrike, bombPoint );
//		playfx( level.mortareffect, bombPoint );
		thread playsoundinspace( "artillery_impact", bombPoint );
		/*
		sound = [];
		sound[0] = "building_explosion1";
		sound[1] = "building_explosion2";
		sound[2] = "building_explosion3";
		
		thread play_sound_in_space( sound[ randomint( sound.size ) ], bombPoint );
		*/
		radiusArtilleryShellshock( bombPoint, 512, 8, 4);
		losRadiusDamage( bombPoint + (0,0,16), 768, 300, 50, owner); // targetpos, radius, maxdamage, mindamage, player causing damage
		
		//radiusDamage( bombPoint + ( 0, 0, 128 ), 768, 200, 25 );*/
	}
}

flat_origin(org)
{
	rorg = (org[0],org[1],0);
	return rorg;

}

flat_angle(angle)
{
	rangle = (0,angle[1],0);
	return rangle;
}

targetisclose(other, target)
{
	infront = targetisinfront(other, target);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+vector_scale(anglestoforward(flat_angle(other.angles)), (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);
	if (dist < 3000)
		return true;
	else
		return false;
}

targetisinfront(other, target)
{
	forwardvec = anglestoforward(flat_angle(other.angles));
	normalvec = vectorNormalize(flat_origin(target)-other.origin);
	dot = vectordot(forwardvec,normalvec); 
	if(dot > 0)
		return true;
	else
		return false;
}

delete_on_death (ent)
{
	ent endon ("death");
	self waittill ("death");
	if (isdefined (ent))
		ent delete();
}

play_loop_sound_on_entity(alias, offset)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (offset))
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org linkto (self);
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}
//	org endon ("death");
	org playloopsound (alias);
//	println ("playing loop sound ", alias," on entity at origin ", self.origin, " at ORIGIN ", org.origin);
	self waittill ("stop sound" + alias);
	org stoploopsound (alias);
	org delete();
}



callStrike_planeSound( plane, bombsite )
{
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	while( !targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );
	while( targetisinfront( plane, bombsite ) )
		wait .05;
	wait .5;
	//plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	while( targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_close_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	plane waittill( "delete" );
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
}


timedHardpointHUD( hudtext, usageInterval )
{
	// self should be the hardpoint's trigger.
	// it must have lastusage defined as the time of the last usage.
	while(1)
	{
		self waittill("trigger", player);
		player thread timedHardpointHUDOnPlayer(self, hudtext, usageInterval);
	}
}
timedHardpointHUDOnPlayer(hardpointobj, hudtext, usageInterval)
{
	if (hardpointobj timedHardpointCanBeUsed( usageInterval ))
		return;
	
	self endon("disconnect");
	
	if (isdefined(self.timedHardpointHUDThread))
		return;
	self.timedHardpointHUDThread = true;
	
	self timedHardpointHUDShow(hardpointobj, hudtext, usageInterval);

	// we loop until we die, leave the trigger, or the hardpoint can be used, then we hide the timer hud
	while(1)
	{
		if (self.sessionstate != "playing" || !isalive(self) || !self istouching(hardpointobj))
			break;
		
		if (hardpointobj timedHardpointCanBeUsed( usageInterval ))
			break;
		
		wait .1;
	}
	self timedHardpointHUDHide(hardpointobj);
	
	self.timedHardpointHUDThread = undefined;
}
timedHardpointCanBeUsed( usageInterval )
{
	assert( isdefined( self.lastusage ) );
	return ((gettime() - self.lastusage) / 1000 >= usageInterval);
}
timedHardpointHUDShow( hardpointobj, hudtext, usageInterval )
{
	if (isdefined(self.showingObjHUD))
		return;
	self.showingObjHUD = hardpointobj;
	
	assert( isdefined( hardpointobj.lastusage ) );
	
	if ( !isdefined( self.timedHardpointHUDText ) )
		self.timedHardpointHUDText = newClientHudElem(self);

	self.timedHardpointHUDText.alpha = 1;
	self.timedHardpointHUDText.alignX = "center";
	self.timedHardpointHUDText.alignY = "top";
	self.timedHardpointHUDText.fontScale = 1.5;
	self.timedHardpointHUDText.x = 0;
	self.timedHardpointHUDText.y = 50;
	self.timedHardpointHUDText.horzAlign = "center";
	self.timedHardpointHUDText.vertAlign = "fullscreen";
	self.timedHardpointHUDText setText( hudtext );

	if ( !isdefined( self.timedHardpointHUDTimer ) )
		self.timedHardpointHUDTimer = newClientHudElem(self);

	self.timedHardpointHUDTimer.alpha = 1;
	self.timedHardpointHUDTimer.alignX = "center";
	self.timedHardpointHUDTimer.alignY = "top";
	self.timedHardpointHUDTimer.fontScale = 1.5;
	self.timedHardpointHUDTimer.x = 0;
	self.timedHardpointHUDTimer.y = 75;
	self.timedHardpointHUDTimer.horzAlign = "center";
	self.timedHardpointHUDTimer.vertAlign = "fullscreen";
	self.timedHardpointHUDTimer setTimer(usageInterval - ((gettime() - hardpointobj.lastusage) / 1000));
}

timedHardpointHUDHide( hardpointobj )
{
	if (!isdefined(self.showingObjHUD) || self.showingObjHUD != hardpointobj)
		return;
	self.showingObjHUD = undefined;
	
	self.timedHardpointHUDText.alpha = 0;
	self.timedHardpointHUDTimer.alpha = 0;
}

playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait ( 10.0 );
	org delete();
}

obj_radar_think()
{
	self.trig = getent(self.flag.target, "targetname");
	self.trig setHintString(&"PLATFORM_PRESS_TO_USE_RADAR");

	self.trig.originalorigin = self.trig.origin;
	
	self.lastusage = gettime() - 1000*60*60;
	self thread timedHardpointHUD( &"MP_WAR_WAITING_FOR_RADAR", level.radarInterval );

	self waittill("objective_created");
	self updateObjStatus("axis", "available");
	self updateObjStatus("allies", "available");

	while(1)
	{
		self.trig waittill("trigger", guy);
		
		if (!isalive(guy) || !isdefined(guy.pers["team"]) )
			continue;
		
		guyTriggeredRadar( guy );
		
		
		self.trig.origin += (0,0,-50000);
		
		self.lastusage = gettime();
		
		wait(level.radarInterval);
		
		self.trig.origin = self.trig.originalOrigin;

	/*
		players = getentarray("players", "classname");
		for (i = 0; i < players.size; i++)
			players[i] timedHardpointHUDHide(self);
	*/

		self updateObjStatus("axis", "available");
		self updateObjStatus("allies", "available");
	}
}

guyTriggeredRadar( guy )
{
	// this function was written to handle someone triggering radar even when they or the other team already had it.
	// that functionality is still in place, because it's harmless.
	
	team = guy.pers["team"];
	otherteam = "axis";
	if (team == "axis")
		otherteam = "allies";
	if (!teamHasRadar(team) || gettime() - level.radarLastUsageTime[team] > 1000*5)
	{
		printOnTeamArg(&"MP_WAR_RADAR_ACQUIRED", team, level.radarViewTime);
		printOnTeamArg(&"MP_WAR_RADAR_ACQUIRED_ENEMY", otherteam, level.radarViewTime);
		
		if (!teamHasRadar(team)) { // don't play the sound if they already have radar
			maps\mp\gametypes\_globallogic::leaderDialog( "uav_online", team );
			maps\mp\gametypes\_globallogic::leaderDialog( "enemy_uav_online", otherTeam );
		}
		
		level.radarLastUsageTime[team] = gettime();
		
		level notify("radar_timer_kill_" + team);
		self thread giveTeamRadar(team, otherteam);
	}
}

giveTeamRadar(team, otherteam)
{
	level endon("game_ended");
	level endon("radar_timer_kill_" + team);
	
	
	setTeamRadarWrapper(team, true);
	
	level notify("radar_timer_kill_" + otherteam);
	setTeamRadarWrapper(otherteam, false);

	self updateObjStatus(team, "used_friendly");
	self updateObjStatus(otherteam, "used_enemy");
	
	wait level.radarViewTime;
	
	setTeamRadarWrapper(team, false);
	
	printOnTeam(&"MP_WAR_RADAR_EXPIRED", team);
	printOnTeam(&"MP_WAR_RADAR_EXPIRED_ENEMY", otherteam);

//	playSoundOnPlayers( "US_Tmp_stm_uavoffline", team );
//	playSoundOnPlayers( "US_Tmp_stm_enemyuavoffline", otherTeam );
	
	//thread playSoundOnPlayers("mp_war_objective_taken");
}

ammo()
{
	ammoHandler = maps\mp\gametypes\_perplayer::init("ammo_handler", ::ammoPlayerPlaying, ::ammoPlayerNotPlaying);
	maps\mp\gametypes\_perplayer::enable(ammoHandler);
	
	level.ammoInterval = 60;
}

ammoPlayerPlaying()
{
	self.ammoLastUsageTime = gettime() - 1000*60*60;
}
ammoPlayerNotPlaying(disconnected)
{
	
}

obj_ammo_think()
{
	self setHintString(&"MP_WAR_PRESS_TO_REPLENISH_AMMO");

	self thread ammoHUD();
	
	self waittill("objective_created");
	self updateObjStatus("all", "available");

	while(1)
	{
		self waittill("trigger", guy);
		if (isalive(guy) && guy canUseAmmo())
		{
			guy playsound("weap_pickup");
			guy thread maps\mp\gametypes\_class::replenishLoadout();
			guy.ammoLastUsageTime = gettime();
		}
	}
}

canUseAmmo()
{
	if (!isdefined(self.ammoLastUsageTime))
		self.ammoLastUsageTime = gettime() - 1000*60*60;
	return (gettime() - self.ammoLastUsageTime) / 1000 >= level.ammoInterval;
}

ammoHUD()
{
	if (!isdefined(self.target))
		return;
	touchtrig = getent(self.target, "targetname");
	wait 1;
	while(1)
	{
		touchtrig waittill("trigger", player);
		player thread ammoHUDOnPlayer(touchtrig, self);
	}
}
ammoHUDOnPlayer(trig, ammoobj)
{
	self endon("disconnect");
	
	if (isdefined(self.ammoHUDThread))
		return;
	self.ammoHUDThread = true;
	
	// we loop until we die or leave the trigger, showing and hiding the ammo hud as necessary, then we hide the ammo hud
	while(1)
	{
		if (self.sessionstate != "playing" || !isalive(self) || !self istouching(trig))
			break;
		
		if (!self canUseAmmo())
			self ammoHUDShow(ammoobj);
		else
			self ammoHUDHide(ammoobj);
		
		wait .1;
	}
	self ammoHUDHide(ammoobj);
	
	self.ammoHUDThread = undefined;
}
ammoHUDShow(ammoobj)
{
	if (isdefined(self.showingObjHUD))
		return;
	self.showingObjHUD = ammoobj;
	
	self.ammoHUDText = newClientHudElem(self);
		self.ammoHUDText.alignX = "center";
		self.ammoHUDText.alignY = "top";
		self.ammoHUDText.fontScale = 1.5;
		self.ammoHUDText.x = 0;
		self.ammoHUDText.y = 50;
		self.ammoHUDText.horzAlign = "center";
		self.ammoHUDText.vertAlign = "fullscreen";
		self.ammoHUDText setText(&"MP_WAR_WAITING_FOR_AMMO");
	self.ammoHUDTimer = newClientHudElem(self);
		self.ammoHUDTimer.alignX = "center";
		self.ammoHUDTimer.alignY = "top";
		self.ammoHUDTimer.fontScale = 1.5;
		self.ammoHUDTimer.x = 0;
		self.ammoHUDTimer.y = 75;
		self.ammoHUDTimer.horzAlign = "center";
		self.ammoHUDTimer.vertAlign = "fullscreen";
		self.ammoHUDTimer setTimer(level.ammoInterval - ((gettime() - self.ammoLastUsageTime) / 1000));
}
ammoHUDHide(ammoobj)
{
	if (!isdefined(self.showingObjHUD) || self.showingObjHUD != ammoobj)
		return;
	self.showingObjHUD = undefined;
	
	self.ammoHUDText destroy();
	self.ammoHUDTimer destroy();
}

obj_copter_think()
{
	if (!isdefined(level.copterErrorChecked))
		copterErrorCheck();
	
	damagetrigs = getentarray("copter_damage_trig", "targetname");
	for (i = 0; i < damagetrigs.size; i++)
	{
		if ( !isdefined(damagetrigs[i].beingUsed) )
			break;
	}
	assert( i < damagetrigs.size );
	self.damagetrig = damagetrigs[i];
	self.damagetrig.beingUsed = true;
	
	self.trig = getent(self.flag.target, "targetname");
	self.trig.originalOrigin = self.trig.origin;
	self.trig.origin += (0,0,-50000);
	self.trig setHintString(&"PLATFORM_PRESS_TO_USE_COPTER");
	
	self.lastusage = gettime() - 1000*60*60;
	
	//thread trigdebug(self.trig);
	
	self.lastarrivaltime = gettime() - 1000*60*60;
	self.lastdeathtime = gettime() - 1000*60*60;
	self.waitingForArrival = false;

	self.oldcopter = [];

	self thread obj_locationSelect(
		::copterUsed,
		::copterInstructionsHUDShow,
		::copterInstructionsHUDHide,
		::canUseCopter
	);

	// no longer owned by a specific team, so let anyone use it
	self.trig.origin = self.trig.originalOrigin;

	self thread copterHUD();
}
trigdebug(trig)
{
	while(1)
	{
		players = level.players;
		if (players.size > 0)
			line(trig.origin, players[0].origin, (1,1,1));
		wait .05;
	}
}
copterErrorCheck()
{
	level.copterErrorChecked = true;
	
	copter_targets = getentarray("copter_target", "targetname");
	for (i = 0; i < copter_targets.size; i++)
	{
		assert(isdefined(copter_targets[i].radius));
		
		descentEnts = [];
		if (isdefined(copter_targets[i].target))
			descentEnts = getentarray(copter_targets[i].target, "targetname");
		for (j = 0; j < descentEnts.size; j++)
		{
			assert(isdefined(descentEnts[j].radius));
			assert(isdefined(descentEnts[j].target));
			assert(getentarray(descentEnts[j].target, "targetname").size == 1);
		}
	}
}
deleteCopterOnArrival(destent)
{
	self endon("death");
	self endon("dont_delete_on_arrival");
	while(1) {
		selfpos = (self.origin[0], self.origin[1], destent.origin[2]);
		if (distance(selfpos, destent.origin) < 256) {
			self maps\mp\gametypes\_copter::deleteCopter();
			return;
		}
		wait 1;
	}
}

canUseCopter(player)
{
	return (gettime() - self.lastusage) / 1000 >= level.copterInterval;
}

copterUsed(pos, player)
{
	self.team = player.pers["team"];
	
	userpos = (pos[0], pos[1], 0);
	copter_targets = getentarray("copter_target", "targetname");
	closest = undefined;
	closestdist = 0;
	for (i = 0; i < copter_targets.size; i++) {
		targetpos = (copter_targets[i].origin[0], copter_targets[i].origin[1], 0);
		thisdist = distance(userpos, targetpos);
		if (!isdefined(closest) || thisdist < closestdist) {
			closest = copter_targets[i];
			closestdist = thisdist;
		}
	}
	self useCopter(closest);
	
	self notify("used_copter");

	self.trig.origin = self.trig.originalOrigin + (0,0,-50000);
	

	wait(level.copterInterval);
	
	self.trig.origin = self.trig.originalOrigin;
}

useCopter(targetent)
{
	copterteam = self.team;
	//copterteam = "noteam";
	if (isdefined(self.copter))
	{
		if ( self.copter.team != copterteam )
		{
			self sendCopterAway();
		}
	}
	if ( !isdefined(self.copter) )
	{
		// check if an old one for this team is flying away; if so, bring it back
		if (isdefined(self.oldcopter[copterteam]) && !isdefined(self.oldcopter[copterteam].dead)) {
			self.copter = self.oldcopter[copterteam];
			self.oldcopter[copterteam] = undefined;
			self.copter maps\mp\gametypes\_copter::makeCopterActive(self.damagetrig);
			self thread handleCopterDeath();
			self.copter notify("dont_delete_on_arrival");
		}
		else {
			location = getent("copter_spawn_" + self.team, "targetname").origin; // should be a script_origin in the level
			self.copter = maps\mp\gametypes\_copter::createCopter(location, copterteam, self.damagetrig);
			self thread handleCopterDeath();
		}
	}
	else
		assert( self.copter.team == copterteam );
	self.copter maps\mp\gametypes\_copter::setCopterDefenseArea(targetent);
	self.copterdest = targetent;
	
	self.lastusage = gettime();

	self.waitingForArrival = true;
	self thread waitForCopterArrival();
}
handleCopterDeath()
{
	self.copter endon("passive");
	self.copter waittill("death");
	
	self notify("copter_death");
	
	self.copter = undefined;
	self.lastdeathtime = gettime();
	self.lastarrivaltime = gettime() - 1000*60*60;
	self.waitingForArrival = false;
	
	self.trig.origin = self.trig.originalOrigin + (0,0,-50000);
}
waitForCopterArrival()
{
	self.copter endon("death");
	self.copter endon("passive");
	while(1)
	{
		copterpos = (self.copter.origin[0], self.copter.origin[1], self.copterdest.origin[2]);
		if (distance(copterpos, self.copterdest.origin) < self.copterdest.radius) {
			self.waitingForArrival = false;
			self.lastarrivaltime = gettime();
			self thread fightAndLeave();
			return;
		}
		wait 1;
	}
}

fightAndLeave()
{
	self.copter endon("death");
	self.copter endon("passive");
	
	wait level.copterFightTime;
	
	self thread sendCopterAway();
}

sendCopterAway()
{
	self.copter maps\mp\gametypes\_copter::makeCopterPassive(); // TODO: copter can't be killed while flying away =\
	destent = getent("copter_spawn_" + self.copter.team, "targetname"); // should be a script_origin in the level
	self.copter maps\mp\gametypes\_copter::setCopterDest(destent.origin);
	self.copter thread deleteCopterOnArrival(destent);
	self.oldcopter[self.copter.team] = self.copter;
	self.copter = undefined;
}

copterInstructionsHUDShow()
{
	if (isdefined(self.showingCopterInstructions))
		return;
	self.showingCopterInstructions = true;

	if ( !isdefined( self.copterInstructions1 ) )
		self.copterInstructions1 = newClientHudElem(self);

	self.copterInstructions1.alignX = "center";
	self.copterInstructions1.alignY = "top";
	self.copterInstructions1.fontScale = 1.5;
	self.copterInstructions1.x = 0;
	self.copterInstructions1.y = 50;
	self.copterInstructions1.horzAlign = "center";
	self.copterInstructions1.vertAlign = "fullscreen";
	self.copterInstructions1 setText(&"MP_WAR_COPTER_INSTRUCTIONS1");
	self.copterInstructions1.alpha = 0;

	if ( !isdefined( self.copterInstructions2 ) )
		self.copterInstructions2 = newClientHudElem(self);

	self.copterInstructions2.alpha = 1;
	self.copterInstructions2.alignX = "center";
	self.copterInstructions2.alignY = "top";
	self.copterInstructions2.fontScale = 1.5;
	self.copterInstructions2.x = 0;
	self.copterInstructions2.y = 75;
	self.copterInstructions2.horzAlign = "center";
	self.copterInstructions2.vertAlign = "fullscreen";
	self.copterInstructions2 setText(&"MP_WAR_COPTER_INSTRUCTIONS2");
	
	self thread monitorCopterInstructions();
}
monitorCopterInstructions()
{
	self endon("hiding_copter_instructions");
	copter_targets = getentarray("copter_target", "targetname");
	while(1)
	{
		showit = false;
		mypos = (self.origin[0], self.origin[1], 0);
		for (i = 0; i < copter_targets.size; i++) {
			targetpos = (copter_targets[i].origin[0], copter_targets[i].origin[1], 0);
			if (distance(mypos, targetpos) <= copter_targets[i].radius) {
				showit = true;
				break;
			}
		}
		
		if (showit)
			self.copterInstructions1.alpha = 1;
		else
			self.copterInstructions1.alpha = 0;
		
		wait .3;
	}
}
copterInstructionsHUDHide(disconnected)
{
	if ( disconnected )
		return;
	
	if (!isdefined(self.showingCopterInstructions))
		return;
	self.showingCopterInstructions = undefined;
	
	self notify("hiding_copter_instructions");
	
	self.copterInstructions1.alpha = 0;
	self.copterInstructions2.alpha = 0;
}

shouldShowCopterHUD(player)
{
	if (player.pers["team"] != self.team)
		return false;
	if (distance(player.origin, self.origin) < 256)
		return true;
	return isdefined(player.usingObj) && player.usingObj == self;
}

waittillAny(str1, str2, str3, str4, str5)
{
	waitingobj = spawnstruct();
	
	if (isdefined(str1))
		waitingobj thread waittillAndNotify(self, str1);
	if (isdefined(str2))
		waitingobj thread waittillAndNotify(self, str2);
	if (isdefined(str3))
		waitingobj thread waittillAndNotify(self, str3);
	if (isdefined(str4))
		waitingobj thread waittillAndNotify(self, str4);
	if (isdefined(str5))
		waitingobj thread waittillAndNotify(self, str5);
	
	waitingobj waittill("happened");
	waitingobj notify("cancel");
	return;
}
waittillAndNotify(obj, str)
{
	self endon("cancel");
	obj waittill(str);
	self notify("happened");
}

copterHUD()
{
	while(1)
	{
		self waittill("trigger", player);
		player thread copterHUDOnPlayer(self);
	}
}
copterHUDOnPlayer(copterobj)
{
	if (copterobj copterCanBeUsed())
		return;
	
	self endon("disconnect");
	
	if (isdefined(self.copterHUDThread))
		return;
	self.copterHUDThread = true;
	
	self copterHUDShow(copterobj);

	// we loop until we die, leave the trigger, or artillery can be used, then we hide the artillery hud
	while(1)
	{
		if (self.sessionstate != "playing" || !isalive(self) || !self istouching(copterobj))
			break;
		
		if (copterobj copterCanBeUsed())
			break;
		
		wait .1;
	}
	self copterHUDHide(copterobj);
	
	self.copterHUDThread = undefined;
}
copterCanBeUsed()
{
	return ((gettime() - self.lastusage) / 1000 >= level.copterInterval);
}
copterHUDShow(copterobj)
{
	if (isdefined(self.showingObjHUD))
		return;
	self.showingObjHUD = copterobj;
	
	self.copterHUDText = newClientHudElem(self);
		self.copterHUDText.alignX = "center";
		self.copterHUDText.alignY = "top";
		self.copterHUDText.fontScale = 1.5;
		self.copterHUDText.x = 0;
		self.copterHUDText.y = 50;
		self.copterHUDText.horzAlign = "center";
		self.copterHUDText.vertAlign = "fullscreen";
		self.copterHUDText setText(&"MP_WAR_WAITING_FOR_COPTER_TO_BE_AVAILABLE");
	self.copterHUDTimer = newClientHudElem(self);
		self.copterHUDTimer.alignX = "center";
		self.copterHUDTimer.alignY = "top";
		self.copterHUDTimer.fontScale = 1.5;
		self.copterHUDTimer.x = 0;
		self.copterHUDTimer.y = 75;
		self.copterHUDTimer.horzAlign = "center";
		self.copterHUDTimer.vertAlign = "fullscreen";
		self.copterHUDTimer setTimer(level.copterInterval - ((gettime() - copterobj.lastusage) / 1000));
}
copterHUDHide(copterobj)
{
	if (!isdefined(self.showingObjHUD) || self.showingObjHUD != copterobj)
		return;
	self.showingObjHUD = undefined;
	
	self.copterHUDText.alpha = 0;
	self.copterHUDTimer.alpha = 0;
}



planeFlyOver( coord )
{	
	// Get starting and ending point for the plane
	direction = ( 0, randomint( 360 ), 0 );
	planeHalfDistance = 24000;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;

	startPoint = coord + vector_scale( anglestoforward( direction ), -1 * planeHalfDistance );
	startPoint += ( 0, 0, planeFlyHeight );

	endPoint = coord + vector_scale( anglestoforward( direction ), planeHalfDistance );
	endPoint += ( 0, 0, planeFlyHeight );
	
	// Make the plane fly by
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );
	
	level thread doPlaneFlyOver( coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), flyTime, direction );
	wait 2; //wait 0.10;
	level thread doPlaneFlyOver( coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), flyTime, direction );
	wait 0.5; //wait 0.50;
	level thread doPlaneFlyOver( coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), flyTime, direction );
	wait 2;
	level thread doPlaneFlyOver( coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), flyTime, direction );
}


doPlaneFlyOver( coord, startPoint, endPoint, flyTime, direction )
{
	// Spawn the planes
	plane = spawnplane( level.players[0], "script_model", startPoint + ( (randomint( 200 ) - 100 ), (randomint( 200 ) - 100 ), 0 ) );
	plane setModel( "vehicle_mig29_desert" );
	plane.angles = direction;
	
	plane thread playContrail();
	
	plane moveTo( endPoint + ( (randomint( 300 ) - 150 ), (randomint( 300 ) - 150 ), 0 ), flyTime, 0, 0 );

	thread callStrike_planeSound( plane, coord );

	wait flyTime;
	plane notify( "delete" );
	plane delete();
}

flyOver_planeSound( plane, coord )
{
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	while( !targetisclose( plane, coord ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );
	while( targetisinfront( plane, coord ) )
		wait .05;
	wait .5;
	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	while( targetisclose( plane, coord ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_close_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	plane waittill( "delete" );
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
}

giveHardpointItemForStreak()
{
	streak = self.cur_kill_streak;
	
	if ( streak < 3 )
		return;

	if ( !level.splitScreen )
	{
		if ( streak == 3 )
			self giveHardpoint( "radar_mp", streak );
		else if ( streak == 5 )
			self giveHardpoint( "airstrike_mp", streak );
		else if ( streak == 7 )
			self giveHardpoint( "helicopter_mp", streak );
		else if ( streak >= 10 )
		{
			if ( (streak % 5) == 0 )
				self streakNotify( streak );
		}

	}
	else
	{
		if ( streak == 3 )
		{
			self giveHardpoint( "airstrike_mp", streak );
		}
		else if ( streak == 5 )
		{
			self giveHardpoint( "helicopter_mp", streak );
		}
		else if ( streak >= 10 )
		{
			if ( (streak % 5) == 0 )
				self streakNotify( streak );
		}
	}
	/*
	if ( !level.splitScreen )
	{
		if ( streak == 3 || streak == 10 || streak == 25 )
			self giveHardpoint( "radar_mp", streak );
		else if ( streak == 5 || streak == 15 || streak == 30 )
			self giveHardpoint( "airstrike_mp", streak );
		else if ( streak == 7 || streak == 20 || streak == 35 )
			self giveHardpoint( "helicopter_mp", streak );
	}
	else
	{
		if ( streak == 3 || streak == 7 || streak == 11 )
			self giveHardpoint( "airstrike_mp", streak );
		else if ( streak == 5 || streak == 9 || streak == 13 )
			self giveHardpoint( "helicopter_mp", streak );
	}
	*/
}


streakNotify( streakVal )
{
	self endon("disconnect");

	// wait until any challenges have been processed
	self waittill( "playerKilledChallengesProcessed" );
	wait .05;
	
	notifyData = spawnStruct();
	notifyData.titleLabel = &"MP_KILLSTREAK_N";
	notifyData.titleText = streakVal;
	
	self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}


giveHardpoint( hardpointType, streak )
{
	if ( self maps\mp\gametypes\_hardpoints::giveHardpointItem( hardpointType ) )
		self thread hardpointNotify( hardpointType, streak );
}

hardpointNotify( hardpointType, streakVal )
{
	self endon("disconnect");
	
	// wait until any challenges have been processed
	self waittill( "playerKilledChallengesProcessed" );
	wait .05;
	
	notifyData = spawnStruct();
	notifyData.titleLabel = &"MP_KILLSTREAK_N";
	notifyData.titleText = streakVal;
	notifyData.notifyText = level.hardpointHints[hardpointType];
	notifyData.sound = level.hardpointInforms[hardpointType];
	notifyData.leaderSound = hardpointType;
	
	self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

giveHardpointItem( hardpointType )
{
	if ( level.gameEnded )
		return;
		
	if ( isDefined( self.selectingLocation ) )
		return false;

	if ( !isDefined( level.hardpointItems[hardpointType] ) )
		return false;

	if ( (!isDefined( level.heli_paths ) || !level.heli_paths.size) && hardpointType == "helicopter_mp" )
		return false;

	if ( isDefined( self.pers["hardPointItem"] ) )
	{
		if ( level.hardpointItems[hardpointType] < level.hardpointItems[self.pers["hardPointItem"]] )
			return false;
	}
	
	self giveWeapon( hardpointType );
	self giveMaxAmmo( hardpointType );
	self setActionSlot( 4, "weapon", hardpointType );
	self.pers["hardPointItem"] = hardpointType;	
	
	return true;
}


upgradeHardpointItem()
{
	if ( isDefined( self.selectingLocation ) )
		return;
	
	if ( !level.hardpointItems.size )
		return;

	hardpointType = getNextHardpointItem( self.pers["hardPointItem"] );

	if ( isDefined( self.pers["hardPointItem"] ) && level.hardpointItems[hardpointType] < level.hardpointItems[self.pers["hardPointItem"]] )
		return;
	
	self giveWeapon( hardpointType );
	self giveMaxAmmo( hardpointType );
	self setActionSlot( 4, "weapon", hardpointType );
	self.pers["hardPointItem"] = hardpointType;
	
	self thread maps\mp\gametypes\_hud_message::hintMessage( level.hardpointHints[hardpointType] );
}


getNextHardpointItem( hardpointType )
{
	hardpoints = getArrayKeys( level.hardpointItems );
	
	if ( !isDefined( hardpointType ) )
		return hardpoints[hardpoints.size-1];
	
	for ( index = hardpoints.size-1; index >= 0; index-- )
	{
		if ( hardpoints[index] != hardpointType )
			continue;
			
		if ( index != 0 )
			return hardpoints[index-1];
		else
			return hardpoints[index];
	}
}

giveOwnedHardpointItem()
{
	if ( isDefined( self.pers["hardPointItem"] ) )
		self giveHardpointItem( self.pers["hardPointItem"] );
}

hardpointItemWaiter()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	lastWeapon = self getCurrentWeapon();
	
	self giveOwnedHardpointItem();
	
	for ( ;; )
	{
		self waittill( "weapon_change" );
		
		currentWeapon = self getCurrentWeapon();
		
		switch( currentWeapon )
		{
			case "radar_mp":
			case "airstrike_mp":
			case "helicopter_mp":
				if ( self triggerHardpoint( currentWeapon ) )
				{	
					logString( "hardpoint: " + currentWeapon );
					self thread maps\mp\gametypes\_missions::useHardpoint( self.pers["hardPointItem"] );
					self thread [[level.onXPEvent]]( "hardpoint" );
					
					self takeWeapon( currentWeapon );
					self setActionSlot( 4, "" );
					self.pers["hardPointItem"] = undefined;
				}
				
				if ( lastWeapon != "none" )
					self switchToWeapon( lastWeapon );
				break;
			case "none":
				break;	
			default:
				lastWeapon = self getCurrentWeapon();
				break;
		}
	}
}


triggerHardPoint( hardpointType )
{
	if ( hardpointType == "radar_mp" )
	{
		self thread useRadarItem();
	}
	else if ( hardpointType == "airstrike_mp" )
	{
		if ( isDefined( level.airstrikeInProgress ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}
			
		result = self selectAirstrikeLocation();
		
		if ( !isDefined( result ) || !result )
			return false;
	}
	else if ( hardpointType == "helicopter_mp" )
	{
		if ( isDefined( level.chopper ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}
		
		destination = 0;
		random_path = randomint( level.heli_paths[destination].size );
		startnode = level.heli_paths[destination][random_path];
		
		team = self.pers["team"];
		otherTeam = level.otherTeam[team];
		
		if ( level.teambased )
		{
			maps\mp\gametypes\_globallogic::leaderDialog( "helicopter_inbound", team );
			maps\mp\gametypes\_globallogic::leaderDialog( "enemy_helicopter_inbound", otherTeam );
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
						player iprintln( &"MP_HELICOPTER_INBOUND", self );
				}
			}
		}
		else
		{
			self maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "helicopter_inbound" );
			selfarray = [];
			selfarray[0] = self;
			maps\mp\gametypes\_globallogic::leaderDialog( "enemy_helicopter_inbound", undefined, undefined, selfarray );
		}
		
		thread maps\mp\_helicopter::heli_think( self, startnode, self.pers["team"] );
	}
	
	return true;
}

UAVAcquiredPrintAndSound( team, otherteam, callingPlayer, numseconds )
{
	soundFriendly = game["voice"][team]      + game["dialog"]["uav_online"];
	soundEnemy    = game["voice"][otherteam] + game["dialog"]["enemy_uav_online"];
	
	if ( level.splitscreen )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED", callingPlayer, numseconds );
				else if ( playerteam == otherteam )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED_ENEMY", numseconds  );
			}
		}
		assert( level.splitscreen );
	
		level.players[0] playLocalSound( soundFriendly );
	}
	else
	{
		maps\mp\gametypes\_globallogic::leaderDialog( "uav_online", team );
		maps\mp\gametypes\_globallogic::leaderDialog( "enemy_uav_online", otherTeam );
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED", callingPlayer, numseconds );
				else if ( playerteam == otherteam )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED_ENEMY", numseconds  );
			}
		}
	}
}

useRadarItem()
{
	team = self.pers["team"];
	otherteam = "axis";
	if (team == "axis")
		otherteam = "allies";
	
	assert( isdefined( level.players ) );
	
	if ( level.teambased )
	{
		UAVAcquiredPrintAndSound( team, otherteam, self, level.radarViewTime );

		level notify( "radar_timer_kill_" + team );
		self thread useTeamUAV( team, otherteam );
	}
	else
	{
		self maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "uav_online" );
		self iprintln( &"MP_WAR_RADAR_ACQUIRED", self, level.radarViewTime );
		
		self notify("radar_timer_kill");
		self thread usePlayerUAV();
	}
}

useTeamUAV( team, otherteam )
{
	level endon("game_ended");
	level endon("radar_timer_kill_" + team);
	
	setTeamRadarWrapper( team, true );
	
	wait level.radarViewTime;
	
	setTeamRadarWrapper( team, false );
	
	printAndSoundOnEveryone( team, otherteam, &"MP_WAR_RADAR_EXPIRED", &"MP_WAR_RADAR_EXPIRED_ENEMY", undefined, undefined, "" );
}

usePlayerUAV( team, otherteam )
{
	level endon("game_ended");
	self endon("radar_timer_kill");
	self endon("disconnect");
	
	self.hasRadar = true;
	
	wait level.radarViewTime;
	
	self.hasRadar = false;
	
	self iprintln( &"MP_WAR_RADAR_EXPIRED" );
}

setTeamRadarWrapper( team, value )
{
	setTeamRadar( team, value );
	
	dvarval = 0;
	if ( value )
		dvarval = 1;
	setDvar( "ui_uav_" + team, dvarval );
	
	level notify( "radar_status_change", team );
}

selectAirstrikeLocation()
{
	self beginLocationSelection( "map_artillery_selector", level.artilleryunlikelyrange * 1.2 );
	self.selectingLocation = true;

	self thread endSelectionOn( "cancel_location" );
	self thread endSelectionOn( "death" );
	self thread endSelectionOn( "disconnect" );
	self thread endSelectionOn( "used" );
	self thread endSelectionOnGameEnd();

	self endon( "stop_location_selection" );
	self waittill( "confirm_location", location );

	if ( isDefined( level.airstrikeInProgress ) )
	{
		self iPrintLnBold( level.hardpointHints["airstrike_mp_not_available"] );
		self thread stopAirstrikeLocationSelection( false );
		return false;
	}

	self thread finishAirstrikeUsage( location, ::useAirstrike );
	return true;
}

finishAirstrikeUsage( location, usedCallback )
{
	self notify( "used" );
	wait ( 0.05 );
	self thread stopAirstrikeLocationSelection( false );
	self thread [[usedCallback]]( location );
	return true;
}

endSelectionOn( waitfor )
{
	self endon( "stop_location_selection" );
	
	self waittill( waitfor );

	self thread stopAirstrikeLocationSelection( (waitfor == "disconnect") );
}

endSelectionOnGameEnd()
{
	self endon( "stop_location_selection" );
	
	level waittill( "game_ended" );
	
	self thread stopAirstrikeLocationSelection( false );
}

stopAirstrikeLocationSelection( disconnected )
{
	if ( !disconnected )
	{
		self endLocationSelection();
		self.selectingLocation = undefined;
	}
	self notify( "stop_location_selection" );
}

useAirstrike( pos )
{
	trace = bullettrace( self.origin + (0,0,10000), self.origin, false, undefined );
	pos = (pos[0], pos[1], trace["position"][2] - 514);

	thread doArtillery( pos, self, self.pers["team"] );
}
