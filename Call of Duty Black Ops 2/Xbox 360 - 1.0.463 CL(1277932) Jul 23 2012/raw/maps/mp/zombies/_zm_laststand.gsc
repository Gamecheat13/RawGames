#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes\_hud_util;

laststand_global_init()
{
	level.CONST_LASTSTAND_GETUP_COUNT_START				= 0;		// The number of laststands in type getup that the player starts with

	level.CONST_LASTSTAND_GETUP_BAR_START				= 0.5;		// Fill amount of the getup bar the first time it is used
	level.CONST_LASTSTAND_GETUP_BAR_REGEN				= 0.0025;	// Percent of the bar filled for auto fill logic
	level.CONST_LASTSTAND_GETUP_BAR_DAMAGE				= 0.1;		// Percent of the bar removed by AI damage
}

init()
{
	if (level.script=="frontend")
		return ;

	laststand_global_init();

	level.revive_tool = "syrette_zm";
	PrecacheItem( level.revive_tool );
	//PrecacheItem( "colt_dirty_harry" ); 
	precachestring( &"GAME_BUTTON_TO_REVIVE_PLAYER" );
	precachestring( &"GAME_PLAYER_NEEDS_TO_BE_REVIVED" );
	precachestring( &"GAME_PLAYER_IS_REVIVING_YOU" );	
	precachestring( &"GAME_REVIVING" );

	if( !IsDefined( level.laststandpistol ) )
	{
		level.laststandpistol = "m1911";
		PrecacheItem( level.laststandpistol );
	}

	//CODER_MOD: TOMMYK 07/13/2008 - Revive text
	//if( !arcadeMode() )
	//{
		level thread revive_hud_think();
	//}

	level.primaryProgressBarX = 0;
	level.primaryProgressBarY = 110;
	level.primaryProgressBarHeight = 4;
	level.primaryProgressBarWidth = 120;

	if ( IsSplitScreen() )
	{
		level.primaryProgressBarY = 280;
	}

	if( GetDvar( "revive_trigger_radius" ) == "" )
	{
		SetDvar( "revive_trigger_radius", "40" ); 
	}

	level.lastStandGetupAllowed = false;
}


player_is_in_laststand()
{
	return ( IsDefined( self.revivetrigger ) );
}


player_num_in_laststand()
{
	num = 0;
	players = GET_PLAYERS();

	for ( i = 0; i < players.size; i++ )
	{	
		if ( players[i] player_is_in_laststand() )
		{
			num++;
		}
	}

	return num;
}


player_all_players_in_laststand()
{
	return ( player_num_in_laststand() == GET_PLAYERS().size );
}


player_any_player_in_laststand()
{
	return ( player_num_in_laststand() > 0 );
}


PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	// check to see if we are in a game module that wants to do something with PvP damage
	if( isDefined( level._game_module_player_laststand_callback ) )
	{
		self [[ level._game_module_player_laststand_callback ]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
	}

	if( self player_is_in_laststand() )
	{
		return;
	}

	//stat tracking
	self.downs++;
	self maps\mp\zombies\_zm_stats::increment_client_stat( "downs" );

	// Zombie players who die should not go into LastStand
	/*
	if ( is_true( self.is_zombie ) )
	{
		self notify("bled_out"); 
		wait_network_frame(); //to guarantee the notify gets sent and processed before the rest of this script continues to turn the guy into a spectator
		self bleed_out();
		
		return;
	}
	*/

	//PI CHANGE: player shouldn't be able to jump while in last stand mode (only was a problem in water) - specifically disallow this
	self AllowJump(false);
	//END PI CHANGE
	
	if( IsDefined( level.playerlaststand_func ) )
	{
		[[level.playerlaststand_func]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
	}

	// vision set
	VisionSetLastStand( "zombie_last_stand", 1 );
	
	self.health = 1;
	self.laststand = true;
	self thread maps\mp\gametypes\_gameobjects::onPlayerLastStand();
	
	//self thread call_overloaded_func( "maps\_arcademode", "arcademode_player_laststand" );

	// revive trigger
	if ( !is_true( self.no_revive_trigger ) )
	{
		self revive_trigger_spawn();
	}

	// laststand weapons
	self laststand_disable_player_weapons();
	self laststand_give_pistol();

	if( is_true(level.playerSuicideAllowed ) && GET_PLAYERS().size > 1 )
	{
		if (!IsDefined(level.canPlayerSuicide) || self [[level.canPlayerSuicide]]() )
		{
			self thread suicide_trigger_spawn();
		}
	}
	
	// Reset Disabled Power Perks Array On Downed State
	//-------------------------------------------------
	if ( IsDefined( self.disabled_perks ) )
	{
		self.disabled_perks = [];
	}

	if( level.lastStandGetupAllowed )
	{
		self thread laststand_getup();
	}
	else
	{
		// bleed out timer
		bleedout_time = GetDvarfloat( "player_lastStandBleedoutTime" );
		self thread laststand_bleedout( bleedout_time );
	}
	
	maps\mp\_demo::bookmark( "zm_player_downed", gettime(), self );
	self notify( "player_downed" );
	self thread refire_player_downed();
}

refire_player_downed()
{
	self endon("player_revived");
	self endon("death");
	wait(1.0);
	if(self.num_perks)
	{
		self notify("player_downed");
	}

}

laststand_allowed( sWeapon, sMeansOfDeath, sHitLoc )
{
	if( level.laststandpistol == "none" )
	{
		return false;
	}
	
	return true;
}


// self = a player
laststand_disable_player_weapons()
{
	weaponInventory = self GetWeaponsList( true );
	self.lastActiveWeapon = self GetCurrentWeapon();
	self SetLastStandPrevWeap( self.lastActiveWeapon );
	self.laststandpistol = undefined;
	
	//assert( self.lastActiveWeapon != "none", "Last active weapon is 'none,' an unexpected result." );

	self.hadpistol = false;

	if ( isdefined( self.weapon_taken_by_losing_specialty_additionalprimaryweapon ) && self.lastActiveWeapon == self.weapon_taken_by_losing_specialty_additionalprimaryweapon )
	{
		self.lastActiveWeapon = "none";
		self.weapon_taken_by_losing_specialty_additionalprimaryweapon = undefined;
	}

	for( i = 0; i < weaponInventory.size; i++ )
	{
		weapon = weaponInventory[i];
		
		if ( WeaponClass( weapon ) == "pistol" && !IsDefined( self.laststandpistol ) ) 
		{
			self.laststandpistol = weapon;
			self.hadpistol = true;

		}
		
		switch( weapon )
		{
			// this player was killed while reviving another player
		case "syrette_zm": 
		// player was killed drinking perks-a-cola
		case "zombie_perk_bottle_doubletap": 
		case "zombie_perk_bottle_revive":
		case "zombie_perk_bottle_jugg":
		case "zombie_perk_bottle_sleight":
		case "zombie_perk_bottle_marathon":
		case "zombie_perk_bottle_nuke":
		case "zombie_perk_bottle_deadshot":
		case "zombie_perk_bottle_additionalprimaryweapon":
		case "zombie_perk_bottle_tombstone":
			self TakeWeapon( weapon );
			self.lastActiveWeapon = "none";
			continue;
		}
		if(isDefined(level.item_meat_name))
		{
			if(weapon == level.item_meat_name)
			{
				self TakeWeapon( weapon );
				self.lastActiveWeapon = "none";
				continue;
			}
		}
	}
	
	if( IsDefined( self.hadpistol ) && self.hadpistol == true && IsDefined( level.zombie_last_stand_pistol_memory ) )
	{
		self [ [ level.zombie_last_stand_pistol_memory ] ]();
	}
	

	if ( !IsDefined( self.laststandpistol ) )
	{
		self.laststandpistol = level.laststandpistol;
	}
	
	self DisableWeaponCycling();
}


// self = a player
laststand_enable_player_weapons()
{
	if ( IsDefined( self.hadpistol ) && !self.hadpistol && IsDefined( self.laststandpistol ) )
	{
		self TakeWeapon( self.laststandpistol );
	}
	
	if( IsDefined( self.hadpistol ) && self.hadpistol == true && IsDefined( level.zombie_last_stand_ammo_return ) )
	{
		[ [ level.zombie_last_stand_ammo_return ] ]();
	}
	
	self EnableWeaponCycling();
	self EnableOffhandWeapons();

	// if we can't figure out what the last active weapon was, try to switch a primary weapon
	//CHRIS_P: - don't try to give the player back the mortar_round weapon ( this is if the player killed himself with a mortar round)
	if( self.lastActiveWeapon != "none" && !is_placeable_mine( self.lastActiveWeapon ) )
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

laststand_clean_up_on_disconnect( playerBeingRevived, reviverGun )
{
	self endon( "do_revive_ended_normally" );

	reviveTrigger = playerBeingRevived.revivetrigger;

	playerBeingRevived waittill("disconnect");	
	
	if( isdefined( reviveTrigger ) )
	{
		reviveTrigger delete();
	}
	self cleanup_suicide_hud();
	
	if( isdefined( self.reviveProgressBar ) )
	{
		self.reviveProgressBar destroyElem();
	}
	
	if( isdefined( self.reviveTextHud ) )
	{
		self.reviveTextHud destroy();
	}
	
	self revive_give_back_weapons( reviverGun );
}

laststand_clean_up_reviving_any( playerBeingRevived )
{
	self endon( "do_revive_ended_normally" );

	playerBeingRevived waittill_any( "disconnect", "zombified", "stop_revive_trigger" );

	self.is_reviving_any--;
	if ( 0 > self.is_reviving_any )
	{
		self.is_reviving_any = 0;
	}
}

laststand_give_pistol()
{
	assert( IsDefined( self.laststandpistol ) );
	assert( self.laststandpistol != "none" );
	//assert( WeaponClass( self.laststandpistol ) == "pistol" );

	if( IsDefined( level.zombie_last_stand  ) )// CODER_MOD (Austin 5/4/08): zombiemode loadout setup GetDvar( "zombiemode" ) == "1" || IsSubStr( level.script, "nazi_zombie_" )
	{
		[ [ level.zombie_last_stand ] ](); // SCRIPT MOD (Walter 08-02-10): moved zombie scripts in to zombie files.
	}
	else
	{
		self GiveWeapon( self.laststandpistol );
		self GiveMaxAmmo( self.laststandpistol );
		self SwitchToWeapon( self.laststandpistol );
	}
}



Laststand_Bleedout( delay )
{
	self endon ("player_revived");
	self endon ("player_suicide");
	self endon ("disconnect");

	//self PlayLoopSound("heart_beat",delay);	// happens on client now DSL

	// Notify client that we're in last stand.
	
	setClientSysState("lsm", "1", self);

	self.bleedout_time = delay;

	while ( self.bleedout_time > Int( delay * 0.5 ) )
	{
		self.bleedout_time -= 1;
		wait( 1 );
	}

	VisionSetLastStand( "zombie_death", delay * 0.5 );
	
	while ( self.bleedout_time > 0 )
	{
		self.bleedout_time -= 1;
		wait( 1 );
	}

	//CODER_MOD: TOMMYK 07/13/2008
	while( IsDefined( self.revivetrigger ) && IsDefined( self.revivetrigger.beingRevived ) && self.revivetrigger.beingRevived == 1 )
	{
		wait( 0.1 );
	}
	
	self notify("bled_out"); 
	wait_network_frame(); //to guarantee the notify gets sent and processed before the rest of this script continues to turn the guy into a spectator

	self bleed_out();
	
}


bleed_out()
{
	self cleanup_suicide_hud();
	if( isdefined( self.reviveTrigger ) )
		self.reviveTrigger delete();
	self.reviveTrigger=undefined;
	
	setClientSysState("lsm", "0", self);	// Notify client last stand ended.
	//self AddPlayerStat( "zombie_deaths", 1 );
	self maps\mp\zombies\_zm_stats::increment_client_stat( "deaths" );

	self maps\mp\zombies\_zm_equipment::equipment_take();

	maps\mp\_demo::bookmark( "zm_player_bledout", gettime(), self );
	level notify("bleed_out", self.characterindex);
	//clear the revive icon
	self UndoLastStand();
	
	if (isdefined(level.is_zombie_level ) && level.is_zombie_level)
	{
		self [[level.player_becomes_zombie]]();
	}
	else if (isdefined(level.is_specops_level ) && level.is_specops_level)
	{
		self thread [[level.spawnSpectator]]();
	}
	else
	{
		self.ignoreme = false;
	}
}


cleanup_suicide_hud()
{
	if (isdefined(self.suicidePrompt))
		self.suicidePrompt destroy();	
	self.suicidePrompt = newclientHudElem( self );	
}


suicide_trigger_spawn()
{
	radius = GetDvarint( "revive_trigger_radius" );

	self.suicidePrompt = newclientHudElem( self );	
	
	self.suicidePrompt.alignX = "center";
	self.suicidePrompt.alignY = "middle";
	self.suicidePrompt.horzAlign = "center";
	self.suicidePrompt.vertAlign = "bottom";
	self.suicidePrompt.y = -113;
	if ( IsSplitScreen() )
	{
		self.suicidePrompt.y = -107;
	}
	self.suicidePrompt.foreground = true;
	self.suicidePrompt.font = "default";
	self.suicidePrompt.fontScale = 1.5;
	self.suicidePrompt.alpha = 1;
	self.suicidePrompt.color = ( 1.0, 1.0, 1.0 );

	self thread suicide_trigger_think();
}

// logic for the revive trigger
suicide_trigger_think()
{
	self endon ( "disconnect" );
	self endon ( "zombified" );
	self endon ( "stop_revive_trigger" );
	self endon ( "player_revived");
	self endon ( "bled_out"); 
	
	while ( 1 )
	{
		wait ( 0.1 );

		players = GET_PLAYERS();
			
		self.suicidePrompt setText( &"ZOMBIE_BUTTON_TO_SUICIDE" );
		
		if ( !self is_suiciding() )
		{
			continue;
		}

		self.pre_suicide_weapon = self GetCurrentWeapon();
		self GiveWeapon( level.suicide_weapon );
		self SwitchToWeapon( level.suicide_weapon );
		duration = self doCowardsWayAnims();

		suicide_success = suicide_do_suicide(duration);
		self.laststand = undefined;
		self TakeWeapon( level.suicide_weapon );

		if ( suicide_success )
		{
			self notify("player_suicide");

			wait_network_frame(); //to guarantee the notify gets sent and processed before the rest of this script continues to turn the guy into a spectator

			//This needs to be added to DDLs 
			//self maps\mp\zombies\_zm_stats::increment_client_stat( "suicides" );
			self bleed_out();

			return;
		}

		self SwitchToWeapon( self.pre_suicide_weapon );
		self.pre_suicide_weapon = undefined;
	}
}

suicide_do_suicide(duration) 
{
	suicideTime = duration; //1.5;

	timer = 0;

	suicided = false;
	
	self.suicidePrompt setText( "" );
	
	if( !isdefined(self.suicideProgressBar) )
	{
		self.suicideProgressBar = self createPrimaryProgressBar();
	}

	if( !isdefined(self.suicideTextHud) )
	{
		self.suicideTextHud = newclientHudElem( self );	
	}
	
	self.suicideProgressBar updateBar( 0.01, 1 / suicideTime );

	self.suicideTextHud.alignX = "center";
	self.suicideTextHud.alignY = "middle";
	self.suicideTextHud.horzAlign = "center";
	self.suicideTextHud.vertAlign = "bottom";
	self.suicideTextHud.y = -113;
	if ( IsSplitScreen() )
	{
		self.suicideTextHud.y = -107;
	}
	self.suicideTextHud.foreground = true;
	self.suicideTextHud.font = "default";
	self.suicideTextHud.fontScale = 1.8;
	self.suicideTextHud.alpha = 1;
	self.suicideTextHud.color = ( 1.0, 1.0, 1.0 );
	self.suicideTextHud setText( &"ZOMBIE_SUICIDING" );
	
	while( self is_suiciding() )
	{
		wait( 0.05 );					
		timer += 0.05;			

		if( timer >= suicideTime)
		{
			suicided = true;	
			break;
		}
	}
	
	if( isdefined( self.suicideProgressBar ) )
	{
		self.suicideProgressBar destroyElem();
	}
	
	if( isdefined( self.suicideTextHud ) )
	{
		self.suicideTextHud destroy();
	}

	self.suicidePrompt setText( &"ZOMBIE_BUTTON_TO_SUICIDE" );
	
	return suicided;
}

can_suicide()
{
	if ( !isAlive( self ) )
	{
		return false;
	}

	if ( !self player_is_in_laststand() )
	{
		return false;
	}
		
	if( !isDefined( self.suicidePrompt ) )
	{
		return false;
	}
	
	if( IsDefined( self.is_zombie ) && self.is_zombie )
	{
		return false;
	}
		
	return true;
}

is_suiciding( revivee )
{	
	return ( can_suicide() && self UseButtonPressed() );
}



// spawns the trigger used for the player to get revived
revive_trigger_spawn()
{
	radius = GetDvarint( "revive_trigger_radius" );

	self.revivetrigger = spawn( "trigger_radius", self.origin, 0, radius, radius );
	self.revivetrigger setHintString( "" ); // only show the hint string if the triggerer is facing me
	self.revivetrigger setCursorHint( "HINT_NOICON" );
	self.revivetrigger SetMovingPlatformEnabled( true );

	self.revivetrigger EnableLinkTo();

	if ( IsDefined( level.revive_trigger_spawn_override_link ) )
	{
		[[ level.revive_trigger_spawn_override_link ]]( self );
	}
	else
	{
		self.revivetrigger LinkTo( self ); 
	}

	//CODER_MOD: TOMMYK 07/13/2008 - Revive text
	self.revivetrigger.beingRevived = 0;
	self.revivetrigger.createtime = gettime();
		
	self thread revive_trigger_think();

	//self.revivetrigger thread revive_debug();
}

// logic for the revive trigger
revive_trigger_think()
{
	self endon ( "disconnect" );
	self endon ( "zombified" );
	self endon ( "stop_revive_trigger" );
	
	while ( 1 )
	{
		wait ( 0.1 );

		//assert( DistanceSquared( self.origin, self.revivetrigger.origin ) <= 25 );
		//drawcylinder( self.revivetrigger.origin, 32, 32 );

		players = GET_PLAYERS();
			
		self.revivetrigger setReviveHintString( "", self.team );
		
		for ( i = 0; i < players.size; i++ )
		{
			//PI CHANGES - revive should work in deep water for nazi_zombie_sumpf
			d = 0;
					d = self depthinwater();
				
			if ( players[i] can_revive( self ) || d > 20)
			//END PI CHANGES
			{
				// TODO: This will turn on the trigger hint for every player within
				// the radius once one of them faces the revivee, even if the others
				// are facing away. Either we have to display the hints manually here
				// (making sure to prioritize against any other hints from nearby objects),
				// or we need a new combined radius+lookat trigger type.						
				self.revivetrigger setReviveHintString( &"GAME_BUTTON_TO_REVIVE_PLAYER", self.team );
				break;			
			}
		}
		
		for ( i = 0; i < players.size; i++ )
		{
			reviver = players[i];
			
			if ( !reviver is_reviving( self ) )
			{
				continue;
			}
			
			// give the syrette
			gun = reviver GetCurrentWeapon();
			assert( IsDefined( gun ) );
			//assert( gun != "none" );
			if ( gun == level.revive_tool )
			{
				//already reviving somebody
				continue;
			}

			reviver GiveWeapon( level.revive_tool );
			reviver SwitchToWeapon( level.revive_tool );
			reviver SetWeaponAmmoStock( level.revive_tool, 1 );

			//CODER_MOD: TOMMY K
			revive_success = reviver revive_do_revive( self, gun );
			
			reviver revive_give_back_weapons( gun );

			//PI CHANGE: player couldn't jump - allow this again now that they are revived
			self AllowJump(true);
			//END PI CHANGE
			
			self.laststand = undefined;

			if ( revive_success )
			{
				self thread revive_success( reviver );
				self cleanup_suicide_hud();
				return;
			}
		}
	}
}

revive_give_back_weapons( gun )
{
	// take the syrette
	self TakeWeapon( level.revive_tool );

	// Don't switch to their old primary weapon if they got put into last stand while trying to revive a teammate
	if ( self player_is_in_laststand() )
	{
		return;
	}

	if ( gun != "none" && !is_placeable_mine( gun ) && gun != "equip_gasmask_zm" && gun != "lower_equip_gasmask_zm" && self HasWeapon( gun ) )
	{
		self SwitchToWeapon( gun );
	}
	else 
	{
		// try to switch to first primary weapon
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}
}


can_revive( revivee )
{
	if ( !isAlive( self ) )
	{
		return false;
	}

	if ( self player_is_in_laststand() )
	{
		return false;
	}

	if ( IsDefined( self.current_equipment_active ) && is_true( self.current_equipment_active["equip_hacker_zm"] ) )
	{
		return false;
	}

	if ( !isDefined( revivee.revivetrigger ) )
	{
		return false;
	}

	if ( !self IsTouching( revivee.revivetrigger ) )
	{
		return false;
	}

	if ( self has_powerup_weapon() )
	{
		return false;
	}

	if ( revivee depthinwater() > 10 )
	{
		return true;
	}

	if ( !self is_facing( revivee ) )
	{
		return false;
	}

	if ( !SightTracePassed( self.origin + ( 0, 0, 50 ), revivee.origin + ( 0, 0, 30 ), false, undefined ) )				
	{
		return false;
	}

	//chrisp - fix issue where guys can sometimes revive thru a wall	
	if ( !bullettracepassed( self.origin + (0, 0, 50), revivee.origin + (0, 0, 30), false, undefined ) )
	{
		return false;
	}

	if ( IsDefined( self.is_zombie ) && self.is_zombie )
	{
		return false;
	}

	if ( isDefined( level.can_revive ) && ![[ level.can_revive ]]( revivee ) )
	{
		return false;
	}

	if ( isDefined( level.can_revive_game_module ) && ![[ level.can_revive_game_module ]]( revivee ) )
	{
		return false;
	}

	return true;
}

is_reviving( revivee )
{	
	return ( can_revive( revivee ) && self UseButtonPressed() );
}

is_reviving_any()
{	
	return is_true( self.is_reviving_any );
}

is_facing( facee )
{
	orientation = self getPlayerAngles();
	forwardVec = anglesToForward( orientation );
	forwardVec2D = ( forwardVec[0], forwardVec[1], 0 );
	unitForwardVec2D = VectorNormalize( forwardVec2D );
	toFaceeVec = facee.origin - self.origin;
	toFaceeVec2D = ( toFaceeVec[0], toFaceeVec[1], 0 );
	unitToFaceeVec2D = VectorNormalize( toFaceeVec2D );
	
	dotProduct = VectorDot( unitForwardVec2D, unitToFaceeVec2D );
	return ( dotProduct > 0.9 ); // reviver is facing within a ~52-degree cone of the player
}

// self = reviver
revive_do_revive( playerBeingRevived, reviverGun )
{
	assert( self is_reviving( playerBeingRevived ) );
	// reviveTime used to be set from a Dvar, but this can no longer be tunable:
	// it has to match the length of the third-person revive animations for
	// co-op gameplay to run smoothly.
	reviveTime = 3;

	if ( self HasPerk( "specialty_quickrevive" ) )
	{
		reviveTime = reviveTime / 2;
	}

	timer = 0;
	revived = false;
	
	//CODER_MOD: TOMMYK 07/13/2008
	playerBeingRevived.revivetrigger.beingRevived = 1;
	playerBeingRevived.revive_hud setText( &"GAME_PLAYER_IS_REVIVING_YOU", self );
	playerBeingRevived revive_hud_show_n_fade( 3.0 );
	
	playerBeingRevived.revivetrigger setHintString( "" );
	
	playerBeingRevived startrevive( self );

	if( !isdefined(self.reviveProgressBar) )
	{
		self.reviveProgressBar = self createPrimaryProgressBar();
	}

	if( !isdefined(self.reviveTextHud) )
	{
		self.reviveTextHud = newclientHudElem( self );	
	}
	
	self thread laststand_clean_up_on_disconnect( playerBeingRevived, reviverGun );

	if ( !IsDefined( self.is_reviving_any ) )
	{
		self.is_reviving_any = 0;
	}
	self.is_reviving_any++;
	self thread laststand_clean_up_reviving_any( playerBeingRevived );
	
	self.reviveProgressBar updateBar( 0.01, 1 / reviveTime );

	self.reviveTextHud.alignX = "center";
	self.reviveTextHud.alignY = "middle";
	self.reviveTextHud.horzAlign = "center";
	self.reviveTextHud.vertAlign = "bottom";
	self.reviveTextHud.y = -113;
	if ( IsSplitScreen() )
	{
		self.reviveTextHud.y = -107;
	}
	self.reviveTextHud.foreground = true;
	self.reviveTextHud.font = "default";
	self.reviveTextHud.fontScale = 1.8;
	self.reviveTextHud.alpha = 1;
	self.reviveTextHud.color = ( 1.0, 1.0, 1.0 );
	self.reviveTextHud setText( &"GAME_REVIVING" );
	
	while( self is_reviving( playerBeingRevived ) )
	{
		wait( 0.05 );					
		timer += 0.05;			

		if ( self player_is_in_laststand() )
		{
			break;
		}
		
		if( IsDefined( playerBeingRevived.revivetrigger.auto_revive ) && playerBeingRevived.revivetrigger.auto_revive == true )
		{
			break;
		}

		if( timer >= reviveTime)
		{
			revived = true;	
			break;
		}
	}
	
	if( isdefined( self.reviveProgressBar ) )
	{
		self.reviveProgressBar destroyElem();
	}
	
	if( isdefined( self.reviveTextHud ) )
	{
		self.reviveTextHud destroy();
	}
	
	if( IsDefined( playerBeingRevived.revivetrigger.auto_revive ) && playerBeingRevived.revivetrigger.auto_revive == true )
	{
		// ww: just fall through this part, no stoprevive
	}
	else if( !revived )
	{
		playerBeingRevived stoprevive( self );
	}

	//CODER_MOD: TOMMYK 07/13/2008
	playerBeingRevived.revivetrigger setHintString( &"GAME_BUTTON_TO_REVIVE_PLAYER" );
	playerBeingRevived.revivetrigger.beingRevived = 0;

	self notify( "do_revive_ended_normally" );
	self.is_reviving_any--;

	return revived;
}

say_revived_vo()
{
	players = GET_PLAYERS();
	for(i=0; i<players.size; i++)
	{
		if (players[i] == self)
		{
			self playsound("plr_" + i + "_vox_revived" + "_" + randomintrange(0, 2));
		}		
	}	
}

auto_revive( reviver )
{
	if( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger.auto_revive = true;
		if( self.revivetrigger.beingRevived == 1 )
		{
			while( 1 )
			{
				if( self.revivetrigger.beingRevived == 0 )
				{
					break;
				}
				wait_network_frame();
	
			}
		}
		self.revivetrigger.auto_trigger = false;
	}

	self reviveplayer();

	//make sure max health is set back to default
	if( isdefined(self.preMaxHealth) )
	{
		self SetMaxHealth( self.preMaxHealth );
	}

	setClientSysState("lsm", "0", self);	// Notify client last stand ended.
	
	self notify( "stop_revive_trigger" );
	self.revivetrigger delete();
	self.revivetrigger = undefined;
	self cleanup_suicide_hud();

	self laststand_enable_player_weapons();

	self AllowJump( true );
	
	self.ignoreme = false;
	self.laststand = undefined;
	
	// ww: moving the revive tracking, wasn't catching below the auto_revive
	reviver.revives++;
	//stat tracking
	reviver maps\mp\zombies\_zm_stats::increment_client_stat( "revives" );

	self thread say_revived_vo();
	maps\mp\_demo::bookmark( "zm_player_revived", gettime(), self, reviver );
	self notify ( "player_revived", reviver );
}


remote_revive( reviver )
{
	if ( !self player_is_in_laststand() )
	{
		return;
	}
	
	// ww: achievement change, no damage in rounds now revive
	reviver giveachievement_wrapper( "SP_ZOM_NODAMAGE" );

	self auto_revive( reviver );

}


revive_success( reviver )
{
	maps\mp\_demo::bookmark( "zm_player_revived", gettime(), self, reviver );
	self notify ( "player_revived", reviver );	
	self reviveplayer();
	
	//make sure max health is set back to default
	if( isdefined(self.preMaxHealth) )
	{
		self SetMaxHealth( self.preMaxHealth );
	}

	//CODER_MOD: TOMMYK 06/26/2008 - For coop scoreboards

	reviver.revives++;
	//stat tracking
	reviver maps\mp\zombies\_zm_stats::increment_client_stat( "revives" );

	// CODER MOD: TOMMY K - 07/30/08
	//reviver thread call_overloaded_func( "maps\_arcademode", "arcademode_player_revive" );
					
	//CODER_MOD: Jay (6/17/2008): callback to revive challenge
	if( isdefined( level.missionCallbacks ) )
	{
		// removing coop challenges for now MGORDON
		//maps\_challenges_coop::doMissionCallback( "playerRevived", reviver ); 
	}	
	
	setClientSysState("lsm", "0", self);	// Notify client last stand ended.
	
	self.revivetrigger delete();
	self.revivetrigger = undefined;
	self cleanup_suicide_hud();

	self laststand_enable_player_weapons();
	
	self.ignoreme = false;
	
	self thread say_revived_vo();
	
}


revive_force_revive( reviver )
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( self player_is_in_laststand() );

	self thread revive_success( reviver );
}

// the text that tells players that others are in need of a revive
revive_hud_create()
{	
	self.revive_hud = newclientHudElem( self );
	self.revive_hud.alignX = "center";
	self.revive_hud.alignY = "middle";
	self.revive_hud.horzAlign = "center";
	self.revive_hud.vertAlign = "bottom";
	self.revive_hud.y = -50;
	self.revive_hud.foreground = true;
	self.revive_hud.font = "default";
	self.revive_hud.fontScale = 1.5;
	self.revive_hud.alpha = 0;
	self.revive_hud.color = ( 1.0, 1.0, 1.0 );
	self.revive_hud setText( "" );

	self.revive_hud.y = -80;
}

//CODER_MOD: TOMMYK 07/13/2008
revive_hud_think()
{
	self endon ( "disconnect" );
	
	while ( 1 )
	{
		wait( 0.1 );

		if ( !player_any_player_in_laststand() )
		{
			continue;
		}
		
		players = GET_PLAYERS();
		playerToRevive = undefined;
			
		for( i = 0; i < players.size; i++ )
		{
			if( !players[i] player_is_in_laststand() || !isDefined( players[i].revivetrigger.createtime ) )
			{
				continue;
			}
			
			if( !isDefined(playerToRevive) || playerToRevive.revivetrigger.createtime > players[i].revivetrigger.createtime )
			{
				playerToRevive = players[i];
			}
		}
			
		if( isDefined( playerToRevive ) )
		{
			for( i = 0; i < players.size; i++ )
			{
				if( players[i] player_is_in_laststand() )
				{
					continue;
				}

				if( GetDvar( "g_gametype" ) == "vs" )
				{
					if( players[i].team != playerToRevive.team ) 
					{
						continue;
					}
				}
				
				if(is_encounter())
				{
					if( players[i].sessionteam != playerToRevive.sessionteam ) 
					{
						continue;
					}
				}
				players[i] thread fadeReviveMessageOver( playerToRevive, 3.0 );
			}
			
			playerToRevive.revivetrigger.createtime = undefined;
			wait( 3.5 );
		}		
	}
}

//CODER_MOD: TOMMYK 07/13/2008
fadeReviveMessageOver( playerToRevive, time )
{
	revive_hud_show();
	self.revive_hud setText( &"GAME_PLAYER_NEEDS_TO_BE_REVIVED", playerToRevive );
	self.revive_hud fadeOverTime( time );
	self.revive_hud.alpha = 0;
}

revive_hud_show()
{
	assert( IsDefined( self ) );
	assert( IsDefined( self.revive_hud ) );

	self.revive_hud.alpha = 1;
}

//CODER_MOD: TOMMYK 07/13/2008
revive_hud_show_n_fade(time)
{
	revive_hud_show();

	self.revive_hud fadeOverTime( time );
	self.revive_hud.alpha = 0;
}

drawcylinder(pos, rad, height)
{
	/#
	currad = rad;
	curheight = height;

	for (r = 0; r < 20; r++)
	{
		theta = r / 20 * 360;
		theta2 = (r + 1) / 20 * 360;

		line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0));
		line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight));
		line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight));
	}
	#/
}

