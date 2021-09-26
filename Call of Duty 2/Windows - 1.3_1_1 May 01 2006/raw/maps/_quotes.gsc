setVictoryQuote()
{
	victoryquotes[0] = "@VICTORYQUOTE_WHEN_YOU_HAVE_TO_KILL";
	victoryquotes[1] = "@VICTORYQUOTE_BATTLES_ARE_WON_BY_SLAUGHTER";
	victoryquotes[2] = "@VICTORYQUOTE_HISTORY_WILL_BE_KIND";
	victoryquotes[3] = "@VICTORYQUOTE_NOTHING_IN_LIFE_IS_SO";
	victoryquotes[4] = "@VICTORYQUOTE_SUCCESS_IS_NOT_FINAL";
	victoryquotes[5] = "@VICTORYQUOTE_WE_SHALL_DEFEND_OUR_ISLAND";
	victoryquotes[6] = "@VICTORYQUOTE_WHEN_YOU_GET_TO_THE_END";
	victoryquotes[7] = "@VICTORYQUOTE_THE_REAL_AND_LASTING";
	victoryquotes[8] = "@VICTORYQUOTE_A_HERO_IS_NO_BRAVER_THAN";
	victoryquotes[9] = "@VICTORYQUOTE_OUR_GREATEST_GLORY_IS";
	victoryquotes[10]= "@VICTORYQUOTE_THE_CHARACTERISTIC_OF";
	victoryquotes[11] = "@VICTORYQUOTE_IF_THE_OPPOSITION_DISARMS";
	victoryquotes[12] = "@VICTORYQUOTE_THE_OBJECT_OF_WAR_IS";
	victoryquotes[13] = "@VICTORYQUOTE_BETTER_TO_FIGHT_FOR_SOMETHING";
	victoryquotes[14] = "@VICTORYQUOTE_COURAGE_IS_FEAR_HOLDING";
	victoryquotes[15] = "@VICTORYQUOTE_IF_A_MAN_DOES_HIS_BEST";
	victoryquotes[16] = "@VICTORYQUOTE_IT_IS_FOOLISH_AND_WRONG";
	victoryquotes[17] = "@VICTORYQUOTE_EVERY_MANS_LIFE_ENDS";
	victoryquotes[18] = "@VICTORYQUOTE_ALL_WARS_ARE_CIVIL_WARS";
	victoryquotes[19] = "@VICTORYQUOTE_I_HAVE_NEVER_ADVOCATED";
	victoryquotes[20] = "@VICTORYQUOTE_WE_HAPPY_FEW_WE_BAND";
	victoryquotes[21] = "@VICTORYQUOTE_COWARDS_DIE_MANY_TIMES";
	victoryquotes[22] = "@VICTORYQUOTE_NEVER_INTERRUPT_YOUR";
	victoryquotes[23] = "@VICTORYQUOTE_THERE_ARE_ONLY_TWO_FORCES";
	victoryquotes[24] = "@VICTORYQUOTE_THERE_WILL_ONE_DAY_SPRING";
	victoryquotes[25] = "@VICTORYQUOTE_THERE_ARE_NO_ATHEISTS";
	victoryquotes[26] = "@VICTORYQUOTE_IF_WE_DONT_END_WAR_WAR";
	victoryquotes[27] = "@VICTORYQUOTE_LIVE_AS_BRAVE_MEN_AND";
	victoryquotes[28] = "@VICTORYQUOTE_COURAGE_AND_PERSEVERANCE";
	victoryquotes[29] = "@VICTORYQUOTE_COURAGE_IS_BEING_SCARED";
	victoryquotes[30] = "@VICTORYQUOTE_ABOVE_ALL_THINGS_NEVER";
	victoryquotes[31] = "@VICTORYQUOTE_I_HAVE_NEVER_MADE_BUT";
	victoryquotes[32] = "@VICTORYQUOTE_SAFEGUARDING_THE_RIGHTS";
	victoryquotes[33] = "@VICTORYQUOTE_HE_CONQUERS_WHO_ENDURES";
	victoryquotes[34] = "@VICTORYQUOTE_IT_IS_BETTER_TO_DIE_ON";
	victoryquotes[35] = "@VICTORYQUOTE_YOU_KNOW_THE_REAL_MEANING";
	victoryquotes[36] = "@VICTORYQUOTE_IN_WAR_THERE_IS_NO_SUBSTITUTE";
	victoryquotes[37] = "@VICTORYQUOTE_WAR_IS_A_SERIES_OF_CATASTROPHES";
	victoryquotes[38] = "@VICTORYQUOTE_THOSE_WHO_HAVE_LONG_ENJOYED";
                        
	i = randomInt(victoryquotes.size);

	setCvar("ui_victoryquote", victoryquotes[i]);
}

