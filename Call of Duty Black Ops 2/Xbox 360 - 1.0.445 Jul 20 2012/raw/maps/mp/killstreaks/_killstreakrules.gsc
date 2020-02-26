#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;


init()
{
	level.killstreakrules = [];
	level.killstreaktype = [];
	level.killstreaks_triggered = [];

	level.killstreak_counter = 0;
	
	//			Rule name,  							max count	per team count
	createRule( "vehicle", 								7,			7);
	createRule( "firesupport", 							1,			1);
	createRule( "airsupport", 							1,			1);
	createRule( "playercontrolledchopper", 				1,			1);
	createRule( "chopperInTheAir", 						1,			1);	
	createRule( "chopper", 								2,			1);
	createRule( "qrdrone",		 						3,			2);
	createRule( "dogs",									1,			1);
	createRule( "turret", 								7,			7);
	createRule( "weapon", 								3,			3);
	createRule( "satellite", 							20,			10);
	createRule( "supplydrop", 							4,			4);
	createRule( "rcxd", 								3,			2);
	createRule( "targetableent",						32,			32); 	
	createRule( "missileswarm",							1,			1);
	createRule( "radar",								20,			10);
	createRule( "counteruav",							20,			10);
	createRule( "emp",									2,			1);
	createRule( "ai_tank",								4,			4);
	createRule( "straferun",							1,			1);
	createRule( "planemortar",							1,			1);
	createRule( "remotemortar", 						1,			1);
	createRule( "missiledrone", 						3,			3);

	// 					HardpointType							Rule Name					adds 	checks 
	addKillstreakToRule( "helicopter_mp", 						"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_mp", 						"chopper", 					true, 	true );
	addKillstreakToRule( "helicopter_mp", 						"playercontrolledchopper", 	false, 	true );
	addKillstreakToRule( "helicopter_mp", 						"chopperInTheAir", 			true, 	false );
	addKillstreakToRule( "helicopter_mp", 						"targetableent", 			true, 	true );
	addKillstreakToRule( "helicopter_x2_mp", 					"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_x2_mp", 					"chopper", 					true, 	true );
	addKillstreakToRule( "helicopter_x2_mp", 					"playercontrolledchopper", 	false, 	true );
	addKillstreakToRule( "helicopter_x2_mp", 					"chopperInTheAir", 			true, 	false );	
	addKillstreakToRule( "helicopter_x2_mp", 					"targetableent", 			true, 	true );	
	addKillstreakToRule( "helicopter_comlink_mp", 				"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_comlink_mp", 				"chopper", 					true, 	true );
	addKillstreakToRule( "helicopter_comlink_mp", 				"playercontrolledchopper", 	false, 	true );
	addKillstreakToRule( "helicopter_comlink_mp", 				"chopperInTheAir", 			true, 	false );	
	addKillstreakToRule( "helicopter_comlink_mp", 				"targetableent", 			true, 	true );	
	addKillstreakToRule( "helicopter_player_firstperson_mp",	"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_player_firstperson_mp", 	"playercontrolledchopper", 	true, 	true );
	addKillstreakToRule( "helicopter_player_firstperson_mp", 	"chopperInTheAir", 			true, 	true );	
	addKillstreakToRule( "helicopter_player_firstperson_mp", 	"targetableent", 			true, 	true );		
	addKillstreakToRule( "helicopter_guard_mp", 				"airsupport",				true, 	true );
	addKillstreakToRule( "helicopter_gunner_mp", 				"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_gunner_mp", 				"playercontrolledchopper", 	true, 	true );
	addKillstreakToRule( "helicopter_gunner_mp", 				"chopperInTheAir", 			true, 	true );
	addKillstreakToRule( "helicopter_gunner_mp", 				"targetableent", 			true, 	true );
	addKillstreakToRule( "helicopter_player_gunner_mp", 		"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_player_gunner_mp", 		"playercontrolledchopper", 	true, 	true );
	addKillstreakToRule( "helicopter_player_gunner_mp", 		"chopperInTheAir", 			true, 	true );
	addKillstreakToRule( "helicopter_player_gunner_mp", 		"targetableent", 			true, 	true );
	addKillstreakToRule( "rcbomb_mp", 							"rcxd", 					true, 	true );
	addKillstreakToRule( "supply_drop_mp", 						"vehicle", 					true, 	true );
	addKillstreakToRule( "supply_drop_mp", 						"supplydrop", 				true, 	true );
	addKillstreakToRule( "supply_drop_mp", 						"targetableent",			true, 	true );
	addKillstreakToRule( "supply_station_mp", 					"vehicle", 					true, 	true );
	addKillstreakToRule( "inventory_supply_drop_mp", 			"vehicle", 					true, 	true );
	addKillstreakToRule( "inventory_supply_drop_mp", 			"supplydrop", 				true, 	true );
	addKillstreakToRule( "inventory_supply_drop_mp", 			"targetableent",			true, 	true );
	addKillstreakToRule( "supply_station_mp", 					"supplydrop", 				true, 	true );
	addKillstreakToRule( "supply_station_mp", 					"targetableent", 			true, 	true );
	addKillstreakToRule( "tow_turret_drop_mp", 					"vehicle", 					true, 	true );
	addKillstreakToRule( "turret_drop_mp", 						"vehicle", 					true, 	true );
	addKillstreakToRule( "m220_tow_drop_mp",					"vehicle", 					true, 	true );
	addKillstreakToRule( "tow_turret_drop_mp", 					"supplydrop", 				true, 	true );
	addKillstreakToRule( "turret_drop_mp", 						"supplydrop", 				true, 	true );
	addKillstreakToRule( "m220_tow_drop_mp",					"supplydrop", 				true, 	true );
	addKillstreakToRule( "m220_tow_killstreak_mp",				"weapon",					true,	true );
	addKillstreakToRule( "autoturret_mp", 						"turret", 					true, 	true );
	addKillstreakToRule( "auto_tow_mp", 						"turret", 					true, 	true );
	addKillstreakToRule( "microwaveturret_mp",					"turret", 					true, 	true );
	addKillstreakToRule( "minigun_mp", 							"weapon", 					true, 	true );
	addKillstreakToRule( "minigun_drop_mp", 					"weapon", 					true, 	true );
	addKillstreakToRule( "inventory_minigun_drop_mp", 			"weapon", 					true, 	true );
	addKillstreakToRule( "m32_mp", 								"weapon", 					true, 	true );
	addKillstreakToRule( "m32_drop_mp", 						"weapon", 					true, 	true );
	addKillstreakToRule( "inventory_m32_drop_mp", 				"weapon", 					true, 	true );
	addKillstreakToRule( "m202_flash_mp",						"weapon", 					true, 	true );
	addKillstreakToRule( "m220_tow_mp", 						"weapon", 					true, 	true );
	addKillstreakToRule( "mp40_drop_mp", 						"weapon", 					true, 	true );
	addKillstreakToRule( "dogs_mp", 							"dogs", 					true, 	true );
	addKillstreakToRule( "dogs_lvl2_mp",						"dogs", 					true, 	true );
	addKillstreakToRule( "dogs_lvl3_mp",						"dogs", 					true, 	true );
	addKillstreakToRule( "artillery_mp", 						"firesupport", 				true, 	true );
	addKillstreakToRule( "mortar_mp", 							"firesupport", 				true, 	true );
	addKillstreakToRule( "napalm_mp", 							"vehicle", 					true, 	true );
	addKillstreakToRule( "napalm_mp", 							"airsupport", 				true, 	true );
	addKillstreakToRule( "airstrike_mp", 						"vehicle", 					true, 	true );
	addKillstreakToRule( "airstrike_mp", 						"airsupport", 				true, 	true );
	addKillstreakToRule( "radardirection_mp", 					"satellite", 				true, 	true );
	addKillstreakToRule( "radar_mp", 							"radar",		 			true, 	true );
	addKillstreakToRule( "radar_mp", 							"targetableent", 			true, 	true );
	addKillstreakToRule( "counteruav_mp", 						"counteruav",	 			true, 	true );
	addKillstreakToRule( "counteruav_mp", 						"targetableent", 			true, 	true );
	addKillstreakToRule( "emp_mp",								"emp",			 			true, 	true );
	addKillstreakToRule( "remote_mortar_mp",					"targetableent", 			true, 	true );
	addKillstreakToRule( "remote_mortar_mp",					"remotemortar", 			true, 	true );
	addKillstreakToRule( "remote_missile_mp",					"targetableent", 			true, 	true );
	addKillstreakToRule( "qrdrone_mp",							"vehicle", 					true, 	true );
	addKillstreakToRule( "qrdrone_mp",							"qrdrone",				 	true, 	true );
	addKillstreakToRule( "missile_swarm_mp",					"missileswarm", 			true, 	true );
	addKillstreakToRule( "missile_drone_mp",					"missiledrone", 			true, 	true );
	addKillstreakToRule( "inventory_missile_drone_mp",			"missiledrone", 			true, 	true );
	addKillstreakToRule( "straferun_mp", 						"straferun",				true, 	true );
	addKillstreakToRule( "ai_tank_drop_mp",						"ai_tank",		 			true, 	true );
	addKillstreakToRule( "inventory_ai_tank_drop_mp",			"ai_tank",		 			true, 	true );
	addKillstreakToRule( "planemortar_mp", 						"planemortar",				true, 	true );
}
	
