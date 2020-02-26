#include common_scripts\utility;
#include maps\mp\_utility;

initLastStand()
{
	precacheitem( "syrette_mp" );

	level.reviveTriggerRadius = GetDvarfloat( "player_reviveTriggerRadius");
	level.howLongToDoLastStandForWithRevive = GetDvarfloat( "player_lastStandBleedoutTime");
	//level.howLongToDoFinalStandFor = 10;
	level.howLongToDoLastStandForWithoutRevive = GetDvarfloat( "player_lastStandBleedoutTimeNoRevive" );
	level.aboutToBleedOutTime = 5;	
	// if both of these are zero then max ammo is given
	level.amountOfLastStandPistolAmmoInClip = 0;
	level.amountOfLastStandPistolAmmoInStock = 0;
	level.lastStandCount = undefined;

	if( !IsDefined( level.laststandpistol ) )
	{
		level.laststandpistol = "fiveseven_mp";

		PrecacheItem( level.laststandpistol );
	}

	level.needs_revive = [];
	
	foreach ( team in level.teams )
	{
		level.needs_revive[team] = false;
	}

	if( GetDvar( "revive_time_taken" ) == "" )
	{
		SetDvar( "revive_time_taken", "1.15" );
	}

	precacherumble( "dtp_rumble" );
	precacherumble( "slide_rumble" );

	//Function to force the player into Last Stand using dvars
	/#
		level thread dev_last_stand();
	#/
}

keep_weapons()
{
	return ( set_dvar_int_if_unset( "scr_laststand_keep_weapons", 0 ) > 0 );
}

LastStandTime()
{
	//if ( allowRevive() )
	//{
	//	return level.howLongToDoLastStandForWithRevive;
	//}
	
	// this perk will allow you to be revived, this is the pro version of second chance
	if( self HasPerk( "specialty_finalstand" ) )
	{
		return level.howLongToDoLastStandForWithRevive;
		//// final stand is twice as long because you can be revived
		//return level.howLongToDoFinalStandFor * 2;
	}

	return level.howLongToDoLastStandForWithoutRevive;
}

PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self.lastStandParams = spawnstruct();
	self.lastStandParams.eInflictor = eInflictor;
	self.lastStandParams.attacker = attacker;
	if ( isPlayer( attacker ) )
	{
		if ( isdefined( attacker.lastStand ) && attacker.laststand == true )
		{
			self.lastStandParams.attackerStance = "laststand";
		}
		else
		{
			self.lastStandParams.attackerStance = attacker getStance();
		}
	}
	self.lastStandParams.iDamage = iDamage;
	self.lastStandParams.sMeansOfDeath = sMeansOfDeath;
	self.lastStandParams.sWeapon = sWeapon;
	self.lastStandParams.vDir = vDir;
	self.lastStandParams.sHitLoc = sHitLoc;
	self.lastStandParams.lastStandStartTime = gettime();	
	if ( isdefined ( attacker ) ) 
		self.lastStandParams.vAttackerOrigin = attacker.origin;
	
	mayDoLastStand = mayDoLastStand( sWeapon, sMeansOfDeath, sHitLoc );
	
	/#
		if ( GetDvar( "scr_forcelaststand" ) == "1" )
		{
			mayDoLastStand = true;
			self thread reviveFromConsole();
		}
	#/

	self.useLastStandParams = true;

	if ( !mayDoLastStand )
	{
		self ensureLastStandParamsValidity();
		return;
	}

	if ( !isdefined( self.lastStandThisLife ) )
	{
		self.lastStandThisLife = 0;		
	}

	self.lastStandThisLife++;

	self.health = 1;
	self thread maps\mp\gametypes\_gameobjects::onPlayerLastStand();

	self notify("entering_last_stand");
	// Play last stand music
	//self thread maps\mp\gametypes\_globallogic_audio::set_music_on_player( "MP_LAST_STAND", false, true, 4  );	
	self playlocalsound ("mus_last_stand");

	weaponslist = self getweaponslist();
	assert( isdefined( weaponslist ) && weaponslist.size > 0, "Player's weapon(s) missing before dying -=Last Stand=-" );

	self.previousweaponslist = self getweaponslist();

	self.previousAmmoClip = [];
	self.previousAmmoStock = [];
	self.laststandpistol = level.laststandpistol;
	self.previousPrimary = self GetCurrentWeapon();
	self.hadPistol = false;

	// check if player has pistol
	// if he does give him that instead of the default weapon
	for( i = 0; i < self.previousweaponslist.size; i++ )
	{
		// we don't want the cz75_auto_mp to be the last stand pistol either
		if( WeaponClass( self.previousweaponslist[i] ) == "pistol" && 
			self.previousweaponslist[i] != "knife_ballistic_mp" &&
			!IsSubStr( self.previousweaponslist[i], "_auto_" ) &&
			!IsSubStr( self.previousweaponslist[i], "dw_" ) )
		{
			self.laststandpistol = self.previousweaponslist[i];
			self.hadPistol = true;
		}
	}

	self notify ("cancel_location");

	gun = self GetCurrentWeapon();
	if (gun == "syrette_mp")
	{
		self takeWeapon ("syrette_mp");
		gun = self.previousprimary;
		self giveWeapon ( self.previousprimary );
	}

	self SetLastStandPrevWeap( gun );
	self DisableOffhandWeapons();
	self DisableWeaponCycling();

	// reset the previousweaponslist
	// now that the primary weapon has been thrown down
	self.previousweaponslist = self getweaponslist();
	for( i = 0; i < self.previousweaponslist.size; i++ )
	{
		weapon = self.previousweaponslist[i];

		self.previousAmmoClip[i] = self GetWeaponAmmoClip ( weapon );
		self.previousAmmoStock[i] = self GetWeaponAmmoStock ( weapon );
	}

	if ( ( !level.hardcoreMode || self.team != attacker.team ) && self HasPerk( "specialty_finalstand" ) ) 
		revive_trigger_spawn();

	if ( !keep_weapons() )
	{
		// if the player doesn't have a pistol, give it to them
		if( !self.hadPistol )
		{
			self GiveWeapon( self.laststandpistol );
			self GiveWeapon( "knife_mp" );
		}

		self switchToWeapon( self.laststandpistol );
		if ( level.amountOfLastStandPistolAmmoInClip == 0 && level.amountOfLastStandPistolAmmoInStock == 0 )
		{
			self GiveMaxAmmo( self.laststandpistol );
		}
		else 
		{
			self SetWeaponAmmoClip( self.laststandpistol, level.amountOfLastStandPistolAmmoInClip );
			self SetWeaponAmmoStock(  self.laststandpistol, level.amountOfLastStandPistolAmmoInStock );
		}

		if ( self isThrowingGrenade() )
		{
			self thread waittillGrenadeThrown();
		}
	}
	
	self lastStandTimer( LastStandTime() );
}

waittillGrenadeThrown()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "player revived" );

	//self waittill("grenade_fire");
	self waittill ( "grenade_fire", grenade, weapname );

	for( i = self.previousweaponslist.size -1; i >= 0 ; i-- )
	{
		weapon = self.previousweaponslist[i];
		if( weapon == weapname)
		{
			self.previousAmmoClip[i]-= 1;
			self.previousAmmoStock[i] -= 1;
		}
	}
}

