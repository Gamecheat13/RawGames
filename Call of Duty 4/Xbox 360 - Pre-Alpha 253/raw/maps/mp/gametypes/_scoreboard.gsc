init()
{
	precacheShader("mpflag_spectator");

	switch(game["allies"])
	{
	case "marines":
		precacheShader("hudicon_american");
		setdvar("g_TeamName_Allies", &"MPUI_MARINES");
		setdvar("g_ScoresColor_MyTeam", ".08 .26 .06");
		setdvar("g_ScoresBanner_Allies", "hudicon_american");
		break;
	}

	switch(game["axis"])
	{
	case "opfor":
		precacheShader("hudicon_opfor");
		setdvar("g_TeamName_Axis", &"MPUI_OPFOR");
		setdvar("g_ScoresColor_EnemyTeam", ".49 .05 .03");
		setdvar("g_ScoresBanner_Axis", "hudicon_opfor");
		break;
	}
	
	setdvar("g_ScoresColor_Spectator", ".25 .25 .25");
	setdvar("g_ScoresColor_Free", ".76 .78 .10");
	setdvar("g_ScoresPing_MaxBars", "4" );
	setdvar("g_ScoresPing_Interval", "100" );
}
