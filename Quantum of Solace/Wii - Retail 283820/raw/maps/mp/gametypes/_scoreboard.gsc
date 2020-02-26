init()
{
	precacheShader("mpflag_spectator");

	switch(game["allies"])
	{
	case "mi6":
		precacheShader("mpflag_american");
		setdvar("g_TeamName_Allies", &"MPBXUI_ALLIES");
		setdvar("g_TeamColor_MyTeam", ".25 .75 .25");
		setdvar("g_ScoresBanner_Allies", "mpflag_american");
		break;

	case "marines":
		precacheShader("mpflag_american");
		setdvar("g_TeamName_Allies", &"MPBXUI_ALLIES");
		setdvar("g_TeamColor_MyTeam", ".25 .75 .25");
		setdvar("g_ScoresBanner_Allies", "mpflag_american");
		break;
	}

	switch(game["axis"])
	{
	case "opfor":
		precacheShader("mpflag_russian");
		setdvar("g_TeamName_Axis", &"MPBXUI_AXIS");
		setdvar("g_TeamColor_EnemyTeam", ".75 .25 .25");
		setdvar("g_ScoresBanner_Axis", "mpflag_russian");
		break;

	case "terrorists":
		precacheShader("mpflag_russian");
		setdvar("g_TeamName_Axis", &"MPBXUI_AXIS");
		setdvar("g_TeamColor_EnemyTeam", ".75 .25 .25");
		setdvar("g_ScoresBanner_Axis", "mpflag_russian");
		break;
	}
}
