#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_so_rts.gsh;



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// rts.csv table column defines 
#define TABLE_IDX					0
#define TABLE_RULE_REF 				1	// rule/game type
#define TABLE_RULE_TIME				2	// game time in minutes
#define TABLE_RULE_PLAYERHELO		3	// num player helos
#define TABLE_RULE_PLAYERVTOL		4	// num player vtols
#define TABLE_RULE_ENEMYHELO		5	// num enemy helos
#define TABLE_RULE_ENEMYRVTOL		6	// num enemy vtols
#define TABLE_RULE_TRANSPORT_REFUEL	7	// extra duration during transport delivery
#define TABLE_RULE_RANDOMIZE_SIDE	8	// 0/1; 0 no random side
#define TABLE_RULE_Z_HEIGHT_DEFAULT	9	// default altitude on map
#define TABLE_RULE_ZOOM_AVAIL		10	// 0/1; zoom in/out avail
#define TABLE_RULE_CAMERA_MODE		11	// look/orbit camera modes
#define TABLE_RULE_CAMERA_ANGLE_DEFAULT		12	// default YPR
#define TABLE_RULE_CAMERA_ANGLE_OFFSETS		13	// additive YPR
#define TABLE_RULE_PLAYER_NAG_SQUADS	14	// number of squads dedicated to player harrassment
#define TABLE_RULE_ALLY_TEAM_DMG_REDUCER	15	// on recruit, normal difficulties, this number is applied to iDamage
#define TABLE_RULE_PLAYER_DMG_REDUCER	16	// on recruit, normal difficulties, this number is applied to iDamage



#define TABLE_RULE_INDEX_START 		300 // First index for POI Table
#define TABLE_RULE_INDEX_END 		310	// Last index for POI Table


