#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

//-----------------------------------------------------------------------------------
// setup the tombstones in the level
//-----------------------------------------------------------------------------------
init()
{
	flag_wait( "start_zombie_round_logic" ); // "all_players_connected" );

	// create tombstone for each player
	players = get_players();

	if ( players.size > 0 )
	{
		foreach( i, player in players )
		{
			level.tombstones[ i ] = SpawnStruct();
		}

		level.tombstone_laststand_func = ::tombstone_laststand;

		level.tombstone_spawn_func = ::tombstone_spawn;
	}
}

//-----------------------------------------------------------------------------------
// place tombstone in level when player dies
//-----------------------------------------------------------------------------------
tombstone_spawn()
{	
	dc = Spawn( "script_model", self.origin + ( 0, 0, 40 ) );
	dc.angles = self.angles;
	dc SetModel( "tag_origin" );
	
	dc_icon = Spawn( "script_model", self.origin + ( 0, 0, 40 ) );
	dc_icon.angles = self.angles;
	dc_icon SetModel( "ch_tombstone1" );
	dc_icon LinkTo( dc );
	dc.icon = dc_icon;

	dc.player = self;
	
	dc thread tombstone_wobble();
	dc thread tombstone_revived( self );
	
	result = self waittill_any_return( "player_revived", "spawned_player", "disconnect" );
	
	// Revived Or Disconnected
	//------------------------
	if ( result == "player_revived" || result == "disconnect" )
	{
		dc notify ( "tombstone_timedout" );
		dc_icon UnLink();
		dc_icon Delete();
		dc Delete();
		
		return;
	}
	
	dc thread tombstone_timeout();
	dc thread tombstone_grab();
}

//-----------------------------------------------------------------------------------
// hide tombstone if player is getting revived because they'll lose it if revived
//-----------------------------------------------------------------------------------
tombstone_revived( player )
{	
	self endon( "tombstone_timedout" );
	player endon( "disconnect" );
	
	shown = true;
	
	while ( IsDefined( self ) && IsDefined( player ) )
	{
		if ( IsDefined( player.revivetrigger ) && is_true( player.revivetrigger.beingRevived ) )
		{
			if ( shown )
			{
				shown = false;
				
				self.icon Hide();
			}
		}
		else
		{
			if ( !shown )
			{
				shown = true;
				
				self.icon Show();
			}
		}
		
		wait ( 0.05 );
	}
}

//-----------------------------------------------------------------------------------
// save player weapon info, score, etc in the tombstone
//-----------------------------------------------------------------------------------
tombstone_laststand()
{
	players = get_players();

	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ] == self )
		{
			dc = level.tombstones[ i ];
			dc.player = self;

			dc.weapon = [];
			dc.score = self.score;
			dc.current_weapon = -1;

			primaries = self GetWeaponsListPrimaries();
			currentWeapon = self GetCurrentWeapon();

			// save weapons
			foreach ( index, weapon in primaries )
			{
				// default weapon is never put in a tombstone
				if ( weapon == "m1911_zm" )
				{
					dc.weapon[ index ] = "none";
					continue;
				}

				dc.weapon[ index ] = weapon;
				dc.stockCount[ index ] = self GetWeaponAmmoStock( weapon );

				if ( weapon == currentWeapon )
				{
					dc.current_weapon = index;
				}
			}
			
			// save riotshield
			if ( is_true( self.hasRiotShield ) )
			{
				dc.hasRiotShield = true;
			}

			// save bowie, other melee weapons
			dc maps\mp\zombies\_zm_melee_weapon::save_weapons_for_tombstone( self );
			
			// save claymore
			if ( self HasWeapon( "claymore_zm" ) )
			{
				dc.hasClaymore = true;
				dc.claymoreClip = self GetWeaponAmmoClip( "claymore_zm" );
			}

			// save perks
			dc.perk = tombstone_save_perks( self );

			// save grenades
			lethal_grenade = self get_player_lethal_grenade();
			if( self HasWeapon( lethal_grenade ) )
			{
				dc.grenade = self GetWeaponAmmoClip( lethal_grenade );
			}
			else
			{
				dc.grenade = 0;
			}

			if ( maps\mp\zombies\_zm_weap_cymbal_monkey::cymbal_monkey_exists() )
			{
				dc.zombie_cymbal_monkey_count = self GetWeaponAmmoClip( "zombie_cymbal_monkey" );
			}
		}
	}
}

