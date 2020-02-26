#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_music; 

init()
{
	level.splitscreen = isSplitScreen(); 
	level.xenon = ( GetDvar( "xenonGame" ) == "true" ); 
	level.ps3 = ( GetDvar( "ps3Game" ) == "true" ); 
	level.wii = ( GetDvar( "wiiGame" ) == "true" ); 
	level.onlineGame = SessionModeIsOnlineGame(); 
	level.systemLink = SessionModeIsSystemlink(); 
	level.console = ( level.xenon || level.ps3 || level.wii ); 

	// CODER_MOD: Austin (8/15/08): display briefing menu until all players have joined
	PrecacheMenu( "briefing" );

    // CODER_MOD
    // GMJ( 7/13/08 ): Players can earn xp and unlock things in private matches.
	level.rankedMatch = ( level.onlineGame 
                          // && !GetDvarint( "xblive_privatematch" )
                        ); 
	level.profileLoggedIn = ( GetDvar( "xblive_loggedin" ) == "1" );
	
/#
	if( GetDvarint( "scr_forcerankedmatch" ) == 1 )
	{
		level.rankedMatch = true; 
	}
#/
}

SetupCallbacks()
{
	level.otherPlayersSpectate = false; 
	
	level.spawnPlayer = ::spawnPlayer; 
	level.spawnClient = ::spawnClient; 
	level.spawnSpectator = ::spawnSpectator; 
	level.spawnIntermission = ::spawnIntermission; 
		
	
	level.onSpawnPlayer = ::default_onSpawnPlayer; 
	level.onPostSpawnPlayer = ::default_onPostSpawnPlayer; 
	level.onSpawnSpectator = ::default_onSpawnSpectator; 
	level.onSpawnIntermission = ::default_onSpawnIntermission; 

	level.onStartGameType = ::blank; 
	level.onPlayerConnect = ::blank; 
	level.onPlayerDisconnect = ::blank; 
	level.onPlayerDamage = ::blank; 
	level.onPlayerKilled = ::blank; 
	level.onPlayerWeaponSwap = ::blank; 
	
	level._callbacks["on_first_player_connect"]	= [];
	level._callbacks["on_player_connect"]		= [];
	level._callbacks["on_player_disconnect"]	= [];
	level._callbacks["on_player_damage"]		= [];
	level._callbacks["on_player_last_stand"]	= [];
	level._callbacks["on_player_killed"]		= [];
	//level._callbacks["on_player_revived"]		= [];	// code doesn't call the callback for this anyway
	level._callbacks["on_actor_damage"]			= [];
	level._callbacks["on_actor_killed"]			= [];
	level._callbacks["on_vehicle_damage"]		= [];
	level._callbacks["on_save_restored"]		= [];
	
	if (!IsDefined(level.onMenuMessage))
		level.onMenuMessage = ::blank;  //used to handle menu messages
	if (!IsDefined(level.onDec20Message))
		level.onDec20Message = ::blank;  //used to handle dec20 messages
}

AddCallback(event, func)
{
	assert(IsDefined(event), "Trying to set a callback on an undefined event.");
	assert(IsDefined(level._callbacks[event]), "Trying to set callback for unknown event '" + event + "'.");
	
	level._callbacks[event] = add_to_array(level._callbacks[event], func, false);
}

RemoveCallback(event, func)
{
	assert(IsDefined(event), "Trying to remove a callback on an undefined event.");
	assert(IsDefined(level._callbacks[event]), "Trying to remove callback for unknown event '" + event + "'.");
	
	level._callbacks[event] = array_remove( level._callbacks[event], func, true );
}

Callback(event)
{
	assert(IsDefined(level._callbacks[event]), "Must init callback array before trying to call it.");

	for (i = 0; i < level._callbacks[event].size; i++)
	{
		callback = level._callbacks[event][i];
		if (IsDefined(callback))
		{
			self thread [[callback]]();
		}
	}
}