createRule( rule, maxAllowable, maxAllowablePerTeam )
{
	if ( !level.teambased ) 
	{
		if ( maxAllowable > maxAllowablePerTeam )
		{
			maxAllowable = maxAllowablePerTeam;
		}
	}
	
	level.killstreakrules[rule] = spawnstruct();
	level.killstreakrules[rule].cur = 0;
	level.killstreakrules[rule].curTeam = [];
	level.killstreakrules[rule].max = maxAllowable;
	level.killstreakrules[rule].maxPerTeam = maxAllowablePerTeam;
}

addKillstreakToRule( hardpointType, rule, countTowards, checkAgainst )
{
	if ( !isdefined (level.killstreaktype[hardpointType] ) )
		level.killstreaktype[hardpointType] = [];
		
	keys = GetArrayKeys( level.killstreaktype[hardpointType] );
	
	// you need to add a rule before adding it to a killstreak
	assert( isdefined(level.killstreakrules[rule] ) );

	if ( !isdefined( level.killstreaktype[hardpointType][rule] ) )
		level.killstreaktype[hardpointType][rule] = spawnstruct();

	level.killstreaktype[hardpointType][rule].counts = countTowards;
	
	level.killstreaktype[hardpointType][rule].checks = checkAgainst;
}

// returns killstreakid or -1 if killstreak is not allowed
killstreakStart( hardpointType, team, hacked, displayTeamMessage )
{	
	/#
	assert( IsDefined( team ), "team needs to be defined" );
	#/

	if ( self isKillstreakAllowed( hardpointType, team ) == false )
		return -1;
		
	assert ( isdefined ( hardpointType ) );
	/#
	killstreak_debug_text( "Started killstreak: " + hardpointtype );
	#/
	
	if( !IsDefined( hacked ) )
		hacked = false;

	if ( !IsDefined( displayTeamMessage ) )
		displayTeamMessage = true;
	
	if ( displayTeamMessage == true )
	{
		if ( isdefined( level.killstreaks[hardpointType] ) && isdefined( level.killstreaks[hardpointType].inboundtext ) && !hacked )
			level thread maps\mp\_popups::DisplayKillstreakTeamMessageToAll( hardpointType, self );
	}

	keys = GetArrayKeys( level.killstreaktype[hardpointType] );

	foreach( key in keys )
	{
		// Check if killstreak is counted by this rule
		if ( !level.killstreaktype[hardpointType][key].counts )
			continue;
			
		assert( isdefined(level.killstreakrules[key] ) );
		level.killstreakrules[key].cur++;
		if ( level.teambased )
		{
			if ( !isdefined( level.killstreakrules[key].curTeam[team] ) )
				level.killstreakrules[key].curTeam[team] = 0;
			level.killstreakrules[key].curTeam[team]++;
		}
	}
	
	level notify( "killstreak_started", hardpointType, team, self );
	
	killstreak_id = level.killstreak_counter;
	level.killstreak_counter++;
	
	killstreak_data = [];
	killstreak_data[ "caller" ] = self GetXUID();
	killstreak_data[ "spawnid" ] = getplayerspawnid( self );
	killstreak_data[ "starttime" ] = gettime();
	killstreak_data[ "type" ] = hardpointType;
	killstreak_data[ "endtime" ] = 0;

	level.killstreaks_triggered[ killstreak_id ] = killstreak_data;

	return killstreak_id;
}

