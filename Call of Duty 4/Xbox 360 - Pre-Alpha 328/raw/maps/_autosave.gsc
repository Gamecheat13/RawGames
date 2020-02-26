#include maps\_utility;
#include common_scripts\utility;

main()
{
	level.lastAutoSaveTime = 0;
	flag_init( "game_saving" );
	flag_init( "can_save" );
	flag_set( "can_save" );
}

getDescription()
{
	return( &"AUTOSAVE_AUTOSAVE" );
}

getnames( num )
{
	if ( num == 0 )
		savedescription = &"AUTOSAVE_GAME";
	else
		savedescription = &"AUTOSAVE_NOGAME";
		
	return savedescription;
}


beginningOfLevelSave()
{
	// Wait for introscreen to finish
	level waittill( "finished final intro screen fadein" );

	if ( level.missionfailed )
		return;
		
	if ( flag( "game_saving" ) )
		return;
		
	flag_set( "game_saving" );
		
	imagename = "levelshots / autosave / autosave_" + level.script + "start";

	// "levelstart" is recognized by the saveGame command as a special save game
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", imagename );
	setDvar( "ui_grenade_death", "0" );
	println( "Saving level start saved game" );
	
	flag_clear( "game_saving" );
}


trigger_autosave( trigger )
{
	if ( !isdefined( trigger.script_autosave ) )
		trigger.script_autosave = 0;
		
	autosaves_think( trigger );
}

autosaves_think( trigger )
{
	savedescription = getnames( trigger.script_autosave );

	if ( !( isdefined( savedescription ) ) )
	{
		println( "autosave", self.script_autosave, " with no save description in _autosave.gsc!" );
		return;
	}

	trigger waittill( "trigger" );
	
	num = trigger.script_autosave;
	imagename = "levelshots / autosave / autosave_" + level.script + num;

	tryAutoSave( num, savedescription, imagename );
	thread maps\_quotes::setDeadQuote();
	
	trigger delete();
}


autoSaveNameThink( trigger )
{
	trigger waittill( "trigger" );
	if ( isdefined( level.customautosavecheck ) )
		if ( ![[ level.customautosavecheck ]]() )
			return;
	name = trigger.script_autosavename;
	maps\_utility::autosave_by_name( name );
	
	trigger delete();
}


trigger_autosave_immediate( trigger )
{
	trigger waittill( "trigger" );
// 	saveId = saveGameNoCommit( 1, &"AUTOSAVE_LEVELSTART", "autosave_image" );
//	level.not_recently_loaded = true;
// 	commitSave( saveId );
}

AutoSavePrint( msg, msg2 )
{
	 /#
	if ( getdvar( "scr_autosave_debug" ) == "" )
		setdvar( "scr_autosave_debug", "0" );
	if ( getdebugdvarint( "scr_autosave_debug" ) == 1 )
	{
		if ( isdefined( msg2 ) )
			iprintln( msg + " [ localized description ]" );
		else
			iprintln( msg );
		return;
	}
	#/ 
	
	if ( isdefined( msg2 ) )
		println( msg, msg2 );
	else
		println( msg );
}

autosave_timeout( timeout )
{
	level endon( "trying_new_autosave" );
	level endon( "autosave_complete" );
	wait( timeout );
	flag_clear( "game_saving" );
	level notify( "autosave_timeout" );
}

_autosave_game_now()
{
	if ( flag( "game_saving" ) )
		return false;


	filename = "save_now";
	descriptionString = getDescription();
	saveId = saveGameNoCommit( filename, descriptionString );
	
	 /# AutoSavePrint( "Saving game " + filename + " with desc ", descriptionString ); #/ 
	
	if ( saveId < 0 )
	{
		 /# AutoSavePrint( "Savegame failed - save error.: " + filename + " with desc ", descriptionString ); #/ 
		return;
	} 

	
	if ( !try_to_autosave_now() )
	{
		return;
	}
	
	flag_set( "game_saving" );
	wait 2;

	// are we still healthy 2 seconds later? k save then
	if ( try_to_autosave_now() )
	{
		level.not_recently_loaded = true;
		commitSave( saveId );
		setDvar( "ui_grenade_death", "0" );
	}

	flag_clear( "game_saving" );
}

