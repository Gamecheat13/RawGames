#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

#insert raw\maps\mp\zombies\_zm_utility.gsh;

//
// General melee weapon support
//

//
// global settings
//   Add this line to main() if players should be able to switch between melee weapons 
//     level._allow_melee_weapon_switching = 1;
//   Without it, buying any melee weapon will disable the wall-buys for all other melee weapons
//

//
// Unresolved corner case:
//   Buy sickle
//   Buy ballistic knife
//   Go to pack a puch and start upgrading the ballistic knife
//   While the machine is churning buy a bowie knife
//   Take your upgraded weapon
//   -- you should have the ballistic & bowie but instead you will have ballistic and sickle 
//

// This is called from the init() calls for the individual weapons

init( weapon_name, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, cost, wallbuy_targetname, hint_string, vo_dialog_id, has_weapon, give_weapon, take_weapon )
{
	PrecacheItem( weapon_name );
	PrecacheItem( flourish_weapon_name );
		
	add_melee_weapon( weapon_name, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, cost, wallbuy_targetname, hint_string, vo_dialog_id, has_weapon, give_weapon, take_weapon );

	melee_weapon_triggers = GetEntArray( wallbuy_targetname, "targetname" );
	for( i = 0; i < melee_weapon_triggers.size; i++ )
	{
		knife_model = GetEnt( melee_weapon_triggers[i].target, "targetname" );
		if(isdefined(knife_model))
		{
			knife_model hide();
		}
		
		melee_weapon_triggers[i] thread melee_weapon_think(weapon_name, cost, has_weapon, give_weapon, vo_dialog_id, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name);
		melee_weapon_triggers[i] SetHintString( hint_string, cost ); 
		melee_weapon_triggers[i] setCursorHint( "HINT_NOICON" ); 
		melee_weapon_triggers[i] UseTriggerRequireLookAt();
	}

	// Support for spawnable system.

	melee_weapon_structs = GetStructArray( wallbuy_targetname, "targetname");
	
	for(i = 0; i < melee_weapon_structs.size; i ++)
	{
		if(isdefined(melee_weapon_structs[i].trigger_stub))
		{
			melee_weapon_structs[i].trigger_stub.hint_string = hint_string;
			melee_weapon_structs[i].trigger_stub.cost = cost;
			melee_weapon_structs[i].trigger_stub.weapon_name = weapon_name;
			melee_weapon_structs[i].trigger_stub.has_weapon = has_weapon;
			melee_weapon_structs[i].trigger_stub.give_weapon = give_weapon;
			melee_weapon_structs[i].trigger_stub.vo_dialog_id = vo_dialog_id;
			melee_weapon_structs[i].trigger_stub.flourish_weapon_name = flourish_weapon_name;
			melee_weapon_structs[i].trigger_stub.ballistic_weapon_name = ballistic_weapon_name;
			melee_weapon_structs[i].trigger_stub.ballistic_upgraded_weapon_name = ballistic_upgraded_weapon_name;
			melee_weapon_structs[i].trigger_stub.trigger_func = ::melee_weapon_think;
		}
	}
	
	
	register_melee_weapon_for_level( weapon_name );
	//maps\mp\zombies\_zm_weapons::add_retrievable_knife_init_name( ballistic_weapon_name );
	//maps\mp\zombies\_zm_weapons::add_retrievable_knife_init_name( ballistic_upgraded_weapon_name );

	if (!isDefined(level.ballistic_weapon_name))
		level.ballistic_weapon_name = [];
	level.ballistic_weapon_name[weapon_name]=ballistic_weapon_name;

	if (!isDefined(level.ballistic_upgraded_weapon_name))
		level.ballistic_upgraded_weapon_name = [];
	level.ballistic_upgraded_weapon_name[weapon_name]=ballistic_upgraded_weapon_name;

}

add_melee_weapon( weapon_name, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, cost, wallbuy_targetname, hint_string, vo_dialog_id, has_weapon, give_weapon, take_weapon )
{
	melee_weapon = SpawnStruct();
	melee_weapon.weapon_name                      = weapon_name;
	melee_weapon.flourish_weapon_name			 = flourish_weapon_name;
	melee_weapon.ballistic_weapon_name			 = ballistic_weapon_name;
	melee_weapon.ballistic_upgraded_weapon_name	 = ballistic_upgraded_weapon_name;
	melee_weapon.cost							 = cost;
	melee_weapon.wallbuy_targetname				 = wallbuy_targetname;
	melee_weapon.hint_string						 = hint_string;
	melee_weapon.vo_dialog_id					 = vo_dialog_id;
	melee_weapon.has_weapon						 = has_weapon;
	melee_weapon.give_weapon						 = give_weapon;
	melee_weapon.take_weapon 					 = take_weapon;

	if (!isdefined(level._melee_weapons))
	{
		level._melee_weapons=[];
	}
	level._melee_weapons[level._melee_weapons.size]=melee_weapon;
}

