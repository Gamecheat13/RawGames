#include maps\_utility;
getDescriptionByName(name)
{
	if (level.script == "beltot")
	{
		switch (name)
		{
		case "orchard":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "village edge":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "mg42_nest":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "crossing":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "one down":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "village_center":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "surrender":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "get_truck":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "on_truck":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "broken wall":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		default:
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		}
		return saveDescription;
	}

	if (level.script == "bergstein")
	{
		switch (name)
		{
		case "intro_dialogue_done":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "first_house_clear":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;	
		case "second_house_clear":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "third_house_clear":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "fourth_house_clear":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;	
		case "before_mortars":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;	
		case "east_hp_clear":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;	
		case "before_house_encounter":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;	
		case "before_church":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;			
		default:
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		}
		return saveDescription;
	}

	if (level.script == "crossroads")
	{
		switch (name)
		{
		case "intro_dialogue_done":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "past_ambush_house":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "player_inside_CommOutpost":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "CommTank_destroyed":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "radios_destroyed":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "mg_three":
			saveDescription = &"AUTOSAVE_AUTOSAVE";	
			break;	
		case "before_halftrack":
			saveDescription = &"AUTOSAVE_AUTOSAVE";	
			break;
		case "crossroads_reached":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;	
		case "before_gateKick":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "farmhouse_secure":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "barn_secure":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "beforeTank":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;	
		case "couterAttack_over":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "barn_tank_destroyed":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;			
		default:
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		}
		return saveDescription;
	}

	if (level.script == "duhoc_defend")
	{
		switch (name)
		{
		case "roadblock":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "orchard":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "machine gun":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "farmarea":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "trench_able":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "trench charlie":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "trench easy":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "deploy smoke":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "pointe secure":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "halftime":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		default:
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		}
		return saveDescription;
	}
	
	if (level.script == "trainyard")
	{
		switch (name)
		{
		case "counter attack":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "maintenance":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "trench":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		default:
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		}
		return saveDescription;
	}
	
	if (level.script == "newvillers")
	{
		switch (name)
		{
		case "tigertank":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		default:
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		}
		return saveDescription;
	}
	
	if (level.script == "silotown_assault")
	{
		switch (name)
		{
		case "introdone":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "gogogo":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "reachedtown":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "fieldsecured":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "bigwallbldg":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "barn":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "northbldg":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "forkbldg":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "signbldg":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "westbldg":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "silo order received":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "locked in silo":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "townDefense1":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "townDefense2":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "townDefense3":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "townDefense4":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "infantrydefense":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;	
		case "german retreat":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;		
		case "debriefing":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;			
		default:
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		}
		return saveDescription;
	}

	if (level.script == "matmata")
	{
		switch (name)
		{
		case "mg nest":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;

		case "before smoke":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;

		case "after car":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;

		case "before courtyard":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;

		case "radio call":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
			
		case "smoke thrown":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		
		case "in alley":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		
		case "courtyard":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
				
		
		default:
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		}
		return saveDescription;
	}
	
	if (level.script == "rhine")
	{
		switch (name)
		{
		case "landing":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "flak_down":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "tank_down":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "crossroad":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "cemetery":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "square":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		default:
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		}
		return saveDescription;
	}

	if (level.script == "tankhunt")
	{
		switch (name)
		{
		case "cable_fixed":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "radio":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "stronghold":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "tankhunt":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "long_road":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "long_road_2":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "third_floor":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "dormitory":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		case "crossroad":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		default:
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		}
		return saveDescription;
	}

	if (level.script == "template")
	{
		switch (name)
		{
		case "your save name":
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		default:
			saveDescription = &"AUTOSAVE_AUTOSAVE";
			break;
		}
		return saveDescription;
	}

	return (&"AUTOSAVE_NOGAME");
}

getnames(num)
{
	if (num == 0)
		savedescription = &"AUTOSAVE_GAME";
	else
		savedescription = &"AUTOSAVE_NOGAME";
		
	return savedescription;
}

beginingOfLevelSave()
{
	if((level.script == "credits"))
		return;

	// Wait for introscreen to finish
	level waittill("finished final intro screen fadein");
	maps\_utility::levelStartSave();
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

	tryAutoSave (num, savedescription, imagename);
	thread maps\_quotes::setDeadQuote();
	
	trigger delete();
}

dead_autosave(trigger)
{
	trigger waittill ("trigger");

	include = undefined;

	if (isdefined (trigger.target))
		include = getentarray (trigger.target,"targetname");
	
	maps\_utility::living_ai_wait (trigger,"axis", include);

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

	tryAutoSave(num, savedescription, imagename);
	thread maps\_quotes::setDeadQuote();

	trigger delete();
}

autoSaveNameThink(trigger)
{
	if ((isdefined (trigger.targetname)) && (trigger.targetname == "dead_autosave"))
		return;

	trigger waittill ("trigger");
	if(isdefined(level.customautosavecheck))
		if(![[level.customautosavecheck]]())
			return;
	name = trigger.script_autosavename;
	maps\_utility::autoSaveByName (name);
	
	trigger delete();
}