autosave_now_trigger( trigger )
{
	trigger waittill( "trigger" );
	autosave_now();
}

try_to_autosave_now()
{
	if ( !issavesuccessful() )
		return false;

	if ( flag( "player_has_red_flashing_overlay" ) )
		return false;
	
	if ( isSaveRecentlyLoaded() )
	{
		level.lastAutoSaveTime = getTime();
		return false;
	}
	
	if ( !flag( "can_save" ) )
	{
		 /# AutoSavePrint( "Can_save flag was clear" ); #/ 
		return false;
	}

	return true;		
}

tryAutoSave( filename, description, image, timeout )
{
	level.player endon( "death" );
	level notify( "trying_new_autosave" );

	if ( flag( "game_saving" ) )
		return false;

	time1 = 1.25;
	time2 = 1.25;

	if ( isdefined( timeout ) && timeout < time1 + time2 )
	{
		assertmsg( "Warning, tried to do an autosave_or_timeout with a time less than " + ( time1 + time2 ) );
	}
	
	flag_set( "game_saving" );
	
	descriptionString = getDescription();
	start_save_time = gettime();
	
	while ( 1 )
	{
		if ( autoSaveCheck() )
		{
			saveId = saveGameNoCommit( filename, descriptionString, image );
			 /# AutoSavePrint( "Saving game " + filename + " with desc ", descriptionString ); #/ 
			
			if ( saveId < 0 )
			{
				 /# AutoSavePrint( "Savegame failed - save error.: " + filename + " with desc ", descriptionString ); #/ 
				break;
			} 
			
			wait time1;
			
			if ( isSaveRecentlyLoaded() )
			{
				level.lastAutoSaveTime = getTime();
				break;
			}
			
			if ( !autoSaveCheck() )
			{
				 /# AutoSavePrint( "Savegame invalid: 1.25 second check failed" ); #/ 
				continue;
			}
			
			wait time2;
			
			if ( isSaveRecentlyLoaded() )
			{
				level.lastAutoSaveTime = getTime();
				break;
			}
			
			if ( !autoSaveCheck_not_picky() )
			{
				 /# AutoSavePrint( "Savegame invalid: 2.5 second check failed" ); #/ 
				continue;
			}

			if ( isdefined( timeout ) )
			{
				if ( gettime() > start_save_time + timeout * 1000 )
					break;
			}
			
			if ( !flag( "can_save" ) )
			{
				 /# AutoSavePrint( "Can_save flag was clear" ); #/ 
				break;
			}
				
			level.not_recently_loaded = true;
			commitSave( saveId );
			setDvar( "ui_grenade_death", "0" );
			break;
		}

		wait 0.25;
	}
	
	flag_clear( "game_saving" );
	return true;
}

autoSaveCheck_not_picky()
{
	return autoSaveCheck( false );
}

autoSaveCheck( doPickyChecks )
{
	if ( isdefined( level.special_autosavecondition ) && ![[ level.special_autosavecondition ]]() )
		return false;
	
	if ( level.missionfailed )
		return false;
	
	if ( !isdefined( doPickyChecks ) )
		doPickyChecks = true;
	
	// health check	
	if ( !autoSaveHealthCheck() )
		return false;
		
	// ammo check
	if ( doPickyChecks && !autoSaveAmmoCheck() )
		return false;
		
	// ai / tank threat check
	if ( !autoSaveThreatCheck( doPickyChecks ) )
		return false;
	
	// player state check
	if ( !autoSavePlayerCheck( doPickyChecks ) )
		return false;
	
	// safe save check for level specific gameplay conditions
	if ( isdefined( level.savehere ) && !level.savehere )
		return false;
	
	// safe save check for level specific gameplay conditions
	if ( isdefined( level.canSave ) && !level.canSave )
		return false;

	// save was unsuccessful for internal reasons, such as lack of memory
	if ( !issavesuccessful() )
	{
		AutoSavePrint( "autosave failed: save call was unsuccessful" );
		return false;
	}
	
	return true;
}

