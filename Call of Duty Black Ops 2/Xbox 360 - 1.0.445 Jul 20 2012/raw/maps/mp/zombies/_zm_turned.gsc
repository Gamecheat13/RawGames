#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes\_hud_util;


init()
{
	level._CLIENTFLAG_PLAYER_TURNED_VISIONSET = 4;

	level.turnedmeleeweapon = "zombiemelee_zm";
	level.turnedmeleeweapon_dw = "zombiemelee_dw";
	//level.turnedmeleeweapon = "zombie_turned_zm";
	//level.turnedmeleeweapon_dw = "zombie_turned_dw";
	PreCacheItem( level.turnedmeleeweapon );
	PreCacheItem( level.turnedmeleeweapon_dw );

	PreCacheModel("c_usa_pent_zombie_militarypolice_body_player");
	PreCacheModel("c_ger_zombie_head1");
	PreCacheModel("viewmodel_usa_pow_arms");
	
	SetDvar( "player_zombieSpeedScale", 1.05 );
}

turn_to_zombie()
{
	// Wait For Player To Finish Humanifying
	//--------------------------------------
	while ( is_true( self.is_in_process_of_humanify ) )
	{
		wait ( 0.1 );
	}

	// Pre-Turning Into Zombie
	//------------------------
	self notify( "zombify" );
	self.is_in_process_of_zombify = true;
	if ( !is_true( level.inGracePeriod ) )
	{
		self thread blackOverlayCoverUp( "Spawning As A Zombie", 2 );
	}
	self turned_disable_player_weapons();
	self.is_zombie = true;

	// Find Farthest Zombie In Game Space To Inherit Them
	//---------------------------------------------------
	spawnPoint = self getSpawnPoint();

	// Zoom Down Into Zombie
	//----------------------
	origin = spawnPoint.origin;
	angles = spawnPoint.angles;
	
	self SetOrigin( origin );
	self SetPlayerAngles( angles );

	self DisableWeapons();
	/* self Hide();
	self.origin = origin + ( 0, 0, 1500 );
	ent = Spawn( "script_model", ( 0, 0, 0 ) );
	ent SetModel( "tag_origin" );
	ent.origin = self.origin;
	ent.angles = self.angles;

	self LinkTo( ent );
	ent.angles = ( ent.angles[ 0 ] + 89, ent.angles[ 1 ], 0 ); */
	
	self setclientflag(level._CLIENTFLAG_PLAYER_TURNED_VISIONSET);

	/* ent MoveTo( spawnPoint.origin, 1.5, 0, 1.5 );
	wait ( 0.9 );
	ent RotateTo( ( ent.angles[ 0 ] - 89, ent.angles[ 1 ], 0 ), 0.5, 0.3, 0.2 );
	wait ( 0.7 );
	self UnLink(); */
	self FreezeControls( false );
	self EnableWeapons();
	self Show();
	/* ent Delete(); */

	// Setup Player As Zombie
	//-----------------------
	self thread turned_player_buttons();
	
	self SetPerk( "specialty_noname" );
	self SetPerk( "specialty_unlimitedsprint" );
	self SetPerk( "specialty_fallheight" );
	self turned_give_melee_weapon();
	self.team = "axis";
	self.sessionteam = "axis";
	self setMoveSpeedScale( 1.0 );
	self.animname = "zombie";

	//self AllowSprint( 0 );
	self AllowStand( 1 );
	self AllowProne( 0 );
	self AllowCrouch( 0 );
	self AllowAds( 0 );
	self AllowJump( 0 );
	self DisableWeaponCycling();
	
	self StopShellShock();
	
	self.maxhealth = 256;
	self.health = 256;
	
	self.meleeDamage = 1000;

	self DetachAll();
	self setModel("c_usa_pent_zombie_militarypolice_body_player");
	self.headModel = "c_ger_zombie_head1";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
	self SetViewModel( "viewmodel_usa_pow_arms" );

	self DisableInvulnerability();

	self.is_in_process_of_zombify = false;
	
	//self thread injured_walk();
}

