#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

/*
File for the mechanic of the player clinging to the back of the bus.  This is a different mode similar to last stand.
*/

// call this after the bus is ready to setup the cling mechanic
initializeCling()
{
	setupClingTrigger();
}

setupClingTrigger()
{
	// if the bus isn't setup then bail
	if ( !IsDefined( level.the_bus ) )
	{
		return;
	}
	
	enableCling();
	
	// link the cling triggers to the bus and set their strings
	triggers = [];
	level.cling_triggers = [];
	triggers = getEntArray( "cling_trigger", "script_noteworthy" );
	
	for ( i = 0; i <triggers.size; i++ )
	{
		level.cling_triggers[i] = spawnstruct();
		level.cling_triggers[i].trigger = triggers[i];
		trigger = level.cling_triggers[i].trigger;
		trigger SetHintString( "Hold [{+activate}] To Cling To The Bus." );
		trigger SetCursorHint( "HINT_NOICON" );
		makeVisibleToAll(trigger);
		trigger enableLinkTo();
		trigger linkto(level.the_bus, "", level.the_bus worldtolocalcoords(trigger.origin), trigger.angles - level.the_bus.angles);

		trigger thread setClingTriggerVisibility(i);
		trigger thread clingTriggerUseThink(i);
		
		// link the script_origin to the bus that has the position to cling to.
		level.cling_triggers[i].position = getEnt( trigger.target, "targetname" );
		position = level.cling_triggers[i].position;
		position linkto(level.the_bus, "", level.the_bus worldtolocalcoords(position.origin), position.angles - level.the_bus.angles);
		
		// this will be set when a player is attached
		level.cling_triggers[i].player = undefined;
	}
	
	// Disable Cling For Now
	//----------------------
	disableCling();
}

// function to enable the cling triggers
enableCling()
{
	level.cling_enabled = true;
	
	if ( IsDefined( level.cling_triggers ) )
	{
		foreach ( struct in level.cling_triggers )
		{
			struct.trigger SetHintString( "Hold [{+activate}] To Cling To The Bus." );
			struct.trigger SetTeamForTrigger( "allies" );
		}
	}
}

// function to disable cling
disableCling()
{
	level.cling_enabled = false;
	detachAllPlayersFromClinging();
	
	if ( IsDefined( level.cling_triggers ) )
	{
		foreach ( struct in level.cling_triggers )
		{
			struct.trigger SetHintString( "" );
			struct.trigger SetTeamForTrigger( "none" );
		}
	}
}

// make the passed trig
makeVisibleToAll(trigger)
{
	players = GET_PLAYERS();
	for(playerIndex = 0; playerIndex < players.size; playerIndex++ )
	{
		trigger setInvisibleToPlayer( players[playerIndex], false );
	}
}

// function that handles when the trigger is pressed
clingTriggerUseThink(positionIndex)
{
	while (1)
	{
		self waittill( "trigger", who );
		if ( !level.cling_enabled )
		{
			continue;
		}
		if ( !who UseButtonPressed() )
		{
			continue;
		}

		if ( who in_revive_trigger() )
		{
			continue;
		}
		
		if ( IsDefined( who.is_drinking ) && who.is_drinking == true )
		{
			continue;
		}
		
		if ( IsDefined( level.cling_triggers[positionIndex].player ) )
		{
			// detach the player
			if ( level.cling_triggers[positionIndex].player == who )
			{
				dettachPlayerFromBus(who, positionIndex);
			}
			
			continue;
		}
		
		attachPlayerToBus(who, positionIndex);
		thread detachFromBusOnEvent(who, positionIndex);
	}
}

// set the cling triggers visiblity based upon if anyone is attached to it
setClingTriggerVisibility(positionIndex)
{
	while ( 1 )
	{
		// set the trigger invisible to players not attached to it
		players = GET_PLAYERS();
		for( i = 0; i < players.size; i++ )
		{
			is_player_clinging = IsDefined( level.cling_triggers[positionIndex].player ) && level.cling_triggers[positionIndex].player == players[i];
			no_player_clinging = !IsDefined( level.cling_triggers[positionIndex].player );
			if ( is_player_clinging || ( no_player_clinging  && level.cling_enabled ) )
			{
				self setInvisibleToPlayer(players[i], false);
			}
			else
			{
				self setInvisibleToPlayer(players[i], true);
			}
		}
		wait(0.1);
	}
}

