#using scripts\codescripts\struct;

#using scripts\shared\popups_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\_util;
#using scripts\cp\killstreaks\_emp;

#namespace killstreakrules;

function init()
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
	createRule( "turret", 								8,			4);
	createRule( "weapon", 								12,			6);
	createRule( "satellite", 							20,			10);
	createRule( "supplydrop", 							4,			4);
	createRule( "rcxd", 								3,			2);
	createRule( "targetableent",						32,			32); 	
	createRule( "missileswarm",							1,			1);
	createRule( "radar",								20,			10);
	createRule( "counteruav",							20,			10);
	createRule( "emp",									2,			1);
	createRule( "ai_tank",								4,			2);
	createRule( "straferun",							1,			1);
	createRule( "planemortar",							1,			1);
	createRule( "remotemortar", 						1,			1);
	createRule( "missiledrone", 						3,			3);

	// 					HardpointType						Rule Name					adds 	checks 
	addKillstreakToRule( "helicopter", 						"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter", 						"chopper", 					true, 	true );
	addKillstreakToRule( "helicopter", 						"playercontrolledchopper", 	false, 	true );
	addKillstreakToRule( "helicopter", 						"chopperInTheAir", 			true, 	false );
	addKillstreakToRule( "helicopter", 						"targetableent", 			true, 	true );
	addKillstreakToRule( "helicopter_x2", 					"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_x2", 					"chopper", 					true, 	true );
	addKillstreakToRule( "helicopter_x2", 					"playercontrolledchopper", 	false, 	true );
	addKillstreakToRule( "helicopter_x2", 					"chopperInTheAir", 			true, 	false );	
	addKillstreakToRule( "helicopter_x2", 					"targetableent", 			true, 	true );	
	addKillstreakToRule( "helicopter_comlink", 				"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_comlink", 				"chopper", 					true, 	true );
	addKillstreakToRule( "helicopter_comlink", 				"playercontrolledchopper", 	false, 	true );
	addKillstreakToRule( "helicopter_comlink", 				"chopperInTheAir", 			true, 	false );	
	addKillstreakToRule( "helicopter_comlink", 				"targetableent", 			true, 	true );	
	addKillstreakToRule( "helicopter_player_firstperson",	"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_player_firstperson", 	"playercontrolledchopper", 	true, 	true );
	addKillstreakToRule( "helicopter_player_firstperson", 	"chopperInTheAir", 			true, 	true );	
	addKillstreakToRule( "helicopter_player_firstperson", 	"targetableent", 			true, 	true );		
	addKillstreakToRule( "helicopter_guard", 				"airsupport",				true, 	true );
	addKillstreakToRule( "helicopter_gunner", 				"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_gunner", 				"playercontrolledchopper", 	true, 	true );
	addKillstreakToRule( "helicopter_gunner", 				"chopperInTheAir", 			true, 	true );
	addKillstreakToRule( "helicopter_gunner", 				"targetableent", 			true, 	true );
	addKillstreakToRule( "helicopter_player_gunner", 		"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_player_gunner", 		"playercontrolledchopper", 	true, 	true );
	addKillstreakToRule( "helicopter_player_gunner", 		"chopperInTheAir", 			true, 	true );
	addKillstreakToRule( "helicopter_player_gunner", 		"targetableent", 			true, 	true );
	addKillstreakToRule( "rcbomb", 							"rcxd", 					true, 	true );
	addKillstreakToRule( "supply_drop", 					"vehicle", 					true, 	true );
	addKillstreakToRule( "supply_drop", 					"supplydrop", 				true, 	true );
	addKillstreakToRule( "supply_drop", 					"targetableent",			true, 	true );
	addKillstreakToRule( "supply_station", 					"vehicle", 					true, 	true );
	addKillstreakToRule( "inventory_supply_drop", 			"vehicle", 					true, 	true );
	addKillstreakToRule( "inventory_supply_drop", 			"supplydrop", 				true, 	true );
	addKillstreakToRule( "inventory_supply_drop", 			"targetableent",			true, 	true );
	addKillstreakToRule( "supply_station", 					"supplydrop", 				true, 	true );
	addKillstreakToRule( "supply_station", 					"targetableent", 			true, 	true );
	addKillstreakToRule( "tow_turret_drop", 				"vehicle", 					true, 	true );
	addKillstreakToRule( "turret_drop", 					"vehicle", 					true, 	true );
	addKillstreakToRule( "m220_tow_drop",					"vehicle", 					true, 	true );
	addKillstreakToRule( "tow_turret_drop", 				"supplydrop", 				true, 	true );
	addKillstreakToRule( "turret_drop", 					"supplydrop", 				true, 	true );
	addKillstreakToRule( "m220_tow_drop",					"supplydrop", 				true, 	true );
	addKillstreakToRule( "m220_tow_killstreak",				"weapon",					true,	true );
	addKillstreakToRule( "autoturret", 						"turret", 					true, 	true );
	addKillstreakToRule( "auto_tow", 						"turret", 					true, 	true );
	addKillstreakToRule( "microwaveturret",					"turret", 					true, 	true );
	addKillstreakToRule( "minigun", 						"weapon", 					true, 	true );
	addKillstreakToRule( "minigun_drop", 					"weapon", 					true, 	true );
	addKillstreakToRule( "inventory_minigun", 				"weapon", 					true, 	true );
	addKillstreakToRule( "m32", 							"weapon", 					true, 	true );
	addKillstreakToRule( "m32_drop", 						"weapon", 					true, 	true );
	addKillstreakToRule( "inventory_m32", 					"weapon", 					true, 	true );
	addKillstreakToRule( "m202_flash",						"weapon", 					true, 	true );
	addKillstreakToRule( "m220_tow", 						"weapon", 					true, 	true );
	addKillstreakToRule( "mp40_drop", 						"weapon", 					true, 	true );
	addKillstreakToRule( "dogs", 							"dogs", 					true, 	true );
	addKillstreakToRule( "dogs_lvl2",						"dogs", 					true, 	true );
	addKillstreakToRule( "dogs_lvl3",						"dogs", 					true, 	true );
	addKillstreakToRule( "artillery", 						"firesupport", 				true, 	true );
	addKillstreakToRule( "mortar", 							"firesupport", 				true, 	true );
	addKillstreakToRule( "napalm", 							"vehicle", 					true, 	true );
	addKillstreakToRule( "napalm", 							"airsupport", 				true, 	true );
	addKillstreakToRule( "airstrike", 						"vehicle", 					true, 	true );
	addKillstreakToRule( "airstrike", 						"airsupport", 				true, 	true );
	addKillstreakToRule( "radardirection", 					"satellite", 				true, 	true );
	addKillstreakToRule( "radar", 							"radar",		 			true, 	true );
	addKillstreakToRule( "radar", 							"targetableent", 			true, 	true );
	addKillstreakToRule( "counteruav", 						"counteruav",	 			true, 	true );
	addKillstreakToRule( "counteruav", 						"targetableent", 			true, 	true );
	addKillstreakToRule( "emp",								"emp",			 			true, 	true );
	addKillstreakToRule( "remote_mortar",					"targetableent", 			true, 	true );
	addKillstreakToRule( "remote_mortar",					"remotemortar", 			true, 	true );
	addKillstreakToRule( "remote_missile",					"targetableent", 			true, 	true );
	addKillstreakToRule( "qrdrone",							"vehicle", 					true, 	true );
	addKillstreakToRule( "qrdrone",							"qrdrone",				 	true, 	true );
	addKillstreakToRule( "missile_swarm",					"missileswarm", 			true, 	true );
	addKillstreakToRule( "missile_drone",					"missiledrone", 			true, 	true );
	addKillstreakToRule( "inventory_missile_drone",			"missiledrone", 			true, 	true );
	addKillstreakToRule( "straferun", 						"straferun",				true, 	true );
	addKillstreakToRule( "ai_tank_drop",					"ai_tank",		 			true, 	true );
	addKillstreakToRule( "inventory_ai_tank_drop",			"ai_tank",		 			true, 	true );
	addKillstreakToRule( "planemortar", 					"planemortar",				true, 	true );
}
	
