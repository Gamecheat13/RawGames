getnames(num)
{
	if (level.script == "training")
	{

		savedescription = &"AUTOSAVE_TRAININGWEAP";
		if (num == 2)
			savedescription = &"AUTOSAVE_TRAINING";

		return savedescription;
	}

	if (level.script == "pathfinder")
	{
		return &"AUTOSAVE_PATHFINDER";
	}

	if ((level.script == "burnville") || (level.script == "burnville_nolight"))
	{

		savedescription = &"AUTOSAVE_BURNVILLE";
		if (num == 1)
			savedescription = &"AUTOSAVE_BURNVILLE1";
		if (num == 2)
			savedescription = &"AUTOSAVE_BURNVILLE2";
		if (num == 3)
			savedescription = &"AUTOSAVE_BURNVILLE3";
		if (num == 4)
			savedescription = &"AUTOSAVE_BURNVILLE4";
		if (num == 5)
			savedescription = &"AUTOSAVE_BURNVILLE5";
		if (num == 6)
			savedescription = &"AUTOSAVE_BURNVILLE6";

		return savedescription;
	}

	if (level.script == "truckride")
	{

		savedescription = &"AUTOSAVE_TRUCKRIDE";
		if (num == 1)
			savedescription = &"AUTOSAVE_TRUCKRIDE1";
		if (num == 2)
			savedescription = &"AUTOSAVE_TRUCKRIDE2";

		return savedescription;
	}

	if (level.script == "airfield")
	{

		savedescription = &"AUTOSAVE_AIRFIELD";
		if (num == 1)
			savedescription = &"AUTOSAVE_AIRFIELD1";

		return savedescription;
	}
	if (level.script == "dawnville")
	{
		savedescription = &"AUTOSAVE_DAWNVILLE";
		if (num == 1)
			savedescription = &"AUTOSAVE_DAWNVILLE1";
		if (num == 2)
			savedescription = &"AUTOSAVE_DAWNVILLE2";
		if (num == 3)
			savedescription = &"AUTOSAVE_DAWNVILLE3";
		if (num == 4)
			savedescription = &"AUTOSAVE_DAWNVILLE4";
		if (num == 5)
			savedescription = &"AUTOSAVE_DAWNVILLE5";
		if (num == 6)
			savedescription = &"AUTOSAVE_DAWNVILLE6";
		if (num == 7)
			savedescription = &"AUTOSAVE_DAWNVILLE7";
		if (num == 8)
			savedescription = &"AUTOSAVE_DAWNVILLE8";
		return savedescription;
	}

	if ((level.script == "carride"))
	{
		savedescription = &"AUTOSAVE_CARRIDE";
		if (num == 2)
			savedescription = &"AUTOSAVE_CARRIDE1";
		if (num == 3)
			savedescription = &"AUTOSAVE_CARRIDE2";
		if (num == 4)
			savedescription = &"AUTOSAVE_CARRIDE3";
		return savedescription;
	}

	if ((level.script == "brecourt"))
	{
		savedescription = &"AUTOSAVE_BRECOURT";
		if (num == 2)
			savedescription = &"AUTOSAVE_BRECOURT1";
		if (num == 3)
			savedescription = &"AUTOSAVE_BRECOURT2";
		if (num == 4)
			savedescription = &"AUTOSAVE_BRECOURT3";
		if (num == 5)
			savedescription = &"AUTOSAVE_BRECOURT4";
		if (num == 6)
			savedescription = &"AUTOSAVE_BRECOURT5";
		if (num == 7)
			savedescription = &"AUTOSAVE_BRECOURT6";
		if (num == 8)
			savedescription = &"AUTOSAVE_BRECOURT7";
		if (num == 9)
			savedescription = &"AUTOSAVE_BRECOURT8";
		return savedescription;
	}

	if (level.script == "chateau")
	{
		savedescription = &"CHATEAU_SAVE_GATES";
		if (num == 2)
			savedescription = &"CHATEAU_SAVE_INSIDE";
		if (num == 3)
			savedescription = &"CHATEAU_SAVE_KICKDOOR";
		if (num == 4)
			savedescription = &"CHATEAU_SAVE_OUTSIDEAGAIN";
		if (num == 5)
			savedescription = &"CHATEAU_SAVE_COM";
		if (num == 6)
			savedescription = &"CHATEAU_SAVE_BOMB";
		if (num == 7)
			savedescription = &"CHATEAU_SAVE_PRICE";
		return savedescription;
	}

	if (level.script == "powoutskirts")
	{
		if (num == 1)
		{
			savedescription = &"AUTOSAVE_POWOUTSKIRTS";
			return savedescription;
		}
	}
	
		if (level.script == "powcamp")
	{

		savedescription = &"AUTOSAVE_POWCAMP";
		if (num == 2)
			savedescription = &"AUTOSAVE_POWCAMP1";
		if (num == 3)
			savedescription = &"AUTOSAVE_POWCAMP2";
		if (num == 4)
			savedescription = &"AUTOSAVE_POWCAMP3";
		if (num == 5)
			savedescription = &"AUTOSAVE_POWCAMP4";
		if (num == 6)
			savedescription = &"AUTOSAVE_POWCAMP5";
		if (num == 7)
			savedescription = &"AUTOSAVE_POWCAMP6";
		if (num == 8)
			savedescription = &"AUTOSAVE_POWCAMP7";

		return savedescription;
	}

	if (level.script == "sewer")
	{

		savedescription = &"AUTOSAVE_SEWER";
		if (num == 2)
			savedescription = &"AUTOSAVE_SEWER1";
		if (num == 3)
			savedescription = &"AUTOSAVE_SEWER2";
		if (num == 4)
			savedescription = &"AUTOSAVE_SEWER3";
		if (num == 5)
			savedescription = &"AUTOSAVE_SEWER4";
		if (num == 6)
			savedescription = &"AUTOSAVE_SEWER5";
		
		return savedescription;
	}

	if (level.script == "trainstation")
	{

		savedescription = &"AUTOSAVE_TRAINSTATION";
		if (num == 2)
			savedescription = &"AUTOSAVE_TRAINSTATION1";
		if (num == 3)
			savedescription = &"AUTOSAVE_TRAINSTATION2";
		if (num == 4)
			savedescription = &"AUTOSAVE_TRAINSTATION3";
			
		return savedescription;
	}
	
		if (level.script == "hurtgen")
	{

		savedescription = &"AUTOSAVE_HURTGEN";
		if (num == 2)
			savedescription = &"AUTOSAVE_HURTGEN1";
		if (num == 3)
			savedescription = &"AUTOSAVE_HURTGEN2";
			
		return savedescription;
	}

	if ((level.script == "pegasusnight"))
	{
		if (num == 1)
		{
			savedescription = &"AUTOSAVE_PNIGHT";
			return savedescription;
		}
		if (num == 2)
		{
			savedescription = &"AUTOSAVE_PNIGHT1";
			return savedescription;
		}
		if (num == 3)
		{
			savedescription = &"AUTOSAVE_PNIGHT2";
			return savedescription;
		}
	}

	if ((level.script == "pegasusday"))
	{
		if (num == 1)
		{
			savedescription = &"AUTOSAVE_PDAY";
			return savedescription;
		}
		if (num == 2)
		{
			savedescription = &"AUTOSAVE_PDAY2";
			return savedescription;
		}
		if (num == 3)
		{
			savedescription = &"AUTOSAVE_PDAY3";
			return savedescription;
		}
		if (num == 4)
		{
			savedescription = &"AUTOSAVE_PDAY4";
			return savedescription;
		}
		if (num == 5)
		{
			savedescription = &"AUTOSAVE_PDAY5";
			return savedescription;
		}
	}

	if (level.script == "dam")
	{
		if (num == 1)
		{
			savedescription = &"AUTOSAVE_DAM";
			return savedescription;
		}
		if (num == 2)
		{
			savedescription = &"AUTOSAVE_DAM2";
			return savedescription;
		}
		if (num == 3)
		{
			savedescription = &"AUTOSAVE_DAM3";
			return savedescription;
		}
		if (num == 4)
		{
			savedescription = &"AUTOSAVE_DAM4";
			return savedescription;
		}
		if (num == 5)
		{
			savedescription = &"AUTOSAVE_DAM5";
			return savedescription;
		}
		if (num == 6)
		{
			savedescription = &"AUTOSAVE_DAM6";
			return savedescription;
		}
		if (num == 7)
		{
			savedescription = &"AUTOSAVE_DAM7";
			return savedescription;
		}
		if (num == 8)
		{
			savedescription = &"AUTOSAVE_DAM8";
			return savedescription;
		}
		if (num == 9)
		{
			savedescription = &"AUTOSAVE_DAM9";
			return savedescription;
		}
		if (num == 10)
		{
			savedescription = &"AUTOSAVE_DAM10";
			return savedescription;
		}
	}

	if ((level.script == "ship"))
	{
		savedescription = "Battleship Tirpitz";
		if (num == 1)
			savedescription = &"AUTOSAVE_SHIP";
		if (num == 2)
			savedescription = &"AUTOSAVE_SHIP1";
		if (num == 3)
			savedescription = &"AUTOSAVE_SHIP2";
		if (num == 4)
			savedescription = &"AUTOSAVE_SHIP3";
		return savedescription;
	}

	if ((level.script == "Stalingrad") || (level.script == "Stalingrad_nolight"))
	{
		savedescription = &"AUTOSAVE_STALINGRAD";

		return savedescription;
	}

	if ((level.script == "redsquare"))
	{
		if (num == 1)
		{
			savedescription = &"AUTOSAVE_REDS";
			return savedescription;
		}
		if (num == 2)
		{
			savedescription = &"AUTOSAVE_REDS1";
			return savedescription;
		}
		if (num == 3)
		{
			savedescription = &"AUTOSAVE_REDS2";
			return savedescription;
		}
		if (num == 4)
		{
			savedescription = &"AUTOSAVE_REDS3";
			return savedescription;
		}
	}

	if ((level.script == "pavlov"))
	{
		if (num == 1)
		{
			savedescription = &"AUTOSAVE_PAVLOV";
			return savedescription;
		}
		if (num == 2)
		{
			savedescription = &"AUTOSAVE_PAVLOV1";
			return savedescription;
		}
		if (num == 3)
		{
			savedescription = &"AUTOSAVE_PAVLOV2";
			return savedescription;
		}
		if (num == 4)
		{
			savedescription = &"AUTOSAVE_PAVLOV3";
			return savedescription;
		}
	}

	if (level.script == "factory")
	{
		if (num == 1)
		{
			savedescription = &"AUTOSAVE_FACTORY";
			return savedescription;
		}
		if (num == 2)
		{
			savedescription = &"AUTOSAVE_FACTORY1";
			return savedescription;
		}
		if (num == 3)
		{
			savedescription = &"AUTOSAVE_FACTORY2";
			return savedescription;
		}
	}

	if (level.script == "railyard")
	{
		if (num == 1)
		{
			savedescription = &"AUTOSAVE_RAIL";
			return savedescription;
		}
		if (num == 2)
		{
			savedescription = &"AUTOSAVE_RAIL1";
			return savedescription;
		}
	}

	if ((level.script == "tankdrivecountry"))
	{
		savedescription = &"AUTOSAVE_TCOUNTRY";
		if (num == 1)
			savedescription = &"AUTOSAVE_TCOUNTRY1";
		if (num == 2)
			savedescription = &"AUTOSAVE_TCOUNTRY2";
		return savedescription;
	}

	if ((level.script == "tankdrivetown"))
	{
		savedescription = &"AUTOSAVE_TTOWN";
		if (num == 1)
			savedescription = &"AUTOSAVE_TTOWN1";
		if (num == 2)
			savedescription = &"AUTOSAVE_TTOWN2";
		return savedescription;
	}

	if ((level.script == "rocket"))
	{

		savedescription = &"AUTOSAVE_ROCKET";
		if (num == 2)
			savedescription = &"AUTOSAVE_ROCKET1";
		if (num == 3)
			savedescription = &"AUTOSAVE_ROCKET2";
		if (num == 4)
			savedescription = &"AUTOSAVE_ROCKET3";
		if (num == 5)
			savedescription = &"AUTOSAVE_ROCKET4";
		return savedescription;
	}

	if ((level.script == "berlin"))
	{
		savedescription = &"AUTOSAVE_BERLIN";
		if (num == 2)
			savedescription = &"AUTOSAVE_BERLIN1";
		if (num == 3)
			savedescription = &"AUTOSAVE_BERLIN2";
		if (num == 4)
			savedescription = &"AUTOSAVE_BERLIN3";
		return savedescription;
	}

	if (num == 0)
		savedescription = &"AUTOSAVE_GAME";
	else
		savedescription = &"AUTOSAVE_NOGAME";
	return savedescription;
}