blank( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
{
}

// CODER_MOD
// Austin( 7/5/07 ): used by the curve code to notify the level entity of a curve event
Callback_CurveNotify( string, curveId, nodeIndex )
{
	level notify( string, curveId, nodeIndex ); 
}


Callback_StartGameType()
{
	//CODER_MOD: TOMMYK 07/16/2008 - For coop scoreboards
	//maps\_gameskill::initialScoreUpdate(); 
}


BriefInvulnerability()
{
	self endon( "disconnect" );
	
	self EnableInvulnerability();
	/#
	println( "****EnableInvulnerability****" ); 
	#/
	
	wait (3);
	
	// SCRIPTER_MOD
	// TravisJ (3/18/2010) - gives player option to come back invulnerable (for use with vehicles, etc)
	if(IsDefined(self))
	{ 
		if(IsDefined(self.invulnerable) && (self.invulnerable == true))
		{
			/#
			PrintLn("****Invulnerability STILL ENABLED****");
			#/
		}
		else
		{
			self DisableInvulnerability();	
			/#
			println( "****DisableInvulnerability****" ); 
			#/		
		}
	}

}


Callback_SaveRestored()
{
	/#
	println( "****Coop CodeCallback_SaveRestored****" ); 
	#/
	
	players = get_players(); 
	level.debug_player = players[0]; 	
	
	num = 0; 
	
	if( isdefined( level._save_pos ) )
	{
		num = level._save_trig_ent; 
	}
	
//	println("*** Restoring with breadcrumbs from player " + num);
	
	for( i = 0; i < 4; i++ )
	{
		player = players[i];
		if( isDefined( player ) )
		{
// CODER_MOD JB - Prevents "death" loop with player upon restoring savegame
			player thread BriefInvulnerability();
			//player thread call_overloaded_func( "maps\_quotes", "main" );
			
/*			player setorigin( level._player_breadcrumbs[num][i].pos ); 
			player setplayerangles( level._player_breadcrumbs[num][i].ang ); 	 */

			if( isdefined( player.savedVisionSet ) )
			{
				player VisionSetNaked( player.savedVisionSet, 0.1 ); 
			}

			if( !GameModeIsMode( level.GAMEMODE_ZOMBIES ) )
			{
				// this is to aviod having the deaths reset when restarting from a checkpoint
				dvarName = "player" + player GetEntityNumber() + "downs";
				player.downs = getdvarint( dvarName );
			}

			// removing coop challenges for now MGORDON
			//maps\_challenges_coop::doMissionCallback( "checkpointLoaded", player ); 
		}
	}

	// removing coop challenges for now MGORDON
	//maps\_challenges_coop::onSaveRestored();

	//level thread call_overloaded_func( "maps\_arcademode", "arcademode_checkpoint_restore" );
	
	level Callback("on_save_restored");
}

Player_BreadCrumb_Reset( position, angles )
{
	if( !isdefined( angles ) )
	{
		angles = ( 0, 0, 0 ); 
	}
	
	level.playerPrevOrigin0 = position; 
	level.playerPrevOrigin1 = position; 
	
	if( !isdefined( level._player_breadcrumbs ) )
	{
		level._player_breadcrumbs = []; 
		
		for( i = 0; i < 4; i ++ )
		{
			level._player_breadcrumbs[i] = []; 

			for( j = 0; j < 4; j ++ )
			{
				level._player_breadcrumbs[i][j] = spawnstruct(); 
			}
		}
		
	}
	
	for( i = 0; i < 4; i ++ )
	{	
		for( j = 0; j < 4; j ++ )
		{
			level._player_breadcrumbs[i][j].pos = position; 
			level._player_breadcrumbs[i][j].ang = angles; 
		}
	}

}

Player_BreadCrumb_Update()
{
	self endon( "disconnect" ); 
	const drop_distance = 70; 
	right = anglestoright( self.angles ) * drop_distance; 
	level.playerPrevOrigin0 = self.origin + right; 
	level.playerPrevOrigin1 = self.origin - right; 
	
	if( !isdefined( level._player_breadcrumbs ) )
	{
		Player_BreadCrumb_Reset( self.origin, self.angles ); 
	}
	
	num = self GetEntityNumber(); 
	
	while( 1 )
	{
		wait 1; 
		dist_squared = distancesquared( self.origin, level.playerPrevOrigin0 ); 
		if( dist_squared > 500*500 )	// just in case player is teleported
		{
			right = anglestoright( self.angles ) * drop_distance; 
			level.playerPrevOrigin0 = self.origin + right; 
			level.playerPrevOrigin1 = self.origin - right; 
		}
		else if( dist_squared > drop_distance*drop_distance )
		{
			level.playerPrevOrigin1 = level.playerPrevOrigin0; 
			level.playerPrevOrigin0 = self.origin; 
		}
		
		dist_squared = distancesquared( self.origin, level._player_breadcrumbs[num][0].pos ); 
		
/*		if( dist_squared > 500 * 500 )
		{
			right = anglestoright( self.angles ) * drop_distance; 
			pos = self.origin -( right * 2 ); 

			level._player_breadcrumbs[num][0].pos = pos; 
			pos += right; 
			level._player_breadcrumbs[num][1].pos = pos; 
			pos += right; 
			pos += right; 	// skip player position
			level._player_breadcrumbs[num][2].pos = pos; 
			pos += right; 
			level._player_breadcrumbs[num][3].pos = pos; 
			
			for( i = 0; i < 4; i ++ )
			{
				level._player_breadcrumbs[num][i].ang = self.angles; 
			}
		}
		else if( dist_squared > drop_distance * drop_distance ) */
		
		dropBreadcrumbs = true;
		
		if(IsDefined( level.flag ) && IsDefined( level.flag["drop_breadcrumbs"]))
		{
			if(!flag("drop_breadcrumbs"))
			{
				dropBreadcrumbs = false;
			}
		}
		
		if( dropBreadcrumbs && (dist_squared > drop_distance * drop_distance) ) 
		{
			for( i = 2; i >= 0; i -- )
			{
				level._player_breadcrumbs[num][i + 1].pos = level._player_breadcrumbs[num][i].pos; 
				level._player_breadcrumbs[num][i + 1].ang = level._player_breadcrumbs[num][i].ang; 
			}
			
			level._player_breadcrumbs[num][0].pos = PlayerPhysicsTrace(self.origin, self.origin + ( 0, 0, -1000 )); 
			level._player_breadcrumbs[num][0].ang = self.angles; 
		}
	/*	
		for( i = 0; i < 4; i ++ )
		{	
			col = ( 0.0, 0.8, 0.0 ); 
			
			switch( num )
			{
				case 1:
					col = ( 0.8, 0.0, 0.0 ); 
					break; 
				case 2:
					col = ( 0.0, 0.0, 0.8 ); 
					break; 
				case 3:
					col = ( 0.8, 0.0, 0.8 ); 
					break; 
			}
			print3d( level._player_breadcrumbs[num][i].pos, i, col, 1, 1, 20 ); 
		} 
		
		if( num == 0 )
		{
			if( isdefined( level._save_pos ) )
			{
				print3d( level._save_pos, "svp " + level._save_trig_ent, ( 0.0, 0.8, 0.0 ), 1, 1, 20 ); 				
			}
		} 
		*/
	} 
}

SetPlayerSpawnPos()
{
	players = get_players(); 
	player = players[0]; 

	if( !isdefined( level._player_breadcrumbs ) )
	{
		spawnpoints = getentarray( "info_player_deathmatch", "classname" ); 
		
		if( player.origin == ( 0, 0, 0 ) && isdefined( spawnpoints ) && spawnpoints.size > 0 )
		{
			Player_BreadCrumb_Reset( spawnpoints[0].origin, spawnpoints[0].angles ); 
		}
		else
		{
			Player_BreadCrumb_Reset( player.origin, player.angles ); 
		}
	}
	
	const too_close = 30; 
	spawn_pos = level._player_breadcrumbs[0][0].pos; 
	dist_squared = distancesquared( player.origin, spawn_pos ); 

	if( dist_squared > 500*500 )	// just in case player is teleported
	{
		if( player.origin != ( 0, 0, 0 ) )
		{
			spawn_pos = player.origin +( 0, 30, 0 ); 
		}
	}
	else if( dist_squared < too_close*too_close )
	{
		spawn_pos = level._player_breadcrumbs[0][1].pos; 
	}
	
	spawn_angles = vectornormalize( player.origin - spawn_pos ); 
	spawn_angles = vectorToAngles( spawn_angles ); 

	// make sure that this is a valid spawn position
	if( !playerpositionvalid( spawn_pos ) )
	{
		// for now just put them at the player position
		// we know this position is valid
		spawn_pos = player.origin; 
		spawn_angles = player.angles; 
	}
		
	//-- GLocke: 5/18/2011 - put this back in so that a co-op player would actually get moved
	self setOrigin( spawn_pos ); 
	// set them looking at player0
	self setPlayerAngles( spawn_angles );
}

Callback_PlayerConnect()
{
	thread first_player_connect(); 

	self waittill( "begin" ); 
	self reset_clientdvars();
	waittillframeend; 

        //this wait allows the first frames to run before the player connects - some init required for player position doesn't get set until the end of the first frame
        //and without this wait things can occur out of order.
	wait(0.1);
	
	level notify( "connected", self );
	self Callback("on_player_connect");

	self thread maps\_load_common::player_special_death_hint();
	self thread maps\_flashgrenades::monitorFlash();

	if( !GameModeIsMode( level.GAMEMODE_ZOMBIES ) )
	{
		// we want to give the player a good default starting position
		// info_player_spawn actually gets renamed to info_player_deathmatch
		// in the game
		info_player_spawn = getentarray( "info_player_deathmatch", "classname" ); 

		if( isdefined( info_player_spawn ) && info_player_spawn.size > 0 )
		{
			// CODER_MOD
			// Danl( 08/03/07 ) Band aid to spawn clients at host position.
			players = get_players("all"); 
			if( Isdefined( players ) &&( players.size != 0 ) )// || players[0] == self ) )
			{
				if( players[0] == self )
				{
					println( "2:  Setting player origin to info_player_start " + info_player_spawn[0].origin ); 
					self setOrigin( info_player_spawn[0].origin ); 
					self setPlayerAngles( info_player_spawn[0].angles ); 
					self thread Player_BreadCrumb_Update(); 
				}
				else
				{
					println( "Callback_PlayerConnect:  Setting player origin near host position " + players[0].origin ); 
					self SetPlayerSpawnPos(); 
					self thread Player_BreadCrumb_Update(); 
				}
			}
			else
			{
				println( "Callback_PlayerConnect:  Setting player origin to info_player_start " + info_player_spawn[0].origin ); 
				self setOrigin( info_player_spawn[0].origin ); 
				self setPlayerAngles( info_player_spawn[0].angles ); 
				self thread Player_BreadCrumb_Update(); 
			}
		}
	}

	// SCRIPTER_MOD
	// JesseS( 3/15/2007 ): added player flag setup function
	// CODER_MOD 
	// Danl( 08/03/2007 ) - bandaid to facilitate hot joined players being at the host position on restart from checkpoint
	if( !IsDefined( self.flag ) )
	{
		self.flag = []; 
		self.flags_lock = []; 
	}
	
		// TFLAME - 3/22/11 - player was being warped to skipto points then being reset to info_player_start - rather than rely on timed waits this should be cleaner
	if( !IsDefined( self.flag["player_set_at_info_start"] ) )
	{
		self player_flag_init( "player_set_at_info_start" ); 
	}

	if( !IsDefined( self.flag["player_has_red_flashing_overlay"] ) )
	{
		self player_flag_init( "player_has_red_flashing_overlay" ); 
		self player_flag_init( "player_is_invulnerable" ); 
	}

	if( !IsDefined( self.flag["loadout_given"] ) )
	{
		self player_flag_init( "loadout_given" ); 
	}

	self player_flag_clear( "loadout_given" ); 

	// CODER_MOD
	// Austin( 6/20/07 ): added spectate camera

	// create the spectate camera
//	self.spectate_cam = spawn( "script_camera", ( 0, 0, 0 ) ); 
//
//	// pick a random player to spectate on
//	players = get_players(); 
//	if( players.size > 0 )
//	{
//		num = RandomInt( players.size ); 
//
//		self.spectate_cam linkto( players[num], "tag_origin", ( -100, 0, 50 ), ( 0, 0, 0 ) ); 
//
//		// activate the spectate camera
//		self playerlinktocamera( self.spectate_cam, 0, 0 ); 
//	}
	
	// CODER_MOD: Jon E - This is needed for the SP_TOOL or MP_TOOL to work for MODS
	if( GetDvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		waittillframeend; 
		//self spawn( self.origin, self.angles ); 
		self thread spawnPlayer(); 
		return; 
	}
		
/#
	if( !isdefined( level.spawnClient ) )
	{
		waittillframeend; 
		//self spawn( self.origin, self.angles ); 
		self thread spawnPlayer(); 
		return; 
	}  
#/
	self setClientDvar( "ui_allow_loadoutchange", "1" ); 
	self SetClientUIVisibilityFlag( "hud_visible", 1 );

	self thread[[level.spawnClient]](); 

	dvarName = "player" + self GetEntityNumber() + "downs";
	setdvar( dvarName, self.downs );
}

reset_clientdvars()
{
	if( IsDefined( level.reset_clientdvars ) )
	{
		self [[level.reset_clientdvars]]();
		return;
	}

	self SetClientDvars( "compass", "1",
						 "hud_showStance", "1",
						 /*"cg_thirdPerson", "0",*/
						 "cg_fov", "65",
						 "cg_cursorHints","4",
						 /*"cg_thirdPersonAngle", "0",*/
						 "hud_showobjectives","1",
						 "ammoCounterHide", "0",
						 "miniscoreboardhide", "0",
						 "ui_hud_hardcore", "0",
						 "credits_active", "0",
						 "hud_missionFailed", "0",
						 "cg_cameraUseTagCamera", "1",
						 "cg_drawCrosshair", "1",
						 "r_heroLightScale", "1 1 1",
						 /*"r_fog_disable", "0",*/
						 /*"r_dof_tweak", "0",*/
						 "player_sprintUnlimited", "0",
						 "r_bloomTweaks", "0",
						 "r_exposureTweak", "0",
						 "cg_aggressiveCullRadius", "0"/*,
						 "sm_sunSampleSizeNear", "0.25"*/
						 );

	self AllowSpectateTeam( "allies", false );
	self AllowSpectateTeam( "axis", false );
	self AllowSpectateTeam( "freelook", false );
	self AllowSpectateTeam( "none", false );
}


Callback_PlayerDisconnect()
{
	self Callback("on_player_disconnect");
}

Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	if( self HasPerk( "specialty_armorvest" ) && !maps\_utility_code::isHeadDamage( sHitLoc ) )
	{
		//If victim has body armor, reduce the damage by the cac armor vest value as a percentage
	   	assert(isDefined(level.armorvest_data),"this var must have value");
	   	iDamage = int(iDamage*level.armorvest_data);
		/#
			if ( GetDvarint( "scr_perkdebug") )
				println( "Perk--> Player took less bullet damage due to armorvest");
//				println( "Perk/> " + eAttacker.name + "'s bullet damage did less damage to " + (isDefined(self.name)?self.name:"Player") );
		#/
	}
	
	
	if( IsDefined( self.overridePlayerDamage ) )
	{
		iDamage = self [[self.overridePlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime );
	}
	else if( IsDefined( level.overridePlayerDamage ) )
	{
		iDamage = self [[level.overridePlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime );
	}

	assert(IsDefined(iDamage), "You must return a value from a damage override function.");

	self Callback("on_player_damage");

	if (is_true(self.magic_bullet_shield))
	{
		// save out and restore the maxHealth, because setting health below modifies it
		maxHealth = self.maxHealth;

		// increase health by damage, because it will be subtracted back out below in finishActorDamage
		self.health += iDamage;

		// restore the maxHealth to what it was
		self.maxHealth = maxHealth;
	}
	
	// DtP: When player is diving to prone away from the grenade, the damage is reduced

	// player is diving
	if( isdefined( self.divetoprone ) && self.divetoprone == 1 )
	{
		// grenade splash damage
		if( sMeansOfDeath == "MOD_GRENADE_SPLASH" )
		{
			// if the player is at least 32 units away
			dist = Distance2d(vPoint, self.origin);
			if( dist > 32 )
			{
				// if player is diving away
				dot_product = vectordot( AnglesToForward( self.angles ), vDir ); 
				if( dot_product > 0 )
				{
					// grenade is behind player
					iDamage = int( iDamage * 0.5 ); // halves damage
				}
			}
		}
	}

	//println("CB PD: " + iDamage + " health: " + self.health);

	//CODER MOD: TOMMY K, this is to prevent a player killing another player
	//CODER MOD: DSL - Allow players on opposing teams to damage each other - Vs Mode.
	if( isdefined( eAttacker ) && ((isPlayer( eAttacker )) && (eAttacker.team == self.team))&& ( !isDefined( level.friendlyexplosivedamage ) || !level.friendlyexplosivedamage ))
	{
		if( !isDefined(level.is_friendly_fire_on) || ![[level.is_friendly_fire_on]]() )
		{
			if( self != eAttacker)
			{
				//one player shouldn't damage another player, grenades, airstrikes called in by another player
				println("Exiting - players can't hut each other.");
				return;
			}
			else if( sMeansOfDeath != "MOD_GRENADE_SPLASH"
					&& sMeansOfDeath != "MOD_GRENADE"
					&& sMeansOfDeath != "MOD_EXPLOSIVE"
					&& sMeansOfDeath != "MOD_PROJECTILE"
					&& sMeansOfDeath != "MOD_PROJECTILE_SPLASH"
					&& sMeansOfDeath != "MOD_BURNED"
					&& sMeansOfDeath != "MOD_SUICIDE" )
			{
				println("Exiting - damage type verbotten.");
				//player should be able to damage they're selves with grenades and stuff
				//otherwise don't damage the player, so like airstrikes  won't kill the player
				return;
			}
		}
	}

	if ( isdefined( level.prevent_player_damage ) )
	{
		if ( self [[ level.prevent_player_damage ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime ) )
		{
			return;
		}
	}
	
	// VS:  wrap this for our mode?  might need to use scr_damagefeedback
	if ( isdefined(eAttacker) && eAttacker != self )
	{
		if ( iDamage > 0 && self.health > 0 )
		{
			eAttacker thread maps\_damagefeedback::updateDamageFeedback();
		}
	}

	self maps\_dds::update_player_damage( eAttacker );

	if (iDamage >= self.health)
	{
		if ((sMeansOfDeath == "MOD_CRUSH")
			&& IsDefined(eAttacker) && IsDefined(eAttacker.classname)
			&& (eAttacker.classname == "script_vehicle"))
		{
			SetDvar( "ui_deadquote", "@SCRIPT_MOVING_VEHICLE_DEATH" );
		}
	}
	
	if ( is_true( level.disable_player_damage_knockback ) )
	{
		iDFlags = iDFlags | level.iDFLAGS_NO_KNOCKBACK;
	}

	//PrintLn("Finishplayerdamagage wrapper.");
	self finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime );
}


finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime ); 
}