/*injured_walk()
{
	self.ground_ref_ent = Spawn( "script_model", ( 0, 0, 0 ) ); 

	self.player_speed = 50; 

	// TODO do death countdown	
 	self PlayerSetGroundReferenceEnt( self.ground_ref_ent ); 
	self thread limp(); 
}

limp()
{
	level endon( "disconnect" ); 
	level endon( "death" ); 
	// TODO uncomment when/if SetBlur works again
	//self thread player_random_blur(); 

	stumble = 0; 
	alt = 0; 

	while( 1 )
	{
		velocity = self GetVelocity(); 
		player_speed = abs( velocity[0] ) + abs( velocity[1] ); 

		if( player_speed < 10 )
		{
			wait( 0.05 ); 
			continue; 
		}

		speed_multiplier = player_speed / self.player_speed; 

		p = RandomFloatRange( 3, 5 ); 
		if( RandomInt( 100 ) < 20 )
		{
			p *= 3; 
		}
		r = RandomFloatRange( 3, 7 ); 
		y = RandomFloatRange( -8, -2 ); 

		stumble_angles = ( p, y, r ); 
		stumble_angles = VectorScale( stumble_angles, speed_multiplier ); 

		stumble_time = RandomFloatRange( .35, .45 ); 
		recover_time = RandomFloatRange( .65, .8 ); 

		stumble++; 
		if( speed_multiplier > 1.3 )
		{
			stumble++; 
		}

		self thread stumble( stumble_angles, stumble_time, recover_time ); 

		level waittill( "recovered" ); 
	}
}

stumble( stumble_angles, stumble_time, recover_time, no_notify )
{
	stumble_angles = self adjust_angles_to_player( stumble_angles ); 

	self.ground_ref_ent RotateTo( stumble_angles, stumble_time, ( stumble_time/4*3 ), ( stumble_time/4 ) ); 
	self.ground_ref_ent waittill( "rotatedone" ); 

	base_angles = ( RandomFloat( 4 ) - 4, RandomFloat( 5 ), 0 ); 
	base_angles = self adjust_angles_to_player( base_angles ); 

	self.ground_ref_ent RotateTo( base_angles, recover_time, 0, ( recover_time / 2 ) ); 
	self.ground_ref_ent waittill( "rotatedone" ); 

	if( !IsDefined( no_notify ) )
	{
		level notify( "recovered" ); 
	}
}*/

/*adjust_angles_to_player( stumble_angles )
{
	pa = stumble_angles[0]; 
	ra = stumble_angles[2]; 

	rv = AnglesToRight( self.angles ); 
	fv = AnglesToForward( self.angles ); 

	rva = ( rv[0], 0, rv[1]*-1 ); 
	fva = ( fv[0], 0, fv[1]*-1 ); 
	angles = VectorScale( rva, pa ); 
	angles = angles + VectorScale( fva, ra ); 
	return angles +( 0, stumble_angles[1], 0 ); 
}*/

turn_to_human()
{
	// Wait For Player To Finish SlamZoomn + Zombifying
	//-------------------------------------------------
	while ( is_true( self.is_in_process_of_zombify ) )
	{
		wait ( 0.1 );
	}

	// Pre-Turning Into Human
	//-----------------------
	self notify( "humanify" );
	self.is_in_process_of_humanify = true;
	self.is_zombie = false;
	
	if ( !is_true( level.inGracePeriod ) )
	{
		self thread blackOverlayCoverUp( "Spawning As A Human", 1.5, true );
	}

	// Find Farthest Zombie In Game Space To Inherit Their Location
	//-------------------------------------------------------------
	spawnPoint = self getSpawnPoint();

	origin = spawnPoint.origin;
	angles = spawnPoint.angles;

	self SetOrigin( origin );
	self SetPlayerAngles( angles );

	if ( self HasWeapon( "death_throe_zm" ) )
	{
		self TakeWeapon( "death_throe_zm" );
	}

	self unsetPerk( "specialty_noname" );
	self unsetPerk( "specialty_unlimitedsprint" );
	self unsetPerk( "specialty_fallheight" );
	self turned_enable_player_weapons();
	self clearclientflag(level._CLIENTFLAG_PLAYER_TURNED_VISIONSET);
	self.team = self.prevteam;
	self.sessionteam = self.prevteam;
	self setMoveSpeedScale( 1.0 );
	self.ignoreme = false;

	self EnableWeaponCycling();
	self AllowStand( 1 );
	self AllowProne( 1 );
	self AllowCrouch( 1 );
	self AllowAds( 1 );
	self AllowJump( 1 );

	self StopShellShock();

	self.maxhealth = 100;
	self.health = 100;
	
	self.meleeDamage = undefined;

	self DetachAll();
	self [[ level.giveCustomCharacters ]]();

	if ( !self HasWeapon( "knife_zm" ) )
	{
		self GiveWeapon( "knife_zm" );
	}

	self DisableInvulnerability();

	self.is_in_process_of_humanify = false;
}

