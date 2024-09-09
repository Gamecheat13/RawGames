#include maps\_utility;
#include maps\_utility_code;
#include common_scripts\utility;

main()
{
	level.lastAutoSaveTime = 0;
	flag_init( "game_saving" );
	flag_init( "can_save" );
	flag_set( "can_save" );
	flag_init( "disable_autosaves" );
	if ( !isdefined( level._extra_autosave_checks ) )
		level._extra_autosave_checks = [];
		
	level.autosave_proximity_threat_func = ::autosave_proximity_threat_func;
}

getDescription()
{
	// autosave
	return( &"AUTOSAVE_AUTOSAVE" );
}

getnames( num )
{
	if ( num == 0 )
		// Begin Game Autosave
		savedescription = &"AUTOSAVE_GAME";
	else
		// No Name Specified
		savedescription = &"AUTOSAVE_NOGAME";

	return savedescription;
}


beginningOfLevelSave()
{
	//introscreen is setup to always complete even when there is non.
	flag_wait( "introscreen_complete" );

	if ( level.MissionFailed )
		return;

	if ( flag( "game_saving" ) )
		return;

	flag_set( "game_saving" );

	imagename = "levelshots / autosave / autosave_" + level.script + "start";

	// "levelstart" is recognized by the saveGame command as a special save game
	// Start
	SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", imagename, true );
	SetDvar( "ui_grenade_death", "0" );
	PrintLn( "Saving level start saved game" );

	flag_clear( "game_saving" );
}

trigger_autosave_stealth( trigger )
{
	trigger waittill( "trigger" );
	autosave_stealth();
}

trigger_autosave_tactical( trigger )
{
	trigger waittill( "trigger" );
	autosave_tactical();
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

	if ( !( IsDefined( savedescription ) ) )
	{
		PrintLn( "autosave", self.script_autosave, " with no save description in _autosave.gsc!" );
		return;
	}
	
	wait 1; // delay for beginningOfLevelSave() conflict

	trigger waittill( "trigger" );

	num = trigger.script_autosave;
	imagename = "levelshots / autosave / autosave_" + level.script + num;

	tryAutoSave( num, savedescription, imagename );

	if ( IsDefined( trigger ) )
		trigger Delete();
}


autoSaveNameThink( trigger )
{
    if( is_no_game_start() )
        return;
    
    wait 1; // delay for beginningOfLevelSave() conflict

	trigger waittill( "trigger" );
	if( !IsDefined( trigger ) )
		return;
	name = trigger.script_autosavename;
	trigger Delete();
	if ( IsDefined( level.customautosavecheck ) )
		if ( ![[ level.customautosavecheck ]]() )
			return;
	maps\_utility::autosave_by_name( name );
}


trigger_autosave_immediate( trigger )
{
	trigger waittill( "trigger" );
	// Start
// 	saveId = SaveGameNoCommit( 1, &"AUTOSAVE_LEVELSTART", "autosave_image" );
// 	CommitSave( saveId );
}

AutoSavePrint( msg, msg2 )
{
	/#
	SetDvarIfUninitialized( "scr_autosave_debug", "0" );
	if ( GetDebugDvarInt( "scr_autosave_debug" ) == 1 )
	{
		if ( IsDefined( msg2 ) )
			IPrintLn( msg + " [ localized description ]" );
		else
			IPrintLn( msg );
		return;
	}
	#/

	if ( IsDefined( msg2 ) )
		PrintLn( msg, msg2 );
	else
		PrintLn( msg );
}

autosave_timeout( timeout )
{
	level endon( "trying_new_autosave" );
	level endon( "autosave_complete" );
	wait( timeout );
	flag_clear( "game_saving" );
	level notify( "autosave_timeout" );
}

_autosave_game_now_nochecks()
{
	imagename = "levelshots / autosave / autosave_" + level.script + "start";
	// Start
	SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", imagename, true );
	//{NOT_IN_SHIP
	autosave_recon( 0 );
	//}NOT_IN_SHIP
}

_autosave_game_now_notrestart()
{
	imagename = "levelshots / autosave / autosave_" + level.script + "start";
	if ( getdvarint( "g_reloading" ) == 0 )
	{
		SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", imagename, true );
		//{NOT_IN_SHIP
		autosave_recon( 0 );
		//}NOT_IN_SHIP
	}
}

