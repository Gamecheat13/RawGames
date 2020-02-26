#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	makeDvarServerInfo( "ui_score_bar", 1 );

	while ( !isDefined( level.inGracePeriod ) || level.inGracePeriod )
		wait ( 0.05 );

	level thread updateTeamScoreBar();
//	level thread scorethread();
}


scorethread()
{
	for ( ;; )
	{
		wait ( randomFloatRange( 1, 8 ) );
		maps\mp\gametypes\_globallogic::giveTeamScore( "kill", "allies",  level.players[0], level.players[0] );					
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

		if ( level.scoreLimit && teamScore / level.scoreLimit > 0.75 )
			scoreBarTime = int((level.timeLimit * 60) - level.timePassed);
		else if ( level.timeLimit && int((level.timeLimit * 60) - level.timePassed) < 60 )
			scoreBarTime = int((level.timeLimit * 60) - level.timePassed);
		else if ( getTime() - lastScoreBarTime < 20000 )
			scoreBarTime = 0;

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