function createRule( rule, maxAllowable, maxAllowablePerTeam )
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

function addKillstreakToRule( hardpointType, rule, countTowards, checkAgainst )
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
function killstreakStart( hardpointType, team, hacked, displayTeamMessage )
{	
	/#
	assert( isdefined( team ), "team needs to be defined" );
	#/

	if ( self isKillstreakAllowed( hardpointType, team ) == false )
		return -1;
		
	assert ( isdefined ( hardpointType ) );
		
	if( !isdefined( hacked ) )
		hacked = false;

	if ( !isdefined( displayTeamMessage ) )
		displayTeamMessage = true;
	
	if ( displayTeamMessage == true )
	{
		if ( isdefined( level.killstreaks[hardpointType] ) && isdefined( level.killstreaks[hardpointType].inboundtext ) && !hacked )
			level thread popups::DisplayKillstreakTeamMessageToAll( hardpointType, self );
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
	if ( level.teambased )
	{
		killstreak_data[ "team" ] = team;
	}
	
	level.killstreaks_triggered[ killstreak_id ] = killstreak_data;

	/#
		killstreak_debug_text( "Started killstreak: " + hardpointtype + " for team: " + team + " id: " + killstreak_id );
	#/
	
	return killstreak_id;
}

function killstreakStop( hardpointType, team, id )
{
	/#
	assert( isdefined( team ), "team needs to be defined" );
	#/

	assert ( isdefined ( hardpointType ) );
	//assert( isdefined( id ), "Must provide the associated killstreak_id for " + hardpointType );

	/#
	killstreak_debug_text( "Stopped killstreak: " + hardpointtype + " for team: " + team + " id: " + id );
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

	if ( !isdefined(id) || (id == -1) )
	{
		killstreak_debug_text("WARNING! Invalid killstreak id detected for " + hardpointType );

		// log a lightweight entry in the DB to assist tracking down invalid cases
		// Removed a blackbox print for "mpkillstreakuses" from here
		return;
	}
	level.killstreaks_triggered[ id ][ "endtime" ] = GetTime();

	// Removed a blackbox print for "mpkillstreakuses" from here

	level.killstreaks_triggered[ id ] = undefined;
	
	if( isdefined( level.killstreaks[hardpointType].menuname ) )
	{
		recordStreakIndex = level.killstreakindices[level.killstreaks[hardpointType].menuname];
		if ( isdefined( recordStreakIndex ) )
		{
			if ( isdefined( self.owner ) )
			{
				self.owner RecordkillstreakEndEvent( recordStreakIndex );
			}
			else if ( IsPlayer( self ) )
			{
				self RecordkillstreakEndEvent( recordStreakIndex );
			}
				
		}
	}
}

function isKillstreakAllowed( hardpointType, team )
{
	/#
	assert( isdefined( team ), "team needs to be defined" );
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
	
	
	if ( isdefined( self.lastStand ) && self.lastStand )
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
		
		if ( self emp::isEnemyEMPKillstreakActive() )
		{
			if ( isdefined( level.empEndTime ) )
			{
				secondsLeft = int( ( level.empendtime - getTime() ) / 1000 );
				if ( secondsLeft > 0 )
				{
				    self iprintlnbold( &"KILLSTREAK_NOT_AVAILABLE_EMP_ACTIVE", secondsLeft );
				    return false;
				}
			}
		}
	}
	
	if ( isAllowed == false )
	{
		if ( isdefined( level.killstreaks[hardpointType] ) && isdefined( level.killstreaks[hardpointType].notAvailableText ) )
		{
			self iprintlnbold( level.killstreaks[hardpointType].notAvailableText );
			
			if( hardpointType == "helicopter_comlink" || hardpointType == "helicopter_guard" || hardpointType == "helicopter_player_gunner" ||
			  hardpointType == "remote_mortar" || hardpointType == "inventory_supply_drop" || hardpointType == "supply_drop" || hardpointType == "straferun")
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

function killstreak_debug_text( text )
{
/#
	level.killstreak_rule_debug = GetDvarInt( "scr_killstreak_rule_debug", 0 );				// debug mode, draws debugging info on screen
	
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