killstreakStop( hardpointType, team, id )
{
	/#
	assert( IsDefined( team ), "team needs to be defined" );
	#/

	assert ( isdefined ( hardpointType ) );
	//assert( isdefined( id ), "Must provide the associated killstreak_id for " + hardpointType );

	/#
	killstreak_debug_text( "Stopped killstreak: " + hardpointtype );
	#/
	keys = GetArrayKeys( level.killstreaktype[hardpointType] );
	
	foreach( key in keys )
	{
		// Check if killstreak is counted by this rule
		if ( !level.killstreaktype[hardpointType][key].counts )
			continue;
			
		assert( isdefined(level.killstreakrules[key] ) );
		level.killstreakrules[key].cur--;
		
		assert (level.killstreakrules[key].cur >= 0 );
		
		if ( level.teambased )
		{
			assert( isdefined( team ) );
			assert( isdefined( level.killstreakrules[key].curTeam[team] ) );

			level.killstreakrules[key].curTeam[team]--;
			assert (level.killstreakrules[key].curTeam[team] >= 0 );
		}
	}

	if ( !isDefined(id) || (id == -1) )
	{
		killstreak_debug_text("WARNING! Invalid killstreak id detected for " + hardpointType );

		// log a lightweight entry in the DB to assist tracking down invalid cases
		bbPrint( "mpkillstreakuses", "starttime %d endtime %d name %s team %s", 0, GetTime(), hardpointType, team ); 
		return;
	}
	level.killstreaks_triggered[ id ][ "endtime" ] = GetTime();

	bbPrint( "mpkillstreakuses", "starttime %d endtime %d spawnid %d name %s team %s",
				level.killstreaks_triggered[ id ][ "starttime" ],
				level.killstreaks_triggered[ id ][ "endtime" ],
				level.killstreaks_triggered[ id ][ "spawnid" ],
				hardpointType,
				team );

	level.killstreaks_triggered[ id ] = undefined;
}

