/******************************************************************* 
//						_perkfunctions.gsc  
//	
//	Holds all the perk set/unset and listening functions 
//	
//	Jordan Hirsh	Sept. 11th 	2008
********************************************************************/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\perks\_perks;


blastshieldUseTracker( perkName, useFunc )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "end_perkUseTracker" );
	level endon ( "game_ended" );

	for ( ;; )
	{
		self waittill ( "empty_offhand" );

		if ( !isOffhandWeaponEnabled() )
			continue;
			
		self [[useFunc]]( self _hasPerk( "_specialty_blastshield" ) );
	}
}

perkUseDeathTracker()
{
	self endon ( "disconnect" );
	
	self waittill("death");
	self._usePerkEnabled = undefined;
}

setRearView()
{
	//self thread perkUseTracker( "specialty_rearview", ::toggleRearView );
}

unsetRearView()
{
	self notify ( "end_perkUseTracker" );
}

toggleRearView( isEnabled )
{
	if ( isEnabled )
	{
		self _setPerk( "_specialty_rearview" );
		self SetRearViewRenderEnabled(true);
	}
	else
	{
		self _unsetPerk( "_specialty_rearview" );
		self SetRearViewRenderEnabled(false);
	}
}


setEndGame()
{
	if ( isdefined( self.endGame ) )
		return;
		
	self.maxhealth = ( maps\mp\gametypes\_tweakables::getTweakableValue( "player", "maxhealth" ) * 4 );
	self.health = self.maxhealth;
	self.endGame = true;
	self.attackerTable[0] = "";
	self visionSetNakedForPlayer("end_game", 5 );
	self thread endGameDeath( 7 );
	self.hasDoneCombat = true;
}


unsetEndGame()
{
	self notify( "stopEndGame" );
	self.endGame = undefined;
	revertVisionSet();
	
	if (! isDefined( self.endGameTimer ) )
		return;
	
	self.endGameTimer destroyElem();
	self.endGameIcon destroyElem();		
}


revertVisionSet()
{
	self VisionSetNakedForPlayer( getDvar( "mapname" ), 1 );	
}

endGameDeath( duration )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "joined_team" );
	level endon( "game_ended" );
	self endon( "stopEndGame" );
		
	wait( duration + 1 );
	//self visionSetNakedForPlayer("end_game2", 1 );
	//wait(1);
	self _suicide();			
}

setCombatHigh()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "end_game" );
	
	self.damageBlockedTotal = 0;
	//self visionSetNakedForPlayer( "end_game", 1 );

	self.combatHighOverlay = newClientHudElem( self );
	self.combatHighOverlay.x = 0;
	self.combatHighOverlay.y = 0;
	self.combatHighOverlay.alignX = "left";
	self.combatHighOverlay.alignY = "top";
	self.combatHighOverlay.horzAlign = "fullscreen";
	self.combatHighOverlay.vertAlign = "fullscreen";
	self.combatHighOverlay setshader ( "combathigh_overlay", 640, 480 );
	self.combatHighOverlay.sort = -10;
	
	self.combatHighTimer = createTimer( "default", 2.0 );
	self.combatHighTimer setPoint( "BOTTOM", "BOTTOM", 0, -40.0 );
	self.combatHighIcon = self createIcon( "specialty_painkiller", 24, 24 );
	self.combatHighIcon.alpha = 0;
	self.combatHighIcon setParent( self.combatHighTimer );
	self.combatHighIcon setPoint( "BOTTOM", "TOP" );
	self.combatHighTimer setTimer( 10.0 );
	self.combatHighTimer.color = (.8,.8,0);

	self.combatHighOverlay.alpha = 0.0;	
	self.combatHighOverlay fadeOverTime( 1.0 );
	self.combatHighIcon fadeOverTime( 1.0 );
	self.combatHighOverlay.alpha = 1.0;
	self.combatHighIcon.alpha = 1;
	
	wait( 8 );

	self.combatHighIcon	fadeOverTime( 2.0 );
	self.combatHighIcon.alpha = 0.0;
	
	self.combatHighOverlay fadeOverTime( 2.0 );
	self.combatHighOverlay.alpha = 0.0;
	
	self.combatHighTimer fadeOverTime( 2.0 );
	self.combatHighTimer.alpha = 0.0;

	wait( 2 );
	self.damageBlockedTotal = undefined;

	self _unsetPerk( "specialty_combathigh" );
}

