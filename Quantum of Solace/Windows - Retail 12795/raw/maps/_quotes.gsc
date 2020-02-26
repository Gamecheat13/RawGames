main()
{
	//thread setVictoryQuote();
	thread setDeadQuote();
}

setVictoryQuote()
{
// 	victoryquotes[0] = "@VICTORYQUOTE_WHEN_YOU_HAVE_TO_KILL";
// 	victoryquotes[1] = "@VICTORYQUOTE_BATTLES_ARE_WON_BY_SLAUGHTER";
// 	victoryquotes[2] = "@VICTORYQUOTE_HISTORY_WILL_BE_KIND";
// 	victoryquotes[3] = "@VICTORYQUOTE_NOTHING_IN_LIFE_IS_SO";
// 	victoryquotes[4] = "@VICTORYQUOTE_SUCCESS_IS_NOT_FINAL";
// 	victoryquotes[5] = "@VICTORYQUOTE_WE_SHALL_DEFEND_OUR_ISLAND";
// 	victoryquotes[6] = "@VICTORYQUOTE_WHEN_YOU_GET_TO_THE_END";
// 	victoryquotes[7] = "@VICTORYQUOTE_THE_REAL_AND_LASTING";
// 	victoryquotes[8] = "@VICTORYQUOTE_A_HERO_IS_NO_BRAVER_THAN";
// 	victoryquotes[9] = "@VICTORYQUOTE_OUR_GREATEST_GLORY_IS";
// 	victoryquotes[10]= "@VICTORYQUOTE_THE_CHARACTERISTIC_OF";
// 	victoryquotes[11] = "@VICTORYQUOTE_IF_THE_OPPOSITION_DISARMS";
// 	victoryquotes[12] = "@VICTORYQUOTE_THE_OBJECT_OF_WAR_IS";
// 	victoryquotes[13] = "@VICTORYQUOTE_BETTER_TO_FIGHT_FOR_SOMETHING";
// 	victoryquotes[14] = "@VICTORYQUOTE_COURAGE_IS_FEAR_HOLDING";
// 	victoryquotes[15] = "@VICTORYQUOTE_IF_A_MAN_DOES_HIS_BEST";
// 	victoryquotes[16] = "@VICTORYQUOTE_IT_IS_FOOLISH_AND_WRONG";
// 	victoryquotes[17] = "@VICTORYQUOTE_EVERY_MANS_LIFE_ENDS";
// 	victoryquotes[18] = "@VICTORYQUOTE_ALL_WARS_ARE_CIVIL_WARS";
// 	victoryquotes[19] = "@VICTORYQUOTE_I_HAVE_NEVER_ADVOCATED";
// 	victoryquotes[20] = "@VICTORYQUOTE_WE_HAPPY_FEW_WE_BAND";
// 	victoryquotes[21] = "@VICTORYQUOTE_COWARDS_DIE_MANY_TIMES";
// 	victoryquotes[22] = "@VICTORYQUOTE_NEVER_INTERRUPT_YOUR";
// 	victoryquotes[23] = "@VICTORYQUOTE_THERE_ARE_ONLY_TWO_FORCES";
// 	victoryquotes[24] = "@VICTORYQUOTE_THERE_WILL_ONE_DAY_SPRING";
// 	victoryquotes[25] = "@VICTORYQUOTE_THERE_ARE_NO_ATHEISTS";
// 	victoryquotes[26] = "@VICTORYQUOTE_IF_WE_DONT_END_WAR_WAR";
// 	victoryquotes[27] = "@VICTORYQUOTE_LIVE_AS_BRAVE_MEN_AND";
// 	victoryquotes[28] = "@VICTORYQUOTE_COURAGE_AND_PERSEVERANCE";
// 	victoryquotes[29] = "@VICTORYQUOTE_COURAGE_IS_BEING_SCARED";
// 	victoryquotes[30] = "@VICTORYQUOTE_ABOVE_ALL_THINGS_NEVER";
// 	victoryquotes[31] = "@VICTORYQUOTE_I_HAVE_NEVER_MADE_BUT";
// 	victoryquotes[32] = "@VICTORYQUOTE_SAFEGUARDING_THE_RIGHTS";
// 	victoryquotes[33] = "@VICTORYQUOTE_HE_CONQUERS_WHO_ENDURES";
// 	victoryquotes[34] = "@VICTORYQUOTE_IT_IS_BETTER_TO_DIE_ON";
// 	victoryquotes[35] = "@VICTORYQUOTE_YOU_KNOW_THE_REAL_MEANING";
// 	victoryquotes[36] = "@VICTORYQUOTE_IN_WAR_THERE_IS_NO_SUBSTITUTE";
// 	victoryquotes[37] = "@VICTORYQUOTE_WAR_IS_A_SERIES_OF_CATASTROPHES";
// 	victoryquotes[38] = "@VICTORYQUOTE_THOSE_WHO_HAVE_LONG_ENJOYED";
//                         
// 	i = randomInt(victoryquotes.size);
// 
// 	setdvar("ui_victoryquote", victoryquotes[i]);
}