deleteZombiesInRadius( origin )
{
	zombies = GetAIArray( "axis" );

	maxRadius = 128;

	foreach ( zombie in zombies )
	{
		if ( IsDefined( zombie ) && IsAlive( zombie ) && !is_true( zombie.is_being_used_as_spawner ) )
		{
			if ( DistanceSquared( zombie.origin, origin ) < ( maxRadius * maxRadius ) )
			{
				PlayFX( level._effect[ "wood_chunk_destory" ], zombie.origin );

				zombie thread silentlyRemoveZombie();
			}

			wait ( 0.05 );
		}
	}
}

blackOverlayCoverUp( text, duration, skipBlackOverlay )
{
	self endon( "disconnect" );

	if ( !is_true( skipBlackOverlay ) )
	{
		fadetoblack = NewClientHudElem( self );
		fadetoblack.x = 0;
		fadetoblack.y = 0;
		fadetoblack.horzAlign = "fullscreen";
		fadetoblack.vertAlign = "fullscreen";
		fadetoblack SetShader( "black", 640, 480 );
		fadetoblack.color = ( 0, 0, 0 );
		fadetoblack.alpha = 1;
		fadetoblack.sort = -1;
		self.fadetoblack = fadetoblack;
	}

	notifyData = SpawnStruct();
	notifyData.notifyText = text;
	notifyData.duration = duration;
	
	self clearCenterPopups();
	self thread maps\mp\gametypes\_hud_message::showNotifyMessage( notifyData, notifyData.duration );
	
	wait ( duration );
	
	if ( IsDefined( fadetoblack ) )
	{
		fadetoblack Destroy();
	}
}

turned_give_melee_weapon()
{
	assert( IsDefined( self.turnedmeleeweapon ) );
	assert( self.turnedmeleeweapon != "none" );

	self.turned_had_knife = self HasWeapon("knife_zm");
	if ( is_true( self.turned_had_knife ) )
	{
		self TakeWeapon("knife_zm");
	}

	self GiveWeapon( self.turnedmeleeweapon_dw );
	self GiveMaxAmmo( self.turnedmeleeweapon_dw );
	self GiveWeapon( self.turnedmeleeweapon );
	self GiveMaxAmmo( self.turnedmeleeweapon );
	self SwitchToWeapon( self.turnedmeleeweapon_dw );
	self SwitchToWeapon( self.turnedmeleeweapon );
}


// self = a player
turned_player_buttons( )
{
	self endon( "disconnect" );
	self endon( "humanify" );
	level endon( "end_game" );
	
	while ( is_true( self.is_zombie ) )
	{
		// Attack Sound
		//-------------
		if ( self AttackButtonPressed() || self AdsButtonPressed() || self MeleeButtonPressed() )
		{
			if ( cointoss() )
			{
				self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "attack", undefined );
			}
			
			while ( self AttackButtonPressed() || self AdsButtonPressed() || self MeleeButtonPressed() )
			{
				wait ( 0.05 );
			}
		}
		
		// Taunt Sound
		//------------
		if ( self UseButtonPressed() )
		{
			self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "taunt", undefined );
			
			while ( self UseButtonPressed() )
			{
				wait ( 0.05 );
			}
		}
		
		// Sprint Sound
		//-------------
		if ( self IsSprinting() )
		{
			while ( self IsSprinting() )
			{
				self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "sprint", undefined );
				
				wait ( 0.05 );
			}
		}
		
		wait ( 0.05 );
	}
}

// self = a player
turned_disable_player_weapons()
{
	// Already A Zombie, Just Respawning
	//----------------------------------
	if ( is_true( self.is_zombie ) )
	{
		return;
	}
	
	weaponInventory = self GetWeaponsList();
	self.lastActiveWeapon = self GetCurrentWeapon();
	self SetLastStandPrevWeap( self.lastActiveWeapon );
	self.laststandpistol = undefined;

	self.hadpistol = false;

	if ( !IsDefined( self.turnedmeleeweapon ) )
	{
		self.turnedmeleeweapon = level.turnedmeleeweapon;
	}
	if ( !IsDefined( self.turnedmeleeweapon_dw ) )
	{
		self.turnedmeleeweapon_dw = level.turnedmeleeweapon_dw;
	}
	
	self TakeAllWeapons();
	self DisableWeaponCycling();
}