//-----------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------
tombstone_save_perks( ent )
{
	perk_array = [];

	if ( ent HasPerk( "specialty_armorvest" ) )
	{
		perk_array[ perk_array.size ] = "specialty_armorvest";
	}

	if ( ent HasPerk( "specialty_deadshot" ) )
	{
		perk_array[ perk_array.size ] = "specialty_deadshot";
	}

	if ( ent HasPerk( "specialty_fastreload" ) )
	{
		perk_array[ perk_array.size ] = "specialty_fastreload";
	}

	if ( ent HasPerk( "specialty_flakjacket" ) )
	{
		perk_array[ perk_array.size ] = "specialty_flakjacket";
	}

	if ( ent HasPerk( "specialty_longersprint" ) )
	{
		perk_array[ perk_array.size ] = "specialty_longersprint";
	}

	if ( ent HasPerk( "specialty_quickrevive" ) )
	{
		perk_array[ perk_array.size ] = "specialty_quickrevive";
	}

	if ( ent HasPerk( "specialty_rof" ) )
	{
		perk_array[ perk_array.size ] = "specialty_rof";
	}

	return( perk_array );
}

//-----------------------------------------------------------------------------------
// wait for player to get tombstone
//-----------------------------------------------------------------------------------
tombstone_grab()
{
	self endon( "tombstone_timedout" );

	wait( 1 );

	while ( IsDefined( self ) )
	{
		players = get_players();

		for ( i = 0; i < players.size; i++ )
		{
			if ( players[ i ].is_zombie )
			{
				continue;
			}

			if ( IsDefined( self.player ) && players[ i ] == self.player )
			{
				dist = distance( players[ i ].origin, self.origin );
				if ( dist < 64 )
				{
					PlayFX( level._effect[ "powerup_grabbed" ], self.origin );
					PlayFX( level._effect[ "powerup_grabbed_wave" ], self.origin );

					players[ i ] tombstone_give( i );

					wait( 0.1 );

					playsoundatposition( "zmb_tombstone_grab", self.origin );
					self StopLoopSound();

					self.icon UnLink();
					self.icon Delete();
					self Delete();
					self notify( "tombstone_grabbed" );
					players[ i ] clientnotify( "dc0" );	// play death card sound
				}
			}
		}

		wait_network_frame();
	}
}