incrGrenadeKillCount()
{
	if (!isPlayer(self) )
	{
		return;
	}
	if (!isDefined(self.grenadeKillCounter) )
	{
		self.grenadeKillCounter = 0;
	}
	self inc_general_stat( "explosivekills" );
	self.grenadeKillCounter++;
	if( self.grenadeKillCounter >= 5 )
	{
		self giveachievement_wrapper( "SP_GEN_FRAGMASTER" );
	}
	wait( 0.25 );
	self.grenadeKillCounter--;
}

Callback_ActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	self endon("death");

	if ( isDefined(eAttacker) )
	{
		if( ( isplayer( eAttacker ) && eAttacker HasPerk( "specialty_bulletdamage") && maps\_utility_code::isPrimaryDamage( sMeansOfDeath ) ))
		{
		   	assert(isDefined(level.bulletdamage_data),"this var must have value");
		   	iDamage = int(iDamage*level.bulletdamage_data);
			/#
			if ( GetDvarint( "scr_perkdebug") )
				println( "Perk--> Player bullet did extra damage" );
				//println( "Perk/> " + eAttacker.name + "'s bullet damage did extra damage to " + (isDefined(self.name)?self.name:"Player") );
			#/
		   		
	    }
	}
	if( IsDefined( self.overrideActorDamage ) )
	{
		iDamage = self [[self.overrideActorDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName );
	}
	else if( IsDefined( level.overrideActorDamage ) )
	{
		iDamage = self [[level.overrideActorDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName );
	}
		
	assert(IsDefined(iDamage), "You must return a value from a damage override function.");

	self Callback("on_actor_damage");

	if ( is_true(self.magic_bullet_shield ) && !is_true( self.bulletcam_death ) )
	{
		const MIN_PAIN_INTERVAL = 500;

		t = GetTime();
		if ((t - self._mbs.last_pain_time > MIN_PAIN_INTERVAL)
			|| (sMeansOfDeath == "MOD_EXPLOSIVE"))
		{
			// if current allowPain is true or old one was defined and true then enable pain
			// otherwise leave it disabled. 
			if (self.allowPain || is_true(self._mbs.allow_pain_old))
			{
				enable_pain();
			}

			self._mbs.last_pain_time = t;

			///////////////////////////////////
			//DK 3/8/11 - REMOVED IGNOREMETIMER call due to substantial issues introduced to AI
			//self thread ignore_me_timer( self._mbs.ignore_time, "stop_magic_bullet_shield" ); 
			//DO NOT RE-ENABLE without consulting AI TEAM
			///////////////////////////////////
			self thread turret_ignore_me_timer( self._mbs.turret_ignore_time );
		}
		else
		{
			self._mbs.allow_pain_old = self.allowPain;
			disable_pain();
		}

		self.delayedDeath = false;

		// save out and restore the maxHealth, because setting health below modifies it
		maxHealth = self.maxHealth;

		// increase health by damage, because it will be subtracted back out below in finishActorDamage
		self.health += iDamage;

		// restore the maxHealth to what it was
		self.maxHealth = maxHealth;
	}
	else if (!is_true(self.a.doingRagdollDeath))
	{
		//iDamage = maps\_bulletcam::try_bulletcam( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime );

		if( !GameModeIsMode( level.GAMEMODE_ZOMBIES ) )
			self call_overloaded_func( "animscripts\balcony", "balconyDamage", iDamage, /*sHitLoc,*/ sMeansOfDeath );
	}

	// VS:  wrap this for our mode?  might need to use scr_damagefeedback
	if ( IsDefined(eAttacker) && eAttacker != self )
	{
		if ( iDamage > 0 && self.health > 0)
		{
			eAttacker thread maps\_damagefeedback::updateDamageFeedback();
		}
	}

	self maps\_dds::update_actor_damage( eAttacker, sMeansOfDeath );

	// don't want to start shooting during ragdoll
	if( self.health - iDamage <= 0 && sWeapon == "crossbow_sp" )
	{
		self.dofiringdeath = false;
	}
	
	if( self.health > 0 && (self.health - iDamage) <= 0 )
	{
		/#
		PrintLn( "LDS: Dropped scavenger item for entity "+self GetEntityNumber() );
		#/
		
		if( isPlayer( eAttacker ) )
		{
			println( "player killed enemy with "+sWeapon+" via "+sMeansOfDeath );
			if ( self.team == "axis" && !GameModeIsMode( level.GAMEMODE_ZOMBIES )  )
			{			
				item = self DropScavengerItem( "scavenger_item_sp" );
				item thread maps\_weapons::scavenger_think();
				
				if ( sWeapon == "explosive_bolt_sp" || sWeapon == "crossbow_explosive_alt_sp" ) // explosion or arrow
				{
					killedSoFar = 1 + GetPersistentProfileVar( 0, 0 ); // index 0, default=0
					if( killedSoFar >= 30 ) // >= to be safe, in case it fails the first time
					{
						eAttacker giveachievement_wrapper( "SP_GEN_CROSSBOW" );
					}
					SetPersistentProfileVar( 0, killedSoFar );
				}
				
				if( self.isBigDog )
				{
					eAttacker inc_general_stat( "mechanicalkills" );
				}
				else
				{
					eAttacker inc_general_stat( "kills" );
				}
				if( ( sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" ) && sWeapon == "frag_grenade_sp" )
				{
					eAttacker thread incrGrenadeKillCount();
				}
				if( sMeansOfDeath == "MOD_EXPLOSIVE" )
				{
					eAttacker inc_general_stat( "explosivekills" );
				}
				if( sMeansOfDeath == "MOD_MELEE" )
				{
					eAttacker inc_general_stat( "meleekills" );
				}
				if( sHitLoc == "head" || sHitLoc == "helmet" )
				{
					eAttacker inc_general_stat( "headshots" );
				}
			}
		}
	}

	self finishActorDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime ); 

//	iPrintlnBold( "Damage: "+iDamage );
}

finishActorDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	self finishActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime );
}

