#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;


init()
{
	level.killstreakrules = [];
	level.killstreaktype = [];
	
	//			Rule name,  							max count	per team count
	createRule( "vehicle", 								7,			7);
	createRule( "firesupport", 							1,			1);
	createRule( "airsupport", 							1,			1);
	createRule( "playercontrolledchopper", 				1,			1);
	createRule( "chopperInTheAir", 						1,			1);	
	createRule( "chopper", 								2,			1);
	createRule( "dog", 									1,			1);
	createRule( "turret", 								7,			7);
	createRule( "weapon", 								3,			3);
	createRule( "satellite", 							2,			1);
	createRule( "supplydrop", 							3,			3);
	createRule( "rcxd", 								3,			2);
	createRule( "targetableent",						32,			32); 	
	
	// 					 HardpointType							Rule Name					adds 	checks 
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
	addKillstreakToRule( "helicopter_gunner_mp", 				"vehicle", 					true, 	true );
	addKillstreakToRule( "helicopter_gunner_mp", 				"playercontrolledchopper", 	true, 	true );
	addKillstreakToRule( "helicopter_gunner_mp", 				"chopperInTheAir", 			true, 	true );
	addKillstreakToRule( "helicopter_gunner_mp", 				"targetableent", 			true, 	true );
	addKillstreakToRule( "rcbomb_mp", 							"rcxd", 					true, 	true );
	addKillstreakToRule( "supply_drop_mp", 						"vehicle", 					true, 	true );
	addKillstreakToRule( "supply_drop_mp", 						"supplydrop", 				true, 	true );
	addKillstreakToRule( "supply_drop_mp", 						"targetableent",			true, 	true );
	addKillstreakToRule( "supply_station_mp", 					"vehicle", 					true, 	true );
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
	addKillstreakToRule( "minigun_mp", 							"weapon", 					true, 	true );
	addKillstreakToRule( "m202_flash_mp",						"weapon", 					true, 	true );
	addKillstreakToRule( "m220_tow_mp", 						"weapon", 					true, 	true );
	addKillstreakToRule( "mp40_drop_mp", 						"weapon", 					true, 	true );
	addKillstreakToRule( "dogs_mp", 							"dog", 						true, 	true );
	addKillstreakToRule( "artillery_mp", 						"firesupport", 				true, 	true );
	addKillstreakToRule( "mortar_mp", 							"firesupport", 				true, 	true );
	addKillstreakToRule( "napalm_mp", 							"vehicle", 					true, 	true );
	addKillstreakToRule( "napalm_mp", 							"airsupport", 				true, 	true );
	addKillstreakToRule( "airstrike_mp", 						"vehicle", 					true, 	true );
	addKillstreakToRule( "airstrike_mp", 						"airsupport", 				true, 	true );
	addKillstreakToRule( "radardirection_mp", 					"satellite", 				true, 	true );
	addKillstreakToRule( "radar_mp", 							"targetableent", 			true, 	true );
	addKillstreakToRule( "counteruav_mp", 						"targetableent", 			true, 	true );
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

killstreakStart( hardpointType, team, hacked, displayTeamMessage )
{	
	/#
	assert( IsDefined( team ), "team needs to be defined" );
	#/

	if ( self isKillstreakAllowed( hardpointType, team ) == false )
		return false;
		
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

	for ( i = 0; i < keys.size; i++ )
	{
		// Check if killstreak is counted by this rule
		if ( !level.killstreaktype[hardpointType][keys[i]].counts )
			continue;
			
		assert( isdefined(level.killstreakrules[keys[ i ]] ) );
		level.killstreakrules[keys[ i ]].cur++;
		if ( level.teambased )
		{
			if ( !isdefined( level.killstreakrules[keys[ i ]].curTeam[team] ) )
				level.killstreakrules[keys[ i ]].curTeam[team] = 0;
			level.killstreakrules[keys[ i ]].curTeam[team]++;
		}
	}
	return true;
}

killstreakStop( hardpointType, team )
{
	/#
	assert( IsDefined( team ), "team needs to be defined" );
	#/

	assert ( isdefined ( hardpointType ) );
	/#
	killstreak_debug_text( "Stopped killstreak: " + hardpointtype );
	#/
	keys = GetArrayKeys( level.killstreaktype[hardpointType] );
	
	for ( i = 0; i < keys.size; i++ )
	{
		// Check if killstreak is counted by this rule
		if ( !level.killstreaktype[hardpointType][keys[i]].counts )
			continue;
			
		assert( isdefined(level.killstreakrules[keys[ i ]] ) );
		level.killstreakrules[keys[ i ]].cur--;
		
		assert (level.killstreakrules[keys[ i ]].cur >= 0 );
		
		if ( level.teambased )
		{
			assert( isdefined( team ) );
			assert( isdefined( level.killstreakrules[keys[ i ]].curTeam[team] ) );

			level.killstreakrules[keys[ i ]].curTeam[team]--;
			assert (level.killstreakrules[keys[ i ]].curTeam[team] >= 0 );
		}
	}
}

isKillstreakAllowed( hardpointType, team )
{
	/#
	assert( IsDefined( team ), "team needs to be defined" );
	#/

	assert ( isdefined ( hardpointType ) );
	
	isAllowed = true;
	
	keys = GetArrayKeys( level.killstreaktype[hardpointType] );
	
	for ( i = 0; i < keys.size; i++ )
	{
		// Check if killstreak is restricted by this rule
		if ( !level.killstreaktype[hardpointType][keys[i]].checks )
			continue;
			
		if ( level.killstreakrules[keys[ i ]].max != 0 ) 
		{
			if (level.killstreakrules[keys[ i ]].cur >= level.killstreakrules[keys[ i ]].max)
				isAllowed = false;	
		}
			
		if ( level.teambased && level.killstreakrules[keys[ i ]].maxPerTeam != 0 )
		{
			if ( !isdefined( level.killstreakrules[keys[ i ]].curTeam[team] ) )
				level.killstreakrules[keys[ i ]].curTeam[team] = 0;
			
			if (level.killstreakrules[keys[ i ]].curTeam[team] >= level.killstreakrules[keys[ i ]].maxPerTeam)
				isAllowed = false;	
		}
	}
	
	
	if ( isDefined( self.lastStand ) && self.lastStand )
		isAllowed = false;
	
	if ( isAllowed == false )
	{
		if ( isdefined( level.killstreaks[hardpointType] ) && isdefined( level.killstreaks[hardpointType].notAvailableText ) )
			self iprintlnbold( level.killstreaks[hardpointType].notAvailableText );
	}

	return isAllowed;
}



killstreak_debug_text( text )
{
/#
	level.killstreak_rule_debug = getDvarIntDefault( "scr_killstreak_rule_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.killstreak_rule_debug ) )
	{
		if ( level.killstreak_rule_debug == 1.0 )
		{
			iprintln( text );
		}
		else  if ( level.killstreak_rule_debug == 2.0 )
		{
			iprintlnbold( text );
		}
	}	
	
#/	
}