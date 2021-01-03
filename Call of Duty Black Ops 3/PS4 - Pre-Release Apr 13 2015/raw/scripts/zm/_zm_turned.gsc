#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\gametypes\_spawnlogic;
#using scripts\zm\gametypes\_zm_gametype;

#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;

#namespace zm_turned;

function init()
{
	dvar = GetDvarString( "ui_gametype" );
	if ( dvar == "zcleansed" )
	{
		level.weaponZMTurnedMelee = GetWeapon( "zombiemelee" );
		level.weaponZMTurnedMeleeDW = GetWeapon( "zombiemelee_dw" );
		
		//SetDvar( "player_zombieSpeedScale", 1.05 );
	
		if ( !IsDefined( level.vsmgr_prio_visionset_zombie_turned ) )
		{
			level.vsmgr_prio_visionset_zombie_turned = 123;
		}
		visionset_mgr::register_info( "visionset", "zombie_turned", 1, level.vsmgr_prio_visionset_zombie_turned, 1, true); //, &vsmgr_lerp_power_up_down, false );
		clientfield::register( "toplayer", "turned_ir", 1, 1, "int" ); 
	 	clientfield::register( "allplayers", "player_has_eyes", 1, 1, "int" );		
	 	clientfield::register( "allplayers", "player_eyes_special", 1, 1, "int" );		
	 	
		thread setup_zombie_exerts();
	}
}

function setup_zombie_exerts()
{
	{wait(.05);};

	// sniper hold breath
	level.exert_sounds[1]["burp"] = "null";

	// medium hit
	level.exert_sounds[1]["hitmed"] = "null";

	// large hit
	level.exert_sounds[1]["hitlrg"] = "null";
}

function delay_turning_on_eyes()
{
	self endon("death");
	self endon("disconnect");
	
	util::wait_network_frame();
	wait(0.1);
	
	self clientfield::set("player_has_eyes", 1);
}

function turn_to_zombie()
{
	// Already On This Team Playing (Alive)
	//------------------------------------
	if ( self.sessionstate == "playing" && ( isdefined( self.is_zombie ) && self.is_zombie ) && !( isdefined( self.laststand ) && self.laststand ) )
	{
		return;
	}
	
	// Already In Process Of Becoming Zombie
	//--------------------------------------
	if ( ( isdefined( self.is_in_process_of_zombify ) && self.is_in_process_of_zombify ) )
	{
		return;
	}
	
	// Wait For Player To Finish Humanifying
	//--------------------------------------
	while ( ( isdefined( self.is_in_process_of_humanify ) && self.is_in_process_of_humanify ) )
	{
		wait ( 0.1 );
	}
	
	if( !level flag::get( "pregame" ) )
	{
		self playsoundtoplayer( "evt_spawn", self );
		playsoundatposition( "evt_disappear_3d", self.origin );
		
		if( !self.is_zombie )
			playsoundatposition( "vox_plr_" + randomintrange(0,4) + "_exert_death_high_" + randomintrange(0,4), self.origin );
	}
	
	self._can_score = true;
	self clientfield::set("player_has_eyes", 0);
	self ghost();
	self turned_disable_player_weapons();
	self notify( "clear_red_flashing_overlay" );
	
	// Pre-Turning Into Zombie
	//------------------------
	self notify( "zombify" );
	self.is_in_process_of_zombify = true;
		
	// Respawn
	//--------
	self.team = level.zombie_team;
	self.pers["team"] = level.zombie_team;
	self.sessionteam = level.zombie_team;
	util::wait_network_frame();
	self zm_gametype::onSpawnPlayer();
	
	self FreezeControls( true );
	
	self.is_zombie = true;

	self SetBurn( 0 );
	
	if (( isdefined( self.turned_visionset ) && self.turned_visionset )) // the turned visionset gets stomped by the laststand visionset if you die as a zombie - deactivate it and reactivate it to force it back on
	{
		visionset_mgr::deactivate( "visionset", "zombie_turned", self );		
		util::wait_network_frame();
		util::wait_network_frame();
		if (!isdefined(self))
			return;
	}
	visionset_mgr::activate( "visionset", "zombie_turned", self ); //,0
	self.turned_visionset = 1;
	self clientfield::set_to_player( "turned_ir", 1 );
	self zm_audio::SetExertVoice(1);
	self.laststand = undefined;

	util::wait_network_frame();
	if (!isdefined(self))
		return;
	self EnableWeapons();
	self Show();
	playsoundatposition( "evt_appear_3d", self.origin );
	playsoundatposition( "zmb_zombie_spawn", self.origin );
	self thread delay_turning_on_eyes();
		/* ent Delete(); */

	// Setup Player As Zombie
	//-----------------------
	self thread turned_player_buttons();
	
	self SetPerk( "specialty_playeriszombie" );
	self SetPerk( "specialty_unlimitedsprint" );
	self SetPerk( "specialty_fallheight" );
	self turned_give_melee_weapon();
	self setMoveSpeedScale( 1.0 );
	self.animname = "zombie";
	
	self DisableOffhandWeapons();

	//self AllowSprint( 0 );
	self AllowStand( 1 );
	self AllowProne( 0 );
	self AllowCrouch( 0 );
	self AllowAds( 0 );
	self AllowJump( 0 );
	self DisableWeaponCycling();
	
	self SetMoveSpeedScale( 1 );
	self SetSprintDuration( 4 );
	self SetSprintCooldown( 0 );
	
	self StopShellShock();
	
	self.maxhealth = 256;
	self.health = 256;
	
	self.meleeDamage = 1000;

	self DetachAll();
	if ( IsDefined( level.custom_zombie_player_loadout ) )
	{
		self [[ level.custom_zombie_player_loadout ]]();
	}
	else
	{
		self setModel("c_zom_player_zombie_fb");
		self.voice = "american";
		self.skeleton = "base";
//		self SetViewModel( "c_zom_zombie_viewhands" );
	}

	self.shock_onpain = 0;

	self DisableInvulnerability();
	if (isdefined(level.player_movement_suppressed))
	{
		self FreezeControls( level.player_movement_suppressed );
	}
    else
    {
    	if(!( isdefined( self.hostMigrationControlsFrozen ) && self.hostMigrationControlsFrozen ))
		{
			self FreezeControls( false );
    	}
    }
	
	self.is_in_process_of_zombify = false;
}

