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

function last_valid_position()
{
	self endon( "disconnect" );

	self notify( "stop_last_valid_position" );
	self endon( "stop_last_valid_position" );

	while ( 1 )
	{
		if ( IsPointOnMesh( self.origin ) && IsAwayFromBoundary( self.origin ) )	// position is already good
		{
			self.last_valid_position = self.origin;
		}
		else 
		{
			queryResult = PositionQuery_Source_Navigation( self.origin, 0, 48, 36, 4 );
			foreach( point in queryResult.data )
			{
				self.last_valid_position = point.origin;
				break;
			}
		}

		wait( 0.1 );
	}
}

function take_weapons()
{
	self._weapons = [];
	self._current_weapon = self GetCurrentWeapon();
	
	foreach ( weapon in self GetWeaponsList() )
	{
		if ( !isdefined( self._weapons ) ) self._weapons = []; else if ( !IsArray( self._weapons ) ) self._weapons = array( self._weapons ); self._weapons[self._weapons.size]=get_weapondata( weapon );;
	}
	
	self TakeAllWeapons();
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
	
	self._weapons = undefined;
	self._current_weapon = undefined;
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