mayDoLastStand( sWeapon, sMeansOfDeath, sHitLoc )
{
	if (   sMeansOfDeath != "MOD_PISTOL_BULLET" 
		&& sMeansOfDeath != "MOD_RIFLE_BULLET")
	{
		return false;	
	}

	if( level.laststandpistol == "none" )
	{
		return false;
	}

	if( isDefined( self.enteringVehicle ) && self.enteringVehicle )
	{
		return false;
	}

	if ( self IsInVehicle() )
	{
		return false;
	}

	if ( self IsRemoteControlling() )
	{
		return false;
	}

	if ( self IsWeaponViewOnlyLinked() )
	{
		return false;
	}

	if ( IsDefined( self.selectingLocation ) && self.selectingLocation == true )
	{
		// player is using a map-based killstreak
		return false;
	}

	if ( IsDefined( self.laststand ) )
	{
		return false;
	}

	// reviving another player
	if ( IsDefined( self.revivingTeammate ) && self.revivingTeammate )
	{
		return false;
	}

	// planting a bomb
	if ( IsDefined( self.isPlanting ) && self.isPlanting )
	{
		return false;
	}
	
	// defusing a bomb
	if ( IsDefined( self.isDefusing ) && self.isDefusing )
	{
		return false;
	}
	
	if ( isdefined( level.lastStandCount ) )
	{
		if ( IsDefined( self.lastStandThisLife ) && self.lastStandThisLife >= level.lastStandCount )
		{
			return false;
		}
	}
	
	if ( IsDefined( sWeapon ) && weaponClass( sWeapon ) == "spread" ) 
	{
		return false;
	}

	return true;
}


lastStandTimer( delay )
{	
	self thread lastStandWaittillDeath();
	
	//if( self HasPerk( "specialty_finalstand" ) )
	//{
	//	self thread final_stand_wait( delay );
	//}
	//else
	//{
		self.aboutToBleedOut = undefined;
		self.lastStand = true;
		self setLowerMessage( &"PLATFORM_COWARDS_WAY_OUT" );
		self.lowerMessage.hideWhenInDemo = true;

		self thread lastStandBleedout(delay);
	//}
}


lastStandWaittillDeath()
{
	self endon( "disconnect" );
	self endon( "player revived" );

	self waittill( "death", attacker, isHeadShot, weapon );
	
	//restore last music state
	//self thread maps\mp\gametypes\_globallogic_audio::return_music_state_player();
	//self thread maps\mp\gametypes\_globallogic_audio::set_music_on_player( "MP_LAST_STAND_DIE", false, true, 1 );
	//self playlocalsound ("mus_last_stand_die");
	
	teamMateNeedsRevive = false;

	if ( isdefined( attacker ) && isdefined( isHeadShot ) && isHeadShot && isplayer( attacker ) )
	{
		if ( level.teambased ) 
		{
			if ( attacker.team != self.team )
			{
				self recordKillModifier("execution");
			}
		}
		else
		{
			if( attacker != self )
			{
				self recordKillModifier("execution");
			}
		}
	}

	self.thisPlayerisinlaststand = false;
	self clearLowerMessage();
	self.lastStand = undefined;

	if ( !allowRevive() )
		return;

	players = GET_PLAYERS();
	if (isdefined(self.revivetrigger))
	{
		self.revivetrigger delete();
	}

	for (i = 0; i < players.size; i++)
	{
		if (self.team == players[i].team)
		{
			if (isdefined (players[i].revivetrigger))
			{
				teammateNeedsRevive = true;
			}
		}
	}

	for ( index = 0; index < 4; index++ )
	{
		self.reviveIcons[index].alpha = 0;
		self.reviveIcons[index] setWaypoint( false );
	}

	self setTeamRevive(teammateNeedsRevive);
}


cleanupTeammateNeedsReviveList()
{	
	if ( !allowRevive() )
		return;

	foreach( team in level.teams )
	{
		level.needs_revive[team] = false;
	}
	
	players = GET_PLAYERS();

	for (i = 0; i < players.size; i++)
	{
		if ( isdefined( level.teams[players[i].team] ) )
		{
			if (isdefined(players[i].revivetrigger))
			{
				level.needs_revive[players[i].team] = true;
			}
		}
	}
}