_autosave_game_now( suppress_print )
{
	if ( isdefined( level.MissionFailed ) && level.MissionFailed )
		return;

	if ( flag( "game_saving" ) )
		return false;

	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[ i ];
		if ( !isalive( player ) )
			return false;
	}

	filename = "save_now";
	descriptionString = getDescription();

	if ( IsDefined( suppress_print ) )
		saveId = SaveGameNoCommit( filename, descriptionString, "$default", true );
	else
		saveId = SaveGameNoCommit( filename, descriptionString );

	wait( 0.05 );// code request
	if ( IsSaveRecentlyLoaded() )
	{
		level.lastAutoSaveTime = GetTime();
		return false;
	}



	/# AutoSavePrint( "Saving game " + filename + " with desc ", descriptionString ); #/

	if ( saveId < 0 )
	{
		/# AutoSavePrint( "Savegame failed - save error.: " + filename + " with desc ", descriptionString ); #/
		return false;
	}


	if ( !try_to_autosave_now() )
	{
		return false;
	}

	flag_set( "game_saving" );
	wait 2;
	flag_clear( "game_saving" );

	if ( !CommitWouldBeValid( saveId ) )
	{
		/# AutoSavePrint( "Save is no longer valid, another save was run from elsewhere" ); #/
		return false;
	}


	// are we still healthy 2 seconds later? k save then
	if ( try_to_autosave_now() )
	{
		//{NOT_IN_SHIP
		autosave_recon( saveId );
		//}NOT_IN_SHIP
		
		CommitSave( saveId );
		SetDvar( "ui_grenade_death", "0" );
	}

	return true;
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

	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[ i ];
		if ( !player autoSaveHealthCheck() )
			return false;
	}

	if ( !flag( "can_save" ) )
	{
		/# AutoSavePrint( "Can_save flag was clear" ); #/
		return false;
	}

	return true;
}

tryAutoSave( filename, description, image, timeout, doStealthChecks, suppress_print )
{
	if ( flag( "disable_autosaves" ) )
		return false;

	level endon( "nextmission" );
	level.player endon( "death" );
	if ( is_coop() )
		level.player2 endon( "death" );

	level notify( "trying_new_autosave" );

	if ( flag( "game_saving" ) )
		return false;

	if ( IsDefined( level.nextmission ) )
		return false;

	time1 = 1.25;
	time2 = 1.25;

	if ( IsDefined( timeout ) && timeout < time1 + time2 )
	{
		AssertMsg( "Warning, tried to do an autosave_or_timeout with a time less than " + ( time1 + time2 ) );
	}

	if ( !isdefined( suppress_print ) )
		suppress_print = false;
	if ( !isdefined( image ) )
		image = "$default";

	if ( !isdefined( doStealthChecks ) )
		doStealthChecks = false;

	flag_set( "game_saving" );

	descriptionString = getDescription();
	start_save_time = GetTime();

	while ( 1 )
	{
		if ( autoSaveCheck( undefined, doStealthChecks ) )
		{
			saveId = SaveGameNoCommit( filename, descriptionString, image, suppress_print );
			/# AutoSavePrint( "Saving game " + filename + " with desc ", descriptionString ); #/

			if ( saveId < 0 )
			{
				/# AutoSavePrint( "Savegame failed - save error.: " + filename + " with desc ", descriptionString ); #/
				break;
			}

			wait( 0.05 );// code request
			if ( IsSaveRecentlyLoaded() )
			{
				level.lastAutoSaveTime = GetTime();
				break;
			}

			wait time1;

			if ( extra_autosave_checks_failed() )
				continue;

			if ( !autoSaveCheck( undefined, doStealthChecks ) )
			{
				/# AutoSavePrint( "Savegame invalid: 1.25 second check failed" ); #/
				continue;
			}

			wait time2;

			if ( !autoSaveCheck_not_picky() )
			{
				/# AutoSavePrint( "Savegame invalid: 2.5 second check failed" ); #/
				continue;
			}

			if ( IsDefined( timeout ) )
			{
				if ( GetTime() > start_save_time + timeout * 1000 )
					break;
			}

			if ( !flag( "can_save" ) )
			{
				/# AutoSavePrint( "Can_save flag was clear" ); #/
				break;
			}

			if ( !CommitWouldBeValid( saveId ) )
			{
				/# AutoSavePrint( "Save is no longer valid, another save was run from elsewhere" ); #/
				flag_clear( "game_saving" );
				return false;
			}

			//{NOT_IN_SHIP
			autosave_recon( saveId );
			//}NOT_IN_SHIP
			CommitSave( saveId );
			level.lastSaveTime = GetTime();
			SetDvar( "ui_grenade_death", "0" );
			break;
		}

		wait 0.25;
	}

	flag_clear( "game_saving" );
	return true;
}