autoSavePlayerCheck( doPickyChecks )
{
	if ( level.script == "ac130" )
		return true;
	
	if ( level.player isMeleeing() && doPickyChecks )
	{
		AutoSavePrint( "autosave failed:player is meleeing" );
		return false;
	}

	if ( level.player isThrowingGrenade() && doPickyChecks )
	{
		AutoSavePrint( "autosave failed:player is throwing a grenade" );
		return false;
	}

	if ( level.player isFiring() && doPickyChecks )
	{
		AutoSavePrint( "autosave failed:player is firing" );
		return false;
	}

	if ( isdefined( level.player.shellshocked ) && level.player.shellshocked )
	{
		AutoSavePrint( "autosave failed:player is in shellshock" );
		return false;
	}

	return true;
}

autoSaveAmmoCheck()
{
	if ( level.script == "ac130" )
		return true;
	
    weapons = level.player GetWeaponsListPrimaries();

    for ( idx = 0; idx < weapons.size; idx++ )
    {
	    fraction = level.player GetFractionMaxAmmo( weapons[ idx ] );
	    if ( fraction > 0.1 )
		    return( true );
    }
    
	AutoSavePrint( "autosave failed: ammo too low" );
	return( false );
}

autoSaveHealthCheck()
{
	if ( level.script == "ac130" )
		return true;
	
	healthFraction = level.player.health / level.player.maxhealth;	
	if ( healthFraction < 0.5 )
	{
		 /# AutoSavePrint( "autosave failed: health too low" ); #/ 
		return false;
	}
	
	if ( flag( "player_has_red_flashing_overlay" ) )
	{
		 /# AutoSavePrint( "autosave failed: player has red flashing overlay" ); #/ 
		return false;
	}
	
	return true;
}

autoSaveThreatCheck( doPickyChecks )
{
	if ( level.script == "ac130" )
		return true;
	
	enemies = getaispeciesarray( "axis", "all" );
	for ( i = 0; i < enemies.size; i++ )
	{
		if ( !isdefined( enemies[ i ].enemy ) )
			continue;
			
		if ( enemies[ i ].enemy != level.player )
			continue;

		if ( enemies[ i ].type == "dog" )
		{
			if ( distance( enemies[ i ].origin, level.player.origin ) < 384 )
			{
				 /# AutoSavePrint( "autosave failed: Dog near player" ); #/ 
				return( false );
			}
			
			continue;
		}
			
		// recently shot at the player
		if ( enemies[ i ].a.lastShootTime > gettime() - 500 )
		{
			if ( doPickyChecks || enemies[ i ] animscripts\utility::canShootEnemy() )
			{
				 /# AutoSavePrint( "autosave failed: AI firing on player" ); #/ 
				return( false );
			}
		}
		
		if ( enemies[ i ].a.alertness == "aiming" && enemies[ i ] animscripts\utility::canShootEnemy() )
		{
			 /# AutoSavePrint( "autosave failed: AI aiming at player" ); #/ 
			return( false );
		}
			
		// is trying to melee the player
		if ( isdefined( enemies[ i ].a.personImMeleeing ) && enemies[ i ].a.personImMeleeing == level.player )
		{
			 /# AutoSavePrint( "autosave failed: AI meleeing player" ); #/ 
			return( false );
		}
	}
	
	grenades = getentarray( "grenade", "classname" );
	for ( i = 0; i < grenades.size; i++ )
	{
		grenade = grenades[ i ];
		if ( grenade.model == "weapon_claymore" )
			continue;
			
		if ( distance( grenade.origin, level.player.origin ) < 250 )// grenade radius is 220
		{
			 /# AutoSavePrint( "autosave failed: live grenade too close to player" ); #/ 
			return( false );
		}
	}
	
	return( true );
}

