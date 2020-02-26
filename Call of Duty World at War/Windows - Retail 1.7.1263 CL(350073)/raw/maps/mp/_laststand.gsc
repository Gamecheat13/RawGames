#include common_scripts\utility;
#include maps\mp\_utility;

initLastStand()
{
	precacheitem( "syrette_mp" );

	level.reviveTriggerRadius = GetDvarFloat("player_reviveTriggerRadius");
	level.howLongToDoLastStandForWithRevive = GetDvarFloat("player_lastStandBleedoutTime");
	level.howLongToDoLastStandForWithoutRevive = 10;
	level.aboutToBleedOutTime = 5;
	level.reviveXP = GetDvarInt("player_reviveXP");	
	// if both of these are zero then max ammo is given
	level.amountOfLastStandPistolAmmoInClip = 0;
	level.amountOfLastStandPistolAmmoInStock = 0;
	
	if( !IsDefined( level.laststandpistol ) )
	{
		level.laststandpistol = "colt_mp";
		PrecacheItem( level.laststandpistol );
	}
	
	level.allies_needs_revive = false;
	level.axis_needs_revive = false;
	
	if( GetDvar( "revive_time_taken" ) == "" )
	{
		SetDvar( "revive_time_taken", "2" );
	}
}

LastStandTime()
{
	if ( allowRevive() )
		return level.howLongToDoLastStandForWithRevive;

	return level.howLongToDoLastStandForWithoutRevive;
}

PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self.lastStandParams = spawnstruct();
	self.lastStandParams.eInflictor = eInflictor;
	self.lastStandParams.attacker = attacker;
	self.lastStandParams.iDamage = iDamage;
	self.lastStandParams.sMeansOfDeath = sMeansOfDeath;
	self.lastStandParams.sWeapon = sWeapon;
	self.lastStandParams.vDir = vDir;
	self.lastStandParams.sHitLoc = sHitLoc;
	self.lastStandParams.lastStandStartTime = gettime();	
	
	mayDoLastStand = mayDoLastStand( sWeapon, sMeansOfDeath, sHitLoc );
	/#
	if ( getdvar("scr_forcelaststand" ) == "1" )
		mayDoLastStand = true;
	#/

	if ( !mayDoLastStand )
	{
		self.useLastStandParams = true;
		self ensureLastStandParamsValidity();
		self suicide();
		return;
	}

	self.health = 1;
	self thread maps\mp\gametypes\_gameobjects::onPlayerLastStand();

	if( IsDefined( self.laststand ) )
	{
		return;
	}

	weaponslist = self getweaponslist();
	assertex( isdefined( weaponslist ) && weaponslist.size > 0, "Player's weapon(s) missing before dying -=Last Stand=-" );
	
	self.previousweaponslist = self getweaponslist();
	
	self.previousAmmoClip = [];
	self.previousAmmoStock = [];
	self.laststandpistol = level.laststandpistol;
	self.previousPrimary = self GetCurrentWeapon();
	self.hadPistol = false;

	// check if player has pistol
	// if he does give him is instead of the default weapon
	for( i = 0; i < self.previousweaponslist.size; i++ )
	{
		if ( WeaponClass( self.previousweaponslist[i] ) == "pistol" ) 
		{
			self.laststandpistol = self.previousweaponslist[i];
			self.hadPistol = true;
		}
	}

	gun = self GetCurrentWeapon();
	if (gun == "syrette_mp")
	{
		self takeWeapon ("syrette_mp");
		self giveWeapon ( self.previousprimary );
	}
	
	// reset the previousweaponslist
	// now that the primary weapon has been thrown down
	self.previousweaponslist = self getweaponslist();
	for( i = 0; i < self.previousweaponslist.size; i++ )
	{
		weapon = self.previousweaponslist[i];
		
		self.previousAmmoClip[i] = self GetWeaponAmmoClip ( weapon );
		self.previousAmmoStock[i] = self GetWeaponAmmoStock ( weapon );
	}

	if ( !level.hardcoreMode || self.team != attacker.team ) 
		revive_trigger_spawn();

	self takeallweapons();

	// the last stand pistol is given after the weaponslist is made
	self giveWeapon( self.laststandpistol );
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
	
	self thread watchForInvalidWeaponSwitch();
	
	if ( self isThrowingGrenade() )
		self thread waittillGrenadeThrown();
	else	
	{
		grenadeTypePrimary = "frag_grenade_mp";
		self GiveWeapon( grenadeTypePrimary );
		self SetWeaponAmmoClip( grenadeTypePrimary, 0 );
		self SwitchToOffhand( grenadeTypePrimary );
	}
	
	self lastStandTimer( LastStandTime() );
}

watchForInvalidWeaponSwitch()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "player revived" );

	while(1)
	{
		weapons = self getweaponslistprimaries();
		
		for ( i = 0; i < weapons.size; i++ )
		{
			if ( weapons[i] == self.laststandpistol )
				continue;
				
			self takeweapon( weapons[i] );
			self switchtoweapon( self.laststandpistol );
		}
		wait (0.25);
	}
}

waittillGrenadeThrown()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "player revived" );
	
	self waittill("grenade_fire");
	
	grenadeTypePrimary = "frag_grenade_mp";
	self GiveWeapon( grenadeTypePrimary );
	self SetWeaponAmmoClip( grenadeTypePrimary, 0 );
	self SwitchToOffhand( grenadeTypePrimary );
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
	
	vehicle = self GetVehicleOccupied();
	
	if ( IsDefined( vehicle ) )
	{
		return false;
	}
		
	return true;
}