extra_autosave_checks_failed()
{
	foreach ( func in level._extra_autosave_checks )
	{
		if ( ![[ func[ "func" ] ]]() )
		{
			AutoSavePrint( "autosave failed: " + func[ "msg" ] );
			return true;
		}
	}

	return false;
}

autoSaveCheck_not_picky()
{
	return autoSaveCheck( false, false );
}

autoSaveCheck( doPickyChecks, doStealthChecks )
{
	if ( IsDefined( level.autosave_check_override ) )
		return [[ level.autosave_check_override ]]();

	if ( IsDefined( level.special_autosavecondition ) && ![[ level.special_autosavecondition ]]() )
		return false;

	if ( level.MissionFailed )
		return false;

	if ( !isdefined( doPickyChecks ) )
		doPickyChecks = level.doPickyAutosaveChecks;

	if ( !isdefined( doStealthChecks ) )
		doStealthChecks = false;
	
	if ( doStealthChecks )
	{
		if ( ! [[ level.global_callbacks[ "_autosave_stealthcheck" ] ]]() )
			return false;
	}

	// health check	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[ i ];
		if ( !player autoSaveHealthCheck() )
			return false;

		// ammo check
		if ( doPickyChecks && !player autoSaveAmmoCheck() )
			return false;
	}

	// ai / tank threat check
	if ( level.autosave_threat_check_enabled )
	{
		if ( !autoSaveThreatCheck( doPickyChecks ) )
			return false;
	}

	// player state check
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[ i ];
		if ( !player autoSavePlayerCheck( doPickyChecks ) )
			return false;
	}

	// safe save check for level specific gameplay conditions
	if ( IsDefined( level.savehere ) && !level.savehere )
		return false;

	// safe save check for level specific gameplay conditions
	if ( IsDefined( level.canSave ) && !level.canSave )
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
	Assert( IsPlayer( self ) );

	if ( IsDefined( level.ac130gunner ) && level.ac130gunner == self )
		return true;

	if ( self IsMeleeing() && doPickyChecks )
	{
		AutoSavePrint( "autosave failed:player is meleeing" );
		return false;
	}

	if ( self IsThrowingGrenade() && doPickyChecks )
	{
		AutoSavePrint( "autosave failed:player is throwing a grenade" );
		return false;
	}

	if ( self IsFiring() && doPickyChecks )
	{
		AutoSavePrint( "autosave failed:player is firing" );
		return false;
	}

	if ( IsDefined( self.shellshocked ) && self.shellshocked )
	{
		AutoSavePrint( "autosave failed:player is in shellshock" );
		return false;
	}

	if ( self isFlashed() )
	{
		AutoSavePrint( "autosave failed:player is flashbanged" );
		return false;
	}

	return true;
}

autoSaveAmmoCheck()
{
	Assert( IsPlayer( self ) );

	if ( IsDefined( level.ac130gunner ) && level.ac130gunner == self )
		return true;

    weapons = self GetWeaponsListPrimaries();

    for ( idx = 0; idx < weapons.size; idx++ )
    {
	    fraction = self GetFractionMaxAmmo( weapons[ idx ] );
	    if ( fraction > 0.1 )
		    return( true );
    }

	AutoSavePrint( "autosave failed: ammo too low" );
	return( false );
}

autoSaveHealthCheck()
{
	Assert( IsPlayer( self ) );

	if ( IsDefined( level.ac130gunner ) && level.ac130gunner == self )
		return true;

	if ( self ent_flag_exist( "laststand_downed" ) && self ent_flag( "laststand_downed" ) )
	{
		/# AutoSavePrint( "autosave failed: health too low" ); #/
		return false;
	}

	healthFraction = self.health / self.maxhealth;
	if ( healthFraction < 0.5 )
	{
		/# AutoSavePrint( "autosave failed: health too low" ); #/
		return false;
	}

	if ( flag( "_radiation_poisoning" ) )
	{
		/# AutoSavePrint( "autosave failed: player has radiation sickness" ); #/
		return false;
	}


	if ( self ent_flag( "player_has_red_flashing_overlay" ) )
	{
		/# AutoSavePrint( "autosave failed: player has red flashing overlay" ); #/
		return false;
	}

	return true;
}