// Re-enable all melee weapon wallbuy triggers 
spectator_respawn_all()
{
	for ( i=0; i<level._melee_weapons.size; i++ )
	{
		self [[level._melee_weapons[i].take_weapon]]();
	}
	for ( i=0; i<level._melee_weapons.size; i++ )
	{
		self spectator_respawn( level._melee_weapons[i].wallbuy_targetname, level._melee_weapons[i].take_weapon, level._melee_weapons[i].has_weapon );
	}
}

spectator_respawn( wallbuy_targetname, take_weapon, has_weapon )
{
	melee_triggers = GetEntArray( wallbuy_targetname, "targetname" );
	// ww: player needs to reset trigger knowledge without claiming full ownership
	players = GET_PLAYERS();
	for( i = 0; i < melee_triggers.size; i++ )
	{
		melee_triggers[i] SetVisibleToAll();
		if (!is_true(level._allow_melee_weapon_switching))
		{
			for( j = 0; j < players.size; j++ )
			{
				if( players[j] [[has_weapon]]() )
				{
					melee_triggers[i] SetInvisibleToPlayer( players[j] );
				}
			}
		}
	}

}

// Hide all melee weapon wallbuy triggers 
trigger_hide_all()
{
	for ( i=0; i<level._melee_weapons.size; i++ )
	{
		self trigger_hide( level._melee_weapons[i].wallbuy_targetname );
	}
}

trigger_hide(wallbuy_targetname)
{
	melee_triggers = GetEntArray( wallbuy_targetname, "targetname" );

	for( i = 0; i < melee_triggers.size; i++ )
	{
		melee_triggers[i] SetInvisibleToPlayer( self );
	}
}


save_weapons_for_tombstone( player )
{
	self.tombstone_melee_weapons = [];
	for ( i=0; i<level._melee_weapons.size; i++ )
	{
		self save_weapon_for_tombstone( player, level._melee_weapons[i].weapon_name );
	}
}

save_weapon_for_tombstone( player, weapon_name )
{
	if ( player HasWeapon( weapon_name ) )
	{
		self.tombstone_melee_weapons[weapon_name]=1;
	}
}

restore_weapons_for_tombstone( player )
{
	for ( i=0; i<level._melee_weapons.size; i++ )
	{
		self restore_weapon_for_tombstone( player, level._melee_weapons[i].weapon_name );
	}
	self.tombstone_melee_weapons = undefined;
}

restore_weapon_for_tombstone( player, weapon_name )
{
	if ( is_true(self.tombstone_melee_weapons[weapon_name]) )
	{
		player GiveWeapon( weapon_name );
		player set_player_melee_weapon( weapon_name );
		self.tombstone_melee_weapons[weapon_name]=0;
	}
}



give_ballistic_knife( weapon_string, upgraded )
{
	current_melee_weapon = self get_player_melee_weapon();
	if ( IsDefined( current_melee_weapon ) )
	{
		if ( upgraded && IsDefined( level.ballistic_upgraded_weapon_name ) && IsDefined( level.ballistic_upgraded_weapon_name[current_melee_weapon] ) )
			weapon_string = level.ballistic_upgraded_weapon_name[current_melee_weapon];
		if ( !upgraded && IsDefined( level.ballistic_weapon_name ) && IsDefined( level.ballistic_weapon_name[current_melee_weapon] ) )
			weapon_string = level.ballistic_weapon_name[current_melee_weapon];
	}
	return weapon_string;
}


