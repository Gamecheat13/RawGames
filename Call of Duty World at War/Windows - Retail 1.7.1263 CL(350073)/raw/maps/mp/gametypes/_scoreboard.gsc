init()
{
	switch(game["allies"])
	{
	case "marines":
		setdvar("g_TeamName_Allies", &"MPUI_MARINE_SHORT");

		precacheShader("faction_128_american");
		setdvar("g_TeamIcon_Allies", "faction_128_american");
		setdvar("g_TeamColor_Allies", ".5 .5 .5");
		setdvar("g_ScoresColor_Allies", "0 0 0");

		break;
	
	case "russian":
		setdvar("g_TeamName_Allies", &"MPUI_RUSSIAN_SHORT");

		precacheShader("faction_128_soviet");
		setdvar("g_TeamIcon_Allies", "faction_128_soviet");
		setdvar("g_TeamColor_Allies", "0.6 0.64 0.69");
		setdvar("g_ScoresColor_Allies", "0.6 0.64 0.69");
		break;
	}

	switch(game["axis"])
	{
	case "german":
		setdvar("g_TeamName_Axis", &"MPUI_GERMAN_SHORT");

		precacheShader("faction_128_german");
		setdvar("g_TeamIcon_Axis", "faction_128_german");
		setdvar("g_TeamColor_Axis", "0.65 0.57 0.41");		
		setdvar("g_ScoresColor_Axis", "0.65 0.57 0.41");
		break;
	
	case "japanese":
		setdvar("g_TeamName_Axis", &"MPUI_JAPANESE_SHORT");

		precacheShader("faction_128_japan");
		setdvar("g_TeamIcon_Axis", "faction_128_japan");
		setdvar("g_TeamColor_Axis", "0.52 0.28 0.28");		
		setdvar("g_ScoresColor_Axis", "0.52 0.28 0.28");
		break;
	}
	setdvar("g_ScoresColor_Spectator", ".25 .25 .25");
	setdvar("g_ScoresColor_Free", ".76 .78 .10");

	setdvar("g_teamColor_MyTeam", ".4 .7 .4" );	
	setdvar("g_teamColor_EnemyTeam", "1 .315 0.35" );	
	setdvar("g_teamColor_MyTeamAlt", ".35 1 1" ); //cyan
	setdvar("g_teamColor_EnemyTeamAlt", "1 .5 0" ); //orange	

	setdvar("g_teamColor_Squad", ".315 0.35 1" );	
}