// function that detaches all players from cling points
detachAllPlayersFromClinging()
{
	for ( positionIndex = 0; positionIndex < level.cling_triggers.size; positionIndex++ )
	{
		if ( !IsDefined( level.cling_triggers[positionIndex] ) || !IsDefined( level.cling_triggers[positionIndex].player ) )
		{
			continue;
		}
		
		players = GET_PLAYERS();
		for( i = 0; i < players.size; i++ )
		{
			if ( level.cling_triggers[positionIndex].player == players[i] )
			{
				dettachPlayerFromBus(players[i], positionIndex);
				break;
			}
		}
	}
}

// function that attaches the passed player to the bus
attachPlayerToBus(player, positionIndex)
{
	// if the platform is upgraded, be able to turn 360 degrees
	turn_angle = 130;
	pitch_up = 25;
	if ( positionIsUpgraded(positionIndex) )
	{
		turn_angle = 180;
		pitch_up = 120;
	}
	
	level.cling_triggers[positionIndex].player = player;
	if ( positionIsBL(positionIndex) )
	{
		player PlayerLinkToDelta( level.cling_triggers[positionIndex].position, "tag_origin", 1, 180, turn_angle, pitch_up, 120, true );
	}
	else if ( positionIsBR(positionIndex) )
	{
		player PlayerLinkToDelta( level.cling_triggers[positionIndex].position, "tag_origin", 1, turn_angle, 180, pitch_up, 120, true );
	}
	else
	{
		// something is not setup right, so reset and bail
		level.cling_triggers[positionIndex].player = undefined;
		return;
	}
	level.cling_triggers[positionIndex].trigger setHintString( "Hold [{+activate}] To Let Go Of The Bus." );
	player disablePlayerWeapons(positionIndex);
	//level.the_bus maps\mp\zm_transit_upgrades::busEnableTurrets(false, player);
}

// check if the passed position is the back left
positionIsBL(positionIndex)
{
	return ( level.cling_triggers[positionIndex].position.script_string == "back_left" );
}

// check if the passed position is the back right
positionIsBR(positionIndex)
{
	return ( level.cling_triggers[positionIndex].position.script_string == "back_right" );
}

// check if the passed position is upgraded
positionIsUpgraded(positionIndex)
{
	return	( ( positionIsBL(positionIndex) && IsDefined(level.the_bus.upgrades["PlatformL"]) && level.the_bus.upgrades["PlatformL"].installed ) ||
		 	  ( positionIsBR(positionIndex) && IsDefined(level.the_bus.upgrades["PlatformR"]) && level.the_bus.upgrades["PlatformR"].installed ) );
}

// function that detaches the passed player from the bus
dettachPlayerFromBus(player, positionIndex)
{
	level.cling_triggers[positionIndex].trigger setHintString( "Hold [{+activate}] To Cling To The Bus." );
	if ( !IsDefined( level.cling_triggers[positionIndex].player ) )
	{
		return;
	}
	player Unlink();
	level.cling_triggers[positionIndex].player = undefined;
	player enablePlayerWeapons(positionIndex);
	//level.the_bus maps\mp\zm_transit_upgrades::busEnableTurrets(true, player);
	player notify ("cling_dettached");
}

// thread function that handles the case if the clung player dies or ambush round starts he should detach from the bus
detachFromBusOnEvent(player, positionIndex)
{
	player endon ("cling_dettached");
	player waittill_any( "fake_death", "death", "player_downed" );
	dettachPlayerFromBus(player, positionIndex);
}

