#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\callbacks_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace player;






function autoexec __init__sytem__() {     system::register("player",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
	isMultiplayer = !SessionModeIsZombiesGame() && !SessionModeIsCampaignGame();

	if ( !isMultiplayer )
	{
		self thread last_valid_position();
	}
}

// cached navmesh position for player
function last_valid_position()
{
	self endon( "disconnect" );

	self notify( "stop_last_valid_position" );
	self endon( "stop_last_valid_position" );

	// try to at least get a valid position
	while ( !isdefined( self.last_valid_position ) )
	{
		self.last_valid_position = GetClosestPointOnNavMesh( self.origin, 2048, 0 );
		wait 0.1;
	}

	while ( 1 )
	{
		// if haven't moved very far, don't bother
		if ( Distance2DSquared( self.origin, self.last_valid_position ) < ( (15) * (15) ) && 
			( (self.origin[2] - self.last_valid_position[2]) * (self.origin[2] - self.last_valid_position[2]) ) < ( (36) * (36) ) )
		{
			wait 0.1;
			continue;
		}

		// position is already good
		if ( IsPointOnNavMesh( self.origin, self ) )
		{
			self.last_valid_position = self.origin;
		}
		else 
		{
			position = GetClosestPointOnNavMesh( self.origin, 100, 15 );
			if ( isdefined( position ) )
			{
				self.last_valid_position = position;
			}
		}

		wait( 0.1 );
	}
}

function take_weapons()
{
	if ( !( isdefined( self.gun_removed ) && self.gun_removed ) )
	{
		self.gun_removed = true;
		
		self._weapons = [];
		
		// Update current weapon only if a valid weapon is returned from code.
		// If the player is in the proccess of switching weapons, it will be "none"
		// and we don't want to save that as the player's weapon.
		
		if(!isdefined(self._current_weapon))self._current_weapon=level.weaponNone;
		
		w_current = self GetCurrentWeapon();
		if ( w_current != level.weaponNone )
		{
			self._current_weapon = w_current;
		}
		
		a_weapon_list = self GetWeaponsList();
		
		// If we still don't have a valid weapon saved off for current weapon, use the first weapon
		// in the player's weapon list
		
		if ( self._current_weapon == level.weaponNone )
		{
			if ( isdefined( a_weapon_list[ 0 ] ) )
			{
				self._current_weapon = a_weapon_list[ 0 ];
			}
		}
		
		foreach ( weapon in a_weapon_list )
		{
			if ( !isdefined( self._weapons ) ) self._weapons = []; else if ( !IsArray( self._weapons ) ) self._weapons = array( self._weapons ); self._weapons[self._weapons.size]=get_weapondata( weapon );;
		}
		
		self TakeAllWeapons();
	}
}

function give_back_weapons( b_immediate = false )
{
	if ( isdefined( self._weapons ) )
	{
		foreach ( weapondata in self._weapons )
		{
			weapondata_give( weapondata );
		}
		
		if ( isdefined( self._current_weapon ) && ( self._current_weapon != level.weaponNone ) )
		{
			if ( b_immediate )
			{
				self SwitchToWeaponImmediate( self._current_weapon );
			}
			else
			{
				self SwitchToWeapon( self._current_weapon );
			}
		}
		else if ( isdefined( self.primaryloadoutweapon ) && self HasWeapon( self.primaryloadoutweapon ) ) //If current weapon is not set, let's try to switch to primary
		{
			switch_to_primary_weapon( b_immediate );
		}
	}
	
	self._weapons = undefined;
	self.gun_removed = undefined;
}

function get_weapondata( weapon )
{
	weapondata = [];

	if ( !isdefined( weapon ) )
	{
		weapon = self GetCurrentWeapon();
	}

	weapondata[ "weapon" ] = weapon.name;

	if ( weapon != level.weaponNone )
	{
		weapondata[ "clip" ] = self GetWeaponAmmoClip( weapon );
		weapondata[ "stock" ] = self GetWeaponAmmoStock( weapon );
		weapondata[ "fuel" ] = self GetWeaponAmmoFuel( weapon );
		weapondata[ "heat" ] = self IsWeaponOverheating( 1, weapon );
		weapondata[ "overheat" ] = self IsWeaponOverheating( 0, weapon );
		
		if ( weapon.isRiotShield )
		{
			weapondata[ "health" ] = self.weaponHealth;
		}
	}
	else
	{
		weapondata[ "clip" ] = 0;
		weapondata[ "stock" ] = 0;
		weapondata[ "fuel" ] = 0;
		weapondata[ "heat" ] = 0;
		weapondata[ "overheat" ] = 0;
	}
	
	if ( weapon.dualWieldWeapon != level.weaponNone )
	{
		weapondata[ "lh_clip" ] = self GetWeaponAmmoClip( weapon.dualWieldWeapon );
	}
	else
	{
		weapondata[ "lh_clip" ] = 0;
	}
	
	if ( weapon.altWeapon != level.weaponNone )
	{
		weapondata[ "alt_clip" ] = self GetWeaponAmmoClip( weapon.altWeapon );
		weapondata[ "alt_stock" ] = self GetWeaponAmmoStock( weapon.altWeapon );
	}
	else
	{
		weapondata[ "alt_clip" ] = 0;
		weapondata[ "alt_stock" ] = 0;
	}
	
	return weapondata;
}

function weapondata_give( weapondata )
{
	weapon = util::get_weapon_by_name( weapondata[ "weapon" ] );

	self GiveWeapon( weapon );
	
	if ( weapon != level.weaponNone )
	{
		self SetWeaponAmmoClip( weapon, weapondata[ "clip" ] );
		self SetWeaponAmmoStock( weapon, weapondata[ "stock" ] );
		
		if ( IsDefined( weapondata[ "fuel" ] ) )
		{
			self SetWeaponAmmoFuel( weapon, weapondata[ "fuel" ] );
		}
		
		if ( IsDefined( weapondata[ "heat" ] ) && IsDefined( weapondata[ "overheat" ] ) )
		{
			self SetWeaponOverheating( weapondata[ "overheat" ], weapondata[ "heat" ], weapon );
		}
		
		if ( weapon.isRiotShield && IsDefined( weapondata[ "health" ] ) )
		{
			self.weaponHealth = weapondata[ "health" ];
		}
	}
	
	if ( weapon.dualWieldWeapon != level.weaponNone )
	{
		self SetWeaponAmmoClip( weapon.dualWieldWeapon, weapondata[ "lh_clip" ] );
	}
	
	if ( weapon.altWeapon != level.weaponNone )
	{
		self SetWeaponAmmoClip( weapon.altWeapon, weapondata[ "alt_clip" ] );
		self SetWeaponAmmoStock( weapon.altWeapon, weapondata[ "alt_stock" ] );
	}
}

function switch_to_primary_weapon( b_immediate = false )
{
	if ( is_valid_weapon( self.primaryloadoutweapon ) )
	{
		if ( b_immediate )
		{
			self SwitchToWeaponImmediate( self.primaryloadoutweapon );
		}
		else
		{
			self SwitchToWeapon( self.primaryloadoutweapon );
		}
	}
}

function fill_current_clip() //self = player
{
	w_current = self GetCurrentWeapon();
	if ( w_current.isheroweapon ) //We don't want to give the player more hero ammo
	{
		w_current = self.primaryloadoutweapon; //Let's give them primary weapon ammo instead
	}
	
	if ( isdefined( w_current ) && self HasWeapon( w_current ) ) // with "copycat" ability, the player might not have their primary loadout weapon
	{	
		self SetWeaponAmmoClip( w_current, w_current.clipsize );
	}
}

function is_valid_weapon( weaponObject )
{
	return ( isdefined( weaponObject ) && ( weaponObject != level.weaponNone ) );
}

function is_spawn_protected()
{
	if ( !isdefined( self.spawntime ) )
	{
		return false;
	}
		
	if ( !isdefined( level.spawnProtectionTime ) )
	{
		return false;
	}
		
	if ( ( gettime() - self.spawntime ) / 1000 <= level.spawnProtectionTime )
	{
		return true;
	}
	
	return false;
}

/@
"Name: simple_respawn()"
"Summary: Respawn a player at whatever the current best spawn point is using the gamemodes base spawn function.  Most of the spawn logic is not included and this is mostly just a teleport using the spawn logic.  The player entity is untouched, and no spawn callbacks are called."
"CallOn: player"
"Example: e_player player::simple_respawn();"
@/
function simple_respawn()
{
	self [[ level.onSpawnPlayer ]]( false );
}