change_melee_weapon( weapon_name, current_weapon )
{
	current_melee_weapon = self get_player_melee_weapon();
	if ( isdefined( current_melee_weapon ) )
	{
		self TakeWeapon( current_melee_weapon );
		unacquire_weapon_toggle( current_melee_weapon );
	}
	self set_player_melee_weapon( weapon_name );

	had_ballistic = 0;
	had_ballistic_upgraded = 0;
	ballistic_was_primary = 0;

	primaryWeapons = self GetWeaponsListPrimaries(); 

	for (i=0; i<primaryweapons.size; i++)
	{
		primary_weapon = primaryweapons[i];
		if ( issubstr( primary_weapon, "knife_ballistic_" ) )
		{
			had_ballistic = 1;
			if (primary_weapon == current_weapon)
				ballistic_was_primary = 1;
			self notify( "zmb_lost_knife" );
			self TakeWeapon( primary_weapon );
			unacquire_weapon_toggle( primary_weapon );
			if ( issubstr( primary_weapon, "upgraded" ) )
			{
				had_ballistic_upgraded = 1;
			}
		}

	}

	if ( had_ballistic )
	{
		if ( had_ballistic_upgraded )
		{
			new_ballistic = level.ballistic_upgraded_weapon_name[weapon_name];
			if ( ballistic_was_primary )
				current_weapon = new_ballistic; 
			self GiveWeapon( new_ballistic, 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( new_ballistic ) );
		}
		else
		{
			new_ballistic = level.ballistic_weapon_name[weapon_name];
			if ( ballistic_was_primary )
				current_weapon = new_ballistic; 
			self GiveWeapon( new_ballistic, 0 );
		}
	}

	return current_weapon;
}



melee_weapon_think(weapon_name, cost, has_weapon, give_weapon, vo_dialog_id, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name)
{
	self.first_time_triggered = false; 
	if(isdefined(self.stub))
	{
		self endon("kill_trigger");
		if(isdefined(self.stub.first_time_triggered))
		{
			self.first_time_triggered = self.stub.first_time_triggered;
		}
		
		weapon_name = self.stub.weapon_name;
		cost = self.stub.cost;
		has_weapon = self.stub.has_weapon;
		give_weapon = self.stub.give_weapon;
		vo_dialog_id = self.stub.vo_dialog_id;
		flourish_weapon_name = self.stub.flourish_weapon_name;
		ballistic_weapon_name = self.stub.ballistic_weapon_name;
		ballistic_upgraded_weapon_name = self.stub.ballistic_upgraded_weapon_name;

		players = GetPlayers();

		if (!is_true(level._allow_melee_weapon_switching))
		{
			for(i = 0; i < players.size; i ++)
			{
				if(players[i] [[has_weapon]]() )
				{
					self SetInvisibleToPlayer( players[i] );
				}
			}
		}
		
	}
	
	for( ;; )
	{
		self waittill( "trigger", player ); 		
		// if not first time and they have the weapon give ammo

		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}

		if( player in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}
		
		if( player isThrowingGrenade() )
		{
			wait( 0.1 );
			continue;
		}

		if( IS_DRINKING(player.is_drinking) )
		{
			wait( 0.1 );
			continue;
		}

		if( player HasWeapon( weapon_name ) || player has_powerup_weapon() )
		{
			wait(0.1);
			continue;
		}

 		if( player isSwitchingWeapons() )
 		{
 			wait(0.1);
 			continue;
 		}

		current_weapon = player GetCurrentWeapon();
		if( is_placeable_mine( current_weapon ) || is_equipment( current_weapon ) || player has_powerup_weapon() )
		{
			wait(0.1);
			continue;
		}
		
		if (player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || is_true( player.intermission ) )
		{
			wait(0.1);
			continue;
		}

		player_has_weapon = player [[has_weapon]]();

		if( !player_has_weapon )
		{
			// else make the weapon show and give it
			if( player.score >= cost )
			{
				if( self.first_time_triggered == false )
				{
					model = getent( self.target, "targetname" ); 
					
					if(isdefined(model))
					{
						model thread melee_weapon_show( player ); 
					}
					else if (isdefined(self.clientFieldName))
					{
						level SetClientField(self.clientFieldName, 1);
					}
					
					self.first_time_triggered = true; 
					if(isdefined(self.stub))
					{
						self.stub.first_time_triggered = true;
					}
					
				}

				player maps\mp\zombies\_zm_score::minus_to_player_score( cost ); 

				bbPrint( "zombie_uses: playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type weapon",
						player.name, player.score, level.round_number, cost, weapon_name, self.origin );

				player maps\mp\zombies\_zm_weapons::check_collector_achievement( weapon_name );

				player thread give_melee_weapon(vo_dialog_id,flourish_weapon_name, weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, give_weapon, self);
			}
			else
			{
				play_sound_on_ent( "no_purchase" );
				player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money", undefined, 1 );
			}
		}
		else
		{
			if (!is_true(level._allow_melee_weapon_switching))
				self SetInvisibleToPlayer( player );
		}
	}
}