autoSaveThreatCheck( doPickyChecks )
{
	if ( IsDefined( level.ac130gunner ) && level.ac130gunner == self )
		return true;

	enemies = GetAISpeciesArray( "bad_guys", "all" );

	foreach ( enemy in enemies )
	{
		if ( !isdefined( enemy.enemy ) )
			continue;

		if ( !isplayer( enemy.enemy ) )
			continue;

		if ( enemy.type == "dog" )
		{
			foreach ( player in level.players )
			{
				if ( Distance( enemy.origin, player.origin ) < 384 )
				{
					/# AutoSavePrint( "autosave failed: Dog near player" ); #/
					return( false );
				}
			}

			continue;
		}

		// is trying to melee the player
		if ( IsDefined( enemy.Melee ) && IsDefined( enemy.melee.target ) && IsPlayer( enemy.melee.target ) )
		{
			/# AutoSavePrint( "autosave failed: AI meleeing player" ); #/
			return( false );
		}

		proximity_threat = [[ level.autosave_proximity_threat_func ]]( enemy );

		if ( proximity_threat == "return_even_if_low_accuracy" )
		{
			/# AutoSavePrint( "autosave failed: AI too close to player, so close we're ignoring his accuracy" ); #/
			return false;
		}

		if ( enemy.finalAccuracy < 0.021 && enemy.finalAccuracy > -1 )
		{
			// enemy lacks the accuracy to be a threat
			continue;
		}
		
		if ( proximity_threat == "return" )
		{
			/# AutoSavePrint( "autosave failed: AI too close to player" ); #/
			return false;
		}
			
		if ( proximity_threat == "none" )
		{
			// enemy isn't close enough to be a threat
			continue;
		}

		// recently shot at the player
		if ( enemy.a.lastShootTime > GetTime() - 500 )
		{
			if ( doPickyChecks || enemy animscripts\utility::canSeeEnemy( 0 ) && enemy CanShootEnemy( 0 ) )
			{
				/# AutoSavePrint( "autosave failed: AI firing on player" ); #/
				return( false );
			}
		}

		if ( IsDefined( enemy.a.aimIdleThread ) && enemy animscripts\utility::canSeeEnemy( 0 ) && enemy CanShootEnemy( 0 ) )
		{
			/# AutoSavePrint( "autosave failed: AI aiming at player" ); #/
			return( false );
		}
	}

	if ( player_is_near_live_grenade() )
		return false;

	vehicles = GetEntArray( "destructible", "classname" );
	foreach ( vehicle in vehicles )
	{
		if ( !isDefined( vehicle.healthDrain ) )
			continue;

		foreach ( player in level.players )
		{
			if ( Distance( vehicle.origin, player.origin ) < 400 )// grenade radius is 220
			{
				/# AutoSavePrint( "autosave failed: burning car too close to player" ); #/
				return( false );
			}
		}
	}

	return( true );
}

enemy_is_a_threat()
{
	// AI must have a reasonable chance of hitting the player
	if ( self.finalAccuracy >= 0.021 )
		return true;

	foreach ( player in level.players )
	{
		if ( Distance( self.origin, player.origin ) < 500 )
			return true;
	}

	return false;
}

autosave_proximity_threat_func( enemy )
{
	foreach ( player in level.players )
	{
		dist = Distance( enemy.origin, player.origin );
		
		if ( dist < 200 )
		{
			return "return_even_if_low_accuracy";
		}
		else
		if ( dist < 360 )
		{
			return "return";
		}
		else
		if ( dist < 1000 )
		{
			return "threat_exists";
		}
	}
	
	return "none";
}

//{NOT_IN_SHIP
autosave_recon( saveId )
{
	if (!is_default_start())
		return;		// times only valid when not using debug_start to jump into middle of level
	time = get_leveltime();
	dtime = time;
	if (isdefined(level.recon_checkpoint_lasttime))
		dtime = time - level.recon_checkpoint_lasttime;
	level.recon_checkpoint_lasttime = time;
    ReconEvent( "script_checkpoint: id %d, leveltime %d, deltatime %d", saveId, time, dtime  );
    /#
    println("script_checkpoint: id "+saveId+", leveltime "+time+", deltatime "+dtime);
    #/
}
//}NOT_IN_SHIP