// self = a player
turned_enable_player_weapons()
{
	if ( !is_true( self.hadpistol ) )
	{
		if ( IsDefined( self.turnedmeleeweapon ) )
		{
			self TakeWeapon( self.turnedmeleeweapon );
		}
		if ( IsDefined( self.turnedmeleeweapon_dw ) )
		{
			self TakeWeapon( self.turnedmeleeweapon_dw );
		}
	}

	if ( is_true( self.turned_had_knife ) )
	{
		self GiveWeapon( "knife_zm" );
	}
	self.turned_had_knife = undefined;

	self EnableWeaponCycling();
	self EnableOffhandWeapons();

	// if we can't figure out what the last active weapon was, try to switch a primary weapon
	//CHRIS_P: - don't try to give the player back the mortar_round weapon ( this is if the player killed himself with a mortar round)
	if( IsDefined( self.lastActiveWeapon ) && self.lastActiveWeapon != "none" && self.lastActiveWeapon != "mortar_round" && self.lastActiveWeapon != "mine_bouncing_betty" && self.lastActiveWeapon != "claymore_zm" && self.lastActiveWeapon != "spikemore_zm" )
	{
		if ( !self HasWeapon( self.lastActiveWeapon ) )
		{
			self GiveWeapon( self.lastActiveWeapon );
		}
		
		self SwitchToWeapon( self.lastActiveWeapon );
	}
	else
	{
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
		else if ( !is_true( self.is_zombie ) )
		{
			// Give Start Weapons As Last Resort
			//----------------------------------
			self GiveWeapon( "knife_zm" );
			self give_start_weapon( true );
		}
	}
	
	// Give ShotGun
	//-------------
	if ( !self HasWeapon( "rottweil72_zm" ) )
	{
		self GiveWeapon( "rottweil72_zm" );
		self SwitchToWeapon( "rottweil72_zm" );
		
		self SetWeaponAmmoClip( "rottweil72_zm", 2 );
		self SetWeaponAmmoStock( "rottweil72_zm", 0 );
	}
	
	if ( self HasWeapon( level.start_weapon ) )
	{
		self GiveMaxAmmo( level.start_weapon );
	}
	
	// Replenish Grenades
	//-------------------
	if ( self HasWeapon( self get_player_lethal_grenade() ) )
	{
		self GetWeaponAmmoClip( self get_player_lethal_grenade() );
	}
	else
	{
		self GiveWeapon( self get_player_lethal_grenade() );
	}

	self SetWeaponAmmoClip( self get_player_lethal_grenade(), 2 );
}

get_farthest_available_zombie( player )
{
	while ( true )
	{
		zombies = get_array_of_closest( player.origin, GetAIArray( "axis" ) );
		//* zombies = array_reverse( zombies );

		for ( x = 0; x < zombies.size; x++ )
		{
			zombie = zombies[ x ];

			if ( IsDefined( zombie ) && IsAlive( zombie ) &&
			!is_true( zombie.in_the_ground ) && // Make Sure This Zombie Isn't Rising
			!is_true( zombie.gibbed ) && !is_true( zombie.head_gibbed ) && // Make Sure This Zombie Wasn't Damaged
			!is_true( zombie.is_being_used_as_spawnpoint ) &&
			zombie in_playable_area() )
			{
				zombie.is_being_used_as_spawnpoint = true;

				return zombie;
			}
		}

		wait ( 0.05 );
	}
}

get_available_human()
{
	players = GET_PLAYERS();
	foreach ( player in players )
	{
		if ( !is_true( player.is_zombie ) )
		{
			return player;
		}
	}
}

silentlyRemoveZombie()
{
	self.skip_death_notetracks = true;
	self.nodeathragdoll = true;
	self DoDamage( self.maxhealth * 2, self.origin, self, self, "none", "MOD_SUICIDE" );
	self self_delete();
}

getSpawnPoint()
{
	spawnPoints = array_randomize( level._turned_zombie_respawnpoints );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	return spawnPoint;
}