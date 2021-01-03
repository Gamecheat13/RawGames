#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\weapons\_weapon_utils;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_wager;

#using scripts\mp\_util;

/*
	Deathmatch
	Objective: 	Score points by eliminating other players
	Map ends:	When one player reaches the score limit, or time limit is reached
	Respawning:	No wait / Away from other players

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_wager_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of enemies at the time of spawn.
			Players generally spawn away from enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			Because Deathmatch doesn't have teams with regard to gameplay or scoring, this effectively sets the available weapons.

		If using minefields or exploders:
			load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["soldiertypeset"] = "seals";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				soldiertypeset	seals
*/

//#define SAS_PRIMARY_WEAPON "crossbow" // brian barnes - crossbow weapon deleted, hoping just swapping this to a supported weapon will work




#precache( "string", "OBJECTIVES_SAS" );
#precache( "string", "OBJECTIVES_SAS_SCORE" );
#precache( "string", "OBJECTIVES_SAS_HINT" );
#precache( "string", "MP_HUMILIATION" );
#precache( "string", "MP_HUMILIATED" );
#precache( "string", "MP_BANKRUPTED" );
#precache( "string", "MP_BANKRUPTED_OTHER" );

function main()
{
	globallogic::init();
	
	level.weapon_SAS_PRIMARY_WEAPON = GetWeapon( "ar_accurate" );
	level.weapon_SAS_SECONDARY_WEAPON = level.weaponBallisticKnife;
	level.weapon_SAS_PRIMARY_GRENADE_WEAPON = GetWeapon( "hatchet" );

	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 5000 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 0, 100 );

	level.onStartGameType =&onStartGameType;
	level.onPlayerDamage =&onPlayerDamage;
	level.onPlayerKilled =&onPlayerKilled;
	level.onWagerAwards =&onWagerAwards;
	level.pointsPerPrimaryKill = GetGametypeSetting( "pointsPerPrimaryKill" );
	level.pointsPerSecondaryKill = GetGametypeSetting( "pointsPerSecondaryKill" );
	level.pointsPerPrimaryGrenadeKill = GetGametypeSetting( "pointsPerPrimaryGrenadeKill" );
	level.pointsPerMeleeKill = GetGametypeSetting( "pointsPerMeleeKill" );
	level.setBacks = GetGametypeSetting( "setbacks" );
	
	switch ( GetGametypeSetting( "gunSelection" ) )
	{
		case 0:
			level.setBackWeapon = undefined;
			break;
			
		case 1:
			level.setBackWeapon = level.weapon_SAS_PRIMARY_GRENADE_WEAPON;
			break;
			
		case 2:
			level.setBackWeapon = level.weapon_SAS_PRIMARY_WEAPON;
			break;
			
		case 3:
			level.setBackWeapon = level.weapon_SAS_SECONDARY_WEAPON;
			break;
			
		default:
			assert( true, "Invalid setting for gunSelection" );
			break;
	}

	game["dialog"]["gametype"] = "sns_start";
	game["dialog"]["wm_humiliation"] = "mpl_wager_bankrupt";
	game["dialog"]["wm_humiliated"] = "sns_hum";
	
	gameobjects::register_allowed_gameobject( level.gameType );

	level.giveCustomLoadout =&giveCustomLoadout;
	
	globallogic::setvisiblescoreboardcolumns( "pointstowin", "kills", "deaths", "tomahawks", "humiliated" ); 
}

function giveCustomLoadout()
{
	self notify( "sas_spectator_hud" );	

	defaultWeapon = level.weapon_SAS_PRIMARY_WEAPON;

	self wager::setup_blank_random_player( true, true, defaultWeapon );
	

	self giveWeapon( defaultWeapon );
	self SetWeaponAmmoClip( defaultWeapon, 3 );
	self SetWeaponAmmoStock( defaultWeapon, 3 );

	secondaryWeapon = level.weapon_SAS_SECONDARY_WEAPON;
	self giveWeapon( secondaryWeapon );
	self SetWeaponAmmoStock( secondaryWeapon, 2 );

	offhandPrimary = level.weapon_SAS_PRIMARY_GRENADE_WEAPON;
	self setOffhandPrimaryClass( offhandPrimary );
	self giveWeapon( offhandPrimary );
	self SetWeaponAmmoClip( offhandPrimary, 1 );
	self SetWeaponAmmoStock( offhandPrimary, 1 );
	
	self giveWeapon( level.weaponBaseMelee );

	self switchToWeapon( defaultWeapon );
	self setSpawnWeapon( defaultWeapon );
	
	self.killsWithSecondary = 0;
	self.killsWithPrimary = 0;
	self.killsWithBothAwarded = false;
	
	return defaultWeapon;
}

function onPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( ( weapon == level.weapon_SAS_PRIMARY_WEAPON ) && ( sMeansOfDeath == "MOD_IMPACT" ) )
	{
		if ( isdefined( eAttacker ) && IsPlayer( eAttacker ) )
		{
			if ( !isdefined( eAttacker.pers["sticks"] ) )
				eAttacker.pers["sticks"] = 1;
			else
				eAttacker.pers["sticks"]++;
			eAttacker.sticks = eAttacker.pers["sticks"];
		}
	}
	
	return iDamage;
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{	
	if ( isdefined( attacker ) && IsPlayer( attacker ) && attacker != self )
	{
		if ( weapon_utils::isMeleeMOD( sMeansOfDeath ) )
		{
			//should probably make this a custom setting
			attacker globallogic_score::givePointsToWin( level.pointsPerMeleeKill );	
		}
		else if ( weapon == level.weapon_SAS_PRIMARY_WEAPON )
		{
			attacker.killsWithPrimary++;
			if ( attacker.killsWithBothAwarded == false && attacker.killsWithSecondary > 0 ) 
			{
				attacker.killsWithBothAwarded = true;
			}
			attacker globallogic_score::givePointsToWin( level.pointsPerPrimaryKill );
		}
		else if ( weapon == level.weapon_SAS_PRIMARY_GRENADE_WEAPON )
		{
			attacker globallogic_score::givePointsToWin( level.pointsPerPrimaryGrenadeKill );
		}
		else
		{
			if ( weapon == level.weapon_SAS_SECONDARY_WEAPON ) // make sure this is not a kill by destructible
			{
				attacker.killsWithSecondary++;
				if ( attacker.killsWithBothAwarded == false && attacker.killsWithPrimary > 0 ) 
				{
					attacker.killsWithBothAwarded = true;
				}
			}
			
			attacker globallogic_score::givePointsToWin( level.pointsPerSecondaryKill );
		}
		
		if ( isdefined( level.setBackWeapon ) && ( weapon == level.setBackWeapon ) )
		{
			self.pers["humiliated"]++;
			self.humiliated = self.pers["humiliated"];
						
			if ( level.setBacks == 0 )
			{
				self globallogic_score::setPointsToWin( 0 );
			}
			else
			{
				self globallogic_score::givePointsToWin( level.setBacks * -1 );
			}
			attacker PlayLocalSound( game["dialog"]["wm_humiliation"] );
			self PlayLocalSound( game["dialog"]["wm_humiliation"] );
			self globallogic_audio::leader_dialog_on_player( "wm_humiliated" );
		}
	}
	else
	{
		self.pers["humiliated"]++;
		self.humiliated = self.pers["humiliated"];
		if ( level.setBacks == 0 )
		{
			self globallogic_score::setPointsToWin( 0 );
		}
		else
		{
			self globallogic_score::givePointsToWin( level.setBacks * -1 );
		}
		self thread wager::queue_popup( &"MP_HUMILIATED", 0, &"MP_BANKRUPTED", "wm_humiliated" );
		self PlayLocalSound( game["dialog"]["wm_humiliated"] );
	}
}

function onStartGameType()
{
	SetDvar( "scr_xpscale", 0 );
	
	setClientNameMode("auto_change");

	util::setObjectiveText( "allies", &"OBJECTIVES_SAS" );
	util::setObjectiveText( "axis", &"OBJECTIVES_SAS" );

	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_SAS" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_SAS" );
	}
	else
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_SAS_SCORE" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_SAS_SCORE" );
	}
	util::setObjectiveHintText( "allies", &"OBJECTIVES_SAS_HINT" );
	util::setObjectiveHintText( "axis", &"OBJECTIVES_SAS_HINT" );

	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	newSpawns = GetEntArray( "mp_wager_spawn", "classname" );
	if (newSpawns.size > 0)
	{
		spawnlogic::add_spawn_points( "allies", "mp_wager_spawn" );
		spawnlogic::add_spawn_points( "axis", "mp_wager_spawn" );
	}
	else
	{
		spawnlogic::add_spawn_points( "allies", "mp_dm_spawn" );
		spawnlogic::add_spawn_points( "axis", "mp_dm_spawn" );
	}

	spawning::updateAllSpawnPoints();
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );

	// use the new spawn logic from the start
	level.useStartSpawns = false;
	
	level.displayRoundEndText = false;
	
	if ( isdefined( game["roundsplayed"] ) && game["roundsplayed"] > 0 )
	{
		game["dialog"]["gametype"] = undefined;
		game["dialog"]["offense_obj"] = undefined;
		game["dialog"]["defense_obj"] = undefined;
	}
}

function onWagerAwards()
{
	tomahawks = self globallogic_score::getPersStat( "tomahawks" );
	if ( !isdefined( tomahawks ) )
		tomahawks = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", tomahawks, 0 );
	
	sticks = self globallogic_score::getPersStat( "sticks" );
	if ( !isdefined( sticks ) )
		sticks = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", sticks, 1 );
	
	bestKillstreak = self globallogic_score::getPersStat( "best_kill_streak" );
	if ( !isdefined( bestKillstreak ) )
		bestKillstreak = 0;
	self persistence::set_after_action_report_stat( "wagerAwards", bestKillstreak, 2 );
}

