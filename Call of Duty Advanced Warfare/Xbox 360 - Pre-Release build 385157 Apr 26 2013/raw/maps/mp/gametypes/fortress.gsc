#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
/*
	Fortress
	Objective: 	Destroy the enemy's barricades to reach their Control Center. Destroy the Control Center.
	Map ends:	when one team's Control Center has been destroyed.
	Respawning:	No wait / Near teammates

	Level requirementss
	------------------
		Spawnpoints:
			classname		mp_ctf_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			At least one is required, any more and they are randomly chosen between.
*/

/*QUAKED mp_tdm_spawn (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_tdm_spawn_axis_start (0.5 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_allies_start (0.0 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	if ( isUsingMatchRulesData() )
	{
		level.initializeMatchRules = ::initializeMatchRules;
		[[level.initializeMatchRules]]();
		level thread reInitializeMatchRulesOnMigration();
	}
	else
	{
		registerTimeLimitDvar( level.gameType, 10 );
		registerScoreLimitDvar( level.gameType, 3 );
		registerRoundLimitDvar( level.gameType, 2 );
		registerWinLimitDvar( level.gameType, 1 );
		registerNumLivesDvar( level.gameType, 0 );
		registerHalfTimeDvar( level.gameType, 0 );
		
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;
	}

	level.teamBased = true;
	level.objectiveBased = true;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onNormalDeath = ::onNormalDeath;
	level.onTimeLimit = ::onTimeLimit;
	level.onRespawnDelay = ::onRespawnDelay;
	
	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;

	//game["dialog"]["gametype"] = "tm_death";
	
	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "camera_thirdPerson" ) )
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "scr_diehard" ) )
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	else if (getDvarInt( "scr_" + level.gameType + "_promode" ) )
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";
	
	level.fortress_barricade_model = "fortress_barricade_test";
	level.fortress_barricade_collision = GetEnt("fortress_barricade_collision", "targetname");

	SetDvarIfUninitialized( "scr_fortress_barricade_health", 3000 );
	SetDvarIfUninitialized( "scr_fortress_bombtimer", 30 );
	SetDvarIfUninitialized( "scr_fortress_planttime", 2 );
	SetDvarIfUninitialized( "scr_fortress_defusetime", 4 );
	SetDvarIfUninitialized( "scr_fortress_flagtime", 11 );
}


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar( "scr_fortress_roundlimit", 1 );
	registerRoundLimitDvar( "fortress", 1 );
	SetDynamicDvar( "scr_fortress_winlimit", 1 );
	registerWinLimitDvar( "fortress", 1 );
	SetDynamicDvar( "scr_fortress_halftime", 0 );
	registerHalfTimeDvar( "fortress", 0 );
		
	SetDynamicDvar( "scr_fortress_promode", 0 );
}


onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	else if ( game["switchedsides"] )
		setDvar( "ui_override_halftime", 2 );
	else
		setDvar( "ui_override_halftime", 1 );

	if ( !isdefined( game["original_defenders"] ) )
		game["original_defenders"] = game["defenders"];

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}

	//If it's the first round, the Defenders' score will be set to zero.
	//If it's Round 2, the Defenders' score will be set to the Attackers' score from the previous round.
	SetTeamScore(game["defenders"], game["teamScores"][game["defenders"]]);
	
	setClientNameMode("auto_change");

	setObjectiveText( game["attackers"], &"OBJECTIVES_FORTRESS_ATTACKER" );
	setObjectiveText( game["defenders"], &"OBJECTIVES_FORTRESS_DEFENDER" );

	if ( level.splitscreen )
	{
		setObjectiveScoreText( game["attackers"], &"OBJECTIVES_FORTRESS_ATTACKER" );
		setObjectiveScoreText( game["defenders"], &"OBJECTIVES_FORTRESS_DEFENDER" );
	}
	else
	{
		setObjectiveScoreText( game["attackers"], &"OBJECTIVES_FORTRESS_ATTACKER_SCORE" );
		setObjectiveScoreText( game["defenders"], &"OBJECTIVES_FORTRESS_DEFENDER_SCORE" );
	}
	setObjectiveHintText( game["attackers"], &"OBJECTIVES_FORTRESS_ATTACKER_HINT" );
	setObjectiveHintText( game["defenders"], &"OBJECTIVES_FORTRESS_DEFENDER_HINT" );
	
	initSpawns();
	
	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 20 );
	maps\mp\gametypes\_rank::registerScoreInfo( "barricade_destroy", 500 );
	maps\mp\gametypes\_rank::registerScoreInfo( "plant", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defuse", 100 );
	
	level._effect["bombexplosion"] = loadfx("explosions/tanker_explosion");
	
	thread fortress();
}

initSpawns()
{
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_ctf_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_ctf_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_ctf_spawn_allies" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_ctf_spawn_axis" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
}


/*
///ScriptDocBegin
Name: fortress( )
Summary: setup Fortress flags and barricades.
Module: fortress
CallOn: N/A
MandatoryArg: N/A
Example: thread fortress();
SPMP: MP
///ScriptDocEnd
*/
fortress()
{
	level.attacker_respawn_delay = GetDvarInt( "scr_fortress_attacker_respawndelay", 0 );
	level.defender_respawn_delay = GetDvarInt( "scr_fortress_defender_respawndelay", 5 );
	
	game["flagmodels"]["allies"] = maps\mp\gametypes\_teams::getTeamFlagModel( "allies" );
	game["flagmodels"]["axis"] = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );
	precacheModel( game["flagmodels"]["allies"] );
	precacheModel( game["flagmodels"]["axis"] );
	
	precacheString( &"MP_SECURING_POSITION" );
	
	//Old Fortress
