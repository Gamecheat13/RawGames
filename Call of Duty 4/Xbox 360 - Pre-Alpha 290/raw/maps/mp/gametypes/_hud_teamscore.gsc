#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init()
{
//	makeDvarServerInfo( "ui_score_bar", 1 );

	while ( !isDefined( level.inPrematchPeriod ) || level.inPrematchPeriod )
		wait ( 0.05 );

//	level thread updateTeamScoreBar();

//	level thread scorethread();
}


scorethread()
{
	wait ( 10.0 );
	for ( ;; )
	{
		wait ( randomFloatRange( 1, 8 ) );
		if ( level.players[0].pers["team"] == "allies" || level.players[0].pers["team"] == "axis" )
			level.players[0] thread [[level.onXPEvent]]( "kill" );

		maps\mp\gametypes\_globallogic::giveTeamScore( "kill", "allies",  level.players[0], level.players[0] );					
		maps\mp\gametypes\_globallogic::giveTeamScore( "kill", "axis",  level.players[0], level.players[0] );					
	}
}


updateTeamScoreBar()
{
	lastScoreBarTime = 0;
	
	for(;;)
	{
		scoreBarTime = 0;

		if ( isDefined( level.scoreLimit ) && level.scoreLimit )
			teamScore = int(max( level.teamScores["axis"], level.teamScores["allies"] ));
		else
			teamScore = 0;

		if ( getTime() - lastScoreBarTime > 60000 )
			scoreBarTime = 5.0;
		else if ( teamScore && !(teamScore % 100) )
			scoreBarTime = 5.0;

		if ( level.scoreLimit && teamScore / level.scoreLimit > 0.85 )
		{
			level notify ( "match_ending_soon" );
			scoreBarTime = int((level.timeLimit * 60) - level.timePassed) + 10;
		}
		else if ( level.timeLimit && int((level.timeLimit * 60) - level.timePassed) < 60 )
		{
			level notify ( "match_ending_soon" );
			scoreBarTime = int((level.timeLimit * 60) - level.timePassed) + 10;
		}
		else if ( getTime() - lastScoreBarTime < 20000 )
		{
			scoreBarTime = 0;
		}

		if ( scoreBarTime > 0 )
		{
			showScoreBar( scoreBarTime );
			lastScoreBarTime = getTime();
		}
		
		wait ( 0.05 );
	}
}


showScoreBar( time )
{
	level notify ( "showScoreBar" );
	level endon ( "showScoreBar" );
	
	setDvar( "ui_score_bar", 1 );
	wait ( time );
	setDvar( "ui_score_bar", 0 );
}