#using scripts\codescripts\struct;

#using scripts\shared\array_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_stats;

                                                                                                                               

function main()
{
	if ( !IsDefined( level.weapon_locker_map ) )
	{
		level.weapon_locker_map = level.script;
	}

	level.weapon_locker_online = SessionModeIsOnlineGame();
	weapon_lockers = struct::get_array( "weapons_locker", "targetname" );
	array::thread_all( weapon_lockers, &triggerWeaponsLockerWatch );
}
	
	
function wl_has_stored_weapondata()
{
	if ( level.weapon_locker_online )
	{
		return self zm_stats::has_stored_weapondata( level.weapon_locker_map );
	}
	else
	{
		return isDefined( self.stored_weapon_data );
	}
}

function wl_get_stored_weapondata()
{
	if ( level.weapon_locker_online )
	{
		return self zm_stats::get_stored_weapondata( level.weapon_locker_map );
	}
	else
	{
		return self.stored_weapon_data;
	}
}

function wl_clear_stored_weapondata()
{
	if ( level.weapon_locker_online )
	{
		self zm_stats::clear_stored_weapondata( level.weapon_locker_map );
	}
	else
	{
		self.stored_weapon_data = undefined;
	}
}

function wl_set_stored_weapondata( weapondata )
{
	if ( level.weapon_locker_online )
	{
		self zm_stats::set_stored_weapondata( weapondata, level.weapon_locker_map );
	}
	else
	{
		self.stored_weapon_data = weapondata;
	}
}

function triggerWeaponsLockerWatch( )
{
	unitrigger_stub = SpawnStruct();
	unitrigger_stub.origin = self.origin; 
	if ( IsDefined( self.script_angles ) )
	{
		unitrigger_stub.angles = self.script_angles;
	}
	else
	{
		unitrigger_stub.angles = self.angles; 
	}

	unitrigger_stub.script_angles = unitrigger_stub.angles;
	if ( IsDefined( self.script_length ) )
	{
		unitrigger_stub.script_length = self.script_length;
	}
	else
	{
		unitrigger_stub.script_length = 16;
	}

	if ( IsDefined( self.script_width ) )
	{
		unitrigger_stub.script_width = self.script_width;
	}
	else
	{
		unitrigger_stub.script_width = 32;
	}

	if ( IsDefined( self.script_height ) )
	{
		unitrigger_stub.script_height = self.script_height;
	}
	else
	{
		unitrigger_stub.script_height = 64;
	}
	
	unitrigger_stub.origin -= (AnglesToRight( unitrigger_stub.angles ) * (unitrigger_stub.script_length / 2));
	
	unitrigger_stub.targetname = "weapon_locker";

	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.clientFieldName = "weapon_locker";
	
	zm_unitrigger::unitrigger_force_per_player_triggers( unitrigger_stub, true );
	unitrigger_stub.prompt_and_visibility_func = &triggerWeaponsLockerThinkUpdatePrompt;
	
	zm_unitrigger::register_static_unitrigger( unitrigger_stub, &triggerWeaponsLockerThink );
}

function triggerWeaponsLockerIsValidWeapon( weapon )
{
	weapon = zm_weapons::get_base_weapon( weapon );

	if ( !zm_weapons::is_weapon_included( weapon ) ) 
	{
		return false;
	}

	// no grenades, claymores, melee weapons, equipment, or limited weapons
	if ( zm_utility::is_offhand_weapon( weapon ) ||  zm_utility::is_limited_weapon( weapon ) )
	{
		return false;
	}

	return true;
}