lastStandTimer( delay )
{	
	self thread lastStandWaittillDeath();
	self.aboutToBleedOut = undefined;
	self.lastStand = true;
	self setLowerMessage( &"PLATFORM_COWARDS_WAY_OUT" );
	
	self thread lastStandBleedout(delay);
}


lastStandWaittillDeath()
{
	self endon( "disconnect" );
	
	self waittill( "death" );
	
	teamMateNeedsRevive = false;
	
	self.thisPlayerisinlaststand = false;
	self clearLowerMessage();
	self.lastStand = undefined;
	
	if ( !allowRevive() )
		return;

	players = get_players();
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

	players = get_players();
	teamMateNeedsRevive = false;
	for (i = 0; i < players.size; i++)
	{
		if ( "allies" == players[i].team)
		{
			if (isdefined (players[i].revivetrigger))
			{
				teammateNeedsRevive = true;
			}
		}
	}
	level.allies_needs_revive = teammateNeedsRevive;
	
	teamMateNeedsRevive = false;
		
	for (i = 0; i < players.size; i++)
	{
		if ( "axis" == players[i].team)
		{
			if (isdefined (players[i].revivetrigger))
			{
				teammateNeedsRevive = true;
			}
		}
	}
	level.axis_needs_revive = teammateNeedsRevive;
}

setTeamRevive(needsRevive)
{
	if (self.team == "allies")
	{
		level.allies_needs_revive = needsRevive;
	}
	else if (self.team == "axis")
	{
		level.axis_needs_revive = needsRevive;
	}
}

teamMateNeedsRevive()
{
	teamMateNeedsRevive = false;
	if (isdefined (self.team))
	{
		if (self.team == "allies")
		{
			teamMateNeedsRevive = level.allies_needs_revive;
		}
		else if (self.team == "axis")
		{
			teamMateNeedsRevive = level.axis_needs_revive;
		}
	}
	return teamMateNeedsRevive;
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
	
	while (isdefined(self) && isdefined (self.thisPlayerIsInLastStand) && self.thisPlayerIsInLastStand == true)
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
						players[i] thread cleanUpRevivingTeamate( self );
						if ( players[i].health > 0 
						&& isDefined(self.revivetrigger) 
						&& players[i] istouching(self.revivetrigger) 
						&& players[i] useButtonPressed())
						{
							players[i].revivingTeammate = true;
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
							
							players[i] player_being_revived(self); 

							if ( isdefined ( self ) )
								self.currentlyBeingRevived = false;

							players[i] TakeWeapon( "syrette_mp" );
							if (isdefined (players[i].previousPrimary) && players[i].previousPrimary != "none" )
							{
								players[i] SwitchToWeapon( players[i].previousprimary );
							}
							players[i].previousprimary = undefined;
							players[i] notify( "completedRevive" );
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
	reviveTime = GetDvarInt( "revive_time_taken" );
	
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
		
				if (level.rankedmatch)
				{
					self maps\mp\gametypes\_rank::giveRankXP( "revive", level.reviveXP );
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
	self revive();
	self needsRevive( false );
	self.revivetrigger delete();
	self.aboutToBleedOut = undefined;
	
	self clearLowerMessage( );
	
	if ( self.hadPistol == false)
	{
		self takeallweapons();
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
		self SwitchToWeapon (self.previousPrimary);
	}	
	
	self.laststandpistol = level.laststandpistol;
	self.lastStand = undefined;
	
	// only remove the team wide teammate_needs_revive flag
	// if no other players on your team are needing revive
	players = get_players();
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
	
	players = get_players();
	
	for (i = 0; i < players.size; i++)
	{
		players[i] notify ("stop revive pulse");
	}
	self needsRevive( false );
	self.useLastStandParams = true;
	self ensureLastStandParamsValidity();
	self suicide();
}

// this will trigger if they land on some bad terrain
lastStandEndOnForceCrouch()
{
	self endon ("player revived");
	self endon ("disconnect");
	self endon ("death");
	self endon ("end coward");
	
	self waittill ("force crouch");
	
	self needsRevive( false );
	self.useLastStandParams = true;
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
	self.useLastStandParams = true;
	self ensureLastStandParamsValidity();
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
	
	players = get_players();	
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
	}
	
	players = get_players();
	
	for ( i = 0; i < players.size && i < 4; i++ )
	{
		if ( self.team != players[i].team )
			continue;
		if ( !isdefined(players[i].lastStand) || !players[i].lastStand )
			continue;

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
	
	players = get_players();
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
	if ( !allowRevive() )
		return;

    if ( !isDefined( self.reviveIcons[0] ) )
        return;

	triggerreviveId = lastStandPlayer getentitynumber();
	
	useId = -1;
	
	for ( index = 0; (index < 4)&& (useId == -1); index++ )
	{
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
		
	self.reviveIcons[useId].x = lastStandPlayer.origin[0];
	self.reviveIcons[useId].y = lastStandPlayer.origin[1];
	self.reviveIcons[useId].z = lastStandPlayer.origin[2]+64;
	self.reviveIcons[useId] setWaypoint( true, "waypoint_second_chance");
	
	self.reviveIcons[useId].alpha = 0.8;
	self.reviveIcons[useId].reviveId = triggerreviveId;
	
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
		wait ( loopTime );
		
	}
		
	if ( !isDefined( self ) )
		return;
		

	self.reviveIcons[useId].reviveId = -1;
	self.reviveIcons[useId] fadeOverTime( 0.25 );
	self.reviveIcons[useId].alpha = 0;
	self.reviveIcons[useId] setWaypoint( false );
}

can_revive( reviver )
{
	if ( isdefined ( reviver ) && reviver hasPerk ("specialty_pistoldeath") )
		return true;
		
	return false;		
}