//	thread spawnBarricades();
//	allies_flag = GetEnt("fortress_flag_allies", "targetname");
//	level.teamFlags[game["attackers"]] = createTeamFlag(game["attackers"], allies_flag);
//	axis_flag = GetEnt("fortress_flag_axis", "targetname");s
//	level.teamFlags[game["defenders"]] = createTeamFlag(game["defenders"], axis_flag);
	
	thread createTeamFlags( game["defenders"] );
	
	thread findFortressForceFields();
}


getSpawnPoint()
{
	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	if ( level.inGracePeriod )
	{
		spawnPoints = getentarray("mp_ctf_spawn_" + spawnteam + "_start", "classname");
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	return spawnPoint;
}


onNormalDeath( victim, attacker, lifeId )
{
	score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	assert( isDefined( score ) );

	if ( game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][level.otherTeam[attacker.team]] )
		attacker.finalKill = true;
}


onTimeLimit()
{
	game["roundsWon"][game["attackers"]] = game["teamScores"][game["attackers"]];
	
	if ( game["switchedsides"] )
	{
		//	whoever is winning wins the round
//		if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
//			game["roundsWon"]["axis"]++;
//		else if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
//			game["roundsWon"]["allies"]++;

//		game["teamScores"]["axis"] = game["roundsWon"]["axis"];
//		game["teamScores"]["allies"] = game["roundsWon"]["allies"];
//		setTeamScore( "axis", game["teamScores"]["axis"] );
//		setTeamScore( "allies", game["teamScores"]["allies"] );
		
//		if ( game["roundsWon"]["axis"] > game["roundsWon"]["allies"] )
		if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		{
			//	win game
			level.finalKillCam_winner = "axis";
			thread maps\mp\gametypes\_gamelogic::endGame( "axis", game["strings"]["time_limit_reached"] );
			return;
		}
//		else if ( game["roundsWon"]["allies"] > game["roundsWon"]["axis"] )
		else if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
		{
			//	win game
			level.finalKillCam_winner = "allies";
			thread maps\mp\gametypes\_gamelogic::endGame( "allies", game["strings"]["time_limit_reached"] );
			return;
		}
		else
		{
			//	tie, end game
	level.finalKillCam_winner = "none";
			thread maps\mp\gametypes\_gamelogic::endGame( "tie", game["strings"]["time_limit_reached"] );
		}
	}
	else
	{
		level.finalKillCam_winner = game["defenders"];
//		setTeamScore( "axis", game["teamScores"]["axis"] );
//		setTeamScore( "allies", game["teamScores"]["allies"] );
		thread maps\mp\gametypes\_gamelogic::endGame( "halftime", game["strings"]["time_limit_reached"] );
	}
}

	
onRespawnDelay()
{
	if( self.team == game["attackers"] )
	{
		return level.attacker_respawn_delay;
	}
	else
	{
		return level.defender_respawn_delay;
	}	
}


/*
///ScriptDocBegin
Name: spawnBarricades( )
Summary: spawn Fortress Barricades on fortress_barricade_node script_origins. Use fortress_barricade xmodel and fortress_barricade_collision script_brushmodel.
Module: fortress
CallOn: N/A
MandatoryArg: N/A
Example: thread spawnBarricades();
SPMP: MP
///ScriptDocEnd
*/
//spawnBarricades()
//{
//	//Get allies' barricades.
//	barricade_nodes_allies = GetEntArray("fortress_barricade_allies", "targetname");
//	//Get axis' barricades.
//	barricade_nodes_axis = GetEntArray("fortress_barricade_axis", "targetname");
//	
//	setupBarricades(barricade_nodes_allies, game["attackers"]);
//	setupBarricades(barricade_nodes_axis, game["defenders"]);
//}
	

/*
///ScriptDocBegin
Name: setupBarricades( <barricade_array>, <barricade_team> )
Summary: set up the barricades in a foreach loop.
Module: fortress
CallOn: N/A
MandatoryArg: <barricade_array> [array] an array of barricade nodes returned from a call to GetEntArray().
MandatoryArg: <barricade_team> [string] the team that owns the barricade (either "allies" or "axis").
Example: thread setupBarricades();
SPMP: MP
///ScriptDocEnd
*/
//setupBarricades(barricade_array, barricade_team)
//{
//	if (IsDefined(barricade_array))
//	{
//		foreach (barricade_node in barricade_array)
//		{
//			barricade_node.script_model = Spawn("script_model", barricade_node.origin);
//			barricade_node.script_model.angles = barricade_node.angles;
//			barricade_node.script_model.team = barricade_team;
//			barricade_node.script_model SetModel(level.fortress_barricade_model);
//			barricade_node.script_model CloneBrushmodelToScriptmodel(level.fortress_barricade_collision);
//			barricade_node.script_model SetCanDamage(true);
//			barricade_node.script_model SetCanRadiusDamage(true);
//			barricade_node.script_model.hidden = false;
//			barricade_node.script_model.destroyed = false;
//			barricade_node.script_model.health = 999999;		//keep it from dying anywhere in code (see barricade_handleDamage())
//			barricade_node.script_model.maxHealth = getDvarInt( "scr_fortress_barricade_health", 3000 );		//this is the health we'll check (see barricade_handleDamage())
//			barricade_node.script_model.damageTaken = 0;		//how much damage has it taken
//			barricade_node.script_model thread barricadeHandleDamage();
//			barricade_node.script_model thread barricade_handleDeath();
//		}
//	}
//}