function triggerWeaponsLockerIsValidWeaponPromptUpdate( player, weapon )
{
	retrievingWeapon = player wl_has_stored_weapondata();
	
	if ( !retrievingWeapon )
	{
		weapon = player zm_weapons::get_nonalternate_weapon( weapon );
		if ( weapon == level.weaponNone )
		{
			self setCursorHint( "HINT_NOICON" ); 
	
			if ( !triggerWeaponsLockerIsValidWeapon( weapon ) )
			{
				self SetHintString( &"ZOMBIE_WEAPON_LOCKER_DENY" );
			}
			else
			{
				self SetHintString( &"ZOMBIE_WEAPON_LOCKER_STORE" );
			}
		}
		else
		{
	        self setCursorHint( "HINT_WEAPON", weapon ); 
	
			if ( !triggerWeaponsLockerIsValidWeapon( weapon ) )
			{
				self SetHintString( &"ZOMBIE_WEAPON_LOCKER_DENY_FILL" );
			}
			else
			{
				self SetHintString( &"ZOMBIE_WEAPON_LOCKER_STORE_FILL" );
			}
		}
	}
	else
	{
		weapondata = player wl_get_stored_weapondata();
		if ( isDefined( level.remap_weapon_locker_weapons ) )
		{
			weapondata = remap_weapon( weapondata, level.remap_weapon_locker_weapons );
		}
		weaponToGive = weapondata["weapon"];
		primaries = player GetWeaponsListPrimaries();
		maxWeapons = zm_utility::get_player_weapon_limit( player );
		weapon = player zm_weapons::get_nonalternate_weapon( weapon );
		if ( (IsDefined( primaries ) && primaries.size >= maxWeapons) || weaponToGive == weapon )
		{
			if ( !triggerWeaponsLockerIsValidWeapon( weapon ) )
			{
				if ( weapon == level.weaponNone )
				{
					self setCursorHint( "HINT_NOICON", weapon ); 
					self SetHintString( &"ZOMBIE_WEAPON_LOCKER_DENY" );
				}
				else
				{
					self setCursorHint( "HINT_WEAPON", weapon ); 
					self SetHintString( &"ZOMBIE_WEAPON_LOCKER_DENY_FILL" );
				}
				return;
			}
		}
		self setCursorHint( "HINT_WEAPON", weaponToGive ); 
		self SetHintString( &"ZOMBIE_WEAPON_LOCKER_GRAB_FILL" );
	}
}

function triggerWeaponsLockerThinkUpdatePrompt( player )
{
	self triggerWeaponsLockerIsValidWeaponPromptUpdate( player, player GetCurrentWeapon() );
	
	return true;
}

function triggerWeaponsLockerThink()
{
	self.parent_player thread triggerWeaponsLockerWeaponChangeThink( self );
	
	while ( 1 )
	{
		self waittill( "trigger", player );
		
		retrievingWeapon = player wl_has_stored_weapondata();
		
		if ( !retrievingWeapon )
		{
			curWeapon = player GetCurrentWeapon();
			curWeapon = player zm_weapons::switch_from_alt_weapon( curWeapon );
			if ( !triggerWeaponsLockerIsValidWeapon( curWeapon ) )
			{
				continue;
			}
			
			weapondata = player zm_weapons::get_player_weapondata( player );
			
			player wl_set_stored_weapondata( weapondata );

			assert( curWeapon == weapondata["weapon"], "weapon data does not match" );
			
			player TakeWeapon( curWeapon );
			
			primaries = player GetWeaponsListPrimaries();
			if ( IsDefined( primaries[ 0 ] ) )
			{
				player SwitchToWeapon( primaries[ 0 ] );
			}
			else
			{
				player zm_weapons::give_fallback_weapon();
			}
			self triggerWeaponsLockerIsValidWeaponPromptUpdate( player, player GetCurrentWeapon() );
			
			player playsoundtoplayer( "evt_fridge_locker_close", player );
			player thread zm_audio::create_and_play_dialog( "general", "weapon_storage" );
			
		}
		else
		{
			curWeapon = player GetCurrentWeapon();
			primaries = player GetWeaponsListPrimaries();

			weapondata = player wl_get_stored_weapondata();
			if ( isDefined( level.remap_weapon_locker_weapons ) )
			{
				weapondata = remap_weapon( weapondata, level.remap_weapon_locker_weapons );
			}
			weaponToGive = weapondata["weapon"];
			
			if ( !triggerWeaponsLockerIsValidWeapon( weaponToGive ) )
			{
				player playlocalsound( level.zmb_laugh_alias );
				player wl_clear_stored_weapondata();
				self triggerWeaponsLockerIsValidWeaponPromptUpdate( player, player GetCurrentWeapon() );
				continue;
			}

			curWeap_base = zm_weapons::get_base_weapon( curWeapon );
			Weap_base = zm_weapons::get_base_weapon( weaponToGive );

			if ( player zm_weapons::has_weapon_or_upgrade( Weap_base ) && Weap_base != curWeap_base )
			{
				self SetHintString( &"ZOMBIE_WEAPON_LOCKER_DENY" );
				wait( 3 );
				self triggerWeaponsLockerIsValidWeaponPromptUpdate( player, player GetCurrentWeapon() );
				continue;
			}	

			maxWeapons = zm_utility::get_player_weapon_limit( player );
			if ( (IsDefined( primaries ) && primaries.size >= maxWeapons) || weaponToGive == curWeapon )
			{
				curWeapon = player zm_weapons::switch_from_alt_weapon( curWeapon );
				if ( !triggerWeaponsLockerIsValidWeapon( curWeapon ) )
				{
					self SetHintString( &"ZOMBIE_WEAPON_LOCKER_DENY" );
					wait( 3 );
					self triggerWeaponsLockerIsValidWeaponPromptUpdate( player, player GetCurrentWeapon() );
					continue;
				}				
				
				CurWeaponData = player zm_weapons::get_player_weapondata( player );
				player TakeWeapon( CurWeaponData["weapon"] );
				
				player zm_weapons::weapondata_give( weapondata );

				player wl_clear_stored_weapondata();
				player wl_set_stored_weapondata( CurWeaponData );
				player SwitchToWeapon( weapondata["weapon"] );
				self triggerWeaponsLockerIsValidWeaponPromptUpdate( player, player GetCurrentWeapon() );
			}
			else
			{
				player thread zm_audio::create_and_play_dialog( "general", "wall_withdrawl" );
				player wl_clear_stored_weapondata();
				player zm_weapons::weapondata_give( weapondata );
				player SwitchToWeapon( weapondata["weapon"] );
				self triggerWeaponsLockerIsValidWeaponPromptUpdate( player, player GetCurrentWeapon() );
			}		

			level notify( "weapon_locker_grab" );
			player playsoundtoplayer( "evt_fridge_locker_open", player );
		}

		wait ( 0.5 );
	}	
}

