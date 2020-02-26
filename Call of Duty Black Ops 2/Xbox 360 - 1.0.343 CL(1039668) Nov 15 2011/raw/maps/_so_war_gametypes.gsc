#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_so_code;
#include maps\_specialops;
#include maps\_hud_util;

// ======================================================================
//	GLOBAL GAMETYPE INITS
// ======================================================================
war_gametypes_init()
{
	// Tweakables: Loot
	level.gamedef_table									= "sp/so_war/war_gamedefs.csv";		// game data tablelookup

	level.so.GD_TABLE_SCENARIO_INDEX					= 0; //index
	level.so.GD_TABLE_GAME_TYPE							= 1; //game type
	level.so.GD_TABLE_GAME_SCENARIO						= 2; // (scenario CSVs determine game type)
	level.so.GD_TABLE_WAVE_ID							= 3; //string used to set wave #;  This is the USER DEFINEd field in the wave.csv
	level.so.GD_TABLE_WAIT_ON_FLAG						= 4; //If exists, game segment will NOT start until Flag is set
	level.so.GD_TABLE_FAIL_ON_LAST						= 5; //If 1, segment can only fail if its the LAST segment being processed.
	level.so.GD_TABLE_NUM_OBJECTIVES					= 6; //number of objectives in this game mode
	level.so.GD_TABLE_TIME_LIMIT						= 7; //time associated with objective (in seconds)
	level.so.GD_TABLE_OBJSTR							= 8; //string associated with objetive
	level.so.GD_TABLE_OBJSTR_3D							= 9; //string associated with objetive 3d text
	level.so.GD_TABLE_ITEM_PARAM						= 10; //label for items to use. this is held on the ent's script_linkname field.
	level.so.GD_TABLE_HACKABLE							= 11; //label for items to use. this is held on the ent's script_linkname field.
	level.so.GD_TABLE_USERDEF_1							= 12; //label for items to use. this is held on the ent's script_linkname field.
	level.so.GD_TABLE_USERDEF_2							= 13; //label for items to use. this is held on the ent's script_linkname field.
	level.so.GD_TABLE_USERDEF_3							= 14; //label for items to use. this is held on the ent's script_linkname field.
	level.so.GD_TABLE_USERDEF_4							= 15; //label for items to use. this is held on the ent's script_linkname field.
	level.so.GD_TABLE_USERDEF_5							= 16; //label for items to use. this is held on the ent's script_linkname field.
	level.so.GD_TABLE_USERDEF_6							= 17; //label for items to use. this is held on the ent's script_linkname field.
	level.so.GD_TABLE_USERDEF_7							= 18; //label for items to use. this is held on the ent's script_linkname field.

	
	level.so.TABLE_SCENARIO_INDEX						= 0; //generic, all scenarios should have this index field
	level.so.TABLE_GAME_SCENARIO						= 1; //generic, all scenarious should have this scenario spec (scenario_one, scenario_two, scenario_three)
	level.so.TABLE_GAME_TYPE							= 2; //generic, all scenarious should define the game type
	
	
	level.so.CONST_COLOR_TEXT_AXIS						= (1,0.2,0.2);
	level.so.CONST_COLOR_TEXT_ALLIES					= (0.2,1,0.2);
	level.so.CONST_START_OBJECTIVE_NUM					= 10;
	
	//No Loot Drops in WAR
	level.so.LOOT_DROPS									= 0;
	level.so.CONST_DOMINATION_RADIUS					= 256;

	level.so.WAR_No_SpawnZones							= [];
	level.so.CONST_NO_SPAWN_ZONE_RADIUS					= 2048;
	
	level.so.CONST_Z_HIDE								= -9999;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
war_watch_player_life()
{
	level endon("special_op_terminated");
	flag_clear("all_ally_dead");
	flag_wait("all_ally_dead");
	mission_complete(false);
	level notify("special_op_terminated");
}

/////////////////////////////////////////////////////////////////////////////////////////////////
war_set_scenario(scenario)
{
	assert (IsDefined(level.scenario_table),"scenario table not defined");
	assert (isDefined(scenario),"scenario not defined");
	if ( scenario == 0 )
		scenario = 1;
	
	warScenarios = array( "invalid","scenario_one", "scenario_two", "scenario_three" );
	scenario = warScenarios[ scenario ];

	level.war_scenario = scenario;
	level.objectiveNum = level.so.CONST_START_OBJECTIVE_NUM;
	
	//move players to readlocations if exists.
	players = GetPlayers();
	i = 1;
	foreach( player in players )
	{
		startLoc = scenario + "_player" + i + "_start";
		player_spawns =  getentarray( startLoc, "targetname");
		if ( isDefined(player_spawns) && player_spawns.size>0 )
		{
			player_spawns = array_randomize(player_spawns);
			player setOrigin( player_spawns[0].origin );
			player setPlayerAngles( player_spawns[0].angles );
		}
		i++;
	}
	

	switch (scenario)
	{
		case "scenario_one":
			delEnts = GetEntArray("scenario_two","script_noteworthy");
			delEnts = array_combine(delEnts,GetEntArray("scenario_three","script_noteworthy"));
			break;
		case "scenario_two":
			delEnts = GetEntArray("scenario_one","script_noteworthy");
			delEnts = array_combine(delEnts,GetEntArray("scenario_three","script_noteworthy"));
			break;
		case "scenario_three":
			delEnts = GetEntArray("scenario_one","script_noteworthy");
			delEnts = array_combine(delEnts,GetEntArray("scenario_two","script_noteworthy"));
			break;
		default:
			assertmsg("unhandled scenario");
			break;
	}
	//delete all ents not associated with this scenario
	array_thread(delEnts, ::war_delete_ent );


	level war_populate_game_items();

	level.war_game_type 		= get_war_Scenario_GameTypes( level.war_scenario  ); //returns string like "DOMINATE DEFEND ESCAPE" etc..
	level.war_game_sequence 	= [];
	modeTokens 					= strtok( level.war_game_type, " " );
	foreach(seg in modeTokens)
	{
		gameSeg 			 	= Spawnstruct();
		gameSeg.idx			 	= get_war_gameIDX_byName(seg);
		gameSeg.segID			= seg;
		assert(gameSeg.idx 	   != "","Mode not found in war_gamedefs.csv");
		gameSeg.type 		 	= get_war_gametype_byIDX(gameSeg.idx);
		gameSeg.waveStart	 	= get_war_gameWaveID_byIDX(gameSeg.idx);
		gameSeg.waitFlag		= get_war_gameGetWaitOnFlag_byIDX(gameSeg.idx);
		if (gameSeg.waitFlag != "" )
		{
			if ( !flag_exists( gameSeg.waitFlag ) )
			{
				flag_init(gameSeg.waitFlag);
			}
		}
		gameSeg.failOnLast		= get_war_gameFailOnStatus_byIDX( gameSeg.idx );
		gameSeg.notifyStart  	= gameSeg.segID + "_" + "BEGIN";
		gameSeg.notifyProgress 	= gameSeg.segID + "_" + "PROGRESS";
		gameSeg.notifyFinish 	= gameSeg.segID + "_" + "DONE";
		gameSeg.notifyWait   	= gameSeg.segID + "_" + "COMPLETE";
		gameSeg.segment_success = false;
		
		switch (gameSeg.type)
		{
			case "CAPTURE":
				gameSeg.callback 	= ::war_gameMode_capture;
				break;
			case "DEFEND":
				gameSeg.callback 	= ::war_gameMode_defend;
				break;
			case "DOMINATE":
				gameSeg.callback 	= ::war_gameMode_dominate;
				break;
			case "ESCAPE":
				gameSeg.callback 	= ::war_gameMode_escape;
				break;
			case "RACE":
				gameSeg.callback 	= ::war_gameMode_race;
				break;
			case "KILL":
				gameSeg.callback 	= ::war_gameMode_assassinate;
				break;
			case "PROTECT":
				gameSeg.callback 	= ::war_gameMode_protect;
				break;
			case "STEALTH":
				gameSeg.callback 	= ::war_gameMode_stealth;
				break;
			default:
				assertMsg("unknown game type");
				break;
		}
		
		level.war_game_sequence[level.war_game_sequence.size] = gameSeg;
	}

	//player insertion.  This MUST set the "start_war" flag;
	if(isDefined(level.custom_war_player_insert))
	{
		level thread [[level.custom_war_player_insert]]();
	}
	else
	{
		level thread war_gametype_generic_player_insert();
	}
	flag_wait( "start_war" );

	while(level.war_game_sequence.size)
	{
		curGameSeg = level.war_game_sequence[0];
		level.war_game_sequence = array_remove(level.war_game_sequence,curGameSeg);

		if (curGameSeg.waitFlag != "" )
		{
			flag_wait(curGameSeg.waitFlag);
		}
		level thread [[curGameSeg.callback]](curGameSeg);
		level waittill("gameSeg_completed");

		if ( level.war_game_sequence.size > 0 )
		{
			if ( !curGameSeg.failOnLast && !curGameSeg.segment_success )
			{
				level thread mission_complete(curGameSeg.segment_success);
				break;
			}
		}
		else
		{
			level thread mission_complete(curGameSeg.segment_success);
			break;
		}
	}
	
	level notify("special_op_terminated");
}
/////////////////////////////////////////////////////////////////////////////////////////////////
// ======================================================================
//	TABLE HELPERS
// ======================================================================
get_war_gameIDX_byName( gameName )
{
	return tablelookup( level.gamedef_table, level.so.GD_TABLE_GAME_SCENARIO, gameName, level.so.GD_TABLE_SCENARIO_INDEX );
}
get_war_gametype_byIDX( index )
{
	return tablelookup( level.gamedef_table, level.so.GD_TABLE_SCENARIO_INDEX, index, level.so.GD_TABLE_GAME_TYPE );
}
get_war_gameWaveID_byIDX( index )
{
	return tablelookup( level.gamedef_table, level.so.GD_TABLE_SCENARIO_INDEX, index, level.so.GD_TABLE_WAVE_ID );
}
get_war_gameGetWaitOnFlag_byIDX( index )
{
	return tablelookup( level.gamedef_table, level.so.GD_TABLE_SCENARIO_INDEX, index, level.so.GD_TABLE_WAIT_ON_FLAG );
}
get_war_gameFailOnStatus_byIDX( index )
{
	return int(tablelookup( level.gamedef_table, level.so.GD_TABLE_SCENARIO_INDEX, index, level.so.GD_TABLE_FAIL_ON_LAST ));
}
get_war_gameNumObjs_byIDX( index )
{
	return int(tablelookup( level.gamedef_table, level.so.GD_TABLE_SCENARIO_INDEX, index, level.so.GD_TABLE_NUM_OBJECTIVES ));
}
get_war_gameObjTime_byIDX( index )
{
	return int(tablelookup( level.gamedef_table, level.so.GD_TABLE_SCENARIO_INDEX, index, level.so.GD_TABLE_TIME_LIMIT ));
}
get_war_gameObjHackable_byIDX( index )
{
	return int(tablelookup( level.gamedef_table, level.so.GD_TABLE_SCENARIO_INDEX, index, level.so.GD_TABLE_HACKABLE ));
}
get_war_gameObjStr_byIDX( index )
{
	string = tablelookup( level.gamedef_table, level.so.GD_TABLE_SCENARIO_INDEX, index, level.so.GD_TABLE_OBJSTR );
	istr   = istring(string);
	return istr;
}
get_war_gameObjStr3D_byIDX( index )
{
	string = tablelookup( level.gamedef_table, level.so.GD_TABLE_SCENARIO_INDEX, index, level.so.GD_TABLE_OBJSTR_3D );
	istr   = istring(string);
	return istr;
}
get_war_gameItemParam_byIDX( index )
{
	return tablelookup( level.gamedef_table, level.so.GD_TABLE_SCENARIO_INDEX, index, level.so.GD_TABLE_ITEM_PARAM );
}
get_war_gameUserDef_byIDX( index, which )
{
	item = tablelookup( level.gamedef_table, level.so.GD_TABLE_SCENARIO_INDEX, index, which );
	return item;
}
get_war_Scenario_GameTypes( scenario )
{
	return tablelookup( level.scenario_table, level.so.TABLE_GAME_SCENARIO, scenario, level.so.TABLE_GAME_TYPE );
}

// ======================================================================
//	MISC UTILS
// ======================================================================
war_populate_game_items()
{
	level.so.WAR_GameItems = getEntArray("war_game_item","script_noteworthy");//all game modes will rely in part upon war_game_items
	foreach(item in level.so.WAR_GameItems )
	{
		assert(isDefined(item.script_linkname),"script_linkname must be defined, used in war_gamedefs.csv");
	}
	
	war_hide_game_items();
}

war_set_objective(objectiveNum, success)
{
	if (success )
	{
		Objective_State( objectiveNum, "done" );
	}
	else
	{
		if (!level.currentGameSeg.failOnLast)
		{
			Objective_State( objectiveNum, "failed" );
		}
		else
			if (level.currentGameSeg.failOnLast)
		{
			if ( level.war_game_sequence.size > 0 )
				Objective_State( objectiveNum, "done" );
			else
				Objective_State( objectiveNum, "failed" );
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////
war_hide_game_items(list)
{
	if(!isDefined(list))
	{
		list = level.so.WAR_GameItems;
	}
	if (isArray(list) )
	{
		gameItems = list;
		foreach (item in gameItems)
		{
			item Hide();
			if (!isDefined(item.origin_old_z) )
			{
				item.origin_old_z = item.origin[2];
			}
			item.origin = (item.origin[0],item.origin[1],level.so.CONST_Z_HIDE);
		}
	}
	else
	{
		item = list;
		item Hide();
		if (!isDefined(item.origin_old_z) )
		{
			item.origin_old_z = item.origin[2];
		}
		item.origin = (item.origin[0],item.origin[1],level.so.CONST_Z_HIDE);
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_show_game_items(list)
{
	if(!isDefined(list))
	{
		list = level.so.WAR_GameItems;
	}
	if (isArray(list))
	{
		gameItems = list;
		foreach (item in gameItems)
		{
			item Show();
			if ( isDefined(item.origin_old_z) )
			{
				item.origin = (item.origin[0],item.origin[1],item.origin_old_z);
				item.origin_old_z = undefined;
			}
		}
	}
	else
	{
		item = list;
		item Show();
		if ( isDefined(item.origin_old_z) )
		{
			item.origin = (item.origin[0],item.origin[1],item.origin_old_z);
			item.origin_old_z = undefined;
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_get_game_items_byParam(param)
{
	assert(isDefined(param));
	
	gameItems = [];
	foreach(item in level.so.WAR_GameItems )
	{
		if ( item.script_linkname == param )
			gameItems[gameItems.size] = item;
	}
	return gameItems;
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_InitGameItemsFor(label)
{
	items = war_get_game_items_byParam(label);
	war_hide_game_items();
	war_show_game_items(items);
	return items;
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_delete_ent()
{
	self delete();
}
/////////////////////////////////////////////////////////////////////////////////////////////////
display_progress_info(percent,text)
{
	init_progress_info();
	if ( isDefined(level.WAR_progress) )
	{
		level.WAR_progress.alpha = 1;
		level.WAR_progress.bar.alpha = 1;
		level.WAR_progress_text.alpha =1;
		bar_length = int(level.primaryProgressBarWidth * percent);
		level.WAR_progress.bar setShader( "white", bar_length, level.primaryProgressBarHeight );
		if (isDefined(text))
		{
			level.WAR_progress_text settext(text);
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
clear_progress_info()
{
	if ( isDefined(level.WAR_progress) )
	{
		level.WAR_progress.alpha = 0;
		level.WAR_progress.bar.alpha = 0;
		level.WAR_progress_text.alpha =0;
		level.WAR_progress_text settext(&"SO_WAR_PROGRESS");
		level.WAR_progress.bar setShader( "white", 0, level.primaryProgressBarHeight );
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
destroy_progress_info()
{
	if ( isDefined(level.WAR_progress) )
	{
		clear_progress_info();
		
		if (isDefined(level.WAR_progress) )
			level.WAR_progress maps\_hud_util::destroyElem();

		if (isDefined(level.WAR_progress_text) )
			level.WAR_progress_text maps\_hud_util::destroyElem();

		level.WAR_progress = undefined;
		level.WAR_progress_text = undefined;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
init_progress_info()
{
	if (!isDefined(level.WAR_progress))
	{
		//various progress meter setup
		player = get_players()[0];
		level.WAR_progress = player maps\_hud_util::createBar( (1,1,1), 120, 9 );//createPrimaryProgressBar();
		level.WAR_progress  maps\_hud_util::setPoint( "CENTER", "BOTTOM", 0,-80);
	}
	if (!isDefined(level.WAR_progress_text))
	{
		level.WAR_progress_text = maps\_hud_util::createFontString( "default", 1.2 );
		level.WAR_progress_text  maps\_hud_util::setPoint( "CENTER", "BOTTOM",0, -95 );
	}
	clear_progress_info();
}
/////////////////////////////////////////////////////////////////////////////////////////////////
display_domination_info(percent,text,numAllies,numAxis)
{
	create_domination_info();
	if ( isDefined(level.dominationStatus) )
	{
		level.dominationStatus.domination_progress1	maps\_hud_util::showElem();
		level.dominationStatus.domination_progress2	maps\_hud_util::showElem();
		
		bar_length = level.primaryProgressBarWidth-int(level.primaryProgressBarWidth * percent);
		level.dominationStatus.domination_progress1.bar setShader( "white", level.primaryProgressBarWidth, level.primaryProgressBarHeight );
		level.dominationStatus.domination_progress2.bar setShader( "white", bar_length, level.primaryProgressBarHeight );
		
		if (isDefined(text))
		{
			level.dominationStatus.domination_progress_text	maps\_hud_util::showElem();
			level.dominationStatus.domination_progress_text_Left	maps\_hud_util::showElem();
			level.dominationStatus.domination_progress_text_Right	maps\_hud_util::showElem();
			level.dominationStatus.domination_progress_text_Enemy	maps\_hud_util::showElem();
			level.dominationStatus.domination_progress_text_Friendly	maps\_hud_util::showElem();
			level.dominationStatus.domination_progress_text settext(text);
			level.dominationStatus.domination_progress_text_Enemy settext(numAxis);
			level.dominationStatus.domination_progress_text_Friendly settext(numAllies);
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
clear_domination_info()
{
	if ( isDefined(level.dominationStatus) )
	{
		if ( isDefined(level.dominationStatus.domination_progress1) )
		{
			level.dominationStatus.domination_progress1	maps\_hud_util::hideElem();
		}
		
		if ( isDefined(level.dominationStatus.domination_progress2) )
		{
			level.dominationStatus.domination_progress2	maps\_hud_util::hideElem();
		}
		level.dominationStatus.domination_progress_text	maps\_hud_util::hideElem();
		level.dominationStatus.domination_progress_text_Left maps\_hud_util::hideElem();
		level.dominationStatus.domination_progress_text_Right maps\_hud_util::hideElem();
		level.dominationStatus.domination_progress_text_Enemy maps\_hud_util::hideElem();
		level.dominationStatus.domination_progress_text_Friendly maps\_hud_util::hideElem();
		level.dominationStatus.domination_progress_text settext(&"SO_WAR_CONTROL");
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
destroy_domination_info()
{
	if (isDefined(level.dominationStatus) )
	{
		clear_domination_info();

		if (isDefined(level.dominationStatus.domination_progress1) )
			level.dominationStatus.domination_progress1 maps\_hud_util::destroyElem();

		if (isDefined(level.dominationStatus.domination_progress2) )
			level.dominationStatus.domination_progress2 maps\_hud_util::destroyElem();
		
		if (isDefined(level.dominationStatus.domination_progress_text) )
			level.dominationStatus.domination_progress_text	maps\_hud_util::destroyElem();
		
		if (isDefined(level.dominationStatus.domination_progress_text_Left) )
			level.dominationStatus.domination_progress_text_Left	maps\_hud_util::destroyElem();

		if (isDefined(level.dominationStatus.domination_progress_text_Right) )
			level.dominationStatus.domination_progress_text_Right	maps\_hud_util::destroyElem();

		if (isDefined(level.dominationStatus.domination_progress_text_Enemy) )
			level.dominationStatus.domination_progress_text_Enemy	maps\_hud_util::destroyElem();

		if (isDefined(level.dominationStatus.domination_progress_text_Friendly) )
			level.dominationStatus.domination_progress_text_Friendly	maps\_hud_util::destroyElem();
		
		level.dominationStatus = undefined;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
create_domination_info()
{
	if (!isDefined(level.dominationStatus) )
	{
		status = SpawnStruct();
		level.dominationStatus = status;
		
		//various progress meter setup
		status.player = get_players()[0];
		status.domination_progress1 = status.player maps\_hud_util::createBar( level.so.CONST_COLOR_TEXT_ALLIES, 120, 9 );//createPrimaryProgressBar();
		assert(isDefined(status.domination_progress1));
		status.domination_progress1  maps\_hud_util::setPoint( "CENTER", "BOTTOM", 0,-80);
		status.domination_progress2 = status.player maps\_hud_util::createBar( level.so.CONST_COLOR_TEXT_AXIS, 120, 9 );//createPrimaryProgressBar();
		assert(isDefined(status.domination_progress2));
		status.domination_progress2  maps\_hud_util::setPoint( "CENTER", "BOTTOM", 0,-80);
		status.domination_progress1.bar.sort = 0;
		status.domination_progress2.bar.sort = 1;
		
		
		status.domination_progress_text = maps\_hud_util::createFontString( "default", 1.2 );
		assert(isDefined(status.domination_progress_text));
		status.domination_progress_text  maps\_hud_util::setPoint( "CENTER", "BOTTOM",0, -95 );
		
		status.domination_progress_text_Left = maps\_hud_util::createFontString( "default", 1.2 );
		assert(isDefined(status.domination_progress_text_Left));
		status.domination_progress_text_Left  maps\_hud_util::setPoint( "CENTER", "BOTTOM",-(level.primaryProgressBarWidth/2)-60, -95 );
		status.domination_progress_text_Left settext(&"SO_WAR_ENEMY");
		status.domination_progress_text_Left.color = level.so.CONST_COLOR_TEXT_AXIS;
		
		status.domination_progress_text_Right = maps\_hud_util::createFontString( "default", 1.2 );
		assert(isDefined(status.domination_progress_text_Right));
		status.domination_progress_text_Right  maps\_hud_util::setPoint( "CENTER", "BOTTOM",(level.primaryProgressBarWidth/2)+60, -95 );
		status.domination_progress_text_Right settext(&"SO_WAR_FRIENDLY");
		status.domination_progress_text_Right.color = level.so.CONST_COLOR_TEXT_ALLIES;
		
		status.domination_progress_text_Enemy = maps\_hud_util::createFontString( "default", 1.2 );
		assert(isDefined(status.domination_progress_text_Enemy));
		status.domination_progress_text_Enemy  maps\_hud_util::setPoint( "CENTER", "BOTTOM",-(level.primaryProgressBarWidth/2)-60, -80 );
		status.domination_progress_text_Enemy settext("0");
		status.domination_progress_text_Enemy.color = level.so.CONST_COLOR_TEXT_AXIS;
		
		status.domination_progress_text_Friendly = maps\_hud_util::createFontString( "default", 1.2 );
		assert(isDefined(status.domination_progress_text_Friendly));
		status.domination_progress_text_Friendly  maps\_hud_util::setPoint( "CENTER", "BOTTOM",(level.primaryProgressBarWidth/2)+60, -80 );
		status.domination_progress_text_Friendly settext("0");
		status.domination_progress_text_Friendly.color = level.so.CONST_COLOR_TEXT_ALLIES;
		
		clear_domination_info();
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
get_ents_touching_trigger()
{
	touching = [];
	total_ents = array_combine(GetPlayers(),getaiarray());
	
	foreach (ent in total_ents)
	{
		if ( ent isTouching(self) )
			touching[touching.size] = ent;
	}
	return touching;
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_countdown(banner,timeInSeconds,owner,killNotify)
{
	level endon( "special_op_terminated" );
	level endon("kill_timer");
	
	if(isDefined(killNotify))
		owner endon(killNotify);
	
	if (!isDefined(level.WAR_countdown_text) && isDefined(banner) )
	{
		level.WAR_countdown_text = maps\_hud_util::createFontString( "objective", 2 );
		level.WAR_countdown_text.fontScale = 1.6;
		level.WAR_countdown_text.color = (0.8, 1.0, 0.8);
		level.WAR_countdown_text.font = "objective";
		level.WAR_countdown_text.glowColor = (0.3, 0.6, 0.3);
		level.WAR_countdown_text.glowAlpha = 1;
		level.WAR_countdown_text.foreground = 1;
		level.WAR_countdown_text.hidewheninmenu = true;
		level.WAR_countdown_text.alpha =1;
		level.WAR_countdown_text.alignX = "right";
		level.WAR_countdown_text.alignY = "middle";
		level.WAR_countdown_text.horzAlign = "right";
		level.WAR_countdown_text.vertAlign = "top";
		level.WAR_countdown_text.x = -235;
		level.WAR_countdown_text.y = 100;
		level.WAR_countdown_text settext(banner);
	}
	if (!isDefined(level.WAR_countdown_timer) )
	{
		level.WAR_countdown_timer = maps\_hud_util::get_countdown_hud();
		level.WAR_countdown_timer.color = (1,1,1);
		level.WAR_countdown_timer.alpha =1;
		level.WAR_countdown_timer.fontScale = 2;
		level.WAR_countdown_timer.alignX = "left";
	}
	
	level.WAR_countdown_timer settenthstimer(timeInSeconds);
	wait(timeInSeconds);
	owner notify("expired");
}

war_countdown_delete()
{
	level notify("kill_timer");

	if (isDefined(level.WAR_countdown_text) )
	{
		level.WAR_countdown_text	maps\_hud_util::destroyElem();
		level.WAR_countdown_text = undefined;
	}

	if (isDefined(level.WAR_countdown_timer) )
	{
		level.WAR_countdown_timer	maps\_hud_util::destroyElem();
		level.WAR_countdown_timer = undefined;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
mission_complete(success)
{
	if (isDefined(level.custom_war_mission_complete) )
	{
		level thread [[level.custom_war_mission_complete]](success);
		return;
	}
	
	level thread maps\_so_war_support::missionCompleteMsg(success);
}

/////////////////////////////////////////////////////////////////////////////////////////////////
//each game scenario should have a default custom tac insertion for player.
war_gametype_generic_player_insert()
{
	players = GetPlayers();
	foreach( player in players )
	{
		player thread maps\_so_war_support::do_slamzoom();
	}
	flag_wait( "slamzoom_finished" );

	level thread maps\_so_war_support::insert_allies_by_ladder();
	
	flag_set("start_war");
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*  						      CAPTURE
                    ____  ____  ____ _____ _     ____  _____
                   /   _\/  _ \/  __X__ __X \ /\/  __\/  __/
                   |  /  | / \||  \/| / \ | | |||  \/||  \
                   |  \__| |-|||  __/ | | | \_/||    /|  /_
                   \____/\_/ \|\_/    \_/ \____/\_/\_\\____\
 */
/////////////////////////////////////////////////////////////////////////////////////////////////
war_capture_points_init(numPoints)
{
	possibles = war_InitGameItemsFor(get_war_gameItemParam_byIDX( level.currentGameSeg.idx ));
	possibles = array_randomize(possibles);
	assert(isDefined(possibles) && possibles.size >= numPoints,"Not enough item_capture_locations defined in the map");

	//select numTargets randomly
	level.WAR_capture_points = [];
	for(i=0;i<numPoints;i++)
	{
		level.WAR_capture_points[level.WAR_capture_points.size] = possibles[i];
	}
	possibles = array_exclude(possibles,level.WAR_capture_points);
	
	
	//make sure there is a min distance between the capture points
	discarded = [];
	for(i=0;i<numPoints;i++)
	{
		if (possibles.size <= 0 )
			break;

		capSpot = level.WAR_capture_points[i];
		for (j=i+1;j<numPoints;j++)
		{
			if (possibles.size <= 0 )
				break;

			capSpot2 = level.WAR_capture_points[j];
			distbetween = distance(capSpot.origin,capSpot2.origin);
			if ( distbetween < 1200 )
			{
				/#
					println("WAR: Discarding capture point due to distance violation (" + distbetween + ")");
				#/
					discarded[discarded.size] 	= level.WAR_capture_points[j];
				level.WAR_capture_points[j] = possibles[0];
				possibles = array_remove(possibles,level.WAR_capture_points[j]);
				j--;
			}
		}
	}
	
	//hide the unused
	possibles = array_combine(discarded,possibles);
	war_hide_game_items(possibles);
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_gameMode_capture(gameSeg)
{
	level endon( "special_op_terminated" );

	level.currentGameSeg = gameSeg;

	//capture point setup
	numTargets = get_war_gameNumObjs_byIDX(gameSeg.idx);
	assert(isDefined(numTargets),"num targets not defined in gamedef csv table");
	war_capture_points_init(numTargets);

	num = 0;
	foreach(capturePoint in level.WAR_capture_points)
	{
		if ( num == 0 )
		{
			//setup objectives
			Objective_Add( level.objectiveNum, "current", get_war_gameObjStr_byIDX(level.currentGameSeg.idx), capturePoint.origin);
			objective_set3d( level.objectiveNum, true, "default", get_war_gameObjStr3D_byIDX(level.currentGameSeg.idx) );
		}
		
		//setup capture watchers
		capturePoint thread war_capture_watcher(level.objectiveNum,num);
		num++;
	}
	level.objectiveNum++;

	//set to starting wave
	wave = maps\_so_war_ai::get_wavenum_by_userdefined(gameSeg.waveStart);
	maps\_so_war::war_set_wave_to(wave);

	//wait till captures complete
	level notify(gameSeg.notifyStart);  //let everything know we've started
	level waittill(gameSeg.notifyWait,success);
	level notify(gameSeg.notifyFinish ); //let everything know we've finished
	gameSeg.segment_success = success;

	//cleanup
	destroy_progress_info();
	level notify("gameSeg_completed");
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_capture_point_captured(objectiveNum,num)
{
	level.WAR_capture_points = array_remove( level.WAR_capture_points,self);
	destroy_progress_info();
	if (isDefined(self.trigger) )
	{
		self.trigger delete();
	}
	war_hide_game_items(self);
	
	hacked = (isDefined(self.BeingHacked)?true:false);
	
	if (isDefined(self.script_ent))
		level notify(level.currentGameSeg.notifyProgress,self.script_ent,hacked);
	else
		level notify(level.currentGameSeg.notifyProgress,self,hacked);
	
	
	Objective_AdditionalPosition( objectiveNum, num, ( 0, 0, 0 ) );  // clears additional position
	
	if(level.WAR_capture_points.size == 0)
	{
		level notify(level.currentGameSeg.notifyWait, true);
		war_set_objective(objectiveNum, true);
	}
	self notify("war_captured");
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_capture_point_destroyed_watcher(objectiveNum,num)
{
	level endon( "special_op_terminated" );
	self endon("war_captured");
	
	while(1)
	{
		level waittill("war_destroyed",entDestroyed);
		if (isDefined(self.script_ent) && self.script_ent == entDestroyed )
		{
			self war_capture_point_captured(objectiveNum,num);
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_capture_switch_abort()
{
	self endon("war_capture_watcher");
	self endon("war_captured");
	self endon("war_capture_abort");

	level waittill("war_char_switch", who);
	self.trigger SetHintString( "" );
	destroy_progress_info();
	who unlink();
	
	wait 0.05;
	self notify("war_capture_abort");
}

war_capture_death_abort(who)
{
	self endon("war_capture_watcher");
	self endon("war_captured");
	self endon("war_capture_abort");
	if(isPlayer(who))
	{
		who waittill("player_died");
	}
	else
	{
		who waittill("death");
	}
	self notify("war_capture_abort");
}

war_capture_input_abort(who)
{
	self endon("war_capture_watcher");
	self endon("war_captured");
	self endon("war_capture_abort");

	btnDown = false;
	while(1)
	{
		if ( who UseButtonPressed() && !who.throwingGrenade && !who meleeButtonPressed() )
		{
			btnDown = true;
		}
		if (btnDown && !who UseButtonPressed())
		{
			self notify("war_capture_abort");
			return;
		}

		wait 0.05;
	}
}
war_capture_proximity_abort(who)
{
	self endon("war_capture_watcher");
	self endon("war_captured");
	self endon("war_capture_abort");

	while(who istouching(self.trigger))
	{
		wait 0.05;
	}
	self notify("war_capture_abort");
}
war_capture_progress_watch(who,time,objectiveNum,num)
{
	self endon("war_capture_watcher");
	self endon("war_captured");
	self endon("war_capture_abort");
	level endon("war_char_switch");
	who endon("death");
	
	if (isDefined(self.BeingHacked) )
	{
		banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_3 );
	}
	else
	{
		banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_1 );
	}
	while(who istouching(self.trigger))
	{
		self.captured_start += 0.05;
		display_progress_info(self.captured_start/time, istring(banner));
		wait 0.05;
		if ( self.captured_start > time )
		{
			break;
		}
	}
	self war_capture_point_captured(objectiveNum,num);
}


war_capture_logicAI(who,objectiveNum,num,linkTag)
{
	self endon("war_capture_watcher");

	ent = undefined;
	
	self thread war_capture_death_abort(who);
	self.BeingCaptured 	= true;
	self.captured_start = 0;
	
	if ( isDefined(linkTag) && isDefined(self.script_ent) )
	{
		who linkto(self.script_ent,linkTag);
	}
	else
	{
		who.position_override = self.origin;
		ent = Spawn( "script_model", ( 69, 69, 69 ) );
		ent SetModel( "tag_origin" );
		ent.origin = self.origin;
		ent.angles = self.angles;
	}
	wait 0.05;
	
	
	//need to attach this dude to some sort of tag and play an animation
	animid = "war_capture_" + level.currentGameSeg.segID;
	if (isDefineD(level.scr_anim["war_ai"][animid]) )
	{
		who.animname = "war_ai";
		who thread maps\_so_war_anim::war_anim_play(animid, true, array( "war_capture_watcher", "war_captured", "war_capture_abort" ), self);
	}

	time = get_war_gameObjTime_byIDX(level.currentGameSeg.idx);
	self thread war_capture_progress_watch(who,time,objectiveNum,num);

	msg = self waittill_any_return("war_captured","war_capture_abort");
	self.BeingCaptured 		= undefined;
	self.BeingHacked 		= undefined;
	if (isAlive(who))
	{
		who.position_override 	= undefined;
		who unlink();
	}
	
	if 	(msg == "war_capture_abort")
	{
		banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_6 );
		self.trigger SetHintString( istring(banner) );
		self thread war_capture_watcher(objectiveNum,num);
	}
	if ( isDefined(ent) )
	{
		ent Delete();
	}
}

war_capture_logic(who,objectiveNum,num)
{
	self endon("war_capture_watcher");
	
	msg = undefined;
	if (isAlive(who))
	{
		self.BeingCaptured = true;
		if (self.isHackable && isPlayer(who) && who HasPerk( "specialty_intruder" ) )
		{
			self.BeingHacked = true;
		}
		
		time = get_war_gameObjTime_byIDX(level.currentGameSeg.idx);
		if ( maps\_so_war_switch::ally_hud_getNumAlive() <= 1 )
			banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_4 );
		else
			banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_5 );
		

		self.trigger SetHintString( istring(banner) );

		self thread war_capture_switch_abort();
		self thread war_capture_input_abort(who);
		self thread war_capture_death_abort(who);
		
		//	self thread war_capture_proximity_abort(who);
		self thread war_capture_progress_watch(who,time,objectiveNum,num);
		
		ent = Spawn( "script_model", ( 69, 69, 69 ) );
		ent SetModel( "tag_origin" );
		ent.origin = who.origin;
		ent.angles = who.angles;
		
		// link player
		who PlayerLinkTo( ent, undefined, 1, 0, 0, 0, 0 );
		who.CaptureOrigin	= ent.origin;
		who.CaptureAngles	= ent.angles;
		who.CaptureEnt 		= self;
		who.CaptureObj		= objectiveNum;
		who.CaptureObjNum	= num;
		
		//play some animation
		animid = "war_capture_" + level.currentGameSeg.segID;
		if (isDefineD(level.scr_anim["war_player"][animid]) )
		{
			who.animname = "war_player";
			who thread maps\_so_war_anim::war_anim_play( animid, true, array( "war_capture_watcher", "war_captured", "war_capture_abort" ), self );
		}
		
		msg = self waittill_any_return("war_captured","war_capture_abort");
		ent Delete();
		self.BeingCaptured 	= undefined;
		self.BehingHacked	= undefined;
		if ( isAlive(who) )
		{
			who.CaptureIsLinked = undefined;
			who.CaptureEnt 		= undefined;
			who.CaptureObj		= undefined;
			who.CaptureObjNum	= undefined;
			who Unlink();
		}
	}
	if 	(!isDefined(msg) || msg == "war_capture_abort")
	{
		banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_6 );
		self.trigger SetHintString( istring(banner) );
		self thread war_capture_watcher(objectiveNum,num);
	}
}
war_capture_trigger_use()
{
	self endon("war_capture_watcher");
	self endon("war_captured");
	self endon("war_capture_abort");

	self.trigger SetCursorHint( "HINT_NOICON" );
	while(1)
	{
		self.trigger SetHintString( "");
		self.trigger waittill("trigger",who);
		if (!isPlayer(who))
			continue;
		if(!isDefined(self.BeingCaptured) )
		{
			if( self.isHackable && who HasPerk( "specialty_intruder" ) )
			{
				banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_7 );
			}
			else
			{
				banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_6 );
			}
			self.trigger SetHintString( istring(banner) );

			btnDown = false;
			while(who istouching(self.trigger))
			{
				if ( who UseButtonPressed() && !who.throwingGrenade && !who meleeButtonPressed() )
				{
					btnDown = true;
				}
				if (btnDown && !who UseButtonPressed())
				{
					self notify("war_capture_used",who);
				}
				wait 0.05;
			}
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_capture_watcher(objectiveNum,num)
{
	level endon( "special_op_terminated" );
	self endon ("war_captured");
	self notify("war_capture_watcher");
	self endon("war_capture_watcher");
	
	if (num>0)
	{
		Objective_AdditionalPosition( objectiveNum, num, self.origin);
	}

	self.captured_start = 0;
	self.isHackable = get_war_gameObjHackable_byIDX( level.currentGameSeg.idx );
	destroy_progress_info();
	
	if ( !isDefined(self.trigger) )
	{
		self.trigger = spawn("trigger_radius", self.origin ,0, int(get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_2 )), 64);
	}
	self thread war_capture_point_destroyed_watcher(objectiveNum,num);
	self thread war_capture_trigger_use();
	
	self waittill("war_capture_used",who);
	self thread war_capture_logic(who,objectiveNum,num);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*  							DEFEND
 			     ____  _____ _____ _____ _      ____
  				/  _ \/  __//    //  __// \  /|/  _ \
  				| | \||  \  |  __\|  \  | |\ ||| | \|
  				| |_/||  /_ | |   |  /_ | | \||| |_/|
  				\____/\____\\_/   \____\\_/  \|\____/
 */
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
war_defend_points_init(numPoints)
{
	level.WAR_defend_points = [];

	possibles = war_InitGameItemsFor(get_war_gameItemParam_byIDX( level.currentGameSeg.idx ));
	possibles = array_randomize(possibles);
	assert(isDefined(possibles) && possibles.size >= numPoints,"Not enough defend defined in the map");
	
	leftOvers = possibles;
	for(i=0;i<possibles.size;i++)//start at one, we're using index zero above
	{
		if ( i<numPoints )
		{
			level.WAR_defend_points[level.WAR_defend_points.size] = possibles[i];
			leftOvers = array_remove(leftOvers,possibles[i]);
		}
	}
	
	//hide the unused ones
	war_hide_game_items(leftOvers);
	
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_gameMode_defend(gameSeg)
{
	level endon( "special_op_terminated" );

	level.currentGameSeg = gameSeg;

	//defend point setup
	numTargets = get_war_gameNumObjs_byIDX(gameSeg.idx);
	assert(isDefined(numTargets),"num targets not defined in gamedef csv table");
	war_defend_points_init(numTargets);
	
	//setup objectives
	foreach (defendPoint in level.WAR_defend_points)
	{
		//setup defend watchers
		defendPoint thread war_defend_watcher(level.objectiveNum);
		level.objectiveNum++;
	}

	//make it so that boss drops via copters will be over defend target locations instead of near players
	level.so.boss_drop_target = level.WAR_defend_points[0].origin;

	//set to starting wave
	wave = maps\_so_war_ai::get_wavenum_by_userdefined(gameSeg.waveStart);
	maps\_so_war::war_set_wave_to(wave);
	
	level notify(gameSeg.notifyStart);  //let everything know we've started
	level waittill(gameSeg.notifyWait,success);  //wait till defend complete
	level notify(gameSeg.notifyFinish ); //let everything know we've finished
	gameSeg.segment_success = success;

	//cleanup
	level.so.boss_drop_target = undefined;
	destroy_progress_info();
	level notify("gameSeg_completed");
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_defend_watcher(objectiveNum)
{
	level endon( "special_op_terminated" );
	
	Objective_Add( objectiveNum, "current", get_war_gameObjStr_byIDX(level.currentGameSeg.idx), self.origin);
	objective_set3d( objectiveNum, true, "default",  get_war_gameObjStr3D_byIDX(level.currentGameSeg.idx) );
	
	self.trigger = spawn("trigger_radius", self.origin ,0, int(get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_2 )), 64);
	self.defend_start = 0;
	self.time_required_to_defend =  get_war_gameObjTime_byIDX(level.currentGameSeg.idx);
	done = false;
	
	while(!done)
	{
		destroy_progress_info();
		self.trigger waittill("trigger",who);
		
		if (!isPlayer(who))
			continue;
		
		while(who istouching(self.trigger))
		{
			self.defend_start += 0.05;
			banner =  get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_1 );
			display_progress_info(self.defend_start/self.time_required_to_defend, istring(banner));
			wait 0.05;
			if ( self.defend_start>self.time_required_to_defend)
			{
				done = true;
				break;
			}
		}
		
	}
	
	level.WAR_defend_points = array_remove( level.WAR_defend_points,self);
	destroy_progress_info();
	self.trigger delete();
	war_hide_game_items(self);

	war_set_objective(objectiveNum, true);

	
	if(level.WAR_defend_points.size == 0)
	{
		level notify(level.currentGameSeg.notifyWait,true);
	}
	else
	{
		level.so.boss_drop_target = level.WAR_defend_points[0].origin;
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*  							PROTECT
				____________ _____ _____ _____ _____ _____
				| ___ \ ___ \  _  |_   _|  ___/  __ \_   _|
				| |_/ / |_/ / | | | | | | |__ | /  \/ | |
				|  __/|    /| | | | | | |  __|| |     | |
				| |   | |\ \\ \_/ / | | | |___| \__/\ | |
				\_|   \_| \_|\___/  \_/ \____/ \____/ \_/
 */
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
war_protect_points_init(numPoints)
{
	level.WAR_protect_points = [];

	possibles = war_InitGameItemsFor(get_war_gameItemParam_byIDX( level.currentGameSeg.idx ));
	possibles = array_randomize(possibles);
	assert(isDefined(possibles) && possibles.size >= numPoints,"Not enough protect points defined in the map");
	
	leftOvers = possibles;
	for(i=0;i<possibles.size;i++)//start at one, we're using index zero above
	{
		if ( i<numPoints )
		{
			level.WAR_protect_points[level.WAR_protect_points.size] = possibles[i];
			leftOvers = array_remove(leftOvers,possibles[i]);
		}
	}
	
	//hide the unused ones
	war_hide_game_items(leftOvers);
	
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_gameMode_protect(gameSeg)
{
	level endon( "special_op_terminated" );

	level.currentGameSeg = gameSeg;

	//protect point setup
	numTargets = get_war_gameNumObjs_byIDX(gameSeg.idx);
	assert(isDefined(numTargets),"num targets not defined in gamedef csv table");
	war_protect_points_init(numTargets);
	
	//setup objectives
	foreach (point in level.WAR_protect_points)
	{
		//setup protect watchers
		point thread war_protect_watcher(level.objectiveNum);
		level.objectiveNum++;
	}

	//make it so that boss drops via copters will be over protect target locations instead of near players
	level.so.boss_drop_target = level.WAR_protect_points[0].origin;

	//set to starting wave
	wave = maps\_so_war_ai::get_wavenum_by_userdefined(gameSeg.waveStart);
	maps\_so_war::war_set_wave_to(wave);
	
	level notify(gameSeg.notifyStart);  //let everything know we've started
	level waittill(gameSeg.notifyWait,success);  //wait till protect complete
	level notify(gameSeg.notifyFinish ); //let everything know we've finished
	gameSeg.segment_success = success;

	//cleanup
	level.so.boss_drop_target = undefined;
	destroy_progress_info();
	level notify("gameSeg_completed");
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_protect_watcher(objectiveNum)
{
	level endon( "special_op_terminated" );
	
	Objective_Add( objectiveNum, "current", get_war_gameObjStr_byIDX(level.currentGameSeg.idx), self.origin);
	objective_set3d( objectiveNum, true, "default",  get_war_gameObjStr3D_byIDX(level.currentGameSeg.idx) );
	
	self.protect_start = 0;
	self.time_required_to_protect=  get_war_gameObjTime_byIDX(level.currentGameSeg.idx);
	done = false;


	targetNameObj =  get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_2 );
	if ( targetNameObj != "" )
	{
		protectObj 	  = GetEnt(targetNameObj,"targetname");
		assert( isDefined(protectObj));
		protectObj	thread war_protect_death_broadcast();
		if (!( isAI(protectObj)))
		{
			protectObj thread war_protect_damage_watcher();
		}
	}
	else
	{
		modelNameObj =  get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_3 );
		assert(modelNameObj != "" );
		
		protectObj = spawn("script_model", self.origin);
		protectObj.angles =  self.angles;
		protectObj setmodel(modelNameObj);
		protectObj thread war_protect_death_broadcast();
		protectObj thread war_protect_damage_watcher();
	}

	if (!isDefined(protectObj.team))
	{
		protectObj.team = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_5 );
		assert(protectObj.team!="");
	}

	maps\_so_war_ai::add_priority_target(protectObj);
	level thread war_protect_deathsquad(int(get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_6 )),protectObj.team );

	destroy_progress_info();
	banner =  get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_1 );
	alive  = false;
	while(protectObj.health>0)
	{
		self.protect_start += 0.05;
		display_progress_info(self.protect_start/self.time_required_to_protect, istring(banner));
		wait 0.05;
		if ( self.protect_start>self.time_required_to_protect)
		{
			alive = true;
			break;
		}
	}
	
	level.WAR_protect_points = array_remove( level.WAR_protect_points,self);
	destroy_progress_info();
	war_hide_game_items(self);

	war_set_objective(objectiveNum, alive);

	if(level.WAR_protect_points.size == 0)
	{
		level notify(level.currentGameSeg.notifyWait,alive);
	}
	else
	{
		level.so.boss_drop_target = level.WAR_protect_points[0].origin;
	}
	
	if (int(get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_7 )))
	{
		protectObj Delete();
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_protect_deathsquad(minCount,targetTeam)
{
	level endon( "special_op_terminated" );
	level endon(level.currentGameSeg.notifyFinish );
	
	if (targetTeam == "allies" )
		team = "axis";
	else
		team = "allies";
		
	while(1)
	{
		count = get_num_PriorityAttackers(team);
		if ( count < minCount)
		{
			level thread maps\_so_war_ai::spawn_priority_target_death_squad(team,4,level.currentGameSeg.notifyFinish);
		}
		wait 1;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////
war_protect_death_broadcast()
{
	self waittill("death");
	level notify("war_protection_object_died");
}

/////////////////////////////////////////////////////////////////////////////////////////////////
war_protect_damage_watcher()
{
	self endon("death");
	self SetCanDamage( true );
	self.health = int(get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_4 ));
	while(self.health>0)
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		self.health -= damage;
	}
	self notify("death");
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*  							ESCAPE
				 _____ ____  ____  ____  ____  _____
				/  __// ___\/   _\/  _ \/  __\/  __/
				|  \  |    \|  /  | / \||  \/||  \
				|  /_ \___ ||  \__| |-|||  __/|  /_
				\____\\____/\____/\_/ \|\_/   \____\
 */
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
war_escape_points_init(numPoints)
{
	level.WAR_escape_points = [];

	possibles = war_InitGameItemsFor(get_war_gameItemParam_byIDX( level.currentGameSeg.idx ));
	possibles = array_randomize(possibles);
	assert(isDefined(possibles) && possibles.size >= numPoints,"Not enough escape defined in the map");

	leftOvers = possibles;
	for(i=0;i<possibles.size;i++)//start at one, we're using index zero above
	{
		if ( i<numPoints )
		{
			level.WAR_escape_points[level.WAR_escape_points.size] = possibles[i];
			leftOvers = array_remove(leftOvers,possibles[i]);
		}
	}

	//hide the unused ones
	war_hide_game_items(leftOvers);
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_gameMode_escape(gameSeg)
{
	level endon( "special_op_terminated" );

	level.currentGameSeg = gameSeg;

	//defend point setup
	numTargets = get_war_gameNumObjs_byIDX(gameSeg.idx);
	assert(isDefined(numTargets),"num targets not defined in gamedef csv table");
	war_escape_points_init(numTargets);
	
	//setup objectives
	foreach (point in level.WAR_escape_points)
	{
		//setup defend watchers
		point thread war_escape_watcher(level.objectiveNum);
		level.objectiveNum++;
	}

	//set to starting wave
	wave = maps\_so_war_ai::get_wavenum_by_userdefined(gameSeg.waveStart);
	maps\_so_war::war_set_wave_to(wave);

	level notify(gameSeg.notifyStart);  //let everything know we've started
	level waittill(gameSeg.notifyWait,success);  //wait till complete
	level notify(gameSeg.notifyFinish ); //let everything know we've finished
	gameSeg.segment_success = success;

	//cleanup
	destroy_progress_info();
	level notify("gameSeg_completed");
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_escape_trigger_watch(owner)
{
	level endon( "special_op_terminated" );
	owner endon("expired");
	
	while(1)
	{
		self waittill("trigger",who);
		if ( isPlayer(who))
			owner notify("exit_trigger");
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_escape_watcher(objectiveNum)
{
	level endon( "special_op_terminated" );

	//setup objectives
	Objective_Add( objectiveNum, "current", get_war_gameObjStr_byIDX(level.currentGameSeg.idx), self.origin);
	objective_set3d( objectiveNum, true, "default",  get_war_gameObjStr3D_byIDX(level.currentGameSeg.idx) );

	self.trigger = spawn("trigger_radius", self.origin ,0, int(get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_2 )), 64);
	self.time_to_escape =  get_war_gameObjTime_byIDX(level.currentGameSeg.idx);
	success	= false;
	
	self.trigger thread war_escape_trigger_watch(self);
	banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_1 );
	self thread war_countdown(istring(banner),self.time_to_escape, self,"exit_trigger");

	note = self waittill_any_return("exit_trigger","expired");
	if ( note == "exit_trigger" )
	{
		success = true;
	}
	
	war_set_objective(objectiveNum, success);
	war_countdown_delete();
	self.trigger delete();
	level.WAR_escape_points = array_remove(level.WAR_escape_points,self);
	war_hide_game_items(self);

	if ( level.WAR_escape_points.size == 0 )
	{
		level notify (level.currentGameSeg.notifyWait,success);
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*						      DOMINATE
			 ____  ____  _      _  _      ____ _____ _____
			/  _ \/  _ \/ \__/|/ \/ \  /|/  _ X__ __X  __/
			| | \|| / \|| |\/||| || |\ ||| / \| / \ |  \
			| |_/|| \_/|| |  ||| || | \||| |-|| | | |  /_
			\____/\____/\_/  \|\_/\_/  \|\_/ \| \_/ \____\
 */
/////////////////////////////////////////////////////////////////////////////////////////////////
war_dominate_points_init(numPoints)
{
	level.WAR_dominate_points = [];
	
	possibles = war_InitGameItemsFor(get_war_gameItemParam_byIDX( level.currentGameSeg.idx ));
	possibles = array_randomize(possibles);
	assert(isDefined(possibles) && possibles.size >= numPoints,"Not enough dominate defined in the map");
	
	leftOvers = possibles;
	for(i=0;i<possibles.size;i++)//start at one, we're using index zero above
	{
		if ( i<numPoints )
		{
			level.WAR_dominate_points[level.WAR_dominate_points.size] = possibles[i];
			leftOvers = array_remove(leftOvers,possibles[i]);
		}
	}

	//hide the unused ones
	war_hide_game_items(leftOvers);
	
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_dominate_spawnLoc_Cull(locs)
{
	foreach (noZone in level.so.WAR_No_SpawnZones)
	{
		foreach(spawn in locs)
		{
			if ( locs.size <= 1 )
				return locs;
			
			distance = Distance(spawn.origin, noZone );

			if ( distance < level.so.CONST_NO_SPAWN_ZONE_RADIUS	)
				locs = array_remove(locs,spawn);
		}
	}

	return locs;
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_gameMode_dominate(gameSeg)
{
	level endon( "special_op_terminated" );

	level.so.WAR_No_SpawnZones = [];
	level.spawn_loc_cull_cb = ::war_dominate_spawnLoc_Cull;
	level.currentGameSeg = gameSeg;

	//dominate point setup
	numTargets = get_war_gameNumObjs_byIDX(gameSeg.idx);
	assert(isDefined(numTargets),"num targets not defined in gamedef csv table");
	war_dominate_points_init(numTargets);
	
	foreach(dominationPoint in level.WAR_dominate_points)
	{
		//setup domination watchers
		level.so.WAR_No_SpawnZones[level.so.WAR_No_SpawnZones.size]	= dominationPoint.origin;

		level thread war_dominate_watcher(dominationPoint,level.objectiveNum);
		level.objectiveNum++;
	}
	//population monitor.
	level thread war_population_domination_monitor();
	
	//set to starting wave
	wave = maps\_so_war_ai::get_wavenum_by_userdefined(gameSeg.waveStart);
	maps\_so_war::war_set_wave_to(wave);

	level notify(gameSeg.notifyStart);  //let everything know we've started
	level waittill(gameSeg.notifyWait,success);  //wait till complete
	level notify(gameSeg.notifyFinish ); //let everything know we've finished
	gameSeg.segment_success = success;
	destroy_domination_info();
	level.spawn_loc_cull_cb = undefined;
	level notify("gameSeg_completed");
}

/////////////////////////////////////////////////////////////////////////////////////////////////
war_dominate_get_best_dompoint()
{
	if ( !isDefined(self.dom_point) )
	{
		self.dom_point = get_closest_ent( self.origin ,level.WAR_dominate_points );
	}
	time_required_to_dominate =  get_war_gameObjTime_byIDX(level.currentGameSeg.idx);//time needed to capture dom point

	bestDomPoint = self.dom_point;
	myTeam 		 = self.team;
	
	
	foreach (domPoint in level.WAR_dominate_points)
	{
		if (!isDefined(domPoint.dominated))
			domPoint.dominated = "contested";

		//my team is trying to take this point, pile on!
		if ( domPoint.dominated == "contested" && domPoint.touchers[self.team]> 0 )
		{
			return domPoint;
		}

		//if enemy has taken a point, go get it
		if ( domPoint.dominated != "contested" && domPoint.dominated != myTeam )
		{
			return domPoint;
		}
	}

	//if I have a current domination point keep going for it
	if ( self.dom_point.dominated == "contested" )
		return self.dom_point;

	//fall back, just return a contested point.
	foreach (domPoint in level.WAR_dominate_points)
	{
		if ( domPoint.dominated == "contested" )
		{
			return domPoint;
		}
	}

	return undefined;
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_population_domination_monitor_cleanup()
{
	level endon( "special_op_terminated" );
	level waittill(level.currentGameSeg.notifyFinish);

	total_AI = getaiarray();
	foreach(ai in total_AI)
	{
		if (isDefined(ai.oldgoalradius))
		{
			ai.goalradius = ai.oldgoalradius;
			ai.oldgoalradius = undefined;
		}
		ai.position_override = undefined;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////
war_population_domination_monitor()
{
	level endon( "special_op_terminated" );
	level endon(level.currentGameSeg.notifyFinish);

	level thread war_population_domination_monitor_cleanup();
	
	while(1)
	{
		total_AI = getaiarray();
		foreach (ai in total_AI)
		{
			if ((ai.team == "axis" && ( isDefined(ai.acting_squad_leader) || !isDefined(ai.leader) ) )  || ai.team=="allies" )
			{
				if ( ( ai.goalradius > level.so.CONST_DOMINATION_RADIUS ) )
				{
					ai.oldgoalradius 	= ai.goalradius;
					ai.goalradius 		= RandomFloatRange(level.so.CONST_DOMINATION_RADIUS/4, level.so.CONST_DOMINATION_RADIUS );
				}
				
				ai.dom_point = ai war_dominate_get_best_dompoint();
				if(isDefined(ai.dom_point) )
				{
					ai.position_override = ai.dom_point.origin;
				}
				else
				{
					ai.position_override = undefined;
				}
			}
			
			if(isDefined(ai.favoriteenemy))
				ai.favoriteenemy = undefined;
			
		}
		wait 1;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_dominate_watcher(domWatchPoint, objectiveNum)
{
	level endon( "special_op_terminated" );
	assert(isDefined(domWatchPoint));

	//setup objectives
	Objective_Add( objectiveNum, "current", get_war_gameObjStr_byIDX(level.currentGameSeg.idx), domWatchPoint.origin);
	objective_set3d( objectiveNum, true, "white", get_war_gameObjStr3D_byIDX(level.currentGameSeg.idx) );

	domWatchPoint.trigger = spawn("trigger_radius", domWatchPoint.origin ,0,level.so.CONST_DOMINATION_RADIUS/2, 64);
	domWatchPoint.dominate_weight = 0;
	domWatchPoint.dominated = "contested";

	time_required_to_dominate =  get_war_gameObjTime_byIDX(level.currentGameSeg.idx);//time needed to capture dom point
	time_required_to_dominate2x = time_required_to_dominate+time_required_to_dominate;
	done = false;

	playerWastouching 		= false;
	playertouching 			= false;

	while(!done)
	{
		domWatchPoint.touchers["axis"] 	= 0;
		domWatchPoint.touchers["allies"] = 0;
		playerWastouching 		= playertouching;
		playertouching 			= false;
		aiTouchers 				= domWatchPoint.trigger get_ents_touching_trigger();
		
		foreach (ai in aiTouchers )
		{
			if(isPlayer(ai))
				playertouching = true;

			if (ai.team == "allies")
			{
				domWatchPoint.dominate_weight += 0.05;
			}
			else
			{
				domWatchPoint.dominate_weight -= 0.05;
			}
			
			domWatchPoint.touchers[ai.team]++;
		}

		if ( playertouching )
		{
			percent = (domWatchPoint.dominate_weight + time_required_to_dominate) / time_required_to_dominate2x;
			if (percent>=1)
			{
				percent = 1;
				destroy_domination_info();
			}
			else
			{
				if ( domWatchPoint.touchers["allies"] < domWatchPoint.touchers["axis"] )
					banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx, level.so.GD_TABLE_USERDEF_5);
				else
					if ( domWatchPoint.touchers["allies"] > domWatchPoint.touchers["axis"] )
						banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx, level.so.GD_TABLE_USERDEF_6);
					else
						banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx, level.so.GD_TABLE_USERDEF_7);
				
				display_domination_info(percent,istring(banner), domWatchPoint.touchers["allies"],domWatchPoint.touchers["axis"]);
			}
		}
		else
			if (playerWastouching)
		{
			destroy_domination_info();
		}
		

		if (domWatchPoint.dominate_weight >= time_required_to_dominate )
		{
			domWatchPoint.dominate_weight = time_required_to_dominate;
			if ( domWatchPoint.dominated != "allies" )
			{
				domWatchPoint.dominated = "allies";
				banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx, level.so.GD_TABLE_USERDEF_3);
				Objective_Add( objectiveNum, "current", istring(banner), domWatchPoint.origin);
				banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx, level.so.GD_TABLE_USERDEF_4);
				objective_set3d( objectiveNum, true, "default", istring(banner) );
			}
		}
		else
			if ( domWatchPoint.dominate_weight <= -time_required_to_dominate )
		{
			domWatchPoint.dominate_weight = -time_required_to_dominate;
			if ( domWatchPoint.dominated != "axis" )
			{
				domWatchPoint.dominated = "axis";
				banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx, level.so.GD_TABLE_USERDEF_1);
				Objective_Add( objectiveNum, "current", istring(banner), domWatchPoint.origin);
				banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx, level.so.GD_TABLE_USERDEF_2);
				objective_set3d( objectiveNum, true, "red", istring(banner) );
			}
		}
		else
			if ( domWatchPoint.dominated != "contested" )
		{
			
			domWatchPoint.dominated = "contested";
			objective_set3d( objectiveNum, true, "white",  get_war_gameObjStr3D_byIDX(level.currentGameSeg.idx) );
		}
		
		wait 0.05;
		
		allDominated = true;
		foreach (domPoint in level.WAR_dominate_points)
		{
			if ( isDefined(domPoint) && domPoint.dominated != "allies" )
			{
				allDominated = false;
				break;
			}
		}

		if ( allDominated )
		{
			break; //break while
		}
	}
	destroy_domination_info();
	domWatchPoint.trigger delete();
	level.WAR_dominate_points = array_remove(level.WAR_dominate_points,domWatchPoint);
	war_hide_game_items(domWatchPoint);
	
	war_set_objective(objectiveNum, true);

	if ( level.WAR_dominate_points.size == 0 )
	{
		level notify (level.currentGameSeg.notifyWait,true);
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*						     RACE
					 ____  ____  ____  _____
					/  __\/  _ \/   _\/  __/
					|  \/|| / \||  /  |  \
					|    /| |-|||  \__|  /_
					\_/\_\\_/ \|\____/\____\
                        			
 */
/////////////////////////////////////////////////////////////////////////////////////////////////
war_race_Points_init(numPoints)
{
	level.so.racePoints = [];

	possibles = war_InitGameItemsFor(get_war_gameItemParam_byIDX( level.currentGameSeg.idx ));
	assert(isDefined(possibles) && possibles.size >= numPoints,"Not enough race locations defined in the map");

	leftOvers = possibles;
	for(i=0;i<possibles.size;i++)//start at one, we're using index zero above
	{
		assert(isDefined(possibles[i].targetname),"race points must have a targetname");
		if ( i<numPoints )
		{
			level.so.racePoints[level.so.racePoints.size] = possibles[i];
			leftOvers = array_remove(leftOvers,possibles[i]);
		}
	}

	//hide the unused ones
	war_hide_game_items(leftOvers);
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_race_getTargetByName(targetname)
{
	foreach(item in level.so.racePoints)
	{
		if (item.targetname == targetname )
			return item;
	}
	return undefined;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
war_gameMode_race(gameSeg)
{
	level endon( "special_op_terminated" );

	level.currentGameSeg = gameSeg;


	//defend point setup
	numTargets = get_war_gameNumObjs_byIDX(gameSeg.idx);
	assert(isDefined(numTargets),"num targets not defined in gamedef csv table");
	war_race_Points_init(numTargets);

	//set to starting wave
	wave = maps\_so_war_ai::get_wavenum_by_userdefined(gameSeg.waveStart);
	maps\_so_war::war_set_wave_to(wave);

	//setup objectives
	success = false;
	race_start = war_race_getTargetByName("race_start");
	assert(isDefined(race_start),"missing entity in race path with targetname race_start");
	race_start thread war_race_watcher(level.objectiveNum);
	while(level.so.racePoints.size)
	{
		level waittill(gameSeg.notifyWait,success);  //wait till complete
		if ( !success || level.so.racePoints.size == 0 )
		{
			break;
		}
		race_start = war_race_getTargetByName(race_start.target);
		assert(isDefined(race_start),"missing entity in race path");
		race_start thread war_race_watcher(level.objectiveNum);
	}

	level notify(gameSeg.notifyStart);  //let everything know we've started
	level notify(gameSeg.notifyFinish ); //let everything know we've finished
	gameSeg.segment_success = success;
	war_countdown_delete();

	//cleanup
	level notify("gameSeg_completed");
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_race_trigger_watch(owner)
{
	level endon( "special_op_terminated" );
	owner endon("expired");
	
	while(1)
	{
		self waittill("trigger",who);
		if ( isPlayer(who))
			owner notify("exit_trigger");
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_race_watcher(objectiveNum)
{
	level endon( "special_op_terminated" );

	//setup objectives
	Objective_Add( objectiveNum, "current", get_war_gameObjStr_byIDX(level.currentGameSeg.idx), self.origin);
	objective_set3d( objectiveNum, true, "default", get_war_gameObjStr3D_byIDX(level.currentGameSeg.idx) );

	self.trigger = spawn("trigger_radius", self.origin ,0,int(get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_2)), 64);
	self.time_to_race =  get_war_gameObjTime_byIDX(level.currentGameSeg.idx);
	success	= false;
	
	self.trigger thread war_race_trigger_watch(self);
	banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_1	);
	self thread war_countdown(istring(banner),self.time_to_race, self,"exit_trigger");

	note = self waittill_any_return("exit_trigger","expired");
	if ( note == "exit_trigger" )
	{//win
		success = true;
	}
	war_set_objective(objectiveNum, success);
	
	self.trigger delete();
	level.so.racePoints = array_remove(level.so.racePoints,self);
	war_hide_game_items(self);

	level notify (level.currentGameSeg.notifyWait,success);
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*						    ASSASSINATE
  ___   _____ _____  ___   _____ _____ _____ _   _   ___ _____ _____
 / _ \ /  ___/  ___|/ _ \ /  ___/  ___|_   _| \ | | / _ \_   _|  ___|
/ /_\ \\ `--.\ `--./ /_\ \\ `--.\ `--.  | | |  \| |/ /_\ \| | | |__
|  _  | `--. \`--. \  _  | `--. \`--. \ | | | . ` ||  _  || | |  __|
| | | |/\__/ /\__/ / | | |/\__/ /\__/ /_| |_| |\  || | | || | | |___
\_| |_/\____/\____/\_| |_/\____/\____/ \___/\_| \_/\_| |_/\_/ \____/
 */
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
war_hideout_points_init(numPoints)
{
	level.so.hideOutPoints = [];

	possibles = war_InitGameItemsFor(get_war_gameItemParam_byIDX( level.currentGameSeg.idx ));
	assert(isDefined(possibles) && possibles.size >= numPoints,"Not enough hideout locations defined in the map");

	leftOvers = possibles;
	for(i=0;i<possibles.size;i++)//start at one, we're using index zero above
	{
		if ( i<numPoints )
		{
			level.so.hideOutPoints[level.so.hideOutPoints.size] = possibles[i];
			leftOvers = array_remove(leftOvers,possibles[i]);
		}
	}

	//hide the unused ones
	war_hide_game_items(leftOvers);

}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_get_bestHideOut(binLaden)
{
	possibles = level.so.hideOutPoints;
	foreach (player in GetPlayers())
	{
		foreach(hideout in possibles )
		{
			player_dist 	= distance2d( player.origin, hideout.origin );
			if ( player_dist < 700 )
				possibles=array_remove(possibles,hideout);
		}
	}
	
	if (possibles.size > 0 )
		hideOut = getClosest( binLaden.origin, possibles );
	else
		hideOut = getClosest( binLaden.origin, level.so.hideOutPoints );
	
	level thread war_hideOut (binLaden, hideOut);
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_notifyMyBossOnDeath(boss)
{
	self endon("bodyguard_bezerk");
	self waittill("death");
	boss notify("bodyguard_died");
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_recruitFollowers()
{
	self endon("death");
	self endon("new hideout");
	self notify("new recruit");
	self endon("new recruit");
	
	fillattempt = 0;


	while(1)
	{
		foreach(guy in self.bodyguards)
		{
			if ( !isDefined(guy) || !isAlive(guy) )
				self.bodyguards = array_remove(self.bodyguards,guy);
		}

		if ( self.bodyguards.size < int(get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_3)) )
		{
			fillattempt += 1;
			
			teamMates = getAIArray(self.team);
			foreach(guy in teamMates)
			{
				if (isDefined(guy.bodyguarding))
					continue;
				if ( guy == self )
					continue;
				
				//prefer claymore guys since they can set defensive mines up
				if ( fillattempt > 20 || isDefined(guy.claymore) )
				{
					guy.entity_override 	= self;
					guy.goalradius 			= 768;
					guy.bodyguarding		= true;
					self.bodyguards[self.bodyguards.size] = guy;
					guy SetGoalEntity(self);
					guy thread war_notifyMyBossOnDeath(self);
					break;
				}
			}
		}
		else
		{
			fillattempt = 0;
		}
		wait 1;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_hideOutFleeWatcher()
{
	self endon("death");
	self endon("new hideout");

	while(1)
	{
		player_closest 	= getclosest( self.origin, GetPlayers() );
		player_dist 	= distance2d( self.origin, player_closest.origin );

		//if player is too close for comfort
		if ( player_dist < int(get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_2)) )
		{
			self notify("flee_hideout");
			return;
		}
		wait 1;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_hideOut(binLaden, hideOut)
{   //self is level
	self endon( "special_op_terminated" );
	self notify("new hideout");
	self endon("new hideout");
	binLaden endon("death");

	//tell binladen to get to his hiding spot
	binLaden setgoalpos(hideOut.origin);
	binLaden.position_override 	= hideOut.origin;
	//if the wave has a boss, put the boss near binladen
	level.so.boss_drop_target 	= hideOut.origin;
	//binLaden thread maps\_so_war_support::debug_draw_goalpos(binLaden.position_override,(1,0,0));
	binLaden setengagementmindist( 300, 200 );
	binLaden setengagementmaxdist( 512, 768 );
	binLaden waittill( "goal");

	//lets get some bodyguards recruited
	if ( !isDefined(binLaden.bodyguards) )
	{
		binLaden.bodyguards = [];
	}
	binLaden thread war_recruitFollowers();
	
	//watch for opportunity to get the hell out of dodge...
	binLaden thread war_hideOutFleeWatcher();
	
	if ( level.so.hideOutPoints.size <= 1 )
		return;
	
	binLaden waittill_any("flee_hideout","bodyguard_died");
	//send all my guards on the closest player
	foreach (guard in binLaden.bodyguards)
	{
		guard.entity_overrride = undefined;
		guard.goalradius	   = 768;
		guard.bodyguarding	   = undefined;
		guard SetGoalEntity(getclosest( guard.origin, GetPlayers() ));
		guard notify ("bodyguard_bezerk");
		guard thread throw_grenade_at_player(getclosest( guard.origin,GetPlayers()));
	}

	binLaden.bodyguards 	= [];
	level.so.hideOutPoints 	= array_remove(level.so.hideOutPoints,hideOut);

	//flee
	level thread war_get_bestHideOut(binLaden);
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_target_timeout(timeout,binLaden)
{
	if (timeout>0)
	{
		banner = get_war_gameUserDef_byIDX(level.currentGameSeg.idx,level.so.GD_TABLE_USERDEF_1	);
		level thread war_countdown(istring(banner),timeout, level);
		level waittill_any_timeout( timeout, "expired" );
		binLaden notify("target_escaped");
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_target_shielder()
{
	self endon ("death");
	while(1)
	{
		self waittill( "damage", amount, attacker );
		if (!isPlayer(attacker))
			self.health += int(amount*0.8);
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_target_manager(binLaden,objectiveNum)
{
	level endon( "special_op_terminated" );
	
	//if we werent supplied a binLaden, lets elect one to the role
	while(!isDefined(binLaden))
	{
		if ( isdefined( level.leaders ) )
		{
			foreach( leader in level.leaders )
			{
				if ( leader.team == "axis" )
				{
					binLaden = leader;
					break;
				}
			}
		}
		level waittill( "axis_spawned" );
	}

	//put up countdown if exists..
	level thread war_target_timeout(get_war_gameObjTime_byIDX(level.currentGameSeg.idx),binLaden);
	//make sure this guy is enemy team
	binLaden SetTeam("axis");
	binLaden.goalradius = 128;
	//thread a damage reducer on damage from non players
	binLaden thread war_target_shielder();
	//move the target package to a location
	level thread war_get_bestHideOut(binLaden);
	//wait for complete
	note 	= binLaden waittill_any_return("death","target_escaped");
	if ( note == "target_escaped" )
	{
		success = false;
	}
	else
	{//win
		success = true;
	}
	
	war_set_objective(objectiveNum, success);
	
	
	//all done
	level notify(level.currentGameSeg.notifyWait,success);
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_gameMode_assassinate(gameSeg)
{
	level endon( "special_op_terminated" );

	level.currentGameSeg = gameSeg;

	numTargets = get_war_gameNumObjs_byIDX(gameSeg.idx);
	assert(isDefined(numTargets),"num targets not defined in gamedef csv table");
	war_hideout_points_init(numTargets);

	//set to starting wave
	maps\_so_war::war_set_wave_to(maps\_so_war_ai::get_wavenum_by_userdefined(gameSeg.waveStart));

	//get assassination target, if exists
	binLaden = simple_spawn_single("binladen");
	level thread war_target_manager(binLaden,level.objectiveNum);

	//add objective
	Objective_Add( level.objectiveNum, "current", get_war_gameObjStr_byIDX(level.currentGameSeg.idx));
	level.objectiveNum++;

	success = false;
	level.so.ignore_mine_dist_check = true;
	
	level notify(gameSeg.notifyStart);  //let everything know we've started
	level waittill(gameSeg.notifyWait,success);  //wait till complete
	level notify(gameSeg.notifyFinish ); //let everything know we've finished
	gameSeg.segment_success = success;

	//cleanup
	level notify("gameSeg_completed");
	war_countdown_delete();
	level.so.ignore_mine_dist_check = undefined;
	level.so.boss_drop_target = undefined;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*						     STEALTH

				 ____ _____ _________ _  _____ _   _
				/ ___Y__ __Y  __/  _ Y \/__ __Y \ / \
				|    \ / \ |  \ | / \| |  / \ | |_| |
				\___ | | | |  /_| |-|| |_/\ | | | | |
				\____/ \_/ \____\_/ \|____|_/ \_/ \_/
				                                    
                        			
 */
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
war_gameMode_stealth(gameSeg)
{
	level endon( "special_op_terminated" );

	level.currentGameSeg = gameSeg;

	add_global_spawn_function( "allies", ::war_stealth_start_pacifist );

	waveNum 	= maps\_so_war_ai::get_wavenum_by_userdefined(gameSeg.waveStart);
	ai_count 	= maps\_so_war_ai::get_ai_count( "regular", waveNum );
	ai_thresh   = maps\_so_war_ai::get_min_ai_threshold( waveNum );
	
	// find all the patrol point starts
	patrolStarts = GetEntArray( "stealth_patrol_start", "targetname" );
	patrolStarts = array_randomize( patrolStarts );
	patrolStartIndex = 0;
	
	assert( patrolStarts.size >= ai_count, "You must have enough stealth patrol points to support " + ai_count + " ai. You only have " + patrolStarts.size + "." );
	
	squad_type 	= maps\_so_war_ai::get_squad_type( waveNum );
	classname 	= maps\_so_war_ai::get_ai_classname( squad_type );

	ai_spawner 	= get_spawners_by_classname( classname )[ 0 ];
	assert( isdefined( ai_spawner ), "No ai spawner with classname: " + classname );
	
	// spawn regular patrollers
	for( ; patrolStartIndex < ai_count && patrolStartIndex < patrolStarts.size; patrolStartIndex++ )
	{
		start = patrolStarts[ patrolStartIndex ];
		
		ai_spawner.count = 1; // make sure count > 0
		
		new_guy = simple_spawn_single( ai_spawner );
		
		new_guy.ai_type = get_ai_struct( "hardened" );
		new_guy [[ level.attributes_func ]]();
		
		new_guy ForceTeleport( start.origin, start.angles );
		new_guy thread war_stealth_patrol( start, gameSeg.notifyWait );
		new_guy thread war_monitor_stealth( gameSeg.notifyWait );
	}
	
	// spawn any bosses
	if( maps\_so_war::wave_has_boss( waveNum ) )
	{
		ai_bosses = get_bosses_ai( waveNum );
		
		startIndex = patrolStartIndex;
		for( ; (patrolStartIndex - startIndex) < ai_bosses.size && patrolStartIndex < patrolStarts.size; patrolStartIndex++ )
		{
			start = patrolStarts[ patrolStartIndex ];
			boss_ref = ai_bosses[ patrolStartIndex - startIndex ];
			
			ai_spawner = get_spawners_by_targetname( boss_ref )[ 0 ];
			assert( isdefined( ai_spawner ), "Type: " + boss_ref + " does not have a spawner present in level." );
			
			ai_spawner.count = 1; // make sure count > 0
			
			new_guy = simple_spawn_single( ai_spawner );
			
			new_guy.ai_type = get_ai_struct( "hardened" );
			new_guy [[ level.attributes_func ]]();
			
			new_guy ForceTeleport( start.origin, start.angles );
			new_guy thread war_stealth_patrol( start, gameSeg.notifyWait );
			new_guy thread war_monitor_stealth( gameSeg.notifyWait );
		}
	}
	
	//add objective
	objectiveNum = level.objectiveNum;
	Objective_Add( level.objectiveNum, "current", get_war_gameObjStr_byIDX(level.currentGameSeg.idx));
	level.objectiveNum++;
	
	level notify( gameSeg.notifyStart );  //let everything know we've started
	level waittill(gameSeg.notifyWait, success);  //wait till complete
	
	total_enemies = get_total_enemies();
	while ( total_enemies >= ai_thresh  )
	{
		wait 1;
		total_enemies = get_total_enemies();
	}

	level notify( gameSeg.notifyFinish ); //let everything know we've finished
	gameSeg.segment_success = success;

	war_set_objective(objectiveNum, success);

	//cleanup
	level notify("gameSeg_completed");
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_monitor_stealth( notifyWait )
{
	level endon( notifyWait );
	level endon( "stealth_broken" );
	
	//level endon( "special_op_terminated" );
	
	self waittill_any("death", "pain", "enemy", "bulletwhizby" );
	
	// send all AI after the player
	array_func( GetAiArray("axis"), maps\_so_war_ai::attack_player, getclosest( self.origin,GetPlayers()) );
	array_func( GetAiArray("allies"), ::war_stealth_engage_enemies );
	
	level notify ( notifyWait, false );
	level notify( "stealth_broken" );
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_stealth_start_pacifist()
{
	self.pacifist = true;
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_stealth_engage_enemies()
{
	self.pacifist = false;
}
/////////////////////////////////////////////////////////////////////////////////////////////////
war_stealth_patrol( pathStart, notifyWait )
{
	self endon("death");
	level endon( notifyWait );
	
	self.goalradius = 32;
	
	nextNode = pathStart;
	while( IsDefined(nextNode) )
	{
		self SetGoalPos( nextNode.origin );
		
		self waittill( "goal" );
		
		wait( RandomFloatRange( 2, 4 ) );
		
		if( IsDefined( nextNode.target ) )
			nextNode = GetEnt( nextNode.target, "targetname" );
		else
			nextNode = pathStart;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////