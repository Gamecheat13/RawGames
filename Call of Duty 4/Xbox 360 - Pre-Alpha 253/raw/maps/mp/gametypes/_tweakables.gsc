#include maps\mp\_utility;

getTweakableDVarValue( category, name )
{
	switch( category )
	{
		case "rule":
			dVar = level.rules[name].dVar;
			break;
		case "game":
			dVar = level.gameTweaks[name].dVar;
			break;
		case "team":
			dVar = level.teamTweaks[name].dVar;
			break;
		case "player":
			dVar = level.playerTweaks[name].dVar;
			break;
		case "class":
			dVar = level.classTweaks[name].dVar;
			break;
		case "weapon":
			dVar = level.weaponTweaks[name].dVar;
			break;
		case "hardpoint":
			dVar = level.hardpointTweaks[name].dVar;
			break;
		case "hud":
			dVar = level.hudTweaks[name].dVar;
			break;
		default:
			dVar = undefined;
			break;
	}
	
	assert( isDefined( dVar ) );
	
	value = getDvarInt( dVar );
	
	return value;
}


getTweakableDVar( category, name )
{
	switch( category )
	{
		case "rule":
			value = level.rules[name].dVar;
			break;
		case "game":
			value = level.gameTweaks[name].dVar;
			break;
		case "team":
			value = level.teamTweaks[name].dVar;
			break;
		case "player":
			value = level.playerTweaks[name].dVar;
			break;
		case "class":
			value = level.classTweaks[name].dVar;
			break;
		case "weapon":
			value = level.weaponTweaks[name].dVar;
			break;
		case "hardpoint":
			value = level.hardpointTweaks[name].dVar;
			break;
		case "hud":
			value = level.hudTweaks[name].dVar;
			break;
		default:
			value = undefined;
			break;
	}
	
	assert( isDefined( value ) );
	return value;
}


getTweakableValue( category, name )
{
	switch( category )
	{
		case "rule":
			value = level.rules[name].value;
			break;
		case "game":
			value = level.gameTweaks[name].value;
			break;
		case "team":
			value = level.teamTweaks[name].value;
			break;
		case "player":
			value = level.playerTweaks[name].value;
			break;
		case "class":
			value = level.classTweaks[name].value;
			break;
		case "weapon":
			value = level.weaponTweaks[name].value;
			break;
		case "hardpoint":
			value = level.hardpointTweaks[name].value;
			break;
		case "hud":
			value = level.hudTweaks[name].value;
			break;
		default:
			value = undefined;
			break;
	}
	
	assert( isDefined( value ) );
	return value;
}


getTweakableLastValue( category, name )
{
	switch( category )
	{
		case "rule":
			value = level.rules[name].lastValue;
			break;
		case "game":
			value = level.gameTweaks[name].lastValue;
			break;
		case "team":
			value = level.teamTweaks[name].lastValue;
			break;
		case "player":
			value = level.playerTweaks[name].lastValue;
			break;
		case "class":
			value = level.classTweaks[name].lastValue;
			break;
		case "weapon":
			value = level.weaponTweaks[name].lastValue;
			break;
		case "hardpoint":
			value = level.hardpointTweaks[name].lastValue;
			break;
		case "hud":
			value = level.hudTweaks[name].lastValue;
			break;
		default:
			value = undefined;
			break;
	}
	
	assert( isDefined( value ) );
	return value;
}


setTweakableValue( category, name, value )
{
	switch( category )
	{
		case "rule":
			dVar = level.rules[name].dVar;
			break;
		case "game":
			dVar = level.gameTweaks[name].dVar;
			break;
		case "team":
			dVar = level.teamTweaks[name].dVar;
			break;
		case "player":
			dVar = level.playerTweaks[name].dVar;
			break;
		case "class":
			dVar = level.classTweaks[name].dVar;
			break;
		case "weapon":
			dVar = level.weaponTweaks[name].dVar;
			break;
		case "hardpoint":
			dVar = level.hardpointTweaks[name].dVar;
			break;
		case "hud":
			dVar = level.hudTweaks[name].dVar;
			break;
		default:
			dVar = undefined;
			break;
	}
	
	setDvar( dVar, value );
}