// Disable the player weapons and give the player a pistol if they don't already have one.
// self = a player
disablePlayerWeapons(positionIndex)
{
	weaponInventory = self GetWeaponsList( true );
	self.lastActiveWeapon = self GetCurrentWeapon();
	self.clingPistol = undefined;
	self.hadClingPistol = false;

	// if the player is not on an upgraded cling position
	if ( !positionIsUpgraded(positionIndex) )
	{
		for( i = 0; i < weaponInventory.size; i++ )
		{
			weapon = weaponInventory[i];

			// how the cling pistol is chosen:
			// 1st preference to your last active weapon
			// preference to anything besides the starting pistol
			if ( WeaponClass( weapon ) == "pistol" && 
				( !IsDefined( self.clingPistol ) || weapon == self.lastActiveWeapon || self.clingPistol == "m1911_zm" ) ) 
			{
				self.clingPistol = weapon;
				self.hadClingPistol = true;
			}
		}
		
		// if the player doesn't have a pistol, they immediately find one
		if ( !IsDefined( self.clingPistol ) )
		{
			self GiveWeapon("m1911_zm");
			self.clingPistol = "m1911_zm";
		}
		
		self SwitchToWeapon(self.clingPistol); 
		
		self DisableWeaponCycling();
		self DisableOffhandWeapons();
		self AllowCrouch( false );
	}
	self AllowLean( false );
	self AllowSprint( false );
	self AllowProne( false );
}

// Enable the player weapons and take away the free pistol if they got one.
// self = a player
enablePlayerWeapons(positionIndex)
{
	self AllowLean( true );
	self AllowSprint( true );
	self AllowProne( true );
	
	if ( !positionIsUpgraded(positionIndex) )
	{
		if ( !self.hadClingPistol )
		{
			self TakeWeapon( "m1911_zm" );
		}
	
		self EnableWeaponCycling();
		self EnableOffhandWeapons();
		self AllowCrouch( true );
		
		// try to switch to the last weapon held
		if( self.lastActiveWeapon != "none" && self.lastActiveWeapon != "mortar_round" && self.lastActiveWeapon != "mine_bouncing_betty" && self.lastActiveWeapon != "claymore_zm" )
		{
			self SwitchToWeapon( self.lastActiveWeapon );
		}
		else
		{
			primaryWeapons = self GetWeaponsListPrimaries();
			if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
			{
				self SwitchToWeapon( primaryWeapons[0] );
			}
		}
	}
}

// returns true if the player is clinging to the bus
playerIsClingingToBus()
{
	if ( !IsDefined( level.cling_triggers ) )
	{
		return false;
	}
	
	for ( i = 0; i < level.cling_triggers.size; i++ )
	{
		if ( !IsDefined( level.cling_triggers[i] ) || !IsDefined( level.cling_triggers[i].player ) )
		{
			continue;
		}
		
		if ( level.cling_triggers[i].player == self )
		{
			return true;
		}
	}
	return false;
}

// return the number of players currently clinging
_getNumPlayersClinging()
{
	num_clinging = 0;
	for ( i = 0; i < level.cling_triggers.size; i++ )
	{
		if ( IsDefined( level.cling_triggers[i] ) && IsDefined( level.cling_triggers[i].player ) )
		{
			num_clinging++;
		}
	}
	return num_clinging;
}

// return a good position to attack from on the bus
_getBusAttackPosition(player)
{
	pos = (-208, 0, 48);
	return level.the_bus localToWorldCoords(pos);
	/*pos_BL_best = (-224, -24, 48);
	pos_BR_best = (-224, 32, 48);
	pos_BL_best = level.the_bus localToWorldCoords(pos_BL_best);
	pos_BR_best = level.the_bus localToWorldCoords(pos_BR_best);
	
	for ( i = 0; i < level.cling_triggers.size; i++ )
	{
		if ( !IsDefined( level.cling_triggers[i] ) || !IsDefined( level.cling_triggers[i].player ) )
		{
			continue;
		}
		
		if ( level.cling_triggers[i].player == player && positionIsBL(i) )
		{
			return pos_BL_best;
		}
		else if ( level.cling_triggers[i].player == player && positionIsBR(i) )
		{
			return pos_BR_best;
		}
	}
	return pos_BL_best;*/
}