/*================ 
Called when a player has been revived while in last stand
 ================ */
Callback_RevivePlayer()
{
// 	self Callback("on_player_revived"); // this should be here, but code isn't calling this callback anyway
	self endon( "disconnect" );
	self RevivePlayer();
}

/*================ 
Called when a player has been killed, but has last stand perk.
self is the player that was killed.
 ================ */
Callback_PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self endon( "disconnect" );
	self Callback("on_player_last_stand");
	[[maps\_laststand::PlayerLastStand]]( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ); 
}


Callback_PlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self thread[[level.onPlayerKilled]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration ); 

	// get rid of the head icon
	//self.headicon = ""; 
	
//	setmusicstate( "DEATH" ); 

	/#
		debug_player_death(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	#/

	self.downs++;
	dvarName = "player" + self GetEntityNumber() + "downs";
	setdvar( dvarName, self.downs );

	if( IsDefined( level.player_killed_shellshock ) )
	{
		self ShellShock( level.player_killed_shellshock, 3 );
	}
	else
	{
		self ShellShock( "death", 3 );
	}

	self PlayLocalSound( "evt_player_death" ); 

	// restore the movement
	self setmovespeedscale( 1.0 ); 
	self.ignoreme = false; 

	self notify( "killed_player" ); 
	self Callback("on_player_killed");
	
	wait( 1 ); 
	// wait for the death sequence to finish

	if( IsDefined( level.overridePlayerKilled ) )
	{
		self [[level.overridePlayerKilled]]();
	}

	if( get_players().size > 1 )
	{
		// CODER_MOD 
		// BNANDAKUMAR( 05/29/08 )
		// We will display a Mission Failed text for all the players
		// We will also display a message below if "You have died" or "Your teammate has died"
		players = get_players(); 
		for( i = 0; i < players.size; i++ )
		{
			if( isDefined( players[i] ) )
			{
				//players[i] thread call_overloaded_func( "maps\_quotes", "displaymissionfailed" );
				if( !isAlive( players[i] ) )
				{
					//players[i] thread call_overloaded_func( "maps\_quotes", "displayplayerdead" );
					println( "Player #"+i+" is dead" );					
				}
				else
				{
					//players[i] thread call_overloaded_func( "maps\_quotes", "displayteammatedead", self );
					println( "Player #"+i+" is alive" ); 
				}
			}
		}
		missionfailed(); 
		return; 
	}
	
/#
	if( !isdefined( level.spawnClient ) )
	{
		waittillframeend; 
		self spawn( self.origin, self.angles ); 
		return; 
	}  
#/
}