setTeamRevive(needsRevive)
{
	if ( isdefined( level.teams[ self.team ] ) )
	{
		level.needs_revive[self.team] = needsRevive;
	}
}

teamMateNeedsRevive()
{
	if (isdefined (self.team) && isdefined( level.teams[ self.team ] ) )
	{
		return level.needs_revive[self.team];
	}
	return false;
}

// spawns the trigger used for the player to get revived
revive_trigger_spawn()
{

	if (allowRevive())
	{
		reviveobituary(self); 
		self setTeamRevive(true);
		self.revivetrigger = spawn("trigger_radius", self.origin, 0, level.reviveTriggerRadius , level.reviveTriggerRadius );
		self thread clearUpOnDisconnect(self);
		self.revivetrigger setrevivehintstring( &"GAME_BUTTON_TO_REVIVE_PLAYER", self.team );
		self.revivetrigger setCursorHint("HINT_NOICON");
		self thread revive_trigger_think();
		self thread cleanUpOnDeath();
		self needsRevive( true );		
	}
}

cleanUpOnDeath()
{
	self endon ("disconnect");
	self waittill("death");
	if (isdefined(self.revivetrigger))
	{
		self.revivetrigger delete();
	}
}

// logic for the revive trigger
revive_trigger_think()
{
	self setTeamRevive(true);

	detectTeam = self.team;

	self.currentlyBeingRevived = false;

	self.thisPlayerIsInLastStand = true;

	self detectReviveIconWaiter();

	while (isdefined(self) && IsAlive( self ) && isdefined (self.thisPlayerIsInLastStand) && self.thisPlayerIsInLastStand == true)
	{
		players = level.aliveplayers[detectTeam];

		// respawn trigger just in case player was moving when put in last stand
		if ( DistanceSquared( self.revivetrigger.origin, self.origin ) > 1 )
		{
			self.revivetrigger delete();
			self.revivetrigger = spawn("trigger_radius", self.origin, 0, level.reviveTriggerRadius , level.reviveTriggerRadius );
			self.revivetrigger setrevivehintstring( &"GAME_BUTTON_TO_REVIVE_PLAYER", self.team );
			self.revivetrigger setCursorHint("HINT_NOICON");
			self thread clearUpOnDisconnect(self);
		}

		for (i = 0; i < players.size; i++)
		{
			if ( can_revive( players[i] ) ) 
			{
				//making sure last stand players don't revive each other
				if ( players[i] != self && !isDefined(players[i].revivetrigger) )
				{
					if ( ( !isdefined(self.currentlyBeingRevived) || !self.currentlyBeingRevived ) && !players[i].revivingTeammate )
					{
						if ( players[i].health > 0 
							&& isDefined(self.revivetrigger) 
							&& players[i] istouching(self.revivetrigger) 
							&& players[i] useButtonPressed())
						{
							players[i].revivingTeammate = true;
							players[i] thread cleanUpRevivingTeamate( self );
							gun = players[i] GetCurrentWeapon();
							if ( gun == "syrette_mp" ) 
							{
								players[i].gun = players[i].previousprimary;
							}
							else
							{
								players[i].previousprimary = gun;
								players[i].gun = gun;
							}	
							players[i] GiveWeapon( "syrette_mp" );
							players[i] SwitchToWeapon( "syrette_mp" );
							players[i] SetWeaponAmmoStock( "syrette_mp", 1 );
							players[i] notify ( "snd_ally_revive" );
							

							players[i] player_being_revived(self); 

							if ( isdefined ( self ) )
								self.currentlyBeingRevived = false;

							players[i] TakeWeapon( "syrette_mp" );

							if ( players[i].previousprimary == "none" || maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( players[i].previousprimary ) )
							{
								players[i] switchToValidWeapon();
							}
							//Check if we're trying to switch to an empty equipment slot.
							else if( IsWeaponEquipment( players[i].previousprimary ) && players[i] GetWeaponAmmoClip( players[i].previousprimary ) <= 0 )
							{
								players[i] switchToValidWeapon();
							}
							else
							{
								players[i] SwitchToWeapon( players[i].previousprimary );
							}

							players[i].previousprimary = undefined;
							players[i] notify( "completedRevive" );
							//Todo CDC play the "I saved you chatter"
							wait(0.1);
							players[i].revivingTeammate = false;
						}
					}
				}
			}
		}
		wait (0.1);
	}
}