//Based on ims_handleDamage() in _ims.gsc
/*
///ScriptDocBegin
Name: barricadeHandleDamage( )
Summary: checks for and applies damage to Fortress barricades.
Module: fortress
CallOn: a barricade
MandatoryArg: N/A
Example: barricade thread barricadeHandleDamage();
SPMP: MP
///ScriptDocEnd
*/
//barricadeHandleDamage()
//{
//	self endon( "death" );
//	level endon( "game_ended" );
//	
//	while( true )
//	{
//		self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, modelName, tagName, partName, iDFlags, weapon );
//
//		//If the player is attacking his/her own team's barricade, continue and do no damage.
//		if ( self.team == attacker.team )
//			continue;
//
//		if ( IsDefined( weapon ) )
//		{
//			switch( weapon )
//			{
//			case "concussion_grenade_mp":
//			case "flash_grenade_mp":
//			case "smoke_grenade_mp":
//			//case "ims_projectile_mp": // shouldn't take damage from itself or another one // now it should!
//				continue;
//			}
//		}
//
//		if ( !IsDefined( self ) )
//			return;
//		
//		// if this is hidden we don't want it to take damage
//		if( self.hidden )
//			continue;
//		
//		//melee should not do damage to barricades.
//		if ( meansOfDeath == "MOD_MELEE" )
//			continue;
//		
//		if( IsExplosiveDamageMOD( meansOfDeath ) )
//			damage *= 1.5;
//		
//		if ( isDefined( iDFlags ) && ( iDFlags & level.iDFLAGS_PENETRATION ) )
//			self.wasDamagedFromBulletPenetration = true;
//		
//		self.wasDamaged = true;
//
//		modifiedDamage = damage;
//		if ( isPlayer( attacker ) )
//		{
//			attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "ims" );
//
//			if ( attacker _hasPerk( "specialty_armorpiercing" ) )
//			{
//				modifiedDamage = damage * level.armorPiercingMod;
//			}
//		}
//
//		// in case we are shooting from a remote position, like being in the osprey gunner shooting this
//		if( IsDefined( attacker.owner ) && IsPlayer( attacker.owner ) )
//		{
//			attacker.owner maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "ims" );
//		}
//
//		if( IsDefined( weapon ) )
//		{
//			switch( weapon )
//			{
//			case "ac130_105mm_mp":
//			case "ac130_40mm_mp":
//			case "stinger_mp":
//			case "javelin_mp":
//			case "remote_mortar_missile_mp":
//			case "remotemissile_projectile_mp":
//				self.largeProjectileDamage = true;
//				modifiedDamage = self.maxHealth + 1;
//				break;
//
//			case "artillery_mp":
//			case "stealth_bomb_mp":
//				self.largeProjectileDamage = false;
//				modifiedDamage += ( damage * 4 );
//				break;
//
//			case "bomb_site_mp":
//			case "emp_grenade_mp":
//				self.largeProjectileDamage = false;
//				modifiedDamage = self.maxHealth + 1;
//				break;
//			}
//			
//			maps\mp\killstreaks\_killstreaks::killstreakHit( attacker, weapon, self );
//		}
//
//		self.damageTaken += modifiedDamage;
//		
//		if ( self.damageTaken >= self.maxHealth )
//		{
//			//thread maps\mp\gametypes\_missions::vehicleKilled( self.owner, self, undefined, attacker, damage, meansOfDeath, weapon );
//			
//			self.destroyed = true;
//			
//			if ( isPlayer( attacker ) )
//			{
//				//Using barricade_destroy event type.
//				attacker thread maps\mp\gametypes\_rank::giveRankXP( "barricade_destroy", 200, weapon, meansOfDeath );
//				//maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( attacker.pers["team"], 1 );
//				maps\mp\gametypes\_gamescore::givePlayerScore( "barricade_destroy", attacker );
//				attacker notify( "destroyed_killstreak" );
//				//attacker notify( "destroyed_explosive" );
//				thread playSoundOnPlayers( "mp_capture_flag", attacker.pers["team"] );
//				//attacker thread maps\mp\gametypes\_hud_message::SplashNotify( "callout_destroyed_objective" );
//				attacker thread maps\mp\gametypes\_hud_message::SplashNotify( "drop_pod_destroy", maps\mp\gametypes\_rank::getScoreInfoValue( "capture" ) );
//				level thread teamPlayerCardSplash( "callout_destroyed_objective", attacker );
//			}
//
//			//if ( isDefined( self.owner ) )
//			//	self.owner thread leaderDialogOnPlayer( "ims_destroyed", undefined, undefined, self.origin );
//
//			self notify ( "death" );
//			return;
//		}
//	}
//}


