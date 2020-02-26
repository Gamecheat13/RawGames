#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	switch(game["allies"])
	{
	case "marines":
		game["hudicon_allies"] = "hudicon_american";
		break;
	}
	
	assert(game["axis"] == "opfor");
	game["hudicon_axis"] = "hudicon_opfor";

	precacheShader(game["hudicon_allies"]);
	precacheShader(game["hudicon_axis"]);
	precacheShader("hud_teamcaret");
	precacheString(&"MP_SLASHSCORE");

	level.enemyScoreFlashFrac = 0.95;
	level.teamScoreFlashFrac = 1;

	if ( !maps\mp\gametypes\_tweakables::getTweakableValue( "hud", "showscore" ) )
		return;

	createTeamScoreHUD( "allies", "axis" );
	createTeamScoreHUD( "axis", "allies" );

	level thread onUpdateTeamScoreHUD();
}


createTeamScoreHUD( team, enemyTeam )
{
	level.hud[team].hud_teamicon = createServerIcon( game["hudicon_"+team], 20, 20, team );
	level.hud[team].hud_teamicon setPoint( "TOPLEFT", "TOPLEFT", 8, 16 );
	level.hud[team].hud_teamicon.foreground = true;

	level.hud[team].hud_enemyicon = createServerIcon( game["hudicon_"+enemyTeam], 20, 20, team );
	level.hud[team].hud_enemyicon setParent( level.hud[team].hud_teamicon );
	level.hud[team].hud_enemyicon setPoint( "TOPLEFT", "BOTTOMLEFT", 0, -2 );
	level.hud[team].hud_enemyicon.foreground = true;

	level.hud[team].hud_teamscorebar = createServerBar( (0.02745, 0.71372, 0.23137), 85, 22, level.teamScoreFlashFrac, team, true );
	level.hud[team].hud_teamscorebar setParent( level.hud[team].hud_teamicon );
	level.hud[team].hud_teamscorebar setPoint( "LEFT", "RIGHT" );
	level.hud[team].hud_teamscorebar.bar.foreground = true;
	level.hud[team].hud_teamscorebar.barFrame.foreground = true;
	level.hud[team].hud_teamscorebar.foreground = true;

	level.hud[team].hud_enemyscorebar = createServerBar( (0.91765, 0.09804, 0.18431), 85, 22, level.enemyScoreFlashFrac, team );
	level.hud[team].hud_enemyscorebar setParent( level.hud[team].hud_enemyicon );
	level.hud[team].hud_enemyscorebar setPoint( "LEFT", "RIGHT" );
	level.hud[team].hud_enemyscorebar.bar.foreground = true;
	level.hud[team].hud_enemyscorebar.barFrame.foreground = true;	
	level.hud[team].hud_enemyscorebar.foreground = true;

	level.hud[team].hud_teamscoretotal = createServerFontString( "default", 1.45, team );
	level.hud[team].hud_teamscoretotal.label = &"MP_SLASHSCORE";
	level.hud[team].hud_teamscoretotal setParent( level.hud[team].hud_teamscorebar );
	level.hud[team].hud_teamscoretotal setPoint( "LEFT", "CENTER", -8, 0 );
	level.hud[team].hud_teamscoretotal.foreground = true;

	level.hud[team].hud_enemyscoretotal = createServerFontString( "default", 1.45, team );
	level.hud[team].hud_enemyscoretotal.label = &"MP_SLASHSCORE";
	level.hud[team].hud_enemyscoretotal setParent( level.hud[team].hud_enemyscorebar );
	level.hud[team].hud_enemyscoretotal setPoint( "LEFT", "CENTER", -8, 0 );
	level.hud[team].hud_enemyscoretotal.foreground = true;

	level.hud[team].hud_teamscore = createServerFontString( "default", 1.45, team );
	level.hud[team].hud_teamscore setParent( level.hud[team].hud_teamscoretotal );
	level.hud[team].hud_teamscore setPoint( "RIGHT", "LEFT" );
	level.hud[team].hud_teamscore.foreground = true;
	
	level.hud[team].hud_enemyscore = createServerFontString( "default", 1.45, team );
	level.hud[team].hud_enemyscore setParent( level.hud[team].hud_enemyscoretotal );
	level.hud[team].hud_enemyscore setPoint( "RIGHT", "LEFT" );
	level.hud[team].hud_enemyscore.foreground = true;
	
	level.hud[team].hud_teamcaret = createServerIcon( "hud_teamcaret", 20, 20, team );
	level.hud[team].hud_teamcaret setParent( level.hud[team].hud_teamicon );
	level.hud[team].hud_teamcaret setPoint( "TOPRIGHT", "TOPLEFT", 7, 0 );
	level.hud[team].hud_teamcaret.foreground = true;

	level.hud[team].team = team;
	level.hud[team].enemyTeam = enemyTeam;
	
	if ( isDefined( level.hud_scoreBar ) )
	{
		level.hud[team].hud_teamscoretotal setParent( level.hud_scoreBar );
		level.hud[team].hud_teamscoretotal setPoint( "LEFT", "LEFT", 245, -3 );
	
		level.hud[team].hud_enemyscoretotal setParent( level.hud_scoreBar );
		level.hud[team].hud_enemyscoretotal setPoint( "LEFT", "LEFT", 345, -3 );

		level.hud[team].hud_teamscorebar hideElem();
		level.hud[team].hud_enemyscorebar hideElem();

		level.hud[team].hud_teamicon destroyElem();
		level.hud[team].hud_enemyicon destroyElem();
		level.hud[team].hud_teamcaret hideElem();

		if ( team == "allies" )
			level.hud[team].hud_teamicon = createServerIcon( "score_bar_allies", 45, 59, team );
		else
			level.hud[team].hud_teamicon = createServerIcon( "score_bar_opfor", 45, 59, team );

		level.hud[team].hud_teamicon setParent( level.hud_scoreBar );
		level.hud[team].hud_teamicon setPoint( "TOPLEFT", "TOPLEFT", 200, 0 );
		level.hud[team].hud_teamicon.foreground = true;

		if ( team == "allies" )
			level.hud[team].hud_enemyicon = createServerIcon( "score_bar_opfor", 46, 59, team );
		else
			level.hud[team].hud_enemyicon = createServerIcon( "score_bar_allies", 46, 59, team );
		
		level.hud[team].hud_enemyicon setParent( level.hud_scoreBar );
		level.hud[team].hud_enemyicon setPoint( "TOPLEFT", "TOPLEFT", 300, 0 );
		level.hud[team].hud_enemyicon.foreground = true;

	}
	
	level.hud[team] updateTeamScoreHUD();	
}


