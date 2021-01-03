#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                                                               

#namespace zm_melee_weapon;

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

function init( weapon_name, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn )
{
	weapon = GetWeapon( weapon_name );
	flourish_weapon = GetWeapon( flourish_weapon_name );
	ballistic_weapon = GetWeapon( ballistic_weapon_name );
	ballistic_upgraded_weapon = GetWeapon( ballistic_upgraded_weapon_name );

	add_melee_weapon( weapon, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn );

	melee_weapon_triggers = GetEntArray( wallbuy_targetname, "targetname" );
	for ( i = 0; i < melee_weapon_triggers.size; i++ )
	{
		knife_model = GetEnt( melee_weapon_triggers[i].target, "targetname" );
		if ( isdefined( knife_model ) )
		{
			knife_model hide();
		}
		
		melee_weapon_triggers[i] thread melee_weapon_think( weapon, cost, flourish_fn, vo_dialog_id, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon );

		melee_weapon_triggers[i] SetHintString( hint_string, cost );
		cursor_hint = "HINT_WEAPON";
		cursor_hint_weapon = weapon;
		melee_weapon_triggers[i] setCursorHint( cursor_hint, cursor_hint_weapon );
		melee_weapon_triggers[i] UseTriggerRequireLookAt();
	}

	// Support for spawnable system.

	melee_weapon_structs = struct::get_array( wallbuy_targetname, "targetname");
	
	for ( i = 0; i < melee_weapon_structs.size; i++ )
	{
		prepare_stub( melee_weapon_structs[i].trigger_stub, weapon, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn );
	}
	
	
	zm_utility::register_melee_weapon_for_level( weapon.name );
	//zm_weapons::add_retrievable_knife_init_name( ballistic_weapon );
	//zm_weapons::add_retrievable_knife_init_name( ballistic_upgraded_weapon );

	if ( !isDefined( level.ballistic_weapon ) )
	{
		level.ballistic_weapon = [];
	}
	level.ballistic_weapon[weapon] = ballistic_weapon;

	if ( !isDefined( level.ballistic_upgraded_weapon ) )
	{
		level.ballistic_upgraded_weapon = [];
	}
	level.ballistic_upgraded_weapon[weapon] = ballistic_upgraded_weapon;

/#
	if ( !IsDefined( level.zombie_weapons[weapon] ) )
    {
		if ( isdefined( level.devgui_add_weapon ) )
		{
			[[level.devgui_add_weapon]]( weapon, "", weapon_name, cost);
		}
    }
#/
}

function prepare_stub( stub, weapon, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn )
{
	if ( isdefined( stub ) )
	{
		stub.hint_string = hint_string;
		stub.cursor_hint = "HINT_WEAPON";
		stub.cursor_hint_weapon = weapon;
		stub.cost = cost;
		stub.weapon = weapon;
		stub.vo_dialog_id = vo_dialog_id;
		stub.flourish_weapon = flourish_weapon;
		stub.ballistic_weapon = ballistic_weapon;
		stub.ballistic_upgraded_weapon = ballistic_upgraded_weapon;
		stub.trigger_func = &melee_weapon_think;
		stub.flourish_fn = flourish_fn;
	}
}

function add_stub( stub, weapon )
{
	melee_weapon = undefined;
	for ( i = 0; i < level._melee_weapons.size; i++ )
	{
		if ( level._melee_weapons[i].weapon == weapon )
		{
			melee_weapon = level._melee_weapons[i];
			break;
		}
	}
	if ( isdefined( stub ) && isdefined( melee_weapon ) )
	{
		prepare_stub( stub, melee_weapon.weapon, melee_weapon.flourish_weapon, melee_weapon.ballistic_weapon, melee_weapon.ballistic_upgraded_weapon, 
		              melee_weapon.cost, melee_weapon.wallbuy_targetname, melee_weapon.hint_string, melee_weapon.vo_dialog_id, 
					  melee_weapon.flourish_fn );
	}
}

function add_melee_weapon( weapon, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn )
{
	melee_weapon = SpawnStruct();
	melee_weapon.weapon                      = weapon;
	melee_weapon.flourish_weapon			 = flourish_weapon;
	melee_weapon.ballistic_weapon			 = ballistic_weapon;
	melee_weapon.ballistic_upgraded_weapon	 = ballistic_upgraded_weapon;
	melee_weapon.cost						 = cost;
	melee_weapon.wallbuy_targetname			 = wallbuy_targetname;
	melee_weapon.hint_string				 = hint_string;
	melee_weapon.vo_dialog_id				 = vo_dialog_id;
	melee_weapon.flourish_fn 				 = flourish_fn;

	if ( !isdefined( level._melee_weapons ) )
	{
		level._melee_weapons = [];
	}
	level._melee_weapons[level._melee_weapons.size] = melee_weapon;
}