autosaves_think(trigger)
{
	if ((isdefined (trigger.targetname)) && (trigger.targetname == "dead_autosave"))
		return;

	savedescription = getnames(trigger.script_autosave);

	if ( !(isdefined (savedescription) ) )
	{
		println ("autosave", self.script_autosave," with no save description in _autosave.gsc!");
		return;
	}

	trigger waittill ("trigger");

	num = trigger.script_autosave;

	imagename = "levelshots/autosave/autosave_" + level.script + num;
	println ("z:         imagename: ", imagename);

	trigger healthchecksave(num, savedescription, imagename);
	
	//println ("Saving game ", num," with desc ", savedescription);
	trigger delete();
}

dead_autosave(trigger)
{
	trigger waittill ("trigger");
	if (isdefined (trigger.target))
	{
		include = getentarray (trigger.target,"targetname");
		maps\_utility::living_ai_wait (trigger,"axis", include);
	}
	else
		maps\_utility::living_ai_wait (trigger,"axis");

	wait (1);

	if (isdefined (trigger.script_autosave))
		savedescription = getnames(trigger.script_autosave);
	else
	{
		savedescription = &"AUTOSAVE_AUTOSAVE";
		trigger.script_autosave = 1;
	}


	num = trigger.script_autosave;

	imagename = "levelshots/autosave/autosave_" + level.script + num;
	println ("z:         imagename: ", imagename);

	healthchecksave(num, savedescription, imagename);
	//println ("Saving game ", num," with desc ", savedescription);

	trigger delete();
}

beginingOfLevelSave()
{
//	if ((level.script == "training"))
//		return;

	// Wait for introscreen to finish fading out
	level waittill ("finished intro screen");
	maps\_utility::levelStartSave();
}

healthchecksave(num, savedescription, imagename)
{
	if (level.script == "powcamp")
	{
		currenttime = gettime() - level.starttime;
		savetime = 600000 - (self.script_parachutegroup);
		if(currenttime > savetime)
			return;
			
	}
	
	healthfraction = .4;
	
	x = (float) level.player.health;
	y = (float) level.player.maxhealth;
	
	
	playerhealthfraction = x/y;
	println ("z:    level.player.health: ", x);
	println ("z:    level.player.maxhealth: ", y);
	println ("z:    playerhealthfraction: ", playerhealthfraction);
	
	if(playerhealthfraction > healthfraction)
	{
		saveGame(num, savedescription, imagename);
		println ("Saving game ", num," with desc ", savedescription);
	}
	else
		println ("NOT Saving game, health below healthfraction (",healthfraction,")");

}