unsetCombatHigh()
{
	self.combatHighOverlay destroy();
	self.combatHighIcon destroy();
	self.combatHighTimer destroy();
}

setSiege()
{
	self thread trackSiegeEnable();
	self thread trackSiegeDissable();
}

trackSiegeEnable()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "stop_trackSiege" );
	
	for ( ;; )
	{
		self waittill ( "gambit_on" );
		
		//self setStance( "crouch" );
		//self thread stanceStateListener();
		//self thread jumpStateListener();  
		self.moveSpeedScaler = 0;
		self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
		class = weaponClass( self getCurrentWeapon() );
		
		if ( class == "pistol" || class == "smg" ) 
			self setSpreadOverride( 1 );
		else
			self setSpreadOverride( 2 );
		
		self player_recoilScaleOn( 0 );
		self allowJump(false);	
	}	
}

trackSiegeDissable()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "stop_trackSiege" );
	
	for ( ;; )
	{
		self waittill ( "gambit_off" );
		
		unsetSiege();
	}	
}

stanceStateListener()
{
	self endon ( "death" );
	self endon ( "disconnect" );	
	
	self notifyOnPlayerCommand( "adjustedStance", "+stance" );

	for ( ;; )
	{
		self waittill( "adjustedStance" );
		if ( self.moveSPeedScaler != 0 )
			continue;
			
		unsetSiege();
	}
}

jumpStateListener()
{
	self endon ( "death" );
	self endon ( "disconnect" );	
	
	self notifyOnPlayerCommand( "jumped", "+goStand" );

	for ( ;; )
	{
		self waittill( "jumped" );
		if ( self.moveSPeedScaler != 0 )
			continue;
				
		unsetSiege();
	}
}

unsetSiege()
{
	self.moveSpeedScaler = 1;
	//if siege is not cut add check to see if
	//using lightweight and siege for movespeed scaler
	self resetSpreadOverride();
	self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
	self player_recoilScaleOff();
	self allowJump(true);
}


setFinalStand()
{
	self _setperk( "specialty_pistoldeath");
}

unsetFinalStand()
{
	self _unsetperk( "specialty_pistoldeath" );
}


setChallenger()
{
	if ( !level.hardcoreMode )
	{
		self.maxhealth = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "maxhealth" );
		
		if ( isDefined( self.xpScaler ) && self.xpScaler == 1 && self.maxhealth > 30 )
		{		
			self.xpScaler = 2;
		}	
	}
}

unsetChallenger()
{
	self.xpScaler = 1;
}


setSaboteur()
{
	self.objectiveScaler = 1.2;
}

unsetSaboteur()
{
	self.objectiveScaler = 1;
}


setLightWeight()
{
	self.moveSpeedScaler = 1.10;	
	self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
}

unsetLightWeight()
{
	self.moveSpeedScaler = 1;
	self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
}


setBlackBox()
{
	self.killStreakScaler = 1.5;
}

unsetBlackBox()
{
	self.killStreakScaler = 1;
}

setSteelNerves()
{
	self _setperk( "specialty_bulletaccuracy" );
	self _setperk( "specialty_holdbreath" );
}

unsetSteelNerves()
{
	self _unsetperk( "specialty_bulletaccuracy" );
	self _unsetperk( "specialty_holdbreath" );
}

setDelayMine()
{
}

unsetDelayMine()
{
}


setBackShield()
{
	self AttachShieldModel( "weapon_riot_shield_mp", "tag_shield_back" );	
}


unsetBackShield()
{
	self DetachShieldModel( "weapon_riot_shield_mp", "tag_shield_back" );
}


setLocalJammer()
{
	if ( !self isEMPed() )
		self RadarJamOn();
}


unsetLocalJammer()
{
	self RadarJamOff();
}


setAC130()
{
	self thread killstreakThink( "ac130", 7, "end_ac130Think" );
}

unsetAC130()
{
	self notify ( "end_ac130Think" );
}


setSentryMinigun()
{
	self thread killstreakThink( "airdrop_sentry_minigun", 2, "end_sentry_minigunThink" );
}

unsetSentryMinigun()
{
	self notify ( "end_sentry_minigunThink" );
}