switchToValidWeapon() //self == player
{
	if( self hasWeapon(self.lastNonKillstreakWeapon) )
	{
		self switchToWeapon( self.lastNonKillstreakWeapon );
	}
	else if( self hasWeapon(self.lastDroppableWeapon) )
	{
		self switchToWeapon( self.lastDroppableWeapon );
	}
	else
	{
		primaries = self GetWeaponsListPrimaries();
		assert( primaries.size > 0 );
		self SwitchToWeapon( primaries[0] );
	}
}

cleanUpRevivingTeamate( revivee )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "completedRevive" );
	
	revivee waittill( "death" );

	self.revivingTeammate = false;
}


player_being_revived( playerBeingRevived )
{
	self endon( "death" );
	self endon( "disconnect" );
	reviveTime = GetDvarint( "revive_time_taken" );

	if ( !isdefined ( playerBeingRevived.currentlyBeingRevived ) )
		playerBeingRevived.currentlyBeingRevived = false;

	if( reviveTime > 0 )
	{
		timer = 0;
		revivetrigger = playerBeingRevived.revivetrigger;

		while(self.health > 0 && isDefined( revivetrigger ) && self istouching( revivetrigger ) && self useButtonPressed() && isdefined (playerBeingRevived) )
		{
			playerBeingRevived.currentlyBeingRevived = true;
			wait(0.05);					
			timer += 0.05;			
			if( timer >= reviveTime)
			{
				obituary(playerBeingRevived, self, "syrette_mp", "MOD_UNKNOWN");
				self AddPlayerStat( "REVIVES", 1 );
				if (level.rankedmatch)
				{
					self maps\mp\gametypes\_missions::doMissionCallback( "medic", self ); 
				}
				playerBeingRevived.thisPlayerIsInLastStand = false;	
				playerBeingRevived thread takePlayerOutOfLastStand();	
			}
		}
		return false;
	}
	else
	{
		playerBeingRevived.thisPlayerIsInLastStand = false;	
		playerBeingRevived thread takePlayerOutOfLastStand();	
	}
}