//Based on ims_handleDeath() in _ims.gsc
/*
///ScriptDocBegin
Name: barricade_handleDeath( )
Summary: Handles death for a Fortress barricade.
Module: fortress
CallOn: a barricade
Example: barricade thread barricade_handleDeath();
SPMP: MP
///ScriptDocEnd
*/
//barricade_handleDeath()
//{
//	entNum = self GetEntityNumber();
//
//	//self addToIMSList( entNum );
//
//	self waittill ( "death" );
//
//	//self removeFromIMSList( entNum );
//
//	// this handles cases of deletion
//	if ( !isDefined( self ) )
//		return;
//
//	//self setModel( level.imsSettings[ self.imsType ].modelDestroyed );
//
//	//self ims_setInactive();
//
//	// TODO: get sound for this
//	self playSound( "ims_destroyed" );
//
//	/*if ( isDefined( self.inUseBy ) )
//	{
//		PlayFX( getfx( "ims_explode_mp" ), self.origin + ( 0, 0, 10 ) );
//		PlayFX( getfx( "ims_smoke_mp" ), self.origin );
//		//playFxOnTag( getFx( "ims_explode_mp" ), self, "tag_origin" );
//		//playFxOnTag( getFx( "ims_smoke_mp" ), self, "tag_origin" );
//
//		self.inUseBy restorePerks();
//		self.inUseBy restoreWeapons();
//
//		self notify( "deleting" );
//		wait ( 1.0 );
//		//StopFXOnTag( getFx( "ims_explode_mp" ), self, "tag_origin" );
//		//StopFXOnTag( getFx( "ims_smoke_mp" ), self, "tag_origin" );
//	}	
//	else
//	{*/
//	PlayFX( getfx( "ims_explode_mp" ), self.origin + ( 0, 0, 10 ) );
//	//playFxOnTag( getFx( "ims_explode_mp" ), self, "tag_origin" );
//	wait ( 0.5 );
//	
//	// this handles cases of deletion again, after the above wait().
//	//We have to make multiple checks after waits because this pod may have been deleted during the wait (when the player respawns).
//	if ( !isDefined( self ) )
//		return;
//	
//	// TODO: get sound for this
//	self playSound( "ims_fire" );
//	for ( smokeTime = 4; smokeTime > 0; smokeTime -= 0.4 )
//	{
//		// this handles cases of deletion again, after the wait() in this for-loop.
//		//We have to make multiple checks after waits because this pod may have been deleted during the wait (when the player respawns).
//		if ( !isDefined( self ) )
//			return;
//	
//		PlayFX( getfx( "ims_smoke_mp" ), self.origin );
//		//playFxOnTag( getFx( "ims_smoke_mp" ), self, "tag_origin" );
//		wait ( 0.4 );
//	}
//	self notify( "deleting" );
//	//}
//
//	/*
//	if ( isDefined( self.objIdFriendly ) )
//		_objective_delete( self.objIdFriendly );
//
//	if ( isDefined( self.objIdEnemy ) )
//		_objective_delete( self.objIdEnemy );
//
//	if( IsDefined( self.lid1 ) )
//		self.lid1 delete();
//	if( IsDefined( self.lid2 ) )
//		self.lid2 delete();
//	if( IsDefined( self.lid3 ) )
//		self.lid3 delete();
//	if( IsDefined( self.lid4 ) )
//		self.lid4 delete();
//
//	if( IsDefined( self.explosive1 ) )
//	{
//		if( IsDefined( self.explosive1.killCamEnt ) )
//			self.explosive1.killCamEnt delete();
//		self.explosive1 delete();
//	}
//	if( IsDefined( self.explosive2 ) )
//	{
//		if( IsDefined( self.explosive2.killCamEnt ) )
//			self.explosive2.killCamEnt delete();
//		self.explosive2 delete();
//	}
//	if( IsDefined( self.explosive3 ) )
//	{
//		if( IsDefined( self.explosive3.killCamEnt ) )
//			self.explosive3.killCamEnt delete();
//		self.explosive3 delete();
//	}
//	if( IsDefined( self.explosive4 ) )
//	{
//		if( IsDefined( self.explosive4.killCamEnt ) )
//			self.explosive4.killCamEnt delete();
//		self.explosive4 delete();
//	}
//	*/
//
//	if (IsDefined(self))
//	{
//		self delete();
//	}
//}


/*
///ScriptDocBegin
Name: createTeamFlag( )
Summary: creates a team's flag useobject for Fortress mode.
Module: fortress
CallOn: N/A
MandatoryArg: <team> - the team to set as the owner of the flag.
MandatoryArg: <flagEnt> - the script_origin entity to use for the flag's origin.
Example: thread createTeamFlag();
SPMP: MP
///ScriptDocEnd
*/
createTeamFlags( team )
{
	level endon( "game_ended" );
	level.fortress_flags = GetEntArray( "fortress_flag", "targetname" );
	
	foreach ( axisflag in level.fortress_flags )
	{
		trigger = Spawn("trigger_radius", axisflag.origin, 0, 128, 128);
		visuals[0] = Spawn("script_model", axisflag.origin);
		visuals[0] SetModel(game["flagmodels"][team]);
		axisflag.useObject = maps\mp\gametypes\_gameobjects::createUseObject( team, trigger, visuals, (0,0,100) );
		axisflag.useObject.label = axisflag.script_label;
		Assert( IsDefined( axisflag.useObject.label ) );
		axisflag.useObject maps\mp\gametypes\_gameobjects::setUseTime( GetDvarInt( "scr_fortress_flagtime", 11 ) );
		axisflag.useObject maps\mp\gametypes\_gameobjects::allowUse("enemy");
		axisflag.useObject maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_OBJECTIVE" );
		axisflag.useObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_defend" + axisflag.useObject.label );
		axisflag.useObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + axisflag.useObject.label );
		axisflag.useObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_captureneutral" + axisflag.useObject.label );
		axisflag.useObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" + axisflag.useObject.label );
		axisflag.useObject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		axisflag.useObject.onUse = ::onUseFlag;
		axisflag.useObject.onBeginUse = ::onBeginUseFlag;
		axisflag.useObject.onUseUpdate = ::onUseFlagUpdate;
		axisflag.useObject.onEndUse = ::onEndUseFlag;
		axisflag.useObject thread hideFlag( visuals[0] );
	}
}