/#
debug_player_death(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	PrintLn("^6[[ Player Killed ]]\n");

	if (IsDefined(eInflictor))
	{
		PrintLn("--eInflictor--");

		if (IsDefined(eInflictor.classname))
		{
			PrintLn("^6classname: " + eInflictor.classname);
		}

		if (IsDefined(eInflictor.targetname))
		{
			PrintLn("^6targetname: " + eInflictor.targetname);
		}
	}

	if (IsDefined(attacker))
	{
		PrintLn("--attacker--");

		if (IsDefined(attacker.classname))
		{
			PrintLn("^6classname: " + attacker.classname);
		}

		if (IsDefined(attacker.targetname))
		{
			PrintLn("^6targetname: " + attacker.targetname);
		}
	}

	if (IsDefined(iDamage))
	{
		PrintLn("--iDamage--");
		PrintLn("^6" + iDamage);
	}

	if (IsDefined(sMeansOfDeath))
	{
		PrintLn("--sMeansOfDeath--");
		PrintLn("^6" + sMeansOfDeath);
	}

	if (IsDefined(sWeapon))
	{
		PrintLn("--sWeapon--");
		PrintLn("^6" + sWeapon);
	}

	PrintLn("\n^6[[ /Player Killed ]]");
}
#/

Callback_ActorKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime )
{
	if( IsDefined( self.overrideActorKilled ) )
	{
		self [[self.overrideActorKilled]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime );
	}
	else if( IsDefined( level.overrideActorKilled ) )
	{
		self [[level.overrideActorKilled]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime );
	}

	self Callback("on_actor_killed");
}


