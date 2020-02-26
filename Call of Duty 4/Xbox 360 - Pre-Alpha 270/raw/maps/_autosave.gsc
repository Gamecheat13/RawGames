#include maps\_utility;

main()
{
	level.lastAutoSaveTime = 0;
	level.isSaving = false;
}

getDescriptionByName( name )
{
	switch ( level.script )
	{
	case "template":
		return ( &"AUTOSAVE_AUTOSAVE" );

	default:
		return ( &"AUTOSAVE_AUTOSAVE" );
	}
}

getnames(num)
{
	if (num == 0)
		savedescription = &"AUTOSAVE_GAME";
	else
		savedescription = &"AUTOSAVE_NOGAME";
		
	return savedescription;
}


beginningOfLevelSave()
{
	// Wait for introscreen to finish
	level waittill("finished final intro screen fadein");

	if ( level.missionfailed )
		return;
		
	if ( level.isSaving )
		return;
		
	level.isSaving = true;
		
	imagename = "levelshots/autosave/autosave_" + level.script + "start";

	// "levelstart" is recognized by the saveGame command as a special save game
	saveGame("levelstart", &"AUTOSAVE_LEVELSTART", imagename);
	setDvar("ui_grenade_death","0");
	println ("Saving level start saved game");
	
	level.isSaving = false;
}


trigger_autosave( trigger )
{
	if ( !isdefined( trigger.script_autosave ) )
		trigger.script_autosave = 0;
		
	autosaves_think( trigger );
}

autosaves_think( trigger )
{
	savedescription = getnames(trigger.script_autosave);

	if ( !( isdefined( savedescription ) ) )
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


autoSaveNameThink(trigger)
{
	trigger waittill ("trigger");
	if(isdefined(level.customautosavecheck))
		if(![[level.customautosavecheck]]())
			return;
	name = trigger.script_autosavename;
	maps\_utility::autosave_by_name (name);
	
	trigger delete();
}


trigger_autosave_immediate( trigger )
{
	trigger waittill( "trigger" );
//	saveId = saveGameNoCommit( 1, &"AUTOSAVE_LEVELSTART", "autosave_image" );
//	commitSave( saveId );
}

tryAutoSave( filename, description, image )
{
	level.player endon ( "death" );

	if ( level.isSaving )
		return;
	else
		level.isSaving = true;
	
	descriptionString = getDescriptionByName( description );
	
	while (1)
	{
		if ( autoSaveCheck() )
		{
			saveId = saveGameNoCommit( filename, descriptionString, image );
			/# printLn( "Saving game ", filename," with desc ", descriptionString ); #/
			
			if ( saveId < 0 )
			{
				/# printLn( "Savegame failed - save error.: ", filename," with desc ", descriptionString ); #/
			    level.isSaving = false;
				return false;
			} 

			wait 1.5;
			
			if ( !isSaveRecentlyLoaded() )
			{
				if ( !autoSaveCheck() )
				{
					/# printLn( "autosave invalid: 3 second check failed" ); #/
					continue;
				}
			    commitSave( saveId );
				setDvar("ui_grenade_death","0");
			}
			level.lastAutoSaveTime = getTime();
		    level.isSaving = false;
			return true;
		}

		wait 0.25;
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
	// temp fix to get ac130 to autosave again.
	// it wasn't saving because the player always has low ammo but is constantly given ammo in script
	if ( level.script == "ac130" )
		return (true);
	
    weapons = level.player GetWeaponsListPrimaries();

    for( idx = 0; idx < weapons.size; idx++ )
    {
	    fraction = level.player GetFractionMaxAmmo( weapons[idx] );
	    if ( fraction > 0.1 )
		    return (true);
    }
    
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
		if (!isdefined (enemies[i].enemy))
			continue;
			
		if (enemies[i].enemy != level.player)
			continue;

		if (enemies[i].type == "dog")
		{
			if ( distance( enemies[i].origin, level.player.origin ) < 384 )
				return (false);

			continue;
		}
			
		// recently shot at the player
		if (enemies[i].a.lastShootTime > gettime() - 500)
		{
			/# println ("autosave failed: AI firing on player"); #/
			return (false);
		}
		
		if (enemies[i].a.alertness == "aiming" && enemies[i] animscripts\utility::canShootEnemy())
		{
			/# println ("autosave failed: AI aiming at player"); #/
			return (false);
		}
			
		// is trying to melee the player
		if (isdefined (enemies[i].a.personImMeleeing) && enemies[i].a.personImMeleeing == level.player)
		{
			/# println ("autosave failed: AI meleeing player"); #/
			return (false);
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