preload()
{
	assert(isdefined( level.rts) );
	assert(isdefined( level.rts_def_table ) );
		
	level.rts.rules			= [];
	level.rts.rules			= rules_populate();	

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
get_rule_ref_by_index( idx )
{
	return tablelookup( level.rts_def_table, TABLE_IDX, idx, TABLE_RULE_REF );
}

set_GameMode(mode)
{
	level.rts.game_mode = mode;
}

init()
{	
	if (!isDefined(level.rts.game_mode) )
	{
		set_GameMode("attack");
	}
	InitRules();
	level.rts.viewAngle		= level.rts.game_rules.default_camera_pitch;
	
}

rules_populate()
{
	rules	= [];

	for( i = TABLE_RULE_INDEX_START; i <= TABLE_RULE_INDEX_END; i++ )
	{		
		ref = get_rule_ref_by_index( i );
		if ( !isdefined( ref ) || ref == "" )
			continue;
		
		rule 				= spawnstruct();
		rule.idx			= i;
		rule.ref			= ref;
		rule.time			= int(lookup_value( ref, i, TABLE_RULE_TIME ));
		rule.player_helo	= int(lookup_value( ref, i, TABLE_RULE_PLAYERHELO ));
		rule.player_vtol	= int(lookup_value( ref, i, TABLE_RULE_PLAYERVTOL ));
		rule.enemy_helo		= int(lookup_value( ref, i, TABLE_RULE_ENEMYHELO ));
		rule.enemy_vtol		= int(lookup_value( ref, i, TABLE_RULE_ENEMYRVTOL ));
		rule.delivery_refuel= int(lookup_value( ref, i, TABLE_RULE_TRANSPORT_REFUEL )) * 1000;
	
		rule.randomize_side = int(lookup_value( ref, i, TABLE_RULE_RANDOMIZE_SIDE ));


		heights				= strtok(lookup_value( ref, i, TABLE_RULE_Z_HEIGHT_DEFAULT )," ");
		rule.minPlayerZ		= int(heights[0]);
		rule.maxPlayerZ		= int(heights[1]);
		rule.zoom_avail 	= int(lookup_value( ref, i, TABLE_RULE_ZOOM_AVAIL ));
		rule.camera_mode 	= (lookup_value( ref, i, TABLE_RULE_CAMERA_MODE )=="look"?CAMERA_MODE_LOOK:CAMERA_MODE_ORBIT);
	

		rule.default_camera_pitch 	= int(lookup_value( ref, i, TABLE_RULE_CAMERA_ANGLE_DEFAULT ));
		angles						= strtok(lookup_value( ref, i, TABLE_RULE_CAMERA_ANGLE_OFFSETS )," ");
		rule.camera_angle_offsets 	= (float(angles[0]),float(angles[1]),float(angles[2]));
		rule.num_nag_squads			= int(lookup_value( ref, i, TABLE_RULE_PLAYER_NAG_SQUADS ));
		reducers					= strtok(lookup_value( ref, i, TABLE_RULE_ALLY_TEAM_DMG_REDUCER )," ");
		rule.ally_dmg_reducerFPS	= float(reducers[0]);
		if (rule.ally_dmg_reducerFPS <= 0.0)
			rule.ally_dmg_reducerFPS = 1.0;
		rule.ally_dmg_reducerRTS	= float(reducers[1]);
		if (rule.ally_dmg_reducerRTS <= 0.0)
			rule.ally_dmg_reducerRTS = 1.0;

		rule.player_dmg_reducerFPS	= float(lookup_value( ref, i, TABLE_RULE_PLAYER_DMG_REDUCER ));
		if (rule.player_dmg_reducerFPS <= 0.0 )
			rule.player_dmg_reducerFPS = 1.0;
	

		switch( GetDifficulty() )
		{
			case "medium":
				rule.ally_dmg_reducerFPS *= 1;
				rule.ally_dmg_reducerRTS *= 1;
				rule.player_dmg_reducerFPS *= 1;
			break;
			case "easy":
				rule.ally_dmg_reducerFPS *= 0.8;
				rule.ally_dmg_reducerRTS *= 0.8;
				rule.player_dmg_reducerFPS *= 0.8;
				rule.enemy_helo -= 2;
				rule.enemy_vtol -= 2;
				if ( rule.enemy_helo <= 0 ) rule.enemy_helo = 1;
				if ( rule.enemy_vtol <= 0 ) rule.enemy_vtol = 1;
				rule.num_nag_squads--;
				if (rule.num_nag_squads <= 0 )
					rule.num_nag_squads	= 1;
				break;
			case "fu":
				rule.ally_dmg_reducerFPS *= 1.5;
				rule.ally_dmg_reducerRTS *= 1.5;
				rule.player_dmg_reducerFPS *= 1.5;
				rule.enemy_helo += 2;
				rule.enemy_vtol += 2;
				rule.num_nag_squads	+= 2;
				break;
			case "hard":
				rule.ally_dmg_reducerFPS *= 1.25;
				rule.ally_dmg_reducerRTS *= 1.25;
				rule.player_dmg_reducerFPS *= 1.25;
				rule.enemy_helo += 1;
				rule.enemy_vtol += 1;
				rule.num_nag_squads	+= 1;
				break;
		}
		
		//add the rule
		rules[ ref ] 		= rule;
	}
	
	
	return rules;
}

InitRules()
{
	

	level.rts.game_rules = level.rts.rules[level.rts.game_mode];
	assert(isDefined(level.rts.game_rules));
	
	level.rts.transport_refuel_delay = 20000;
	if ( isDefined(level.rts.game_rules.delivery_refuel) )
	{
		level.rts.transport_refuel_delay = level.rts.game_rules.delivery_refuel;
	}

}


rules_SetGameTimer()
{
	if ( isDefined(level.rts.game_rules.time) && level.rts.game_rules.time > 0 )
	{
		flag_wait("rts_start_clock");
		level thread maps\_so_rts_support::time_countdown(level.rts.game_rules.time,level.rts.player,"kill_countdown");
		level.rts.player waittill("expired");
		mission_complete(false);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////
mission_complete(success,param)
{
	if (isDefined(level.custom_mission_complete) )
	{
		level thread [[level.custom_mission_complete]](success,param);
		return;
	}
	
	level thread maps\_so_rts_support::missionCompleteMsg(success);
}