takePlayerOutOfLastStand()
{

	self notify ("player revived");		

	self clearLowerMessage( );
	
	//restore last music state
	//self thread maps\mp\gametypes\_globallogic_audio::return_music_state_player();	
	//self thread maps\mp\gametypes\_globallogic_audio::set_music_on_player( "MP_LAST_STAND_REVIVE", false, true, 1 );	
	self playlocalsound ("mus_last_stand_revive");	
	

	if ( !keep_weapons() )
	{
		if ( self.hadPistol == false)
		{
			self TakeWeapon( self.laststandpistol );
		}
		for( i = self.previousweaponslist.size -1; i >= 0 ; i-- )
		{
			weapon = self.previousweaponslist[i];
			self GiveWeapon( weapon );
			self SetWeaponAmmoClip(weapon, self.previousAmmoClip[i]);
			self SetWeaponAmmoStock(weapon, self.previousAmmoStock[i]);
		}

		if (isdefined (self.previousPrimary) && self.previousPrimary != "none" )
		{ 
			if( !IsWeaponEquipment( self.previousPrimary ) && !IsWeaponSpecificUse( self.previousPrimary ) && !isdefined( level.grenade_array[self.previousPrimary] ) )
			{
				self SwitchToWeapon (self.previousPrimary);
			}
			else
			{
				for( i = self.previousweaponslist.size -1; i >= 0 ; i-- )
				{
					if( !IsWeaponEquipment( self.previousweaponslist[i] ) && !IsWeaponSpecificUse( self.previousweaponslist[i] ) && IsWeaponPrimary( self.previousweaponslist[i] ) )
					{
						self SwitchToWeapon( self.previousweaponslist[i] );
						break;
					}
				}
			}
		}
		else
		{
			for( i = self.previousweaponslist.size -1; i >= 0 ; i-- )
			{
				if( !IsWeaponEquipment( self.previousweaponslist[i] ) && !IsWeaponSpecificUse( self.previousweaponslist[i] ) && IsWeaponPrimary( self.previousweaponslist[i] ) )
				{
					self SwitchToWeapon( self.previousweaponslist[i] );
					break;
				}
			}
		}
	}
	
	self revive();
	self needsRevive( false );
	if( isDefined( self.revivetrigger ) )
	{
		self.revivetrigger delete();
	}
	self.aboutToBleedOut = undefined;
	
	self clearLowerMessage( );	

	self thread maps\mp\killstreaks\_killstreaks::giveOwnedKillstreak();

	self.laststandpistol = level.laststandpistol;
	self.lastStand = undefined;

	self EnableOffhandWeapons();
	self EnableWeaponCycling();
	self.useLastStandParams = undefined;
	self.lastStandParams = undefined;

	// only remove the team wide teammate_needs_revive flag
	// if no other players on your team are needing revive
	players = GET_PLAYERS();
	anyPlayerLeftInLastStand = false;
	for (i = 0; i < players.size; i++)
	{
		if (isDefined (players[i].revivetrigger) && players[i].team == self.team)
		{
			anyPlayerLeftInLastStand = true;
		}
	}

	if (!anyPlayerLeftInLastStand)
	{
		self setTeamRevive(false);
	}
}

reviveFromConsole()
{
	self endon ("player revived");	
	for(;;)
	{
		if ( GetDvar( "scr_reviveme" ) != "" )
		{
			self.thisPlayerIsInLastStand = false;	
			SetDvar("scr_reviveme", "");
			self thread takePlayerOutOfLastStand();
		}
		wait (0.1);
	}
}


// bleedout, player dies after level.howLongToDoLastStandForWithRevive seconds
lastStandBleedout(delay)
{
	self endon ("player revived");
	self endon ("disconnect");
	self endon ("death");

	self thread cowardsWayOut();
	self thread lastStandHealthOverlay();
	self thread lastStandEndOnForceCrouch();

	wait ( delay - level.aboutToBleedOutTime  );	
	self.aboutToBleedOut = true;
	wait (level.aboutToBleedOutTime );

	self notify ("end coward");

	players = GET_PLAYERS();

	for (i = 0; i < players.size; i++)
	{
		players[i] notify ("stop revive pulse");
	}
	self needsRevive( false );
	self ensureLastStandParamsValidity();
	self suicide();
}

//// waiting, player gets back up after level.howLongToDoFinalStandFor seconds
//final_stand_wait( delay ) // self == player
//{
//	self endon ("player revived");
//	self endon ("disconnect");
//	self endon ("death");
//
//	wait ( delay );	
//
//	players = GET_PLAYERS();
//	for (i = 0; i < players.size; i++)
//	{
//		players[i] notify ("stop revive pulse");
//	}
//	self needsRevive( false );
//
//	self.thisPlayerIsInLastStand = false;	
//	self thread takePlayerOutOfLastStand();	
//}

// this will trigger if they land on some bad terrain
lastStandEndOnForceCrouch()
{
	self endon ("player revived");
	self endon ("disconnect");
	self endon ("death");
	self endon ("end coward");

	self waittill ("force crouch");

	self needsRevive( false );
	self ensureLastStandParamsValidity();
	self suicide();

}