tryAutoSave (filename, description, image)
{
	level.player endon ( "death" );

	if ( level.isSaving )
		return;
	else
		level.isSaving = true;
	
	while (1)
	{
		if (autoSaveCheck())
		{
			saveId = savegamenocommit (filename, description, image);
			/# println ("Saving game ", filename," with desc ", description); #/
			
			if ( saveId < 0 )
			{
				/# println ("SaveGame failed - save error.: ", filename," with desc ", description); #/
			    level.isSaving = false;
				return (false);				
			} 

			wait (1.5);
			
			if ( !isSaveRecentlyLoaded() )
			{
				if ( !autoSaveCheck() )
				{
					/# println ("autosave invalid: 3 second check failed"); #/
					continue;
				}
//				level.player playsound("game_save");
			    commitsave(saveId);
				thread spam_death_dvar_removal();
			}
			level.lastAutoSaveTime = gettime();
		    level.isSaving = false;
			return (true);
		}

		wait (0.25);
	}
}

autoSaveCheck()
{
	if(isdefined(level.special_autosavecondition) && ![[level.special_autosavecondition]]())
		return false;
	if (level.missionfailed)
		return (false);
	
	// health check	
	if (!autoSaveHealthCheck())
		return (false);
		
	// ammo check
	if (!autoSaveAmmoCheck())
		return (false);
		
	// ai/tank threat check
	if (!autoSaveThreatCheck())
		return (false);
	
	// player state check
	if (!autoSavePlayerCheck())
		return (false);
	
	// safe save check for level specific gameplay conditions
	if(isdefined(level.savehere) && !level.savehere)
		return (false);
	
	// safe save check for level specific gameplay conditions
	if(isdefined(level.canSave) && !level.canSave)
		return (false);

	// save was unsuccessful for internal reasons, such as lack of memory
	if(!issavesuccessful())
	{
		println("autosave failed:save call was unsuccessful");
		return (false);
	}
	
	return (true);
}

autoSavePlayerCheck()
{
	if (level.player ismeleeing())
	{
		println("autosave failed:player is meleeing");
		return (false);
	}

	if (level.player isthrowinggrenade())
	{
		println("autosave failed:player is throwing a grenade");
		return (false);
	}

	if (level.player isfiring())
	{
		println("autosave failed:player is firing");
		return (false);
	}

	if (isdefined(level.player.shellshocked) && level.player.shellshocked)
	{
		println("autosave failed:player is in shellshock");
		return (false);
	}

	return (true);
}

autoSaveAmmoCheck ()
{
	weapon = level.player getweaponslotweapon ("primary");	
	if (level.player getfractionmaxammo (weapon) > 0.1)
		return (true);

	weapon = level.player getweaponslotweapon ("primaryb");	
	if (level.player getfractionmaxammo (weapon) > 0.1)
		return (true);
		
	println ("autosave failed: ammo too low");
	return (false);
}

autoSaveHealthCheck()
{
	healthFraction = level.player.health / level.player.maxhealth;	
	if (healthFraction < 0.5)
	{
		/# println ("autosave failed: health too low"); #/
		return (false);
	}
	
	return (true);
}

autoSaveThreatCheck()
{
	enemies = getaiarray ("axis");
	for (i = 0; i < enemies.size; i++)
	{
		// getaiarray() should never return dead AI
//		if (!isalive (enemies[i]))
//			continue;
			
		if (!isdefined (enemies[i].enemy))
			continue;
			
		if (enemies[i].enemy != level.player)
			continue;
			
		// recently shot at the player
		if (enemies[i].lastShootTime > gettime() - 500)
		{
			/# println ("autosave failed: AI firing on player"); #/
			return (false);
		}
		
		if (enemies[i].anim_alertness == "aiming" && enemies[i] animscripts\utility::canShootEnemy())
		{
			/# println ("autosave failed: AI aiming at player"); #/
			return (false);
		}
			
		// is trying to melee the player
		if (isdefined (enemies[i].anim_personImMeleeing) && enemies[i].anim_personImMeleeing == level.player)
		{
			/# println ("autosave failed: AI meleeing player"); #/
			return (false);
		}
	}
	
	for (i = 0; i < level.tanks.size; i++)
	{
		if (!isdefined (level.tanks[i]))
			continue;
		
		if (level.tanks[i].script_team != "axis")
			continue;
			
		if (!isdefined (level.tanks[i].mgturret))
			continue;
		
		for (mgIndex=0;mgIndex<level.tanks[i].mgturret.size;mgIndex++)
		{
			if (isdefined (level.tanks[i].mgturret[mgIndex] getturrettarget()) && level.tanks[i].mgturret[mgIndex] getturrettarget() == level.player)
			{
				/# println ("autosave failed: tank MG targetting player"); #/
				return (false);
			}
		}
	}

	grenades = getentarray ("grenade", "classname");
	for (i = 0; i < grenades.size; i++)
	{
		if (distance (grenades[i].origin, level.player.origin) < 250) // grenade radius is 220
		{
			/# println ("autosave failed: live grenade too close to player"); #/
			return (false);
		}
	}
	
	return (true);
}