get_lives_remaining()
{
	assert( level.lastStandGetupAllowed, "Lives only exist in the Laststand type GETUP." );

	if ( level.lastStandGetupAllowed && IsDefined( self.laststand_info ) && IsDefined( self.laststand_info.type_getup_lives ) )
	{
		return max( 0, self.laststand_info.type_getup_lives );
	}

	return 0;
}

update_lives_remaining( increment )
{
	assert( level.lastStandGetupAllowed, "Lives only exist in the Laststand type GETUP." );
	assert( isdefined( increment ), "Must specify increment true or false" );

	// Increment / Decrement lives 
	increment = (isdefined( increment )?increment:false );
	self.laststand_info.type_getup_lives = max( 0, ( increment?self.laststand_info.type_getup_lives + 1:self.laststand_info.type_getup_lives - 1 ) );

	// Notify HUD that laststand life amount has changed
	self notify( "laststand_lives_updated" );
}

player_getup_setup()
{
/#	println( "ZM >> player_getup_setup called" );	#/
	self.laststand_info = SpawnStruct();
	self.laststand_info.type_getup_lives = level.CONST_LASTSTAND_GETUP_COUNT_START;
}

laststand_getup()
{
	self endon ("player_revived");
	self endon ("disconnect");

/#	println( "ZM >> laststand_getup called" );	#/
	self update_lives_remaining(false);

	setClientSysState("lsm", "1", self);

	self.laststand_info.getup_bar_value = level.CONST_LASTSTAND_GETUP_BAR_START;

	self thread laststand_getup_hud();
	self thread laststand_getup_damage_watcher();

	while ( self.laststand_info.getup_bar_value < 1 )
	{
		self.laststand_info.getup_bar_value += level.CONST_LASTSTAND_GETUP_BAR_REGEN;
		wait( 0.05 );
	}

	self auto_revive( self );

	setClientSysState("lsm", "0", self);	// Notify client last stand ended.
}