function triggerWeaponsLockerWeaponChangeThink( trigger )
{
	self endon( "disconnect" );
	self endon( "death" );
	trigger endon( "kill_trigger" );
	
	while ( true )
	{
		self waittill( "weapon_change", newWeapon );
		
		trigger triggerWeaponsLockerIsValidWeaponPromptUpdate( self, newWeapon );
	}
}

function add_weapon_locker_mapping( fromweapon, toweapon )
{
	if ( !isDefined( level.remap_weapon_locker_weapons ) )
	{
		level.remap_weapon_locker_weapons = [];
	}
	level.remap_weapon_locker_weapons[fromweapon] = toweapon;
}

function remap_weapon( weapondata, maptable )
{
	weapon = weapondata["weapon"].rootWeapon;
	att = undefined;
	if ( weapondata["weapon"].attachments.size )
	{
		att = weapondata["weapon"].attachments[0];
	}

	if ( !IsDefined( maptable[ weapon ] ) )
	{
		return weapondata;	
	}

	weapondata["weapon"] = maptable[ weapon ];
	weapon = weapondata["weapon"];
	if ( zm_weapons::is_weapon_upgraded( weapon ) )
	{
		if ( IsDefined( att ) && zm_weapons::weapon_supports_attachments( weapon ) )
		{
			base = zm_weapons::get_base_weapon( weapon );
			if ( !zm_weapons::weapon_supports_this_attachment( base, att ) )
			{
				att = zm_weapons::random_attachment( base );
			}
			weapondata["weapon"] = GetWeapon( weapondata["weapon"], att );
		}
		else if ( zm_weapons::weapon_supports_default_attachment( weapon ) )
		{
			att = zm_weapons::default_attachment( weapon );
			weapondata["weapon"] = GetWeapon( weapondata["weapon"], att );
		}
	}

	weapon = weapondata["weapon"];
	if ( weapon != level.weaponNone )
	{
		weapondata["clip"] = int( min( weapondata["clip"], weapon.clipSize ) );
		weapondata["stock"] = int( min( weapondata["stock"], weapon.maxAmmo ) );
		weapondata["fuel"] = int( min( weapondata["fuel"], weapon.fuelLife ) );
	}

	dw_weapon = weapon.dualWieldWeapon;
	if ( dw_weapon != level.weaponNone )
	{
		weapondata["lh_clip"] = int( min( weapondata["lh_clip"], dw_weapon.clipSize ) );
	}

	alt_weapon = weapon.altWeapon;
	if ( alt_weapon != level.weaponNone )
	{
		weapondata["alt_clip"] = int( min( weapondata["alt_clip"], alt_weapon.clipSize ) );
		weapondata["alt_stock"] = int( min( weapondata["alt_stock"], alt_weapon.maxAmmo ) );
	}

	return weapondata;	
}