function turn_to_human()
{
	// Already On This Team Playing (Alive)
	//------------------------------------
	if ( self.sessionstate == "playing" && !( isdefined( self.is_zombie ) && self.is_zombie ) && !( isdefined( self.laststand ) && self.laststand ) )
	{
		return;
	}
	
	// Already In Process Of Becoming Human
	//-------------------------------------
	if ( ( isdefined( self.is_in_process_of_humanify ) && self.is_in_process_of_humanify ) )
	{
		return;
	}
	
	// Wait For Player To Finish SlamZoomn + Zombifying
	//-------------------------------------------------
	while ( ( isdefined( self.is_in_process_of_zombify ) && self.is_in_process_of_zombify ) )
	{
		wait ( 0.1 );
	}
	
	// Pre-Turning Into Human
	//-----------------------
	self playsoundtoplayer( "evt_spawn", self );
	playsoundatposition( "evt_disappear_3d", self.origin );
	self clientfield::set("player_has_eyes", 0);
	self ghost();
	self notify( "humanify" );
	self.is_in_process_of_humanify = true;
	self.is_zombie = false;
	self notify( "clear_red_flashing_overlay" );

	// Respawn
	//--------
	self.team = self.prevteam;
	self.pers["team"] = self.prevteam;
	self.sessionteam = self.prevteam;
	util::wait_network_frame();
	self zm_gametype::onSpawnPlayer();
	self.maxhealth = 100;
	self.health = 100;
	
	self FreezeControls( true );

	if ( self HasWeapon( level.weaponZMDeathThroe ) )
	{
		self TakeWeapon( level.weaponZMDeathThroe );
	}
	
	self unsetPerk( "specialty_playeriszombie" );
	self unsetPerk( "specialty_unlimitedsprint" );
	self unsetPerk( "specialty_fallheight" );
	self turned_enable_player_weapons();
	
	self zm_audio::SetExertVoice(0);
	self.turned_visionset = 0;
	visionset_mgr::deactivate( "visionset", "zombie_turned", self );		
	self clientfield::set_to_player( "turned_ir", 0 );
	self setMoveSpeedScale( 1.0 );
	self.ignoreme = false;
	self.shock_onpain = 1;

	self EnableWeaponCycling();
	self AllowStand( 1 );
	self AllowProne( 1 );
	self AllowCrouch( 1 );
	self AllowAds( 1 );
	self AllowJump( 1 );
	self TurnedHuman();

	self EnableOffhandWeapons();

	self StopShellShock();

	self.laststand = undefined;
	self.is_burning = undefined;
	
	self.meleeDamage = undefined;

	self DetachAll();
	self [[ level.giveCustomCharacters ]]();

	if ( !self HasWeapon( level.weaponBaseMelee ) )
	{
		self GiveWeapon( level.weaponBaseMelee );
	}

	util::wait_network_frame();
	if (!isdefined(self))
		return;
	self DisableInvulnerability();
	
	if (isdefined(level.player_movement_suppressed))
	{
		self FreezeControls( level.player_movement_suppressed );
	}
    else
    {
    	if(!( isdefined( self.hostMigrationControlsFrozen ) && self.hostMigrationControlsFrozen ))
		{
			self FreezeControls( false );
    	}
    }
	
	self Show();
	playsoundatposition( "evt_appear_3d", self.origin );

	self.is_in_process_of_humanify = false;
}