function player_can_see_weapon_prompt()
{
	if ( ( isdefined( level._allow_melee_weapon_switching ) && level._allow_melee_weapon_switching ) )
	{
		return true;
	}

	if ( IsDefined( self zm_utility::get_player_melee_weapon() ) && self HasWeapon( self zm_utility::get_player_melee_weapon() ) )
	{
		return false;
	}

	return true;
}

// Re-enable all melee weapon wallbuy triggers 
function spectator_respawn_all()
{
	for ( i = 0; i < level._melee_weapons.size; i++ )
	{
		self spectator_respawn( level._melee_weapons[i].wallbuy_targetname, level._melee_weapons[i].weapon );
	}
}

function spectator_respawn( wallbuy_targetname, weapon )
{
	melee_triggers = GetEntArray( wallbuy_targetname, "targetname" );
	// ww: player needs to reset trigger knowledge without claiming full ownership
	players = GetPlayers();
	for ( i = 0; i < melee_triggers.size; i++ )
	{
		melee_triggers[i] SetVisibleToAll();
		if ( !( isdefined( level._allow_melee_weapon_switching ) && level._allow_melee_weapon_switching ) )
		{
			for ( j = 0; j < players.size; j++ )
			{
				if ( !players[j] player_can_see_weapon_prompt() )
				{
					melee_triggers[i] SetInvisibleToPlayer( players[j] );
				}
			}
		}
	}
}

// Hide all melee weapon wallbuy triggers 
function trigger_hide_all()
{
	for ( i = 0; i < level._melee_weapons.size; i++ )
	{
		self trigger_hide( level._melee_weapons[i].wallbuy_targetname );
	}
}

function trigger_hide( wallbuy_targetname )
{
	melee_triggers = GetEntArray( wallbuy_targetname, "targetname" );

	for ( i = 0; i < melee_triggers.size; i++ )
	{
		melee_triggers[i] SetInvisibleToPlayer( self );
	}
}

function has_any_ballistic_knife()
{
	primaryWeapons = self GetWeaponsListPrimaries(); 

	for ( i = 0; i < primaryweapons.size; i++ )
	{
		if ( primaryWeapons[i].isBallisticKnife )
		{
			return true;
		}
	}

	return false;
}

function has_upgraded_ballistic_knife()
{
	primaryWeapons = self GetWeaponsListPrimaries(); 

	for ( i = 0; i < primaryweapons.size; i++ )
	{
		if ( primaryWeapons[i].isBallisticKnife && zm_weapons::is_weapon_upgraded( primaryWeapons[i] ) )
		{
			return true;
		}
	}

	return false;
}

function give_ballistic_knife( weapon, upgraded )
{
	current_melee_weapon = self zm_utility::get_player_melee_weapon();
	if ( IsDefined( current_melee_weapon ) )
	{
		if ( upgraded && IsDefined( level.ballistic_upgraded_weapon ) && IsDefined( level.ballistic_upgraded_weapon[current_melee_weapon] ) )
		{
			weapon = level.ballistic_upgraded_weapon[current_melee_weapon];
		}
		if ( !upgraded && IsDefined( level.ballistic_weapon ) && IsDefined( level.ballistic_weapon[current_melee_weapon] ) )
		{
			weapon = level.ballistic_weapon[current_melee_weapon];
		}
	}

	return weapon;
}