//-----------------------------------------------------------------------------------
// give back weapons, perks, money, etc...
//-----------------------------------------------------------------------------------
tombstone_give( index )
{
	dc = level.tombstones[ index ];
	
	// weapons
	if ( dc.current_weapon >= 0 && !flag( "solo_game" ) ) // QuickReive gives weapons back in SOLO
	{
		primaries = self GetWeaponsListPrimaries();

		// If player had two weapons, take away default pistol to make room for that second weapon
		if ( dc.weapon.size >= 2 )
		{
			if ( self HasWeapon( "m1911_zm" ) )
			{
				self TakeWeapon( "m1911_zm" );
			}
		}

		for ( i = 0; i < dc.weapon.size; i++ )
		{
			if ( dc.weapon[ i ] == "none" )
			{
				continue;
			}

			weapon = dc.weapon[ i ];
			stock = dc.stockCount[ i ];

			if ( !self HasWeapon( weapon ) )
			{
				self GiveWeapon( weapon, 0 );

				self SetWeaponAmmoClip( weapon, WeaponClipSize( weapon ) );
				self SetWeaponAmmoStock( weapon, stock );

				if ( i == dc.current_weapon )
				{
					self SwitchToWeapon( weapon );
				}
			}
		}
	}
	
	// riotshield
	if ( is_true( dc.hasRiotShield ) )
	{
		self maps\mp\zombies\_zm_equipment::equipment_give( "riotshield_zm" );
		
		if ( IsDefined( self.player_shield_reset_health ) )
		{
			self [[ self.player_shield_reset_health ]]();
		}
	}
	
	// melee weapons
	dc maps\mp\zombies\_zm_melee_weapon::restore_weapons_for_tombstone( self );
	
	// claymore
	if ( is_true( dc.hasClaymore ) && !self HasWeapon( "claymore_zm" ) )
	{
		self GiveWeapon( "claymore_zm" );
		self set_player_placeable_mine( "claymore_zm" );
		self SetActionSlot( 4, "weapon", "claymore_zm" );
		self SetWeaponAmmoClip( "claymore_zm", dc.claymoreClip );
	}

	// score
	if ( !flag( "solo_game" ) ) // Player will get their points back for self revival in Solo
	{
		self.score = dc.score;
	}

	// perks
	if ( IsDefined( dc.perk ) && dc.perk.size > 0 )
	{
		for ( i = 0; i < dc.perk.size; i++ )
		{
			if ( self HasPerk( dc.perk[ i ] ) )
			{
				continue;
			}

			// don't give back quickrevive if solo match
			if ( dc.perk[ i ] == "specialty_quickrevive" && flag( "solo_game" ) )
			{
				continue;
			}

			maps\mp\zombies\_zm_perks::give_perk( dc.perk[ i ] );
		}
	}

	// grenades
	if ( dc.grenade > 0 && !flag( "solo_game" ) ) // QuickReive gives weapons back in SOLO
	{
		curGrenadeCount = 0;

		if ( self HasWeapon( self get_player_lethal_grenade() ) )
		{
			self GetWeaponAmmoClip( self get_player_lethal_grenade() );
		}
		else
		{
			self GiveWeapon( self get_player_lethal_grenade() );
		}

		self SetWeaponAmmoClip( self get_player_lethal_grenade(), dc.grenade + curGrenadeCount );
	}

	if ( maps\mp\zombies\_zm_weap_cymbal_monkey::cymbal_monkey_exists() && !flag( "solo_game" ) ) // QuickReive gives weapons back in SOLO
	{
		if ( dc.zombie_cymbal_monkey_count )
		{
			self GiveWeapon( "zombie_cymbal_monkey" );
			self SetWeaponAmmoClip( "zombie_cymbal_monkey", dc.zombie_cymbal_monkey_count );
		}
	}
}

//-----------------------------------------------------------------------------------
// bounce the tombstone around
//-----------------------------------------------------------------------------------
tombstone_wobble()
{
	self endon ( "tombstone_grabbed" );
	self endon ( "tombstone_timedout" );

	if ( IsDefined( self ) )
	{
		wait_network_frame();
		
		PlayFXOnTag ( level._effect[ "powerup_on" ], self, "tag_origin" );
		self PlaySound( "zmb_tombstone_spawn" );
		self PlayLoopSound( "zmb_tombstone_looper" );
	}

	while ( IsDefined( self ) )
	{
		self RotateYaw( 360, 3 );

		wait( 3 - 0.1 );
	}
}

//-----------------------------------------------------------------------------------
// time out after end of round
//-----------------------------------------------------------------------------------
tombstone_timeout()
{
	self endon ( "tombstone_grabbed" );
	
	self thread playTombstoneTimerAudio();

	wait ( 48.5 );

	for ( i = 0; i < 40; i++ )
	{
		if ( i % 2 )
		{
			self Hide();
		}
		else
		{
			self Show();
		}

		if ( i < 15 )
		{
			wait 0.5;
		}
		else if ( i < 25 )
		{
			wait 0.25;
		}
		else
		{
			wait 0.1;
		}
	}

	self notify ( "tombstone_timedout" );
	self.icon UnLink();
	self.icon Delete();
	self Delete();
}

playTombstoneTimerAudio()
{
	self endon( "tombstone_grabbed" );
	self endon( "tombstone_timedout" );
	
	player = self.player;
	
	self thread playTombstoneTimerOut( player );
	
	//TODO: Switch this temp asset with something zombified
	
	while(1)
	{
		player playsoundtoplayer( "zmb_tombstone_timer_count", player );
		wait(1);
	}
}

playTombstoneTimerOut( player )
{
	self endon( "tombstone_grabbed" );
	
	self waittill( "tombstone_timedout" );
	
	//TODO: Switch this temp asset with something zombified
	player playsoundtoplayer( "zmb_tombstone_timer_out", player );
}