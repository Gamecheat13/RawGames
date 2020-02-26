init()
{
	SetDvar("g_ScoresColor_Spectator", ".25 .25 .25");
	SetDvar("g_ScoresColor_Free", ".76 .78 .10");

	SetDvar("g_teamColor_MyTeam", ".4 .7 .4" );	
	SetDvar("g_teamColor_EnemyTeam", "1 .315 0.35" );	
	SetDvar("g_teamColor_MyTeamAlt", ".35 1 1" ); //cyan
	SetDvar("g_teamColor_EnemyTeamAlt", "1 .5 0" ); //orange	

	SetDvar("g_teamColor_Squad", ".315 0.35 1" );

	if ( level.createFX_enabled || SessionModeIsZombiesGame() )
		return;

	SetDvar( "g_TeamIcon_Axis", game["icons"]["axis"] );
	SetDvar( "g_TeamIcon_Allies", game["icons"]["allies"] );
}