Callback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	self endon("death");

	if( IsDefined( self.overrideVehicleDamage ) )
	{
		iDamage = self [[self.overrideVehicleDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName );
	}
	else if( IsDefined( level.overrideVehicleDamage ) )
	{
		iDamage = self [[level.overrideVehicleDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName );
	}

	assert(IsDefined(iDamage), "You must return a value from a damage override function.");

	self Callback("on_vehicle_damage");

	if( self IsVehicleImmuneToDamage( iDFlags, sMeansOfDeath, sWeapon ) )		// this checks the GDT settings
	{
		return;
	}

	if( self maps\_vehicle::friendlyfire_shield_callback( eAttacker, iDamage, sMeansOfDeath ) )
	{
		return;
	}
	
	// TFLAME - 2/4/2011- adding damage feedback support, only called if damage feedback is initialized
	if ( IsDefined(eAttacker) && isplayer(eAttacker) )
	{
		if ( iDamage > 0 && self.health > 0 )
		{
			eAttacker thread maps\_damagefeedback::updateDamageFeedback();
		}
		
		if ( self.health - iDamage <= 0 )
		{
			eAttacker inc_general_stat( "mechanicalkills" );
		}
	}
	
	// Save last damage mod
	self.last_damage_mod = sMeansOfDeath;
	
	self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName, false);
}