setTweakableLastValue( category, name, value )
{
	switch( category )
	{
		case "rule":
			level.rules[name].lastValue = value;
			break;
		case "game":
			level.gameTweaks[name].lastValue = value;
			break;
		case "team":
			level.teamTweaks[name].lastValue = value;
			break;
		case "player":
			level.playerTweaks[name].lastValue = value;
			break;
		case "class":
			level.classTweaks[name].lastValue = value;
			break;
		case "weapon":
			level.weaponTweaks[name].lastValue = value;
			break;
		case "hardpoint":
			level.hardpointTweaks[name].lastValue = value;
			break;
		case "hud":
			level.hudTweaks[name].lastValue = value;
			break;
		default:
			break;
	}
}


registerTweakable( category, name, dvar, value )
{
	if ( isString( value ) )
	{
		if( getDvar( dvar ) == "" )
			setDvar( dvar, value );
		else
			value = getDvar( dvar );
	}
	else
	{
		if( getDvar( dvar ) == "" )
			setDvar( dvar, value );
		else
			value = getDvarInt( dvar );
	}

	switch( category )
	{
		case "rule":
			if ( !isDefined( level.rules[name] ) )
				level.rules[name] = spawnStruct();				
			level.rules[name].value = value;
			level.rules[name].lastValue = value;
			level.rules[name].dVar = dvar;
			break;
		case "game":
			if ( !isDefined( level.gameTweaks[name] ) )
				level.gameTweaks[name] = spawnStruct();
			level.gameTweaks[name].value = value;
			level.gameTweaks[name].lastValue = value;			
			level.gameTweaks[name].dVar = dvar;
			break;
		case "team":
			if ( !isDefined( level.teamTweaks[name] ) )
				level.teamTweaks[name] = spawnStruct();
			level.teamTweaks[name].value = value;
			level.teamTweaks[name].lastValue = value;			
			level.teamTweaks[name].dVar = dvar;
			break;
		case "player":
			if ( !isDefined( level.playerTweaks[name] ) )
				level.playerTweaks[name] = spawnStruct();
			level.playerTweaks[name].value = value;
			level.playerTweaks[name].lastValue = value;			
			level.playerTweaks[name].dVar = dvar;
			break;
		case "class":
			if ( !isDefined( level.classTweaks[name] ) )
				level.classTweaks[name] = spawnStruct();
			level.classTweaks[name].value = value;
			level.classTweaks[name].lastValue = value;			
			level.classTweaks[name].dVar = dvar;
			break;
		case "weapon":
			if ( !isDefined( level.weaponTweaks[name] ) )
				level.weaponTweaks[name] = spawnStruct();
			level.weaponTweaks[name].value = value;
			level.weaponTweaks[name].lastValue = value;			
			level.weaponTweaks[name].dVar = dvar;
			break;
		case "hardpoint":
			if ( !isDefined( level.hardpointTweaks[name] ) )
				level.hardpointTweaks[name] = spawnStruct();
			level.hardpointTweaks[name].value = value;
			level.hardpointTweaks[name].lastValue = value;			
			level.hardpointTweaks[name].dVar = dvar;
			break;
		case "hud":
			if ( !isDefined( level.hudTweaks[name] ) )
				level.hudTweaks[name] = spawnStruct();
			level.hudTweaks[name].value = value;
			level.hudTweaks[name].lastValue = value;			
			level.hudTweaks[name].dVar = dvar;
			break;
	}
}