function change_melee_weapon( weapon, current_weapon )
{
	current_melee_weapon = self zm_utility::get_player_melee_weapon();
	if ( current_melee_weapon != level.weaponNone && current_melee_weapon != weapon )
	{
		self TakeWeapon( current_melee_weapon );
	}
	self zm_utility::set_player_melee_weapon( weapon );

	had_ballistic = 0;
	had_ballistic_upgraded = 0;
	ballistic_was_primary = 0;

	primaryWeapons = self GetWeaponsListPrimaries(); 

	for ( i = 0; i < primaryweapons.size; i++ )
	{
		primary_weapon = primaryweapons[i];
		if ( primary_weapon.isBallisticKnife )
		{
			had_ballistic = 1;
			if ( primary_weapon == current_weapon )
			{
				ballistic_was_primary = 1;
			}

			self notify( "zmb_lost_knife" );
			self TakeWeapon( primary_weapon );
			if ( zm_weapons::is_weapon_upgraded( primary_weapon ) )
			{
				had_ballistic_upgraded = 1;
			}
		}

	}

	if ( had_ballistic )
	{
		if ( had_ballistic_upgraded )
		{
			new_ballistic = level.ballistic_upgraded_weapon[weapon];
			if ( ballistic_was_primary )
			{
				current_weapon = new_ballistic;
			}

			self GiveWeapon( new_ballistic, self zm_weapons::get_pack_a_punch_weapon_options( new_ballistic ) );
		}
		else
		{
			new_ballistic = level.ballistic_weapon[weapon];
			if ( ballistic_was_primary )
			{
				current_weapon = new_ballistic;
			}

			self GiveWeapon( new_ballistic, 0 );
		}
	}

	return current_weapon;
}



function melee_weapon_think( weapon, cost, flourish_fn, vo_dialog_id, flourish_weapon, ballistic_weapon, ballistic_upgraded_weapon )
{
	self.first_time_triggered = false; 
	if ( isdefined( self.stub ) )
	{
		self endon( "kill_trigger" );
		if ( isdefined( self.stub.first_time_triggered ) )
		{
			self.first_time_triggered = self.stub.first_time_triggered;
		}
		
		weapon = self.stub.weapon;
		cost = self.stub.cost;
		flourish_fn = self.stub.flourish_fn;
		vo_dialog_id = self.stub.vo_dialog_id;
		flourish_weapon = self.stub.flourish_weapon;
		ballistic_weapon = self.stub.ballistic_weapon;
		ballistic_upgraded_weapon = self.stub.ballistic_upgraded_weapon;

		players = GetPlayers();

		if ( !( isdefined( level._allow_melee_weapon_switching ) && level._allow_melee_weapon_switching ) )
		{
			for ( i = 0; i < players.size; i++ )
			{
				if ( !players[i] player_can_see_weapon_prompt() )
				{
					self SetInvisibleToPlayer( players[i] );
				}
			}
		}
		
	}
	
	for ( ;; )
	{
		self waittill( "trigger", player ); 		
		// if not first time and they have the weapon give ammo

		if ( !zm_utility::is_player_valid( player ) )
		{
			player thread zm_utility::ignore_triggers( 0.5 );
			continue;
		}

		if ( player zm_utility::in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}
		
		if ( player isThrowingGrenade() )
		{
			wait( 0.1 );
			continue;
		}

		if ( ( player.is_drinking > 0 ) )
		{
			wait( 0.1 );
			continue;
		}

		player_has_weapon = player HasWeapon( weapon ); 
		if ( player_has_weapon || player zm_utility::has_powerup_weapon() )
		{
			wait( 0.1 );
			continue;
		}

 		if ( player isSwitchingWeapons() )
 		{
			wait( 0.1 );
 			continue;
 		}

		current_weapon = player GetCurrentWeapon();
		if ( zm_utility::is_placeable_mine( current_weapon ) || zm_equipment::is_equipment( current_weapon ) )
		{
			wait( 0.1 );
			continue;
		}
		
		if ( player laststand::player_is_in_laststand() || ( isdefined( player.intermission ) && player.intermission ) )
		{
			wait( 0.1 );
			continue;
		}

		if ( !player_has_weapon )
		{
			cost = self.stub.cost;
			
			// If the player has the double points persistent upgrade, reduce the "cost" and "ammo cost"
			if ( player zm_pers_upgrades_functions::is_pers_double_points_active() )
			{
				cost = int( cost / 2 );
			}
			
			// else make the weapon show and give it
			if ( player.score >= cost )
			{
				if ( self.first_time_triggered == false )
				{
					model = getent( self.target, "targetname" ); 
					
					if ( isdefined( model ) )
					{
						model thread melee_weapon_show( player ); 
					}
					else if ( isdefined( self.clientFieldName ) )
					{
						level clientfield::set( self.clientFieldName, 1 );
					}
					
					self.first_time_triggered = true; 
					if ( isdefined( self.stub ) )
					{
						self.stub.first_time_triggered = true;
					}
					
				}

				player zm_score::minus_to_player_score( cost, true ); 

				player thread give_melee_weapon( vo_dialog_id, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon, flourish_fn, self );
			}
			else
			{
				zm_utility::play_sound_on_ent( "no_purchase" );
				player zm_audio::create_and_play_dialog( "general", "outofmoney", 1 );
			}
		}
		else
		{
			if ( !( isdefined( level._allow_melee_weapon_switching ) && level._allow_melee_weapon_switching ) )
			{
				self SetInvisibleToPlayer( player );
			}
		}
	}
}