/*
///ScriptDocBegin
Name: onUseFlag( player )
Summary: onUse function for the Fortress mode objective flags.
Module: fortress
CallOn: Fortress mode objective flag
MandatoryArg: <player> - the player that just used the Fortress objective flag.
Example: N/A
SPMP: MP
///ScriptDocEnd
*/
onUseFlag( player )
		{
	team = player.pers["team"];
	oldTeam = getOtherTeam( team );
	self.captureTime = getTime();

	self maps\mp\gametypes\_gameobjects::disableObject();
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	
	thread playSoundOnPlayers( "mp_enemy_obj_captured", team );
	thread playSoundOnPlayers( "mp_lose_flag", oldteam );
	
	thread leaderDialog( "enemy_flag_captured", team, "status" );
	thread leaderDialog( "flag_captured", oldTeam, "status" );

	player notify( "objective", "captured" );
	self thread giveFlagCaptureXP( self.touchList[team] );
		
	player maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( team, 1 );
	SetTeamScore( team, game["teamScores"][team] );
		
	level thread checkRoundWin(team);
		
	self notify( "flag_capped" );
}
		
		
/*
///ScriptDocBegin
Name: checkRoundWin( team )
Summary: checks team scores and determines how to end the round/game.
Module: fortress
CallOn: level
MandatoryArg: <team> - the team that just scored a point.
Example: level thread checkRoundWin(team);
SPMP: MP
///ScriptDocEnd
*/
checkRoundWin( team )
{
	if ( game["teamScores"][team] == getWatchedDvar( "scorelimit" ) )
	{
		game["roundsWon"][team] = game["teamScores"][team];		//game["roundsWon"][team] is the number that appears between rounds. Without this line, scores always show as 0 - 0.

		if ( game["switchedsides"] )
		{
//			setTeamScore( team, game["teamScores"][team] );
//			setTeamScore( getOtherTeam( team ), game["teamScores"][getOtherTeam( team )] );

//			if ( game["roundsWon"][team] > game["roundsWon"][level.otherTeam[team]] )
			if ( game["teamScores"][team] > game["teamScores"][getOtherTeam( team )] )
			{
				level.finalKillCam_winner = team;
				thread maps\mp\gametypes\_gamelogic::endGame( team, game["strings"]["score_limit_reached"] );
			}
			else
			{
				//	tie, end game
				level.finalKillCam_winner = "none";
				thread maps\mp\gametypes\_gamelogic::endGame( "tie", game["strings"]["score_limit_reached"] );
			}
		}
		else
		{
//			setTeamScore( team, game["teamScores"][team] );
//			setTeamScore( getOtherTeam( team ), game["teamScores"][getOtherTeam( team )] );

			level.finalKillCam_winner = team;
			thread maps\mp\gametypes\_gamelogic::endGame( "halftime", game["strings"]["score_limit_reached"] );
		}
	}
		}


/*
///ScriptDocBegin
Name: onBeginUseFlag( player )
Summary: when someone starts to capture a Fortress objective flag, set icons and play leader dialog.
Module: fortress
CallOn: Fortress mode objective flag
MandatoryArg: <player> - the player that is using the objective flag.
Example: N/A
SPMP: MP
///ScriptDocEnd
*/
onBeginUseFlag( player )
		{
	team = player.pers["team"];
	
	//TODO:check touchlist - check if it's already set
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_defend_yellow" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend_yellow" );

	//Warning to the other team that the enemy is about to score.
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_capture" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture" );

	if ( IsDefined ( self.label ) )
	{
		//"Your team is taking the enemy flag."
		thread leaderDialog( "securing" + self.label, team, "status" );
		//"The enemy is taking your flag."
		thread leaderDialog( "losing" + self.label, getOtherTeam( team ), "status" );
			}
			
	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::startFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::startFlashing();
		}

		
onUseFlagUpdate( team, progress, change )
		{
}
			
			
/*
///ScriptDocBegin
Name: onEndUseFlag( team, player, success )
Summary: when someone stops capturing a Fortress mode objective flag, update icon.
Module: fortress
CallOn: Fortress mode objective flag
MandatoryArg: <team> - the team of the player that used the objective flag.
MandatoryArg: <player> - the player that used the objective flag.
MandatoryArg: <success> - was the use event successful?
Example: N/A
SPMP: MP
///ScriptDocEnd
*/
onEndUseFlag( team, player, success )
			{
	//TODO:make sure no one else is using before swapping
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_defend" + self.label );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + self.label );

	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_captureneutral" + self.label );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" + self.label );

	//self.visuals[0] setModel( game["flagmodels"][team] );
}


/*
///ScriptDocBegin
Name: giveFlagCaptureXP( touchList )
Summary: give flag capture XP to players.
Module: fortress
CallOn: Fortress mode objective flag
MandatoryArg: <touchList> the list of players that have used this Fortress mode objective flag.
Example: self thread giveFlagCaptureXP( self.touchList[team] );
SPMP: MP
///ScriptDocEnd
*/
giveFlagCaptureXP( touchList )
{
	level endon ( "game_ended" );
	
	players = getArrayKeys( touchList );
	for ( index = 0; index < players.size; index++ )
{
		player = touchList[players[index]].player;
		player thread maps\mp\gametypes\_hud_message::SplashNotify( "capture", maps\mp\gametypes\_rank::getScoreInfoValue( "capture" ) );
		//player thread updateCPM();
		player thread maps\mp\gametypes\_rank::giveRankXP( "capture", maps\mp\gametypes\_rank::getScoreInfoValue( "capture" ) );
		printLn( maps\mp\gametypes\_rank::getScoreInfoValue( "capture" ) );
		maps\mp\gametypes\_gamescore::givePlayerScore( "capture", player );

		//player incPlayerStat( "pointscaptured", 1 );
		//player incPersStat( "captures", 1 );
		player maps\mp\gametypes\_persistence::statSetChild( "round", "captures", player.pers["captures"] );

		if ( player != self )
			player notify( "objective", "assistedCapture" );
	}

	player = self maps\mp\gametypes\_gameobjects::getEarliestClaimPlayer();

	//level thread teamPlayerCardSplash( "callout_securedposition" + self.label, player );

	player thread maps\mp\_matchdata::logGameEvent( "capture", player.origin );
}