setCarePackage()
{
	self thread killstreakThink( "airdrop", 2, "endCarePackageThink" );
}

unsetCarePackage()
{
	self notify ( "endCarePackageThink" );
}

setTank()
{
	self thread killstreakThink( "tank", 6, "end_tankThink" );
}

unsetTank()
{
	self notify ( "end_tankThink" );
}

setPrecision_airstrike()
{
	println( "!precision airstrike!" );
	self thread killstreakThink( "precision_airstrike", 6, "end_precision_airstrike" );
}

unsetPrecision_airstrike()
{
	self notify ( "end_precision_airstrike" );
}

setPredatorMissile()
{
	self thread killstreakThink( "predator_missile", 4, "end_predator_missileThink" );
}

unsetPredatorMissile()
{
	self notify ( "end_predator_missileThink" );
}


setHelicopterMinigun()
{
	self thread killstreakThink( "helicopter_minigun", 5, "end_helicopter_minigunThink" );
}

unsetHelicopterMinigun()
{
	self notify ( "end_helicopter_minigunThink" );
}



killstreakThink( streakName, streakVal, endonString )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( endonString );
	
	for ( ;; )
	{
		self waittill ( "killed_enemy" );
		
		if ( self.pers["cur_kill_streak"] != streakVal )
			continue;

		self thread maps\mp\killstreaks\_killstreaks::giveKillstreak( streakName );
		self thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( streakName, streakVal );
		return;
	}
}


setThermal()
{
	self ThermalVisionOn();
}


unsetThermal()
{
	self ThermalVisionOff();
}


setOneManArmy()
{
	self thread oneManArmyWeaponChangeTracker();
	self.OMAClassChanged = false;
}


unsetOneManArmy()
{
	self notify ( "stop_oneManArmyTracker" );
}


oneManArmyWeaponChangeTracker()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "stop_oneManArmyTracker" );
	
	for ( ;; )
	{
		self waittill( "weapon_change", newWeapon );

		if ( newWeapon != "onemanarmy_mp" ) 		
			continue;
	
		//if ( self isUsingRemote() )
		//	continue;
		
		self thread selectOneManArmyClass();	
	}
}


selectOneManArmyClass()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	self openPopupMenu( "changeclass_onemanarmy" );
	
	self waittill ( "menuresponse", menu, className );
	
	if ( menu != "changeclass_onemanarmy" || className == "back" )
	{
		if ( self getCurrentWeapon() == "onemanarmy_mp" )
		{
			self _disableWeaponSwitch();
			self switchToWeapon( self getLastWeapon() );
			self waittill ( "weapon_change" );
			self _enableWeaponSwitch();
		}
		return;
	}	
	
	self thread giveOneManArmyClass( className );	
}


giveOneManArmyClass( className )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	if ( self _hasPerk( "specialty_omaquickchange" ) )
	{
		changeDuration = 3.0;
		self playLocalSound( "foly_onemanarmy_bag3_plr" );
		self playSoundToTeam( "foly_onemanarmy_bag3_npc", "allies", self );
		self playSoundToTeam( "foly_onemanarmy_bag3_npc", "axis", self );
	}
	else
	{
		changeDuration = 6.0;
		self playLocalSound( "foly_onemanarmy_bag6_plr" );
		self playSoundToTeam( "foly_onemanarmy_bag6_npc", "allies", self );
		self playSoundToTeam( "foly_onemanarmy_bag6_npc", "axis", self );
	}
		
	self thread omaUseBar( changeDuration );
		
	self _disableWeapon();
	self _disableOffhandWeapons();
	
	wait ( changeDuration );

	self _enableWeapon();
	self _enableOffhandWeapons();
	self.OMAClassChanged = true;

	self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], className, false );
	self notify ( "changed_kit" );
}


omaUseBar( duration )
{
	self endon( "disconnect" );
	
	useBar = createPrimaryProgressBar();
	useBarText = createPrimaryProgressBarText();
	useBarText setText( "Changing Kit..." );

	useBar updateBar( 0, 1 / duration );
	for ( waitedTime = 0; waitedTime < duration && isAlive( self ) && !level.gameEnded; waitedTime += 0.05 )
		wait ( 0.05 );
	
	useBar destroyElem();
	useBarText destroyElem();
}


