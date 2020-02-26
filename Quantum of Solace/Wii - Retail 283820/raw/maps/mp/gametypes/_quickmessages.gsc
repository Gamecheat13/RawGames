init()
{
	game["menu_quickcommands"] = "quickcommands";
	game["menu_quickstatements"] = "quickstatements";
	game["menu_quickresponses"] = "quickresponses";

	precacheMenu(game["menu_quickcommands"]);
	precacheMenu(game["menu_quickstatements"]);
	precacheMenu(game["menu_quickresponses"]);
	precacheHeadIcon("talkingicon");
}

quickcommands(response)
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;

	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "marines":
			switch(response)		
			{
			case "1":
				soundalias = "US_mp_cmd_followme";
				saytext = &"QUICKMESSAGE_FOLLOW_ME";
				
				break;

			case "2":
				soundalias = "US_mp_cmd_movein";
				saytext = &"QUICKMESSAGE_MOVE_IN";
				
				break;

			case "3":
				soundalias = "US_mp_cmd_fallback";
				saytext = &"QUICKMESSAGE_FALL_BACK";
				
				break;

			case "4":
				soundalias = "US_mp_cmd_suppressfire";
				saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
				
				break;

			case "5":
				soundalias = "US_mp_cmd_attackleftflank";
				saytext = &"QUICKMESSAGE_ATTACK_LEFT_FLANK";
				
				break;

			case "6":
				soundalias = "US_mp_cmd_attackrightflank";
				saytext = &"QUICKMESSAGE_ATTACK_RIGHT_FLANK";
				
				break;

			case "7":
				soundalias = "US_mp_cmd_holdposition";
				saytext = &"QUICKMESSAGE_HOLD_THIS_POSITION";
				
				break;

			default:
				assert(response == "8");
				soundalias = "US_mp_cmd_regroup";
				saytext = &"QUICKMESSAGE_REGROUP";
				
				break;
			}
			break;

		default:
			assert(game["allies"] == "russian");
			switch(response)		
			{
			case "1":
				soundalias = "RU_mp_cmd_followme";
				saytext = &"QUICKMESSAGE_FOLLOW_ME";
				
				break;

			case "2":
				soundalias = "RU_mp_cmd_movein";
				saytext = &"QUICKMESSAGE_MOVE_IN";
				
				break;

			case "3":
				soundalias = "RU_mp_cmd_fallback";
				saytext = &"QUICKMESSAGE_FALL_BACK";
				
				break;

			case "4":
				soundalias = "RU_mp_cmd_suppressfire";
				saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
				
				break;

			case "5":
				soundalias = "RU_mp_cmd_attackleftflank";
				saytext = &"QUICKMESSAGE_ATTACK_LEFT_FLANK";
				
				break;

			case "6":
				soundalias = "RU_mp_cmd_attackrightflank";
				saytext = &"QUICKMESSAGE_ATTACK_RIGHT_FLANK";
				
				break;

			case "7":
				soundalias = "RU_mp_cmd_holdposition";
				saytext = &"QUICKMESSAGE_HOLD_THIS_POSITION";
				
				break;

			default:
				assert(response == "8");
				soundalias = "RU_mp_cmd_regroup";
				saytext = &"QUICKMESSAGE_REGROUP";
				
				break;
			}
			break;
		}
	}
	else
	{
		assert(self.pers["team"] == "axis");
		switch(game["axis"])
		{
		default:
			assert(game["axis"] == "opfor" || game["axis"] == "terrorists");
			switch(response)		
			{
			case "1":
				soundalias = "GE_mp_cmd_followme";
				saytext = &"QUICKMESSAGE_FOLLOW_ME";
				
				break;

			case "2":
				soundalias = "GE_mp_cmd_movein";
				saytext = &"QUICKMESSAGE_MOVE_IN";
				
				break;

			case "3":
				soundalias = "GE_mp_cmd_fallback";
				saytext = &"QUICKMESSAGE_FALL_BACK";
				
				break;

			case "4":
				soundalias = "GE_mp_cmd_suppressfire";
				saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
				
				break;

			case "5":
				soundalias = "GE_mp_cmd_attackleftflank";
				saytext = &"QUICKMESSAGE_ATTACK_LEFT_FLANK";
				
				break;

			case "6":
				soundalias = "GE_mp_cmd_attackrightflank";
				saytext = &"QUICKMESSAGE_ATTACK_RIGHT_FLANK";
				
				break;

			case "7":
				soundalias = "GE_mp_cmd_holdposition";
				saytext = &"QUICKMESSAGE_HOLD_THIS_POSITION";
				
				break;

			default:
				assert(response == "8");
				soundalias = "GE_mp_cmd_regroup";
				saytext = &"QUICKMESSAGE_REGROUP";
				
				break;
			}
			break;
		}			
	}

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();	
}