/*
///ScriptDocBegin
Name: findFortressForceFields( )
Summary: creates useobjects for all of the script_brushmodel force fields used in Fortress mode.
Module: fortress
CallOn: a force field
MandatoryArg: N/A
Example: thread findFortressForceFields();
SPMP: MP
///ScriptDocEnd
*/
findFortressForceFields()
{	
	level.forcefields = [];
	level.forcefields = GetEntArray( "fortress_forcefield", "targetname" );

	foreach (forcefield in level.forcefields)
	{
		if (IsDefined(forcefield))
	{
			forcefield.origin += (0, 0, 1024);		//Translating the forcefields up 1024 units because I put them under the world in the .map file.
			forcefield.trigger = GetEnt( forcefield.target, "targetname" );
			visuals[0] = Spawn("script_model", forcefield.origin);
			forcefield.plantLoc = maps\mp\gametypes\_gameobjects::createUseObject( game["defenders"], forcefield.trigger, visuals, (0,0,0) );
			forcefield.plantLoc.forcefieldbrushmodel = forcefield;
			forcefield.plantLoc.origin = forcefield.origin;
			forcefield.plantLoc maps\mp\gametypes\_gameobjects::setUseTime( GetDvarInt( "scr_fortress_planttime", 2 ) );
			forcefield.plantLoc maps\mp\gametypes\_gameobjects::allowUse("enemy");
			forcefield.plantLoc maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
			forcefield.plantLoc maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
			forcefield.plantLoc maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_defend" );
			forcefield.plantLoc maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
			forcefield.plantLoc maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
			forcefield.plantLoc.onBeginUse = ::onBeginUseForceField;
			forcefield.plantLoc.onEndUse = ::onEndUseForceField;
			forcefield.plantLoc.onUse = ::onUseForceField;
			forcefield.rad_trigger = Spawn("trigger_radius", forcefield.origin - ( 0, 0, 64 ), 0, 128, 128);
			forcefield thread lowerForcefield();
		}
	}
}


/*
///ScriptDocBegin
Name: onBeginUseForceField( player )
Summary: when a player starts to use a force field's useObject, play a sound.
Module: fortress
CallOn: a force field's useObject
MandatoryArg: <player> - the user of the force field's useObject.
Example: N/A
SPMP: MP
///ScriptDocEnd
*/
onBeginUseForceField( player )
{
	if ( !self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
		player.isPlanting = true;
	else
		player.isDefusing = true;
	}	
	
	
/*
///ScriptDocBegin
Name: onEndUseForceField( team, player, result )
Summary: called when a player stops using a force field's useObject.
Module: fortress
CallOn: a force field's useObject
MandatoryArg: <team> - team of the force field's user.
MandatoryArg: <player> - the player using the force field.
MandatoryArg: <result> - success or failure to use the force field's useObject.
Example: N/A
SPMP: MP
///ScriptDocEnd
*/
onEndUseForceField( team, player, result )
	{
	if ( !isDefined( player ) )
			return;
	
	if ( isAlive( player ) )
	{
		player.isDefusing = false;
		player.isPlanting = false;
	}
	}


	/*
///ScriptDocBegin
Name: onUseForceField( player )
Summary: called when a player has used force field's useObject to plant a bomb.
Module: fortress
CallOn: a force field's useObject
MandatoryArg: <player> - the player that used the bomb.
Example: N/A
SPMP: MP
///ScriptDocEnd
*/
onUseForceField( player )
{
	team = player.pers["team"];
	otherTeam = level.otherTeam[team];
	// planted the bomb
	if ( !self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		self thread bombPlanted( player );
		
		player playSound( "mp_bomb_plant" );
		player notify ( "bomb_planted" );
		player notify ( "objective", "plant" ); // gives adrenaline for killstreaks
		
		player incPersStat( "plants", 1 );
		player maps\mp\gametypes\_persistence::statSetChild( "round", "plants", player.pers["plants"] );
		
		//	bomb carrier class?
		if ( isDefined( level.sd_loadout ) && isDefined( level.sd_loadout[player.team] ) )
			player thread removeBombCarrierClass();	

		leaderDialog( "bomb_planted" );

		level thread teamPlayerCardSplash( "callout_bombplanted", player );

		level.bombOwner = player;
		player thread maps\mp\gametypes\_hud_message::SplashNotify( "plant", maps\mp\gametypes\_rank::getScoreInfoValue( "plant" ) );
		player thread maps\mp\gametypes\_rank::giveRankXP( "plant" );
		player.bombPlantedTime = getTime();
		maps\mp\gametypes\_gamescore::givePlayerScore( "plant", player );

		player thread maps\mp\_matchdata::logGameEvent( "plant", player.origin );

		self setUpForDefusing();
	}
	//defused the bomb
	else
	{
		self thread bombDefused();
		
		player notify ( "bomb_defused" );
		player notify ( "objective", "defuse" );  // gives adrenaline for killstreaks
		
		leaderDialog( "bomb_defused" );
	
		level thread teamPlayerCardSplash( "callout_bombdefused", player );
	
		if ( isDefined( level.bombOwner ) && ( level.bombOwner.bombPlantedTime + 3000 + ( GetDvarInt( "scr_fortress_defusetime", 4 ) * 1000) ) > getTime() && isReallyAlive( level.bombOwner ) )
			player thread maps\mp\gametypes\_hud_message::SplashNotify( "ninja_defuse", ( maps\mp\gametypes\_rank::getScoreInfoValue( "defuse" ) ) );
		else
			player thread maps\mp\gametypes\_hud_message::SplashNotify( "defuse", maps\mp\gametypes\_rank::getScoreInfoValue( "defuse" ) );
		
		player thread maps\mp\gametypes\_rank::giveRankXP( "defuse" );
		maps\mp\gametypes\_gamescore::givePlayerScore( "defuse", player );		
		
		player incPersStat( "defuses", 1 );
		player maps\mp\gametypes\_persistence::statSetChild( "round", "defuses", player.pers["defuses"] );
		
		player thread maps\mp\_matchdata::logGameEvent( "defuse", player.origin );
		
		self resetBombsite();
	}
	}


resetBombsite()
	{
	self maps\mp\gametypes\_gameobjects::allowUse("enemy");
	self maps\mp\gametypes\_gameobjects::setUseTime( GetDvarInt( "scr_fortress_planttime", 2 ) );
	self maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
	self maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	self.useWeapon = "briefcase_bomb_mp";
	}


setUpForDefusing()
	{
	self maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	self maps\mp\gametypes\_gameobjects::setUseTime( GetDvarInt( "scr_fortress_defusetime", 4 ) );
	self maps\mp\gametypes\_gameobjects::setUseText( &"MP_DEFUSING_EXPLOSIVE" );
	self maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_defuse" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defuse" );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_defend" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend" );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	self.useWeapon = "briefcase_bomb_defuse_mp";
}