setBlastShield()
{
	self thread blastshieldUseTracker( "specialty_blastshield", ::toggleBlastShield );
	self SetWeaponHudIconOverride( "primaryoffhand", "specialty_blastshield" );
}


unsetBlastShield()
{
	self notify ( "end_perkUseTracker" );
	self SetWeaponHudIconOverride( "primaryoffhand", "none" );
}

toggleBlastShield( isEnabled )
{
	if ( !isEnabled )
	{
		self VisionSetNakedForPlayer( "black_bw", 0.15 );
		wait ( 0.15 );
		self _setPerk( "_specialty_blastshield" );
		self VisionSetNakedForPlayer( getDvar( "mapname" ), 0 );
	}
	else
	{
		self VisionSetNakedForPlayer( "black_bw", 0.15 );
		wait ( 0.15 );	
		self _unsetPerk( "_specialty_blastshield" );
		self VisionSetNakedForPlayer( getDvar( "mapname" ), 0 );
	}
}


setFreefall()
{
	//eventually set a listener to do a roll when falling damage is taken
}

unsetFreefall()
{
}


setTacticalInsertion()
{
	self _giveWeapon( "flare_mp", 0 );
	self giveStartAmmo( "flare_mp" );
	
	self thread monitorTIUse();
}

unsetTacticalInsertion()
{
	self notify( "end_monitorTIUse" );
}

clearPreviousTISpawnpoint()
{
	self waittill_any ( "disconnect", "joined_team", "joined_spectators" );
	
	if ( isDefined ( self.setSpawnpoint ) )
		self deleteTI( self.setSpawnpoint );
}

updateTISpawnPosition()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	self endon ( "end_monitorTIUse" );
	
	while ( isReallyAlive( self ) )
	{
		if ( self isValidTISpawnPosition() )
			self.TISpawnPosition = self.origin;

		wait ( 0.05 );
	}
}

isValidTISpawnPosition()
{
	if ( CanSpawn( self.origin ) && self IsOnGround() )
		return true;
	else
		return false;
}

monitorTIUse()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	self endon ( "end_monitorTIUse" );

	self thread updateTISpawnPosition();
	self thread clearPreviousTISpawnpoint();
	
	for ( ;; )
	{
		self waittill( "grenade_fire", lightstick, weapName );
				
		if ( weapName != "flare_mp" )
			continue;
		
		//lightstick delete();
		
		if ( isDefined( self.setSpawnPoint ) )
			self deleteTI( self.setSpawnPoint );
		

		if ( self isValidTISpawnPosition() )
		{
			TIGroundPosition = playerPhysicsTrace( self.origin + (0,0,16), self.origin - (0,0,2048) );
			
			self.playerSpawnPos = self.origin;
			self.TISpawnPosition = TIGroundPosition + (0,0,1);
		}
		
		if ( !isDefined( self.TISpawnPosition ) )
			continue;
		
		glowStick = spawn( "script_model", self.TISpawnPosition );
		glowStick.angles = self.angles;
		glowStick.team = self.team;
		glowStick.enemyTrigger =  spawn( "script_origin", self.origin );
		glowStick thread GlowStickSetupAndWaitForDeath( self );
		glowStick.playerSpawnPos = self.playerSpawnPos;
		
		glowStick thread maps\mp\gametypes\_weapons::createBombSquadModel( "weapon_light_stick_tactical_bombsquad", "j_gun", level.otherTeam[self.team] );
		
		self.setSpawnPoint = glowStick;		
		return;
	}
}


GlowStickSetupAndWaitForDeath( owner )
{
	self setModel( level.spawnGlowModel["enemy"] );
	if ( level.teamBased )
		self maps\mp\_entityheadIcons::setTeamHeadIcon( self.team , (0,0,20) );
	else
		self maps\mp\_entityheadicons::setPlayerHeadIcon( owner, (0,0,20) );

	self thread GlowStickDamageListener( owner );
	self thread GlowStickEnemyUseListener( owner );
	self thread GlowStickUseListener( owner );
	self thread GlowStickTeamUpdater( level.otherTeam[self.team], level.spawnGlow["enemy"], owner );	

	dummyGlowStick = spawn( "script_model", self.origin+ (0,0,0) );
	dummyGlowStick.angles = self.angles;
	dummyGlowStick setModel( level.spawnGlowModel["friendly"] );
	dummyGlowStick setContents( 0 );
	dummyGlowStick thread GlowStickTeamUpdater( self.team, level.spawnGlow["friendly"] );
	
	dummyGlowStick playLoopSound( "emt_road_flare_burn" );

	self waittill ( "death" );
	
	dummyGlowStick stopLoopSound();
	dummyGlowStick delete();
}