quickstatements(response)
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;
	
	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "marines":
			switch(response)		
			{
			case "1":
				soundalias = "US_mp_stm_enemyspotted";
				saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
				
				break;

			case "2":
				soundalias = "US_mp_stm_enemydown";
				saytext = &"QUICKMESSAGE_ENEMY_DOWN";
				
				break;

			case "3":
				soundalias = "US_mp_stm_iminposition";
				saytext = &"QUICKMESSAGE_IM_IN_POSITION";
				
				break;

			case "4":
				soundalias = "US_mp_stm_areasecure";
				saytext = &"QUICKMESSAGE_AREA_SECURE";
				
				break;

			case "5":
				soundalias = "US_mp_stm_grenade";
				saytext = &"QUICKMESSAGE_GRENADE";
				
				break;

			case "6":
				soundalias = "US_mp_stm_sniper";
				saytext = &"QUICKMESSAGE_SNIPER";
				
				break;

			case "7":
				soundalias = "US_mp_stm_needreinforcements";
				saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
				
				break;

			default:
				assert(response == "8");
				soundalias = "US_mp_stm_holdyourfire";
				saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
				
				break;
			}
			break;

		default:
			assert(game["allies"] == "russian");
			switch(response)		
			{
			case "1":
				soundalias = "RU_mp_stm_enemyspotted";
				saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
				
				break;

			case "2":
				soundalias = "RU_mp_stm_enemydown";
				saytext = &"QUICKMESSAGE_ENEMY_DOWN";
				
				break;

			case "3":
				soundalias = "RU_mp_stm_iminposition";
				saytext = &"QUICKMESSAGE_IM_IN_POSITION";
				
				break;

			case "4":
				soundalias = "RU_mp_stm_areasecure";
				saytext = &"QUICKMESSAGE_AREA_SECURE";
				
				break;

			case "5":
				soundalias = "RU_mp_stm_grenade";
				saytext = &"QUICKMESSAGE_GRENADE";
				
				break;

			case "6":
				soundalias = "RU_mp_stm_sniper";
				saytext = &"QUICKMESSAGE_SNIPER";
				
				break;

			case "7":
				soundalias = "RU_mp_stm_needreinforcements";
				saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
				
				break;

			default:
				assert(response == "8");
				soundalias = "RU_mp_stm_holdyourfire";
				saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
				
				break;
			}
			break;
		}
	}
	else
	{
		assert(self.pers["team"] == "axis");
		switch(game["axis"])
		{
		default:
			assert(game["axis"] == "opfor" || game["axis"] == "terrorists");
			switch(response)		
			{
			case "1":
				soundalias = "GE_mp_stm_enemyspotted";
				saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
				
				break;

			case "2":
				soundalias = "GE_mp_stm_enemydown";
				saytext = &"QUICKMESSAGE_ENEMY_DOWN";
				
				break;

			case "3":
				soundalias = "GE_mp_stm_iminposition";
				saytext = &"QUICKMESSAGE_IM_IN_POSITION";
				
				break;

			case "4":
				soundalias = "GE_mp_stm_areasecure";
				saytext = &"QUICKMESSAGE_AREA_SECURE";
				
				break;

			case "5":
				soundalias = "GE_mp_stm_grenade";
				saytext = &"QUICKMESSAGE_GRENADE";
				
				break;

			case "6":
				soundalias = "GE_mp_stm_sniper";
				saytext = &"QUICKMESSAGE_SNIPER";
				
				break;

			case "7":
				soundalias = "GE_mp_stm_needreinforcements";
				saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
				
				break;

			default:
				assert(response == "8");
				soundalias = "GE_mp_stm_holdyourfire";
				saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
				
				break;
			}
			break;
		}			
	}

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}