setDeadQuote()
{
 //	level endon ("mine death");
 
// 	// kill any deadquotes already running
 //	level notify ("new_quote_string");
 //	level endon ("new_quote_string");
 
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
 		deadquotes[15] = "@DEADQUOTE_MAP_5";
 		deadquotes[16] = "@DEADQUOTE_MAP_6";
 		deadquotes[17] = "@DEADQUOTE_MOVEMENT_1";
 		deadquotes[18] = "@DEADQUOTE_MOVEMENT_2";
 		deadquotes[19] = "@DEADQUOTE_MOVEMENT_3";
 		deadquotes[20] = "@DEADQUOTE_MOVEMENT_4";
 		deadquotes[21] = "@DEADQUOTE_MOVEMENT_5";
 		deadquotes[22] = "@DEADQUOTE_MOVEMENT_6";
 		deadquotes[23] = "@DEADQUOTE_WEAPONS_1";
 		deadquotes[24] = "@DEADQUOTE_WEAPONS_2";
 		deadquotes[25] = "@DEADQUOTE_WEAPONS_3";
		//deadquotes[26] = "@DEADQUOTE_WEAPONS_4";	//need to re-order else a script error - jc
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
 		deadquotes[43] = "@DEADQUOTE_MOVEMENT_11";
 		deadquotes[44] = "@DEADQUOTE_MOVEMENT_9";
 		deadquotes[45] = "@DEADQUOTE_MOVEMENT_10";
 		//deadquotes[44] = "@DEADQUOTE_WE_MAKE_WAR_THAT_WE_MAY";
 		//deadquotes[45] = "@DEADQUOTE_THE_QUICKEST_WAY_OF_ENDING";
 		//deadquotes[46] = "@DEADQUOTE_THE_ONLY_WINNER_IN_THE";
 		//deadquotes[47] = "@DEADQUOTE_IF_YOU_ARE_GOING_THROUGH";
 		//deadquotes[48] = "@DEADQUOTE_IN_PEACE_AS_A_WISE_MAN";
 		//deadquotes[49] = "@DEADQUOTE_WAR_IS_CRUEL_AND_YOU";
 		//deadquotes[50] = "@DEADQUOTE_IN_WAR_THERE_ARE_NO_UNWOUNDED";
 		//deadquotes[51] = "@DEADQUOTE_THE_ESSENCE_OF_WAR_IS";
 		//deadquotes[52] = "@DEADQUOTE_SOLDIERS_USUALLY_WIN";
 		//deadquotes[53] = "@DEADQUOTE_I_DONT_KNOW_WHETHER_WAR";
 		//deadquotes[54] = "@DEADQUOTE_NO_ONE_CAN_GUARANTEE";
 		//deadquotes[55] = "@DEADQUOTE_THE_MILITARY_DONT_START";
 		//deadquotes[56] = "@DEADQUOTE_IF_YOU_KNOW_THE_ENEMY";
	
		
		level.player waittill("death");
		 	
		if(!level.missionfailed)
		{            
			i = randomInt(deadquotes.size);
 		 	setdvar("ui_deadquote", deadquotes[i]);
		}
}