// this function is going to handle waiting for player input or programmed delays before starting the spawn
spawnClient()
{
	self endon( "disconnect" ); 
	self endon( "end_respawn" ); 

	println( "*************************spawnClient****" ); 

	// CODER_MOD
	// Austin( 6/20/07 ): added spectate camera
	
	// shut off the spectate cam
	self unlink(); 
	
	if( isdefined( self.spectate_cam ) )
	{
		self.spectate_cam delete(); 
	}

	if( level.otherPlayersSpectate )
	{
		self thread	[[level.spawnSpectator]](); 
	}
	else
	{
		self thread	[[level.spawnPlayer]](); 
	}
}

spawnPlayer( spawnOnHost )
{
	self endon( "disconnect" ); 
	self endon( "spawned_spectator" ); 
	self notify( "spawned" ); 
	self notify( "end_respawn" ); 

	// Be sure everyone is connected before actually spawning in.
	// Wait until all players are connected
	synchronize_players(); 

	setSpawnVariables(); 
	
	self.sessionstate = "playing"; 
	self.spectatorclient = -1; 
	self.archivetime = 0; 
	self.psoffsettime = 0; 
	self.statusicon = ""; 
//	self.maxhealth = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "maxhealth" ); 
//	self.health = self.maxhealth; 
	self.maxhealth = self.health; 
	self.shellshocked = false; 
	self.inWater = false; 
	self.friendlydamage = undefined; 
	self.hasSpawned = true; 
	self.spawnTime = getTime(); 
	self.afk = false; 

	println( "*************************spawnPlayer****" ); 
	self detachAll(); 

	if( IsDefined( level.custom_spawnPlayer ) )
	{
		self [[level.custom_spawnPlayer]]();
		return;
	}

	if( isdefined( level.onSpawnPlayer ) )
	{
		self [[level.onSpawnPlayer]](); 
	}

	wait_for_first_player(); 
	
	if( isdefined( spawnOnHost ) )
	{
		self Spawn( get_players()[0].origin, get_players()[0].angles ); 
		self SetPlayerSpawnPos(); 
	}
	else
	{
		self Spawn( self.origin, self.angles ); 			
	}

	if( isdefined( level.onPostSpawnPlayer ) )
	{
		self[[level.onPostSpawnPlayer]](); 
	}

	if( isdefined( level.onPlayerWeaponSwap ) )
	{
		self thread[[level.onPlayerWeaponSwap]](); 
	}

	// Insert all checks for other utility scripts here...
	// If you do not thread it, make sure it immediately finishes the function( no waits )
	self maps\_introscreen::introscreen_player_connect(); 

	// should not need this wait.  something in the spawn overides the weapons
	waittillframeend; 
	
	// CODER_MOD
	// Dan L( 08/01/06 ) we need to delay the rest of the creation process, until the messages dealing with the
	// spawning of the player has finished propagating to remote clients.  This is not a good final solution.
	// Ultimately, this whole chain of code shouldn't be triggered off until the server has determined that the clients
	// have all received the map_restart message.
	
	if( self != get_players("all")[0] )
	{
		wait( 0.5 ); 
	}
	
	self notify( "spawned_player" ); 
}