quickresponses(response)
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;

	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "marines":
			switch(response)		
			{
			case "1":
				soundalias = "US_mp_rsp_yessir";
				saytext = &"QUICKMESSAGE_YES_SIR";
				
				break;

			case "2":
				soundalias = "US_mp_rsp_nosir";
				saytext = &"QUICKMESSAGE_NO_SIR";
				
				break;

			case "3":
				soundalias = "US_mp_rsp_onmyway";
				saytext = &"QUICKMESSAGE_IM_ON_MY_WAY";
				
				break;

			case "4":
				soundalias = "US_mp_rsp_sorry";
				saytext = &"QUICKMESSAGE_SORRY";
				
				break;

			case "5":
				soundalias = "US_mp_rsp_greatshot";
				saytext = &"QUICKMESSAGE_GREAT_SHOT";
				
				break;

			case "6":
				soundalias = "US_mp_rsp_tooklongenough";
				saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
				
				break;

			default:
				assert(response == "7");
				soundalias = "US_mp_rsp_areyoucrazy";
				saytext = &"QUICKMESSAGE_ARE_YOU_CRAZY";
				
				break;
			}
			break;

		default:
			assert(game["allies"] == "russian");
			switch(response)		
			{
			case "1":
				soundalias = "RU_mp_rsp_yessir";
				saytext = &"QUICKMESSAGE_YES_SIR";
				
				break;

			case "2":
				soundalias = "RU_mp_rsp_nosir";
				saytext = &"QUICKMESSAGE_NO_SIR";
				
				break;

			case "3":
				soundalias = "RU_mp_rsp_onmyway";
				saytext = &"QUICKMESSAGE_IM_ON_MY_WAY";
				
				break;

			case "4":
				soundalias = "RU_mp_rsp_sorry";
				saytext = &"QUICKMESSAGE_SORRY";
				
				break;

			case "5":
				soundalias = "RU_mp_rsp_greatshot";
				saytext = &"QUICKMESSAGE_GREAT_SHOT";
				
				break;

			case "6":
				soundalias = "RU_mp_rsp_tooklongenough";
				saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
				
				break;

			default:
				assert(response == "7");
				soundalias = "RU_mp_rsp_areyoucrazy";
				saytext = &"QUICKMESSAGE_ARE_YOU_CRAZY";
				
				break;
			}
			break;
		}
	}
	else
	{
		assert(self.pers["team"] == "axis");
		switch(game["axis"])
		{
		default:
			assert(game["axis"] == "opfor" || game["axis"] == "terrorists");
			switch(response)		
			{
			case "1":
				soundalias = "GE_mp_rsp_yessir";
				saytext = &"QUICKMESSAGE_YES_SIR";
				
				break;

			case "2":
				soundalias = "GE_mp_rsp_nosir";
				saytext = &"QUICKMESSAGE_NO_SIR";
				
				break;

			case "3":
				soundalias = "GE_mp_rsp_onmyway";
				saytext = &"QUICKMESSAGE_IM_ON_MY_WAY";
				
				break;

			case "4":
				soundalias = "GE_mp_rsp_sorry";
				saytext = &"QUICKMESSAGE_SORRY";
				
				break;

			case "5":
				soundalias = "GE_mp_rsp_greatshot";
				saytext = &"QUICKMESSAGE_GREAT_SHOT";
				
				break;

			case "6":
				soundalias = "GE_mp_rsp_tooklongenough";
				saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
				
				break;

			default:
				assert(response == "7");
				soundalias = "GE_mp_rsp_areyoucrazy";
				saytext = &"QUICKMESSAGE_ARE_YOU_CRAZY";
				
				break;
			}
			break;
		}			
	}

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}

doQuickMessage(soundalias, saytext)
{
	if(self.sessionstate != "playing")
		return;

	if(isdefined(level.QuickMessageToAll) && level.QuickMessageToAll)
	{
		self.headiconteam = "none";
		self.headicon = "talkingicon";

		self playSound(soundalias);
		self sayAll(saytext);
	}
	else
	{
		if(self.sessionteam == "allies")
			self.headiconteam = "allies";
		else if(self.sessionteam == "axis")
			self.headiconteam = "axis";
		
		self.headicon = "talkingicon";

		self playSound(soundalias);
		self sayTeam(saytext);
		self pingPlayer();
	}
}

saveHeadIcon()
{
	if(isdefined(self.headicon))
		self.oldheadicon = self.headicon;

	if(isdefined(self.headiconteam))
		self.oldheadiconteam = self.headiconteam;
}

restoreHeadIcon()
{
	if(isdefined(self.oldheadicon))
		self.headicon = self.oldheadicon;

	if(isdefined(self.oldheadiconteam))
		self.headiconteam = self.oldheadiconteam;
}