init()
{
	level.clientTweakables = [];
	level.tweakablesInitialized = true;

	level.rules = [];
	level.gameTweaks = [];
	level.teamTweaks = [];
	level.playerTweaks = [];
	level.classTweaks = [];
	level.weaponTweaks = [];
	level.hardpointTweaks = [];
	level.hudTweaks = [];
	// commented out tweaks have not yet been implemented
	
	registerTweakable( "game", 			"graceperiod", 			"scr_game_graceperiod", 			15 ); //*
	registerTweakable( "game", 			"onlyheadshots", 		"scr_game_onlyheadshots", 			0 ); //*
	registerTweakable( "game", 			"allowpenetration", 	"bullet_penetrationEnabled", 		1 );
	registerTweakable( "game", 			"allowkillcam", 		"scr_game_allowkillcam", 			1 ); //*
	registerTweakable( "game", 			"spectatetype", 		"scr_game_spectatetype", 			2 ); //*

	registerTweakable( "game", 			"deathpointloss", 		"scr_game_deathpointloss", 			0 ); //*
	registerTweakable( "game", 			"suicidepointloss", 	"scr_game_suicidepointloss", 		0 ); //*
	registerTweakable( "game", 			"teamkillpointloss", 	"scr_team_teamkillpointloss", 		0 ); //*
	
	registerTweakable( "team", 			"respawntime", 			"scr_team_respawntime", 			0 );
	registerTweakable( "team", 			"fftype", 				"scr_team_fftype", 					0 ); 
	registerTweakable( "team", 			"teamkillspawndelay", 	"scr_team_teamkillspawndelay", 		0 );
	registerTweakable( "team", 			"kickteamkillers", 		"scr_team_kickteamkillers", 		0 );
	registerTweakable( "team", 			"friendlynames", 		"cg_drawCrosshairNames", 			1 ); //*
	
	registerTweakable( "player", 		"numlives", 			"scr_player_numlives", 				0 ); //*
	registerTweakable( "player", 		"respawndelay", 		"scr_player_respawndelay", 			0 ); //*
	registerTweakable( "player", 		"maxhealth", 			"scr_player_maxhealth", 			100 ); //*
	registerTweakable( "player", 		"healthregentime", 		"scr_player_healthregentime", 		5 ); //*
	registerTweakable( "player", 		"suicidespawndelay", 	"scr_player_suicidespawndelay", 	0 );
	registerTweakable( "player", 		"forcerespawn", 		"scr_player_forcerespawn", 			0 ); //*

	//registerTweakable( "player", 		"sprinttime", 			"player_sprintTime", 				4 ); //*
	//registerTweakable( "player", 		"sprintregentime", 		"player_sprintregentime", 			1 ); // needs code support
	//registerTweakable( "player", 		"allowjump", 			"scr_player_allowjump", 			1 ); // needs code support

	registerTweakable( "class", 	"allowclosequarters", "scr_class_allowclosequarters", 	1 );
	registerTweakable( "class", 	"allowassault", 	"scr_class_allowassault", 			1 );
	registerTweakable( "class", 	"allowsniper", 		"scr_class_allowsniper", 			1 );
	registerTweakable( "class", 	"allowengineer", 	"scr_class_allowengineer", 			1 );
	registerTweakable( "class", 	"allowantiarmor", 	"scr_class_allowantiarmor", 		1 );
	registerTweakable( "class", 	"allowsupport", 	"scr_class_allowsupport", 			1 );
    
	registerTweakable( "weapon", 	"onlypistols", 		"scr_weapon_onlypistols", 0 );
	registerTweakable( "weapon", 	"allowfrag", 		"scr_weapon_allowfrags", 1 );
	registerTweakable( "weapon", 	"allowsmoke", 		"scr_weapon_allowsmoke", 1 );
	registerTweakable( "weapon", 	"allowflash", 		"scr_weapon_allowflash", 1 );
	registerTweakable( "weapon", 	"allowc4", 			"scr_weapon_allowc4", 1 );
	registerTweakable( "weapon", 	"allowclaymores", 	"scr_weapon_allowclaymores", 1 );
	registerTweakable( "weapon", 	"allowrpgs", 		"scr_weapon_allowrpgs", 1 );
	registerTweakable( "weapon", 	"allowmines", 		"scr_weapon_allowmines", 1 );

	registerTweakable( "hardpoint", "allowartillery", 	"scr_hardpoint_allowartillery", 1 );
	registerTweakable( "hardpoint", "allowuav", 		"scr_hardpoint_allowuav", 1 );
	registerTweakable( "hardpoint", "allowsupply", 		"scr_hardpoint_allowsupply", 1 );
	registerTweakable( "hardpoint", "allowhelicopter", 	"scr_hardpoint_allowhelicopter", 1 );
    
	registerTweakable( "hud", 		"showGPS", 			"ui_hud_showGPS", 							1 ); //*
	setClientTweakable( "hud", 		"showGPS" );
	registerTweakable( "hud", 		"showstanceicon", 	"ui_hud_showstanceicon", 					1 ); //*
	setClientTweakable( "hud", 		"showstanceicon" );
	registerTweakable( "hud", 		"showobjicons", 	"ui_hud_showobjicons", 						1 ); //*
	setClientTweakable( "hud", 		"showobjicons" );
	registerTweakable( "hud", 		"showweaponinfo", 	"ui_hud_showweaponinfo", 					1 ); //*
	setClientTweakable( "hud", 		"showweaponinfo" );
	registerTweakable( "hud", 		"showscore", 		"ui_hud_showscore", 						1 ); //*
	setClientTweakable( "hud", 		"showscore" );

	registerTweakable( "hud", 		"showtimer", 		"ui_hud_showtimer", 						1 ); //*

	registerTweakable( "hud", 		"showcrosshair", 	"cg_drawCrosshair", 						1 ); //* bug
	setClientTweakable( "hud", 		"showcrosshair" );

	registerTweakable( "hud", 		"showfragindicator", 	"cg_hudGrenadeIconMaxRangeFrag", 		250 ); //* bug
	setClientTweakable( "hud", 		"showfragindicator" );

	registerTweakable( "hud", 		"showflashindicator", 	"cg_hudGrenadeIconMaxRangeFlash", 		500 ); //* bug
	setClientTweakable( "hud", 		"showflashindicator" );

	//registerTweakable( "hud", 		"showoverhead", "scr_hud_showoverhead", 1 );
	//registerTweakable( "hud", 		"showtimer", "scr_hud_showtimer", 1 );
	//registerTweakable( "hud", 		"showteamscore", "scr_hud_showteamscore", 1 );
	//registerTweakable( "hud", 		"showcrosshair", "scr_hud_showcrosshair", 1 );
	//registerTweakable( "hud", 		"showstance", "scr_hud_showstance", 1 );
	//registerTweakable( "hud", 		"showobituaries", "scr_hud_showobituaries", 1 );
	//registerTweakable( "hud", 		"showteamicons", "scr_hud_showteamicons", 1 );
	//registerTweakable( "hud", 		"showdeathicons", "scr_hud_showdeathicons", 1 );
	
	level thread updateUITweakables();
}

setClientTweakable( category, name )
{
	level.clientTweakables[level.clientTweakables.size] = name;
}



updateUITweakables()
{
	for ( ;; )
	{
		for ( index = 0; index < level.clientTweakables.size; index++ )
		{
			clientTweakable = level.clientTweakables[index];
			curValue = getTweakableDVarValue( "hud", clientTweakable );
			lastValue = getTweakableLastValue( "hud", clientTweakable );
			
			if ( curValue != lastValue )
			{
				updateServerDvar( getTweakableDvar( "hud", clientTweakable ), curValue );
				setTweakableLastValue( "hud", clientTweakable, curValue );
			}
		}
			
		wait ( 1.0 );
	}
}


updateServerDvar( dvar, value )
{
	makeDVarServerInfo( dvar, value );
}