synchronize_players()
{
	// If this flag is not set, then we are either in a testmap or reflection probes is being called
	if( !IsDefined( level.flag ) || !IsDefined( level.flag["all_players_connected"] ) )
	{
		println( "^1****    ERROR: You must call _load::main() if you don't want bad coop things to happen!    ****" );
		println( "^1****    ERROR: You must call _load::main() if you don't want bad coop things to happen!    ****" );
		println( "^1****    ERROR: You must call _load::main() if you don't want bad coop things to happen!    ****" );
		return;
	}

	// MikeD( 6/2/2008 ): If the expected and connected players match, then don't even bother with
	// the synchronize screen.
	if( GetNumConnectedPlayers() == GetNumExpectedPlayers() )
	{
		return; 
	}

	if( flag( "all_players_connected" ) )
	{
		return; 
	}

	// CODER_MOD: Austin (8/15/08): rework to display briefing menu in online coop and black screen for splitscreen
	background = undefined;

	if ( level.onlineGame || level.systemLink ) 
	{
		self OpenMenu( "briefing" );
	}
	else
	{
		background = NewHudElem(); 
		background.x = 0; 
		background.y = 0; 
		background.horzAlign = "fullscreen"; 
		background.vertAlign = "fullscreen"; 
		background.foreground = true; 
		background SetShader( "black", 640, 480 ); 
	}
	
	flag_wait( "all_players_connected" );

	if ( level.onlineGame || level.systemLink ) 
	{
		players = get_players("all");

		for ( i = 0; i < players.size; i++ )
		{
			players[i] CloseMenu();
		}
	}
	else 
	{
		assert( IsDefined( background ) );
		background Destroy(); 
	}
}

spawnSpectator()
{
	self endon( "disconnect" ); 
	self endon( "spawned_spectator" ); 
	self notify( "spawned" ); 
	self notify( "end_respawn" ); 

	setSpawnVariables(); 
	
	self.sessionstate = "spectator"; 
	self.spectatorclient = -1; 
	if( isdefined( level.otherPlayersSpectateClient ) )
	{
		self.spectatorclient = level.otherPlayersSpectateClient getEntityNumber(); 
	}

	self setClientDvars( "cg_thirdPerson", 0 );	
	self setSpectatePermissions();
	
	self.archivetime = 0; 
	self.psoffsettime = 0; 
	self.statusicon = ""; 
//	self.maxhealth = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "maxhealth" ); 
//	self.health = self.maxhealth; 
	self.maxhealth = self.health; 
	self.shellshocked = false; 
	self.inWater = false; 
	self.friendlydamage = undefined; 
	self.hasSpawned = true; 
	self.spawnTime = getTime(); 
	self.afk = false; 

	println( "*************************spawnSpectator***" ); 
	self detachAll(); 

	if( isdefined( level.onSpawnSpectator ) )
	{
		self[[level.onSpawnSpectator]](); 
	}
	
	self Spawn( self.origin, self.angles ); 

	// should not need this wait.  something in the spawn overides the weapons
	waittillframeend; 
	
	flag_wait( "all_players_connected" ); 
	
	self notify( "spawned_spectator" ); 
}

setSpectatePermissions()
{
	self AllowSpectateTeam( "allies", true );
	self AllowSpectateTeam( "axis", false );
	self AllowSpectateTeam( "freelook", false );
	self AllowSpectateTeam( "none", false );
}

spawnIntermission()
{
	self notify( "spawned" ); 
	self notify( "end_respawn" ); 
	
	self setSpawnVariables(); 
	
	self freezeControls( false ); 
	
	self setClientDvar( "cg_everyoneHearsEveryone", "1" ); 
	
	self.sessionstate = "intermission"; 
	self.spectatorclient = -1; 
	self.killcamentity = -1; 
	self.archivetime = 0; 
	self.psoffsettime = 0; 
	self.friendlydamage = undefined; 
	
	[[level.onSpawnIntermission]](); 
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 ); 
}

default_onSpawnPlayer()
{
}


default_onPostSpawnPlayer()
{
}


default_onSpawnSpectator()
{
}

default_onSpawnIntermission()
{
	spawnpointname = "info_intermission"; 
	spawnpoints = getentarray( spawnpointname, "classname" ); 
	
	// CODER_MOD: TommyK (8/5/08)
	if(spawnpoints.size < 1)
	{
		println( "NO " + spawnpointname + " SPAWNPOINTS IN MAP" ); 
		return;
	}	
	
	spawnpoint = spawnpoints[RandomInt(spawnpoints.size)];	
	if( isDefined( spawnpoint ) )
	{
		self spawn( spawnpoint.origin, spawnpoint.angles ); 
	}
}

first_player_connect()
{
	waittillframeend; 

	if( isDefined( self ) )
	{
		level notify( "connecting", self ); 

		players = get_players(); 
		if( isdefined( players ) &&( players.size == 0 || players[0] == self ) )
		{
			level notify( "connecting_first_player", self ); 
			self waittill( "spawned_player" ); 
			
			waittillframeend; 
			
			level notify( "first_player_ready", self );

			if( !GameModeIsMode( level.GAMEMODE_ZOMBIES ) && !is_true( level.createfx_enabled ) )
			{
				prefetchnext();
			}

			self Callback("on_first_player_connect");
		}
	}
}

setSpawnVariables()
{
	resetTimeout(); 

	// Stop shellshock and rumble
	self StopShellshock(); 
	self StopRumble( "damage_heavy" ); 
}