isKillstreakAllowed( hardpointType, team )
{
	/#
	assert( IsDefined( team ), "team needs to be defined" );
	#/

	assert ( isdefined ( hardpointType ) );
	
	isAllowed = true;
	
	keys = GetArrayKeys( level.killstreaktype[hardpointType] );
	
	foreach( key in keys )
	{
		// Check if killstreak is restricted by this rule
		if ( !level.killstreaktype[hardpointType][key].checks )
			continue;
			
		if ( level.killstreakrules[key].max != 0 ) 
		{
			if (level.killstreakrules[key].cur >= level.killstreakrules[key].max)
			{
				/#
				killstreak_debug_text( "Exceeded " + key + " overall" );
				#/
				isAllowed = false;	
				break;
			}
		}
			
		if ( level.teambased && level.killstreakrules[key].maxPerTeam != 0 )
		{
			if ( !isdefined( level.killstreakrules[key].curTeam[team] ) )
				level.killstreakrules[key].curTeam[team] = 0;
			
			if (level.killstreakrules[key].curTeam[team] >= level.killstreakrules[key].maxPerTeam)
			{
				isAllowed = false;	
				/#
				killstreak_debug_text( "Exceeded " + key + " team" );
				#/
				break;
			}
		}
	}
	
	
	if ( isDefined( self.lastStand ) && self.lastStand )
	{
		/#
		killstreak_debug_text( "In LastStand" );
		#/
		isAllowed = false;
	}

	// should only be needed in case of a hacked client, the client checks the EMP flag prior to switching to the killstreak weapon
	if ( self IsEMPJammed() ) 
	{
		/#
		killstreak_debug_text( "EMP active" );
		#/
		isAllowed = false;
	}
	
	if ( isAllowed == false )
	{
		if ( isdefined( level.killstreaks[hardpointType] ) && isdefined( level.killstreaks[hardpointType].notAvailableText ) )
		{
			self iprintlnbold( level.killstreaks[hardpointType].notAvailableText );
			
			if( hardpointType == "helicopter_comlink_mp" || hardpointType == "helicopter_guard_mp" || hardpointType == "helicopter_player_gunner_mp" ||
			  hardpointType == "remote_mortar_mp" || hardpointType == "inventory_supply_drop_mp" || hardpointType == "supply_drop_mp" || hardpointType == "straferun_mp")
			{
				//get random voice number
				pilotVoiceNumber = RandomIntRange(0,3);
			
				soundAlias = level.teamPrefix[self.team] + pilotVoiceNumber + "_" + "kls_full";
				self playLocalSound(soundAlias);
			}
			
		}
	}

	return isAllowed;
}

killstreak_debug_text( text )
{
/#
	level.killstreak_rule_debug = GetDvarIntDefault( "scr_killstreak_rule_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.killstreak_rule_debug ) )
	{
		if ( level.killstreak_rule_debug == 1.0 )
		{
			iprintln( "KSR: " + text + "\n" );
		}
		else  if ( level.killstreak_rule_debug == 2.0 )
		{
			iprintlnbold( "KSR: " + text );
		}
	}
#/
}