cowardsWayOut()
{
	self endon ("player revived");
	self endon ("disconnect");
	self endon ("death");
	self endon ("end coward");

	while(1)
	{
		if ( self useButtonPressed() )
		{
			pressStartTime = gettime();
			while ( self useButtonPressed() )
			{
				wait .05;
				if ( gettime() - pressStartTime > 700 )
					break;
			}
			if ( gettime() - pressStartTime > 700 )
				break;
		}
		wait .05;
	}
	self needsRevive( false );
	self ensureLastStandParamsValidity();
	duration = self doCowardsWayAnims();
	wait( duration );
	//PlayFXOnTag( level._effect["animscript_laststand_suicide"], self, "tag_flash" );
	self.suicideWeapon = self GetCurrentWeapon();	
	//self FakeFire( self, self.origin, self.suicideWeapon, 1 );	
	wait( 0.05 );
	self suicide();
}


clearUpOnDisconnect(player)
{
	reviveTrigger = self.revivetrigger;
	self notify ("clearing revive on disconnect");
	self endon ("clearing revive on disconnect");
	self waittill ("disconnect");

	self.lastStand = undefined;

	cleanupTeammateNeedsReviveList();

	if (isdefined (revivetrigger) )
	{
		revivetrigger delete();
	}

	teamMateNeedsRevive = false;

	players = GET_PLAYERS();	
	for (i = 0; i < players.size; i++)
	{
		if (self.team == players[i].team)
		{
			if (isdefined (players[i].revivetrigger))
			{
				teammateNeedsRevive = true;
			}
		}
	}

	self setTeamRevive(teammateNeedsRevive);
}

allowRevive()
{
	if (!level.teambased) 
		return false;

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "player", "allowrevive" ) == 0 )
		return false;

	return true;
}

setupRevive()
{
	if (!allowRevive()) 
		return;

	self.aboutToBleedOut = undefined;	
	for ( index = 0; index < 4; index++ )
	{
		if ( !isDefined( self.reviveIcons[index] ) )
			self.reviveIcons[index] = newClientHudElem( self );

		self.reviveIcons[index].x = 0;
		self.reviveIcons[index].y = 0;
		self.reviveIcons[index].z = 0;
		self.reviveIcons[index].alpha = 0;
		self.reviveIcons[index].archived = true;
		self.reviveIcons[index] setShader( "waypoint_second_chance", 14, 14 );
		self.reviveIcons[index] setWaypoint( false );
		self.reviveIcons[index].reviveId = -1;
		self.reviveIcons[index].overrridewhenindemo = true;
	}

	players = GET_PLAYERS();

	iconCount = 4;

	for ( i = 0; i < players.size && iconCount > 0; i++ )
	{
		if ( !IsDefined(players[i].team) )
			continue;
			
		if ( self.team != players[i].team )
			continue;
		if ( !isdefined(players[i].lastStand) || !players[i].lastStand )
			continue;

		iconCount--;

		self thread showReviveIcon( players[i] );
	}	
}

lastStandHealthOverlay()
{
	self endon( "player revived" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "game_ended" );

	// keep the health overlay going by making code think the player is getting damaged
	while(1)
	{
		self.health = 2;
		wait .05;
		self.health = 1;
		wait .5;
	}
}

ensureLastStandParamsValidity()
{
	// attacker may have become undefined if the player that killed me has disconnected
	if ( !isDefined( self.lastStandParams.attacker ) )
		self.lastStandParams.attacker = self;
}


detectReviveIconWaiter( )
{
	level endon ( "game_ended" );

	if ( !allowRevive() )
		return;

	players = GET_PLAYERS();
	for (i = 0; i < players.size; i++)
	{
		player = players[i];

		if ( player.team != self.team) 
			continue;

		if (player == self)
			continue;

		if ( !(can_revive( player ) ) )
			continue;

		if ( isai( player ) )
			continue;

		player thread showReviveIcon( self ); 
	}
}