/*
///ScriptDocBegin
Name: bombPlanted( plantLoc, player )
Summary: a bomb has been planted. Start ticking sound and timer. Spawn/setup suitcase bomb script_model. Explode bomb.
Module: fortress
CallOn: a force field useObject
MandatoryArg: <player> - the player that planted the bomb.
Example: level thread bombPlanted( self, player );
SPMP: MP
///ScriptDocEnd
*/
bombPlanted( player )
{
	player SetClientDvar( "ui_carrying_bomb", false );
	
	//self.visuals[0] thread maps\mp\gametypes\_gamelogic::playTickingSound();
	level.tickingObject = self.visuals[0];
	
	self.BombModel = spawn( "script_model", player.origin );
	self.BombModel.origin = player.origin;
	self.BombModel.angles = player.angles;
	self.BombModel setModel( "prop_suitcase_bomb" );
	self.bomb_clock = Int( GetDvarInt( "scr_fortress_bombtimer", 30 ) );
	self thread countdownBombClock();
	
	self.bombDefused = false;
	
	self BombTimerWait();
	//setDvar( "ui_bomb_timer", 0 );
	
	//self.visuals[0] maps\mp\gametypes\_gamelogic::stopTickingSound();
	
	if ( level.gameEnded || self.bombDefused )
	{
		return;		//Return so that the rest of the function doesn't execute and create an explosion.
	}
		
	self.forcefieldbrushmodel.origin = self.forcefieldbrushmodel.origin - (0, 0, 1024);

	explosionOrigin = self.BombModel.origin;
	self.BombModel hide();
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );

	if ( isdefined( player ) )
{
		self.visuals[0] RadiusDamage( explosionOrigin, 512, 200, 20, player, "MOD_EXPLOSIVE", "bomb_site_mp" );
		player incPersStat( "destructions", 1 );
		player maps\mp\gametypes\_persistence::statSetChild( "round", "destructions", player.pers["destructions"] );
	}
	else
		self.visuals[0] RadiusDamage( explosionOrigin, 512, 200, 20, undefined, "MOD_EXPLOSIVE", "bomb_site_mp" );
	
	rot = randomfloat(360);
	explosionEffect = spawnFx( level._effect["bombexplosion"], explosionOrigin + (0,0,50), (0,0,1), (cos(rot),sin(rot),0) );
	triggerFx( explosionEffect );
	
	PlayRumbleOnPosition( "grenade_rumble", explosionOrigin );
	earthquake( 0.75, 2.0, explosionOrigin, 2000 );
	
	thread playSoundinSpace( "exp_suitcase_bomb_main", explosionOrigin );
	
	if ( isDefined( self.exploderIndex ) )
		exploder( self.exploderIndex );
}


/*
///ScriptDocBegin
Name: BombTimerWait()
Summary: the wait that delays a bomb's explosion for its timer's duration.
Module: fortress
CallOn: a defuseObject (a planted bomb)
MandatoryArg: N/A
Example: level thread BombTimerWait();
SPMP: MP
///ScriptDocEnd
*/
BombTimerWait()
{
	level endon( "game_ended" );
	self endon( "bomb_defused" );

	bombEndMilliseconds = ( GetDvarInt( "scr_fortress_bombtimer", 30 ) * 1000) + gettime();
	SetDvar( "ui_bomb_timer_endtime", bombEndMilliseconds );

	level thread handleHostMigration( bombEndMilliseconds );
	maps\mp\gametypes\_hostmigration::waitLongDurationWithGameEndTimeUpdate( GetDvarInt( "scr_fortress_bombtimer", 30 ) );
	}