laststand_getup_damage_watcher()
{
	self endon ("player_revived");
	self endon ("disconnect");

	while(1)
	{
		self waittill( "damage" );

		self.laststand_info.getup_bar_value -= level.CONST_LASTSTAND_GETUP_BAR_DAMAGE;

		if( self.laststand_info.getup_bar_value < 0 )
			self.laststand_info.getup_bar_value = 0;
	}
}

laststand_getup_hud()
{
	self endon ("player_revived");
	self endon ("disconnect");

	hudelem = NewClientHudElem( self );

	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.horzAlign = "left";
	hudelem.vertAlign = "middle";
	hudelem.x = 5;
	hudelem.y = 170;
	hudelem.font = "big";
	hudelem.fontScale = 1.5;
	hudelem.foreground = 1;
	hudelem.hidewheninmenu = true;
	hudelem.hidewhendead = true;
	hudelem.sort = 2;
	hudelem.label = &"SO_WAR_LASTSTAND_GETUP_BAR";

	self thread laststand_getup_hud_destroy( hudelem );

	while( 1 )
	{
		hudelem SetValue( self.laststand_info.getup_bar_value );
		wait( 0.05 );
	}
}

laststand_getup_hud_destroy( hudelem )
{
	self waittill_either( "player_revived", "disconnect" );

	hudelem Destroy();
}