function deleteZombiesInRadius( origin )
{
	zombies = zombie_utility::get_round_enemy_array();

	maxRadius = 128;

	foreach ( zombie in zombies )
	{
		if ( IsDefined( zombie ) && IsAlive( zombie ) && !( isdefined( zombie.is_being_used_as_spawner ) && zombie.is_being_used_as_spawner ) )
		{
			if ( DistanceSquared( zombie.origin, origin ) < ( maxRadius * maxRadius ) )
			{
				PlayFX( level._effect[ "wood_chunk_destory" ], zombie.origin );

				zombie thread silentlyRemoveZombie();
			}

			{wait(.05);};
		}
	}
}

function turned_give_melee_weapon()
{
	assert( IsDefined( self.weaponZMTurnedMelee ) );
	assert( self.weaponZMTurnedMelee != level.weaponNone );

	self.turned_had_knife = self HasWeapon(level.weaponBaseMelee);
	if ( ( isdefined( self.turned_had_knife ) && self.turned_had_knife ) )
	{
		self TakeWeapon(level.weaponBaseMelee);
	}

	self GiveWeapon( self.weaponZMTurnedMeleeDW );
	self GiveMaxAmmo( self.weaponZMTurnedMeleeDW );
	self GiveWeapon( self.weaponZMTurnedMelee );
	self GiveMaxAmmo( self.weaponZMTurnedMelee );
	self SwitchToWeapon( self.weaponZMTurnedMeleeDW );
	self SwitchToWeapon( self.weaponZMTurnedMelee );
}