showReviveIcon( lastStandPlayer )
{
	self endon ("disconnect");
	
	if ( is_true( level.dodge_show_revive_icon ) )
	{
		return;
	}
	
	if ( !allowRevive() )
		return;

	triggerreviveId = lastStandPlayer getentitynumber();

	useId = -1;

	for ( index = 0; (index < 4)&& (useId == -1); index++ )
	{
		if ( !isdefined(self.reviveIcons) || !isdefined(self.reviveIcons[index]) || !isdefined(self.reviveIcons[index].reviveId) )
			continue;

		reviveId = self.reviveIcons[index].reviveId;

		if ( reviveId == triggerreviveId )
			return;

		if (reviveId == -1)
		{
			useId = index;
		}
	}

	if ( useId < 0 )
		return;

	looptime = 0.05;

	self.reviveIcons[useId] setWaypoint( true, "waypoint_second_chance");

	reviveIconAlpha = 0.8;
	self.reviveIcons[useId].alpha = reviveIconAlpha;
	self.reviveIcons[useId].reviveId = triggerreviveId;
	self.reviveIcons[useId] SetTargetEnt( lastStandPlayer );

	while ( isdefined ( laststandplayer.revivetrigger ) )
	{
		if ( isdefined ( laststandplayer.aboutToBleedOut ) )
		{
			self.reviveIcons[useId] fadeOverTime( level.aboutToBleedOutTime );
			self.reviveIcons[useId].alpha = 0;
			while ( isdefined ( laststandplayer.revivetrigger ) )
			{
				wait ( 0.1 );
			}
			wait (level.aboutToBleedOutTime);
			self.reviveIcons[useId].reviveId = -1;
			self.reviveIcons[useId] setWaypoint( false );

			return;
		}	
		else if ( self IsInVehicle() )
		{
			self.reviveIcons[useId].alpha = 0;
		}
		else
		{
			self.reviveIcons[useId].alpha = reviveIconAlpha;
		}
			
		wait ( loopTime );
	}

	if ( !isDefined( self ) )
		return;

	self.reviveIcons[useId] fadeOverTime( 0.25 );
	self.reviveIcons[useId].alpha = 0;
	wait 1;
	self.reviveIcons[useId].reviveId = -1;
	self.reviveIcons[useId] setWaypoint( false );
}

can_revive( reviver )
{
	if ( isdefined ( reviver ) ) // && reviver hasPerk ("specialty_pistoldeath") )
		return true;

	return false;		
}

/#
//Adds functionality so we can put the player in Last Stand when we want for development purposes
dev_last_stand()
{	
	//Init my dvar
	SetDvar("scr_last_stand", "");

	while(1)
	{
		wait(0.5);

		//Grab my dvar every frame
		devgui_string = GetDvar( "scr_last_stand");

		//This  can happen in the dev gui. Look at devgui_mp.cfg.
		if(devgui_string == "force_last_stand")
		{
			//Give the player Last Stand if he doesn't have it
			if(!level.players[0] hasPerk("specialty_pistoldeath"))
			{
				level.players[0].extraPerks[ "specialty_pistoldeath" ] = 1;
				level.players[0] setPerk( "specialty_pistoldeath" );	
			}
			//'scr_forcelaststand' opens up the ability to use DoDamage in script to put him into Last Stand
			SetDvar("scr_forcelaststand", "1");
			level.players[0] DoDamage( level.players[0].health, level.players[0].origin );
			SetDvar("scr_last_stand", "");
		}
		if(devgui_string == "do_revive")
		{
			if(IsDefined(level.players[0].lastStand) && level.players[0].lastStand)
			{
				//"scr_reviveme" revives the player
				SetDvar("scr_reviveme", "1");	
			}
			SetDvar("scr_last_stand", "");	
		}		
	}
}
#/