function melee_weapon_show( player )
{
	player_angles = VectorToAngles( player.origin - self.origin ); 

	player_yaw = player_angles[1]; 
	weapon_yaw = self.angles[1]; 

	yaw_diff = AngleClamp180( player_yaw - weapon_yaw ); 

	if ( yaw_diff > 0 )
	{
		yaw = weapon_yaw - 90; 
	}
	else
	{
		yaw = weapon_yaw + 90; 
	}

	self.og_origin = self.origin; 
	self.origin = self.origin + ( AnglesToForward( (0, yaw, 0) ) * 8 ); 

	{wait(.05);}; 
	self Show(); 

	zm_utility::play_sound_at_pos( "weapon_show", self.origin, self );

	time = 1; 
	self MoveTo( self.og_origin, time ); 
}


function give_melee_weapon( vo_dialog_id, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon, flourish_fn, trigger )
{
	if ( isdefined( flourish_fn ) )
	{
		self thread [[flourish_fn]]();
	}

	original_weapon = self do_melee_weapon_flourish_begin( flourish_weapon );
	self zm_audio::create_and_play_dialog( "weapon_pickup", vo_dialog_id );
	
	self util::waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );

	// restore player controls and movement
	self do_melee_weapon_flourish_end( original_weapon, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon );

	if ( self laststand::player_is_in_laststand() || ( isdefined( self.intermission ) && self.intermission ) )
	{
		// if they're in laststand at this point then they won't have gotten the weapon, so don't hide the trigger
		return;
	}

	if ( !( isdefined( level._allow_melee_weapon_switching ) && level._allow_melee_weapon_switching )  )
	{
		if ( IsDefined( trigger ) )
		{
			trigger SetInvisibleToPlayer( self );
		}
		self trigger_hide_all();
	}

}

function do_melee_weapon_flourish_begin( flourish_weapon )
{
	self zm_utility::increment_is_drinking();

	self zm_utility::disable_player_move_states( true );

	original_weapon = self GetCurrentWeapon();
	weapon = flourish_weapon;

	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );

	return original_weapon;
}

function do_melee_weapon_flourish_end( original_weapon, flourish_weapon, weapon, ballistic_weapon, ballistic_upgraded_weapon )
{
	Assert( !original_weapon.isPerkBottle );
	Assert( original_weapon != level.weaponReviveTool );
	
	
	self zm_utility::enable_player_move_states();

	// TODO: race condition?
	if ( self laststand::player_is_in_laststand() || ( isdefined( self.intermission ) && self.intermission ) )
	{
		self TakeWeapon( weapon );
		self.lastActiveWeapon = level.weaponNone; // this should be handled by laststand.gsc, but then we couldn't FFOTD the fix
		return;
	}

	self TakeWeapon( flourish_weapon );

	self GiveWeapon( weapon );
	original_weapon = change_melee_weapon( weapon, original_weapon );

	if ( self HasWeapon( level.weaponBaseMelee ) )
	{
		self TakeWeapon( level.weaponBaseMelee );
	}

	if ( self zm_utility::is_multiple_drinking() )
	{
		self zm_utility::decrement_is_drinking();
		return;
	}
	else if ( original_weapon == level.weaponBaseMelee ) // if all they had was the knife, we need to switch them to the new weapon
	{
		self SwitchToWeapon( weapon );
		
		// and since it has no raise anim, there'll be no "weapon_change_complete" notify
		self zm_utility::decrement_is_drinking();
		return;
	}
	else if ( original_weapon != level.weaponBaseMelee && !zm_utility::is_placeable_mine( original_weapon ) && !zm_equipment::is_equipment( original_weapon ) )
	{
		self SwitchToWeapon( original_weapon );
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

	if ( !self laststand::player_is_in_laststand() && !( isdefined( self.intermission ) && self.intermission ) )
	{
		self zm_utility::decrement_is_drinking();
	}
}