setDeadQuote()
{
	level endon ("mine death");

	// kill any deadquotes already running
	level notify ("new_quote_string");
	level endon ("new_quote_string");
	level.player waittill("death");
	
	if(!level.missionfailed)
	{
		deadquotes[0] = "@DEADQUOTE_NEVER_IN_THE_FIELD_OF";
		deadquotes[1] = "@DEADQUOTE_SUCCESS_IS_NOT_FINAL";
		deadquotes[2] = "@DEADQUOTE_IN_WAR_THERE_IS_NO_PRIZE";
		deadquotes[3] = "@DEADQUOTE_THERE_NEVER_WAS_A_GOOD_WAR";
		deadquotes[4] = "@DEADQUOTE_IT_IS_FATAL_TO_ENTER";
		deadquotes[5] = "@DEADQUOTE_IN_WAR_YOU_WIN_OR_LOSE";
		deadquotes[6] = "@DEADQUOTE_UNTUTORED_COURAGE_IS";
		deadquotes[7] = "@DEADQUOTE_MAY_GOD_HAVE_MERCY_UPON";
		deadquotes[8] = "@DEADQUOTE_SO_LONG_AS_THERE_ARE";
		deadquotes[9] = "@DEADQUOTE_IN_MODERN_WAR_YOU_WILL";
		deadquotes[10]= "@DEADQUOTE_THEREFORE_WHOEVER_WISHES";
		deadquotes[11] = "@DEADQUOTE_THE_REAL_WAR_WILL_NEVER";
		deadquotes[12] = "@DEADQUOTE_THERES_NO_HONORABLE_WAY";
		deadquotes[13] = "@DEADQUOTE_THE_DEATH_OF_ONE_MAN";
		deadquotes[14] = "@DEADQUOTE_DEATH_SOLVES_ALL_PROBLEMS";
		deadquotes[15] = "@DEADQUOTE_IN_THE_SOVIET_ARMY_IT";
		deadquotes[16] = "@DEADQUOTE_THE_OBJECT_OF_WAR_IS";
		deadquotes[17] = "@DEADQUOTE_IT_IS_FOOLISH_AND_WRONG";
		deadquotes[18] = "@DEADQUOTE_NEVER_THINK_THAT_WAR";
		deadquotes[19] = "@DEADQUOTE_WAR_IS_FEAR_CLOAKED_IN";
		deadquotes[20] = "@DEADQUOTE_ALL_WARS_ARE_CIVIL_WARS";
		deadquotes[21] = "@DEADQUOTE_I_HAVE_NEVER_ADVOCATED";
		deadquotes[22] = "@DEADQUOTE_OLDER_MEN_DECLARE_WAR";
		deadquotes[23] = "@DEADQUOTE_ONLY_THE_DEAD_HAVE_SEEN";
		deadquotes[24] = "@DEADQUOTE_WAR_DOES_NOT_DETERMINE";
		deadquotes[25] = "@DEADQUOTE_DEATH_IS_NOTHING_BUT";
		deadquotes[26] = "@DEADQUOTE_PATRIOTS_ALWAYS_TALK";
		deadquotes[27] = "@DEADQUOTE_ALL_THAT_IS_NECESSARY";
		deadquotes[28] = "@DEADQUOTE_IT_IS_WELL_THAT_WAR_IS";
		deadquotes[29] = "@DEADQUOTE_A_SOLDIER_WILL_FIGHT";
		deadquotes[30] = "@DEADQUOTE_HE_WHO_FEARS_BEING_CONQUERED";
		deadquotes[31] = "@DEADQUOTE_YOU_MUST_NOT_FIGHT_TOO";
		deadquotes[32] = "@DEADQUOTE_THE_REAL_AND_LASTING";
		deadquotes[33] = "@DEADQUOTE_IF_WE_DONT_END_WAR_WAR";
		deadquotes[34] = "@DEADQUOTE_FROM_MY_ROTTING_BODY";
		deadquotes[35] = "@DEADQUOTE_HE_WHO_DID_WELL_IN_WAR";
		deadquotes[36] = "@DEADQUOTE_MORE_THAN_AN_END_TO_WAR";
		deadquotes[37] = "@DEADQUOTE_THERE_IS_NOTHING_SO_LIKELY";
		deadquotes[38] = "@DEADQUOTE_NEVER_YIELD_TO_FORCE";
		deadquotes[39] = "@DEADQUOTE_WAR_IS_DELIGHTFUL_TO";
		deadquotes[40] = "@DEADQUOTE_WAR_IS_AS_MUCH_A_PUNISHMENT";
		deadquotes[41] = "@DEADQUOTE_WAR_WOULD_END_IF_THE";
		deadquotes[42] = "@DEADQUOTE_YOU_CANT_SAY_CIV";
		deadquotes[43] = "@DEADQUOTE_IN_PEACE_THE_SONS_BURY";
		deadquotes[44] = "@DEADQUOTE_WE_MAKE_WAR_THAT_WE_MAY";
		deadquotes[45] = "@DEADQUOTE_THE_QUICKEST_WAY_OF_ENDING";
		deadquotes[46] = "@DEADQUOTE_THE_ONLY_WINNER_IN_THE";
		deadquotes[47] = "@DEADQUOTE_IF_YOU_ARE_GOING_THROUGH";
		deadquotes[48] = "@DEADQUOTE_IN_PEACE_AS_A_WISE_MAN";
		deadquotes[49] = "@DEADQUOTE_WAR_IS_CRUEL_AND_YOU";
		deadquotes[50] = "@DEADQUOTE_IN_WAR_THERE_ARE_NO_UNWOUNDED";
		deadquotes[51] = "@DEADQUOTE_THE_ESSENCE_OF_WAR_IS";
		deadquotes[52] = "@DEADQUOTE_SOLDIERS_USUALLY_WIN";
		deadquotes[53] = "@DEADQUOTE_I_DONT_KNOW_WHETHER_WAR";
		deadquotes[54] = "@DEADQUOTE_NO_ONE_CAN_GUARANTEE";
		deadquotes[55] = "@DEADQUOTE_THE_MILITARY_DONT_START";
		deadquotes[56] = "@DEADQUOTE_IF_YOU_KNOW_THE_ENEMY";
		
		//deadquotes[29] = "@DEADQUOTE_THE_VICTOR_WILL_NEVER";
		//deadquotes[30] = "@DEADQUOTE_IN_STARTING_AND_WAGING";
		//deadquotes[31] = "@DEADQUOTE_SUCCESS_IS_THE_SOLE_EARTHLY";
		//deadquotes[32] = "@DEADQUOTE_WHAT_LUCK_FOR_RULERS";
	                       
		i = randomInt(deadquotes.size);
	
		setCvar("ui_deadquote", deadquotes[i]);
	}
}