GlowStickTeamUpdater( showForTeam, showEffect, owner )
{
	self endon ( "death" );
	
	// PlayFXOnTag fails if run on the same frame the parent entity was created
	wait ( 0.05 );
	
	//PlayFXOnTag( showEffect, self, "TAG_FX" );
	angles = self getTagAngles( "TAG_FX" );
	fxEnt = SpawnFx( showEffect, self getTagOrigin( "TAG_FX" ), anglesToForward( angles ), anglesToUp( angles ) );
	TriggerFx( fxEnt );
	
	self thread deleteOnDeath( fxEnt );
	
	for ( ;; )
	{
		self hide();
		fxEnt hide();
		foreach ( player in level.players )
		{
			if ( player.team == showForTeam )
			{
				self showToPlayer( player );
				fxEnt showToPlayer( player );
			}
		}
		
		level waittill_either ( "joined_team", "player_spawned" );
	}
}

deleteOnDeath( ent )
{
	self waittill( "death" );
	if ( isdefined( ent ) )
		ent delete();
}

GlowStickDamageListener( owner )
{
	self endon ( "death" );

	self setCanDamage( true );
	// use large health to work around teamkilling issue
	self.health = 5000;

	for ( ;; )
	{
		self waittill ( "damage", amount, attacker );

		if ( level.teambased && attacker.team == self.team && isDefined( owner ) && attacker != owner )
		{
			self.health += amount;
			continue;
		}
		
		array = [];
		array[0] = attacker;
		
		if ( self.health < (5000-20) )
		{
			attacker notify ( "destroyed_insertion", owner );
			//playFXOnTagForClients( level.spawnGlowSplat, self, "TAG_FX", array );
			if ( isDefined( owner ) )
				owner thread leaderDialogOnPlayer( "ti_destroyed" );

			attacker thread leaderDialogOnPlayer( "ti_destroyed" );
			
			playFX( level.spawnGlowSplat, self.origin);	
			attacker thread deleteTI( self );
		}
	}
}

GlowStickUseListener( owner )
{
	self endon ( "death" );
	level endon ( "game_ended" );
	owner endon ( "disconnect" );
	
	self setCursorHint( "HINT_NOICON" );
	self setHintString( &"MP_PICKUP_TI" );
	
	self setSelfUsable( owner );

	for ( ;; )
	{
		self waittill ( "trigger", player );
		
		player playSound( "chemlight_pu" );
		player thread setTacticalInsertion();
		player thread deleteTI( self );
	}
}

deleteTI( TI )
{
	if (isDefined( TI.enemyTrigger ) )
		TI.enemyTrigger Delete();
	
	TI Delete();
}

GlowStickEnemyUseListener( owner )
{
	self endon ( "death" );
	level endon ( "game_ended" );
	owner endon ( "disconnect" );
	
	self.enemyTrigger setCursorHint( "HINT_NOICON" );
	self.enemyTrigger setHintString( &"MP_DESTROY_TI" );
	self.enemyTrigger makeEnemyUsable( owner );
	
	for ( ;; )
	{
		self.enemyTrigger waittill ( "trigger", player );
		
		player notify ( "destroyed_insertion", owner );
		playFX( level.spawnGlowSplat, self.origin);		
		
		if ( isDefined( owner ) )
			owner thread leaderDialogOnPlayer( "ti_destroyed" );

		player thread leaderDialogOnPlayer( "ti_destroyed" );

		player thread deleteTI( self );
	}	
}

setLittlebirdSupport()
{
	self thread killstreakThink( "littlebird_support", 2, "end_littlebird_support_think" );
}

unsetLittlebirdSupport()
{
	self notify ( "end_littlebird_support_think" );
}

setC4Death()
{
	if ( ! self _hasperk( "specialty_pistoldeath" ) )
		self _setperk( "specialty_pistoldeath");
}

unsetC4Death()
{

}