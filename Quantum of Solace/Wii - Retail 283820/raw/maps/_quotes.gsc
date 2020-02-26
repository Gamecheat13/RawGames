main()
{
	
	thread setDeadQuote();
}

setVictoryQuote()
{











































}

setDeadQuote()
{
 	level endon ("mine death");
 

 	level notify ("new_quote_string");
 	level endon ("new_quote_string");
 	level.player waittill("death");

 	if(!level.missionfailed)
 	{
 		deadquotes[0] = "@DEADQUOTE_GRENADES_1";
 		deadquotes[1] = "@DEADQUOTE_GRENADES_2";
 		deadquotes[2] = "@DEADQUOTE_GRENADES_3";
 		deadquotes[3] = "@DEADQUOTE_COVER_1";
 		deadquotes[4] = "@DEADQUOTE_COVER_2";
 		deadquotes[5] = "@DEADQUOTE_COVER_3";
 		deadquotes[6] = "@DEADQUOTE_COVER_4";
 		deadquotes[7] = "@DEADQUOTE_ENEMY_1";
 		deadquotes[8] = "@DEADQUOTE_ENEMY_2";
 		deadquotes[9] = "@DEADQUOTE_ENEMY_3";
 		deadquotes[10]= "@DEADQUOTE_GENERAL_1";
 		deadquotes[11] = "@DEADQUOTE_MAP_1";
 		deadquotes[12] = "@DEADQUOTE_MAP_2";
 		deadquotes[13] = "@DEADQUOTE_MAP_3";
 		deadquotes[14] = "@DEADQUOTE_MAP_4";
		
 		
 		deadquotes[15] = "@DEADQUOTE_MAP_6";
 		deadquotes[16] = "@DEADQUOTE_MOVEMENT_1";
 		deadquotes[17] = "@DEADQUOTE_MOVEMENT_2";
 		deadquotes[18] = "@DEADQUOTE_MOVEMENT_3";
 		deadquotes[19] = "@DEADQUOTE_MOVEMENT_4";
 		deadquotes[20] = "@DEADQUOTE_MOVEMENT_5";
 		deadquotes[21] = "@DEADQUOTE_MOVEMENT_6";
 		deadquotes[22] = "@DEADQUOTE_WEAPONS_1";
 		deadquotes[23] = "@DEADQUOTE_WEAPONS_2";
 		deadquotes[24] = "@DEADQUOTE_WEAPONS_3";
 		deadquotes[25] = "@DEADQUOTE_WEAPONS_4";
 		deadquotes[26] = "@DEADQUOTE_WEAPONS_5";
 		deadquotes[27] = "@DEADQUOTE_WEAPONS_6";
		deadquotes[28] = "@DEADQUOTE_WEAPONS_7";
 		deadquotes[29] = "@DEADQUOTE_WEAPONS_8";
 		deadquotes[30] = "@DEADQUOTE_WEAPONS_9";
 		deadquotes[31] = "@DEADQUOTE_WEAPONS_10";
 		deadquotes[32] = "@DEADQUOTE_WEAPONS_11";
 		deadquotes[33] = "@DEADQUOTE_MOVEMENT_7";
 		deadquotes[34] = "@DEADQUOTE_MOVEMENT_8";
		deadquotes[35] = "@DEADQUOTE_GENERAL_2";
 		deadquotes[36] = "@DEADQUOTE_GENERAL_3";
 		deadquotes[37] = "@DEADQUOTE_GENERAL_4";
 		deadquotes[38] = "@DEADQUOTE_ENEMY_4";
 		deadquotes[39] = "@DEADQUOTE_GENERAL_5";
 		deadquotes[40] = "@DEADQUOTE_WEAPONS_12";
 		deadquotes[41] = "@DEADQUOTE_ENEMY_5";
 		deadquotes[42] = "@DEADQUOTE_WEAPONS_13";
		deadquotes[43] = "@DEADQUOTE_MOVEMENT_9";
 

 	                       
 		i = randomInt(deadquotes.size);

 		setdvar("ui_deadquote", deadquotes[i]);
 	}
}