onUpdateTeamScoreHUD()
{
	//level endon ( "game_ended" );
	
	for(;;)
	{
		level waittill_any( "update_teamscore_hud", "update_scorelimit" );
		
		level.hud["allies"] updateTeamScoreHUD();
		level.hud["axis"] updateTeamScoreHUD();
	}
}


updateTeamScoreHUD()
{
// commented out to allow final scoring point to register
//	if ( game["state"] != "playing" )
//		return;

	teamscore = 0;
	enemyscore = 0;
	scoreLimit = 1;
	
	if ( isDefined( level.scoreLimit ) && !level.scoreLimit && level.roundLimit > 1 )
	{
		teamscore = maps\mp\gametypes\_globallogic::getGameScore( self.team );
		enemyscore = maps\mp\gametypes\_globallogic::getGameScore( self.enemyTeam );
		scoreLimit = level.roundLimit;
	}
	else if ( isDefined( level.scoreLimit ) && !level.scoreLimit )
	{
		teamscore = game[self.team+"roundwins"];
		enemyscore = game[self.enemyTeam+"roundwins"];
		scoreLimit = 1;
	}
	else
	{
		teamscore = level.teamScores[self.team];
		enemyscore = level.teamScores[self.enemyTeam];
		scoreLimit = level.scoreLimit;
	}
	
	if ( !scoreLimit )
		scoreLimit = 1;
	

	if ( !isDefined( level.hud_scoreBar ) )
	{
		if(teamscore == enemyscore || teamscore > enemyscore )
		{
			level.hud[self.team].hud_teamicon setParent( level.uiParent );
			level.hud[self.team].hud_teamicon setPoint( "TOPLEFT", "TOPLEFT", 8, 16 );
	
			level.hud[self.team].hud_enemyicon setParent( level.hud[self.team].hud_teamicon );
			level.hud[self.team].hud_enemyicon setPoint( "TOPLEFT", "BOTTOMLEFT", 0, -2 );
		}
		else
		{
			level.hud[self.team].hud_enemyicon setParent( level.uiParent );
			level.hud[self.team].hud_enemyicon setPoint( "TOPLEFT", "TOPLEFT", 8, 16 );
	
			level.hud[self.team].hud_teamicon setParent( level.hud[self.team].hud_enemyicon );
			level.hud[self.team].hud_teamicon setPoint( "TOPLEFT", "BOTTOMLEFT", 0, -2 );
		}
	}

	if ( level.roundLimit == 0 )
	{
		teamscore = game[self.team+"roundwins"];
		enemyscore = game[self.enemyTeam+"roundwins"];
		
		self.hud_teamscore setValue( teamscore );
		self.hud_enemyscore setValue( enemyscore );
		
		self.hud_teamscoretotal hideElem();
		self.hud_enemyscoretotal hideElem();
		
		if ( !isDefined( level.hud_scoreBar ) )
		{
			self.hud_teamscorebar hideElem();
			self.hud_enemyscorebar hideElem();
		
			self.hud_teamscore showElem();
			self.hud_enemyscore showElem();
		}
		return;
	}
	
	self.hud_teamscore setValue( teamscore );
	self.hud_enemyscore setValue( enemyscore );
	
	self.hud_teamscoretotal setValue( scoreLimit );
	self.hud_enemyscoretotal setValue( scoreLimit );
	
	if ( !isDefined( level.hud_scoreBar ) )
	{
		// to prevent progress bar going over 100%
		if ( ( teamscore / scoreLimit ) > 1 )
			self.hud_teamscorebar updateBar( 1 );
		else
			self.hud_teamscorebar updateBar( teamscore / scoreLimit );
			
		if ( ( enemyscore / scoreLimit ) > 1 )
			self.hud_enemyscorebar updateBar( 1 );
		else
			self.hud_enemyscorebar updateBar( enemyscore / scoreLimit );
	
		self.hud_teamscore showElem();
		self.hud_enemyscore showElem();
		
		self.hud_teamscorebar showElem();
		self.hud_enemyscorebar showElem();
	}
}


setEnemyScoreFlashFrac( flashFrac )
{
	level.enemyScoreFlashFrac = flashFrac;
}


setTeamScoreFlashFrac( flashFrac )
{
	level.teamScoreFlashFrac = flashFrac;
}