// self = a player
function turned_player_buttons( )
{
	self endon( "disconnect" );
	self endon( "humanify" );
	level endon( "end_game" );
	
	while ( ( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
		// Attack Sound
		//-------------
		if ( self AttackButtonPressed() || self AdsButtonPressed() || self MeleeButtonPressed() )
		{
			if ( math::cointoss() )
			{
				self notify( "bhtn_action_notify", "attack" );
			}
			
			while ( self AttackButtonPressed() || self AdsButtonPressed() || self MeleeButtonPressed() )
			{
				{wait(.05);};
			}
		}
		
		// Taunt Sound
		//------------
		if ( self UseButtonPressed() )
		{
			self notify( "bhtn_action_notify", "taunt" );
			
			while ( self UseButtonPressed() )
			{
				{wait(.05);};
			}
		}
		
		// Sprint Sound
		//-------------
		if ( self IsSprinting() )
		{
			while ( self IsSprinting() )
			{
				self notify( "bhtn_action_notify", "sprint" );
				
				{wait(.05);};
			}
		}
		
		{wait(.05);};
	}
}

// self = a player
function turned_disable_player_weapons()
{
	// Already A Zombie, Just Respawning
	//----------------------------------
	if ( ( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
		return;
	}
	
	weaponInventory = self GetWeaponsList();
	self.lastActiveWeapon = self GetCurrentWeapon();
	self SetLastStandPrevWeap( self.lastActiveWeapon );
	self.laststandpistol = undefined;

	self.hadpistol = false;

	if ( !IsDefined( self.weaponZMTurnedMelee ) )
	{
		self.weaponZMTurnedMelee = level.weaponZMTurnedMelee;
	}
	if ( !IsDefined( self.weaponZMTurnedMeleeDW ) )
	{
		self.weaponZMTurnedMeleeDW = level.weaponZMTurnedMeleeDW;
	}
	
	self TakeAllWeapons();
	self DisableWeaponCycling();
}


// self = a player
function turned_enable_player_weapons()
{
	self TakeAllWeapons();
	self EnableWeaponCycling();
	self EnableOffhandWeapons();
	
	self.turned_had_knife = undefined;
	rottweil_weapon = GetWeapon( "rottweil72" );
	
	// Custom Loadout
	//---------------
	if ( IsDefined( level.humanify_custom_loadout ) )
	{		
		self thread [[ level.humanify_custom_loadout ]]();
		return;
	}
	// Give ShotGun
	//-------------
	else if ( !self HasWeapon( rottweil_weapon ) )
	{
		self GiveWeapon( rottweil_weapon );
		self SwitchToWeapon( rottweil_weapon );
	}
	
	// Give Start Weapons
	//-------------------
	if ( !( isdefined( self.is_zombie ) && self.is_zombie ) && !self HasWeapon( level.start_weapon ) )
	{
		if ( !self HasWeapon( level.weaponBaseMelee ) )
		{
			self GiveWeapon( level.weaponBaseMelee );
		}
		
		self zm_utility::give_start_weapon( false );
	}
		
	if ( self HasWeapon( rottweil_weapon ) )
	{
		self SetWeaponAmmoClip( rottweil_weapon, 2 );
		self SetWeaponAmmoStock( rottweil_weapon, 0 );
	}
	
	if ( self HasWeapon( level.start_weapon ) )
	{
		self GiveMaxAmmo( level.start_weapon );
	}
	
	// Replenish Grenades
	//-------------------
	if ( self HasWeapon( self zm_utility::get_player_lethal_grenade() ) )
	{
		self GetWeaponAmmoClip( self zm_utility::get_player_lethal_grenade() );
	}
	else
	{
		self GiveWeapon( self zm_utility::get_player_lethal_grenade() );
	}

	self SetWeaponAmmoClip( self zm_utility::get_player_lethal_grenade(), 2 );

}

function get_farthest_available_zombie( player )
{
	while ( true )
	{
		zombies = array::get_all_closest( player.origin, GetAiTeamArray( level.zombie_team ) );
		//* zombies = array_reverse( zombies );

		for ( x = 0; x < zombies.size; x++ )
		{
			zombie = zombies[ x ];

			if ( IsDefined( zombie ) && IsAlive( zombie ) &&
			!( isdefined( zombie.in_the_ground ) && zombie.in_the_ground ) && // Make Sure This Zombie Isn't Rising
			!( isdefined( zombie.gibbed ) && zombie.gibbed ) && !( isdefined( zombie.head_gibbed ) && zombie.head_gibbed ) && // Make Sure This Zombie Wasn't Damaged
			!( isdefined( zombie.is_being_used_as_spawnpoint ) && zombie.is_being_used_as_spawnpoint ) &&
			zombie zm_utility::in_playable_area() )
			{
				zombie.is_being_used_as_spawnpoint = true;

				return zombie;
			}
		}

		{wait(.05);};
	}
}

function get_available_human()
{
	players = GetPlayers();
	foreach ( player in players )
	{
		if ( !( isdefined( player.is_zombie ) && player.is_zombie ) )
		{
			return player;
		}
	}
}

function silentlyRemoveZombie()
{
	self.skip_death_notetracks = true;
	self.nodeathragdoll = true;
	self DoDamage( self.maxhealth * 2, self.origin, self, self, "none", "MOD_SUICIDE" );
	self zm_utility::self_delete();
}

function getSpawnPoint()
{
	spawnPoint = self spawnlogic::getSpawnpoint_DM( level._turned_zombie_respawnpoints );
	return spawnPoint;
}

/*
function spawnSpectator()
{
	self StopShellshock();
	self StopRumble( "damage_heavy" );

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.maxhealth = self.health;
	self.shellshocked = false;
	self.inWater = false;
	self.friendlydamage = undefined;
	self.hasSpawned = true;
	self.spawnTime = GetTime();
	self.afk = false;

	/#	println( "*************************Zombie Spectator***" );	#/
	self DetachAll();
	
	self zm::setSpectatePermissions( true ); 
	
	self Spawn( self.origin, self.angles, "zsurvival" );
	self notify( "spawned_spectator" );
}
*/