melee_weapon_show( player )
{
	player_angles = VectorToAngles( player.origin - self.origin ); 

	player_yaw = player_angles[1]; 
	weapon_yaw = self.angles[1]; 

	yaw_diff = AngleClamp180( player_yaw - weapon_yaw ); 

	if( yaw_diff > 0 )
	{
		yaw = weapon_yaw - 90; 
	}
	else
	{
		yaw = weapon_yaw + 90; 
	}

	self.og_origin = self.origin; 
	self.origin = self.origin +( AnglesToForward( ( 0, yaw, 0 ) ) * 8 ); 

	wait( 0.05 ); 
	self Show(); 

	play_sound_at_pos( "weapon_show", self.origin, self );

	time = 1; 
	self MoveTo( self.og_origin, time ); 
}


give_melee_weapon(vo_dialog_id,flourish_weapon_name, weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, give_weapon, trigger)
{
	gun = self do_melee_weapon_flourish_begin(flourish_weapon_name);
	self maps\mp\zombies\_zm_audio::create_and_play_dialog( "weapon_pickup", vo_dialog_id );
	
	self waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );

	// restore player controls and movement
	self do_melee_weapon_flourish_end( gun, flourish_weapon_name, weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name );

	if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || is_true( self.intermission ) )
	{
		// if they're in laststand at this point then they won't have gotten the weapon, so don't hide the trigger
		return;
	}

	self [[give_weapon]]();
	if (!is_true(level._allow_melee_weapon_switching))
	{
		trigger SetInvisibleToPlayer( self );
		self trigger_hide_all();
	}

}

do_melee_weapon_flourish_begin(flourish_weapon_name)
{
	self increment_is_drinking();

	self AllowLean( false );
	self AllowAds( false );
	self AllowSprint( false );
	self AllowCrouch( true );
	self AllowProne( false );
	self AllowMelee( false );
	
	wait( 0.05 );
	
	if ( self GetStance() == "prone" )
	{
		self SetStance( "crouch" );
	}

	gun = self GetCurrentWeapon();
	weapon = flourish_weapon_name;

	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );

	return gun;
}

do_melee_weapon_flourish_end( gun, flourish_weapon_name, weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name )
{
	assert( gun != "zombie_perk_bottle_doubletap" );
	assert( gun != "zombie_perk_bottle_revive" );
	assert( gun != "zombie_perk_bottle_jugg" );
	assert( gun != "zombie_perk_bottle_sleight" );
	assert( gun != "zombie_perk_bottle_marathon" );
	assert( gun != "zombie_perk_bottle_nuke" );
	assert( gun != "zombie_perk_bottle_deadshot" );
	assert( gun != "zombie_perk_bottle_additionalprimaryweapon" );
	assert( gun != "zombie_perk_bottle_tombstone" );
	assert( gun != level.revive_tool );
	
	self AllowLean( true );
	self AllowAds( true );
	self AllowSprint( true );
	self AllowProne( true );		
	self AllowMelee( true );
	weapon = flourish_weapon_name;
	
	// TODO: race condition?
	if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || is_true( self.intermission ) )
	{
		self TakeWeapon(weapon);
		self.lastActiveWeapon = "none"; // this should be handled by laststand.gsc, but then we couldn't FFOTD the fix
		return;
	}

	self TakeWeapon(weapon);

	self GiveWeapon( weapon_name );
	gun = change_melee_weapon( weapon_name, gun );

	if( self HasWeapon("knife_zm") )
	{
		self TakeWeapon( "knife_zm" );
	}

	if( self is_multiple_drinking() )
	{
		self decrement_is_drinking();
		return;
	}
	else if ( gun == "knife_zm" ) // if all they had was the knife, we need to switch them to the new weapon
	{
		self SwitchToWeapon( weapon_name );
		
		// and since it has no raise anim, there'll be no "weapon_change_complete" notify
		self decrement_is_drinking();
		return;
	}
	else if ( gun != "none" && !is_placeable_mine( gun ) && !is_equipment( gun ) )
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

	self waittill( "weapon_change_complete" );

	if ( !self maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !is_true( self.intermission ) )
	{
		self decrement_is_drinking();
	}
}