handleHostMigration( bombEndMilliseconds )
	{
	level endon( "game_ended" );
	level endon( "bomb_defused" );
	level endon( "disconnect" );

	level waittill( "host_migration_begin" );

	timePassed = maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
			
	if ( timePassed > 0 )
			{
		SetDvar( "ui_bomb_timer_endtime", bombEndMilliseconds + timePassed );
	}
			}


/*
///ScriptDocBegin
Name: bombDefused()
Summary: stop ticking sound for defused bomb and notify "bomb_defused" on the defuseObject.
Module: fortress
CallOn: a force field useObject
MandatoryArg: N/A
Example: self thread bombDefused();
SPMP: MP
///ScriptDocEnd
*/
bombDefused()
			{
	//level.tickingObject maps\mp\gametypes\_gamelogic::stopTickingSound();
	self.bombDefused = true;
	
	if ( IsDefined( self.BombModel ) )
		self.BombModel hide();
	
	self notify("bomb_defused");
			}


removeBombCarrierClass()
	{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	//	remove placement item if carrying
	if ( IsDefined( self.isCarrying ) && self.isCarrying == true )
		{
		self notify( "force_cancel_placement" );
		wait( 0.05 );
		}
	
	//	remove jugg
	if ( self isJuggernaut() )
	{
		self notify( "lost_juggernaut" );
		wait( 0.05 );
}

	//	unset the gamemodeloadout
	self.pers["gamemodeLoadout"] = undefined;	

	//	remove old TI if it exists
	if ( isDefined ( self.setSpawnpoint ) )
		self maps\mp\perks\_perkfunctions::deleteTI( self.setSpawnpoint );	
	
	//	set faux TI to respawn in place	
	spawnPoint = spawn( "script_model", self.origin );
	spawnPoint.angles = self.angles;
	spawnPoint.playerSpawnPos = self.origin;
	spawnPoint.notTI = true;		
	self.setSpawnPoint = spawnPoint;
	
	//	faux spawn
	self notify( "faux_spawn" );
	self.faux_spawn_stance = self getStance();
	self thread maps\mp\gametypes\_playerlogic::spawnPlayer( true );	
}


/*
///ScriptDocBegin
Name: countdownBombClock( )
Summary: decrements the bomb's clock.
Module: fortress
CallOn: a planted bomb
MandatoryArg: N/A
Example: self.BombModel thread countdownBombClock();
SPMP: MP
///ScriptDocEnd
*/
countdownBombClock()
{
	level endon("game_ended");

	gameFlagWait("prematch_done");

	//Bomb strobe light.
	//self thread controlBombStrobe();
	
	self thread play3DTickingSound();
	
	while (self.bomb_clock >= 0)
	{
		self.bomb_clock--;
		wait(1.0);
	}
}


/*
///ScriptDocBegin
Name: play3DTickingSound()
Summary: plays a 3D ticking sound on a bomb at different frequencies based on how close to zero the bomb's clock is.
Module: fortress
CallOn: a planted bomb
MandatoryArg: N/A
Example: self thread play3DTickingSound();
SPMP: MP
///ScriptDocEnd
*/
play3DTickingSound()
{
	self endon( "bomb_defused" );
	level endon ( "game_ended" );
	
	while( self.bomb_clock >= 0 )
	{
		if ( self.bomb_clock < 5 )
		{
			thread playSoundinSpace( "mp_suitcasebomb_timer_3d", self.origin );
			wait(0.2);
		}
		else if ( self.bomb_clock < 15 )
		{
			thread playSoundinSpace( "mp_suitcasebomb_timer_3d", self.origin );
			wait(0.5);
		}
		else
		{
			thread playSoundinSpace( "mp_suitcasebomb_timer_3d", self.origin );
			wait(1.0);
		}
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	}
}
		
		
/*
=============
///ScriptDocBegin
"Name: hideFlag()"
"Summary: wait until flag_captured notification on the useObject (self), then hide the visuals argument."
"Module: Entity"
"CallOn: a useObject"
"MandatoryArg: <visuals>: a script_model"
"Example: useObject thread hideFlag( visuals[0] );"
"SPMP: MP"
///ScriptDocEnd
=============
*/
hideFlag( visuals )
{
	self waittill( "flag_capped" );
	visuals Hide();
	}
	

/*
=============
///ScriptDocBegin
"Name: lowerForcefield()"
"Summary: lowers a forcefield when a defender walks up to it"
"Module: Entity"
"CallOn: a brushmodel"
"MandatoryArg: N/A"
"Example: "
"SPMP: MP"
///ScriptDocEnd
=============
*/
lowerForcefield()
{
	level endon( "game_ended" );

	if ( !IsDefined( self.lowered ) )
	{
		self.lowered = false;
	}
	
	while (1)
	{
		keep_forcefield_down = false;
		foreach( player in level.players )
		{
			if ( player IsTouching( self.rad_trigger ) && player.pers["team"] == game["defenders"] && IsAlive( player ) )
			{
				keep_forcefield_down = true;
				if ( self.lowered == false )
				{
					//Lower the force field.
					self.lowered = true;
					self.origin -= ( 0, 0, 1024 );
				}
			}
			else if ( keep_forcefield_down == false )
			{
				if ( self.lowered == true )
				{
					//Raise the force field.
					self.lowered = false;
					self.origin += ( 0, 0, 1024 );
				}
			}
		}
		wait(0.05);
	}
}
