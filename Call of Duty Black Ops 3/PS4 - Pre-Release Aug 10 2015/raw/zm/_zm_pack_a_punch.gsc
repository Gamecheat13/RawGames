#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                       	                                
                                                                                                                               

#precache( "string", "ZOMBIE_PERK_PACKAPUNCH" );
#precache( "string", "ZOMBIE_PERK_PACKAPUNCH_ATT" );









function autoexec __init__sytem__() {     system::register("zm_pack_a_punch",&__init__,&__main__,undefined);    }
	
function __init__()
{
	zm_pap_util::init_parameters();
}

function __main__()
{
	if ( !IsDefined( level.pap_zbarrier_state_func ) )
	{
		level.pap_zbarrier_state_func = &process_pap_zbarrier_state;
	}
	
	// Spawn models, triggers, clip, etc.
	spawn_init();
	
	vending_weapon_upgrade_trigger = zm_pap_util::get_triggers();
	
	if ( vending_weapon_upgrade_trigger.size >= 1 )
	{
		array::thread_all( vending_weapon_upgrade_trigger, &vending_weapon_upgrade );
	}
	
	// Add old style pack machines if necessary.
	old_packs = GetEntArray( "zombie_vending_upgrade", "targetname" );
	for( i = 0; i < old_packs.size; i++ )
	{
		vending_weapon_upgrade_trigger[vending_weapon_upgrade_trigger.size] = old_packs[i];
	}
	level flag::init("pack_machine_in_use");
}

function private spawn_init()
{
	zbarriers = GetEntArray("zm_pack_a_punch", "targetname");
	
	for ( i = 0; i < zbarriers.size; i++ )
	{
		if ( !zbarriers[i] IsZbarrier() )
		{
			continue;
		}

		// Create the use trigger.
		use_trigger = Spawn( "trigger_radius_use", zbarriers[i].origin + (0, 0, 30), 0, 40, 70 );
		use_trigger.script_noteworthy = "pack_a_punch";
		use_trigger TriggerIgnoreTeam();

		// Create the collision model.
		collision = Spawn("script_model", zbarriers[i].origin, 1);
		collision.angles = zbarriers[i].angles;
		collision SetModel( "zm_collision_perks1" );
		collision.script_noteworthy = "clip";
		collision DisconnectPaths();

		// Connect all of the pieces for easy access.
		use_trigger.clip = collision;
		use_trigger.zbarrier = zbarriers[i];

		// Set up sounds
		use_trigger.script_sound = "mus_perks_packa_jingle";
		use_trigger.script_label = "mus_perks_packa_sting";
		use_trigger.longJingleWait = true;

		// Connect the trigger to the machine.
		use_trigger.target = "vending_packapunch";
		use_trigger.zbarrier.targetname = "vending_packapunch";

		// Set up power interactions.
		powered_on = get_start_state();
		use_trigger.powered = zm_power::add_powered_item( &turn_on, &turn_off, &get_range, &cost_func, 0, powered_on, use_trigger );
		
		if ( IsDefined( level.pack_a_punch.custom_power_think ) )
		{
			use_trigger thread [[level.pack_a_punch.custom_power_think]]( powered_on );
		}
		else
		{
			use_trigger thread toggle_think( powered_on );
		}

		if ( !isdefined( level.pack_a_punch.triggers ) ) level.pack_a_punch.triggers = []; else if ( !IsArray( level.pack_a_punch.triggers ) ) level.pack_a_punch.triggers = array( level.pack_a_punch.triggers ); level.pack_a_punch.triggers[level.pack_a_punch.triggers.size]=use_trigger;;
	}
}

function private third_person_weapon_upgrade( current_weapon, upgrade_weapon, packa_rollers, pap_machine, trigger )
{
	level endon("Pack_A_Punch_off");

	trigger endon("pap_player_disconnected");

	current_weapon = self GetBuildKitWeapon( current_weapon );
	upgrade_weapon = self GetBuildKitWeapon( upgrade_weapon );

	trigger.current_weapon = current_weapon;
	trigger.current_weapon_options = self GetBuildKitWeaponOptions( trigger.current_weapon );
	trigger.current_weapon_acvi = self GetBuildKitAttachmentCosmeticVariantIndexes( trigger.current_weapon );

	trigger.upgrade_weapon = upgrade_weapon;
	trigger.upgrade_weapon_options = self GetBuildKitWeaponOptions( trigger.upgrade_weapon, zm_weapons::get_pack_a_punch_camo_index() );
	trigger.upgrade_weapon_acvi = self GetBuildKitAttachmentCosmeticVariantIndexes( trigger.upgrade_weapon );

	trigger.zbarrier SetWeapon( trigger.current_weapon );
	trigger.zbarrier SetWeaponOptions( trigger.current_weapon_options );
	trigger.zbarrier SetAttachmentCosmeticVariantIndexes( trigger.current_weapon_acvi );

	trigger.zbarrier set_pap_zbarrier_state( "take_gun" );

	rel_entity = trigger.pap_machine;
	
	origin_offset = (0,0,0);
	angles_offset = (0,0,0);
	origin_base = self.origin;
	angles_base = self.angles;
	
	if( isDefined(rel_entity) )
	{
		origin_offset = (0, 0, level.pack_a_punch.interaction_height);
		angles_offset = (0, 90, 0);
		
		origin_base = rel_entity.origin;
		angles_base = rel_entity.angles;
	}
	else
	{
		rel_entity = self;
	}
	forward = anglesToForward( angles_base+angles_offset );
	interact_offset = origin_offset+(forward*-25);
	
	offsetdw = ( 3, 3, 3 );

	pap_machine [[ level.pack_a_punch.move_in_func ]]( self, trigger, origin_offset, angles_offset );
	
	self playsound( "zmb_perks_packa_upgrade" );
	wait( 0.35 );

	wait( 3 );

	trigger.zbarrier SetWeapon( upgrade_weapon );
	trigger.zbarrier SetWeaponOptions( trigger.upgrade_weapon_options );
	trigger.zbarrier SetAttachmentCosmeticVariantIndexes( trigger.upgrade_weapon_acvi );

	trigger.zbarrier set_pap_zbarrier_state( "eject_gun" );

	if ( IsDefined( self ) )
	{
		self playsound( "zmb_perks_packa_ready" );
	}
	else
	{
		return;		// player disconnected.  Get gone.
	}

	rel_entity thread [[ level.pack_a_punch.move_out_func ]]( self, trigger, origin_offset, interact_offset );
}


function private can_pack_weapon( weapon )
{
	if ( weapon.isriotshield )
	{
		return false;
	}

	if ( level flag::get("pack_machine_in_use") )
	{
		return true;
	}

	weapon = self zm_weapons::get_nonalternate_weapon( weapon );
	if ( !zm_weapons::is_weapon_or_base_included( weapon ) )
	{
		return false;
	}

	if ( !self zm_weapons::can_upgrade_weapon( weapon ) )
	{
		return false;
	}

	return true;
}

function private player_use_can_pack_now()
{
	if ( self laststand::player_is_in_laststand() || ( isdefined( self.intermission ) && self.intermission ) || self isThrowingGrenade() )
	{
		return false;
	}

	if( !self zm_magicbox::can_buy_weapon() )
	{
		return false;
	}

	if( self zm_equipment::hacker_active() )
	{
		return false;
	}

	if ( !self can_pack_weapon( self GetCurrentWeapon() ) )
	{
		return false;
	}

	return true;
}

function private pack_a_punch_machine_trigger_think()
{
	self endon("death");
	self endon("Pack_A_Punch_off");
	
	while(1)
	{
		players = GetPlayers();
		
		for(i = 0; i < players.size; i ++)
		{
			if ( ( IsDefined( self.pack_player ) && self.pack_player != players[i] ) ||
			     !players[i] player_use_can_pack_now() )
			{
				self SetInvisibleToPlayer( players[i], true );
			}
			else
			{
				self SetInvisibleToPlayer( players[i], false );
			}		
		}
		wait(0.1);
	}
}

//
//	Pack-A-Punch Weapon Upgrade
//
function private vending_weapon_upgrade()
{
	level endon("Pack_A_Punch_off");

	pap_machine = GetEnt( self.target, "targetname" );
	self.pap_machine = pap_machine;
	pap_machine_sound = GetEntarray ( "perksacola", "targetname");
	packa_rollers = spawn("script_origin", self.origin);
	packa_timer = spawn("script_origin", self.origin);
	packa_rollers LinkTo( self );
	packa_timer LinkTo( self );

	self UseTriggerRequireLookAt();
	self SetHintString( &"ZOMBIE_NEED_POWER" );
	self SetCursorHint( "HINT_NOICON" );
	
	power_off = !self is_on();

	if ( power_off )
	{
		pap_array = [];
		pap_array[0] = pap_machine;
		level waittill("Pack_A_Punch_on");
	}
	
	self TriggerEnable( true );
	
	if( IsDefined( level.pack_a_punch.power_on_callback ) )
	{
		pap_machine thread [[ level.pack_a_punch.power_on_callback ]]();
	}
	
	self thread pack_a_punch_machine_trigger_think();
	
	//self thread zm_magicbox::decide_hide_show_hint("Pack_A_Punch_off");
	
	pap_machine playloopsound("zmb_perks_packa_loop");
	self thread shutOffPAPSounds( pap_machine, packa_rollers, packa_timer );

	self thread vending_weapon_upgrade_cost();
	
	for( ;; )
	{
		self.pack_player = undefined;
		
		self waittill( "trigger", player );		
				
		index = zm_utility::get_player_index(player);	

		current_weapon = player getCurrentWeapon();

		current_weapon = player zm_weapons::switch_from_alt_weapon( current_weapon );
		
		if( IsDefined( level.pack_a_punch.custom_validation ) )
 		{
 			valid = self [[ level.pack_a_punch.custom_validation ]]( player );
 			if( !valid )
 			{
 				continue;
 			}
 		}
		
		if( !player zm_magicbox::can_buy_weapon() ||
			player laststand::player_is_in_laststand() ||
			( isdefined( player.intermission ) && player.intermission ) ||
			player isThrowingGrenade() ||
			!player zm_weapons::can_upgrade_weapon( current_weapon ) )
		{
			wait( 0.1 );
			continue;
		}

 		if( player isSwitchingWeapons() )
 		{		
			wait( 0.1 );
	 		if( player isSwitchingWeapons() )
	 			continue;
 		}

 		if ( !zm_weapons::is_weapon_or_base_included( current_weapon ) )
 		{
			continue;
 		}

 		current_cost = self.cost;
 		player.restore_ammo = undefined;
 		player.restore_clip = undefined;
 		player.restore_stock = undefined;
		player_restore_clip_size = undefined;
 		player.restore_max = undefined; 
 		
 		upgrade_as_attachment = zm_weapons::will_upgrade_weapon_as_attachment( current_weapon );
 		if (upgrade_as_attachment)
 		{
	 		current_cost = self.attachment_cost;
	 		player.restore_ammo = true;
	 		player.restore_clip = player GetWeaponAmmoClip( current_weapon );
	 		player.restore_clip_size = current_weapon.clipSize;
	 		player.restore_stock = player Getweaponammostock( current_weapon );
	 		player.restore_max = current_weapon.maxAmmo;
 		}

		// If the persistent upgrade "double_points" is active, the cost is halved
		if( player zm_pers_upgrades_functions::is_pers_double_points_active() )
		{
			current_cost = player zm_pers_upgrades_functions::pers_upgrade_double_points_cost( current_cost );
		}
				
		if( player.score < current_cost )
		{
			self playsound("deny");
			if(isDefined(level.pack_a_punch.custom_deny_func))
			{
				player [[level.pack_a_punch.custom_deny_func]]();
			}
			else
			{
				player zm_audio::create_and_play_dialog( "general", "outofmoney", 0 );
			}
			continue;
		}
		
		self.pack_player = player;
		level flag::set("pack_machine_in_use");
		
		demo::bookmark( "zm_player_use_packapunch", gettime(), player );

		//stat tracking
		player zm_stats::increment_client_stat( "use_pap" );
		player zm_stats::increment_player_stat( "use_pap" );
		
		self thread destroy_weapon_in_blackout(player);

		player zm_score::minus_to_player_score( current_cost ); 
//		sound = "evt_bottle_dispense";
//		playsoundatposition(sound, self.origin);
		
		self thread zm_audio::sndPerksJingles_Player(1);
		player zm_audio::create_and_play_dialog( "general", "pap_wait" );
		
		self TriggerEnable( false );
		
		player thread do_knuckle_crack();

		// Remember what weapon we have.  This is needed to check unique weapon counts.
		self.current_weapon = current_weapon;
		
		upgrade_weapon = zm_weapons::get_upgrade_weapon( current_weapon, upgrade_as_attachment );
											
		player third_person_weapon_upgrade( current_weapon, upgrade_weapon, packa_rollers, pap_machine, self );
		
		self TriggerEnable( true );
		self SetCursorHint("HINT_WEAPON", upgrade_weapon);
		self SetHintString( &"ZOMBIE_GET_UPGRADED_FILL" );
		if ( IsDefined( player ) )
		{
			self setinvisibletoall();
			self setvisibletoplayer( player );
		
			self thread wait_for_player_to_take( player, current_weapon, packa_timer, upgrade_as_attachment );
		}
		self thread wait_for_timeout( current_weapon, packa_timer,player );
		
		self util::waittill_any( "pap_timeout", "pap_taken", "pap_player_disconnected" );

		self.zbarrier set_pap_zbarrier_state( "powered" );

		self.current_weapon = level.weaponNone;
		
		self SetCursorHint("HINT_NOICON");
		self zm_pap_util::update_hint_string();
		self setvisibletoall();

		self.pack_player = undefined;
		level flag::clear("pack_machine_in_use");

	}
}

function private shutOffPAPSounds( ent1, ent2, ent3 )
{
	while(1)
	{
		level waittill( "Pack_A_Punch_off" );
		level thread turnOnPAPSounds( ent1 );
		ent1 stoploopsound( .1 );
		ent2 stoploopsound( .1 );
		ent3 stoploopsound( .1 );
	}
}

function private turnOnPAPSounds( ent )
{
	level waittill( "Pack_A_Punch_on" );
	ent playloopsound( "zmb_perks_packa_loop" );
}

function private vending_weapon_upgrade_cost()
{
	level endon("Pack_A_Punch_off");
	while ( 1 )
	{
		self.cost = 5000;
		self.attachment_cost = 2000;
		self zm_pap_util::update_hint_string();

		level waittill( "powerup bonfire sale" );

		self.cost = 1000;
		self.attachment_cost = 1000;
		self zm_pap_util::update_hint_string();

		level waittill( "bonfire_sale_off" );
	}
}


//	
//
function private wait_for_player_to_take( player, weapon, packa_timer, upgrade_as_attachment )
{
	current_weapon = self.current_weapon;
	upgrade_weapon = self.upgrade_weapon;
	Assert( IsDefined( current_weapon ), "wait_for_player_to_take: weapon does not exist" );
	Assert( IsDefined( upgrade_weapon ), "wait_for_player_to_take: upgrade_weapon does not exist" );

	self endon( "pap_timeout" );
	level endon( "Pack_A_Punch_off" );
	while( true )
	{
		packa_timer playloopsound( "zmb_perks_packa_ticktock" );
		self waittill( "trigger", trigger_player );
		if ( level.pack_a_punch.grabbable_by_anyone )
		{
			player = trigger_player;
		}
		
		packa_timer stoploopsound(.05);
		if( trigger_player == player ) 
		{

			player zm_stats::increment_client_stat( "pap_weapon_grabbed" );
			player zm_stats::increment_player_stat( "pap_weapon_grabbed" );

			current_weapon = player GetCurrentWeapon();
/#
if ( level.weaponNone == current_weapon )
{
	iprintlnbold( "WEAPON IS NONE, PACKAPUNCH RETRIEVAL DENIED" );
}
#/
			if( zm_utility::is_player_valid( player ) && 
				!( player.is_drinking > 0 ) && 
				!zm_utility::is_placeable_mine( current_weapon )  && 
				!zm_equipment::is_equipment( current_weapon ) && 
			    !player zm_utility::is_player_revive_tool(current_weapon) && 
				level.weaponNone!= current_weapon  && 
				!player zm_equipment::hacker_active())
			{
				demo::bookmark( "zm_player_grabbed_packapunch", gettime(), player );

				self notify( "pap_taken" );
				player notify( "pap_taken" );
				player.pap_used = true;

				weapon_limit = zm_utility::get_player_weapon_limit( player );

				player zm_weapons::take_fallback_weapon();

				primaries = player GetWeaponsListPrimaries();
				if( isDefined( primaries ) && primaries.size >= weapon_limit )
				{
					player zm_weapons::weapon_give( upgrade_weapon );
				}
				else
				{
					player zm_weapons::give_build_kit_weapon( upgrade_weapon );
					player GiveStartAmmo( upgrade_weapon );
				}

				if ( ( isdefined( level.aat_in_use ) && level.aat_in_use ) )
				{
					player thread aat::acquire( upgrade_weapon );
				}

				player SwitchToWeapon( upgrade_weapon );

				if (( isdefined( player.restore_ammo ) && player.restore_ammo ))
				{
					new_clip = player.restore_clip + ( upgrade_weapon.clipSize - player.restore_clip_size );
					new_stock = player.restore_stock + ( upgrade_weapon.maxAmmo - player.restore_max );
					player SetWeaponAmmoStock( upgrade_weapon, new_stock );
					player SetWeaponAmmoClip( upgrade_weapon, new_clip );
				}
		 		player.restore_ammo = undefined;
		 		player.restore_clip = undefined;
		 		player.restore_stock = undefined;
 				player.restore_max = undefined;
		 		player.restore_clip_size = undefined;
		 		
				player zm_weapons::play_weapon_vo(upgrade_weapon);
				return;
			}
		}
		{wait(.05);};
	}
}


//	Waiting for the weapon to be taken
//
function private wait_for_timeout( weapon, packa_timer,player )
{
	self endon( "pap_taken" );
	self endon( "pap_player_disconnected" );
	
	self thread wait_for_disconnect( player );
	
	wait( level.pack_a_punch.timeout );
	
	self notify( "pap_timeout" );
	packa_timer stoploopsound(.05);
	packa_timer playsound( "zmb_perks_packa_deny" );

	//stat tracking
	if(isDefined(player))
	{
		player zm_stats::increment_client_stat( "pap_weapon_not_grabbed" );
		player zm_stats::increment_player_stat( "pap_weapon_not_grabbed" );
	}
}

function private wait_for_disconnect( player )
{
	self endon( "pap_taken" );
	self endon( "pap_timeout" );
	
	while(isdefined(player))
	{
		wait(0.1);
	}
	
	/#	println("*** PAP : User disconnected."); #/
	
	self notify( "pap_player_disconnected" );
}

function private destroy_weapon_in_blackout( player )
{		
	self endon( "pap_timeout" );
	self endon( "pap_taken" );
	self endon ("pap_player_disconnected" );

	level waittill("Pack_A_Punch_off");

	self.zbarrier set_pap_zbarrier_state( "take_gun" );

	player playlocalsound( level.zmb_laugh_alias );

	wait( 1.5 );

	self.zbarrier set_pap_zbarrier_state( "power_off" );
}



//	Weapon has been inserted, crack knuckles while waiting
//
function private do_knuckle_crack()
{
	self endon("disconnect");
	self upgrade_knuckle_crack_begin();
	
	self util::waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
	
	self upgrade_knuckle_crack_end();
	
}


//	Switch to the knuckles
//
function private upgrade_knuckle_crack_begin()
{
	self zm_utility::increment_is_drinking();
	
	self zm_utility::disable_player_move_states(true);

	primaries = self GetWeaponsListPrimaries();

	original_weapon = self GetCurrentWeapon();
	weapon = GetWeapon( "zombie_knuckle_crack" );
	
	if ( original_weapon != level.weaponNone && !zm_utility::is_placeable_mine( original_weapon ) && !zm_equipment::is_equipment( original_weapon ) )
	{
		self notify( "zmb_lost_knife" );
		self TakeWeapon( original_weapon );
	}
	else
	{
		return;
	}

	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );
}

//	Anim has ended, now switch back to something
//
function private upgrade_knuckle_crack_end()
{
	self zm_utility::enable_player_move_states();
	
	weapon = GetWeapon( "zombie_knuckle_crack" );

	// TODO: race condition?
	if ( self laststand::player_is_in_laststand() || ( isdefined( self.intermission ) && self.intermission ) )
	{
		self TakeWeapon(weapon);
		return;
	}

	self zm_utility::decrement_is_drinking();

	self TakeWeapon(weapon);
	primaries = self GetWeaponsListPrimaries();
	if( ( self.is_drinking > 0 ) )
	{
		return;
	}
	else if( isDefined( primaries ) && primaries.size > 0 )
	{
		self SwitchToWeapon( primaries[0] );
	}
	else if ( self HasWeapon( level.laststandpistol ) )
	{
		self SwitchToWeapon( level.laststandpistol );
	}
	else
	{
		self zm_weapons::give_fallback_weapon();
	}
}

function private get_range( delta, origin, radius )
{
	if (IsDefined(self.target))
	{
		paporigin = self.target.origin; 
		if( ( isdefined( self.target.trigger_off ) && self.target.trigger_off ) )
			paporigin = self.target.realorigin;
		else if( ( isdefined( self.target.disabled ) && self.target.disabled ) )
			paporigin = paporigin + ( 0, 0, 10000 );
	
		if ( DistanceSquared( paporigin, origin ) < radius * radius )
			return true;
	}
	return false;
}

function private turn_on( origin, radius )
{
	/#	println( "^1ZM POWER: PaP on\n" );	#/
	level notify( "Pack_A_Punch_on" );
}

function private turn_off( origin, radius )
{
	/#	println( "^1ZM POWER: PaP off\n" );	#/

	// NOTE: This will cause problems if there is more than one pack-a-punch machine in the level
	level notify( "Pack_A_Punch_off" );
	self.target notify( "death" );
	self.target thread vending_weapon_upgrade();
}

function private is_on() // self == PaP trigger
{
	if (isdefined(self.powered))
		return self.powered.power;
	return false;
}

function private get_start_state()
{
	if ( ( isdefined( level.vending_machines_powered_on_at_start ) && level.vending_machines_powered_on_at_start ) )
	{
		return true;
	}

	return false;
}

function private cost_func()
{
	if (isdefined(self.one_time_cost))
	{
		cost = self.one_time_cost;
		self.one_time_cost=undefined;
		return cost;
	}
	if (( isdefined( level._power_global ) && level._power_global ))
		return 0;
	if (( isdefined( self.self_powered ) && self.self_powered ))
		return 0;
	return 1;
}

function private toggle_think( powered_on )
{
	if ( !powered_on )
	{
		self.zbarrier set_pap_zbarrier_state( "initial" );

		level waittill( "Pack_A_Punch_on" );
	}

	for (;;)
	{
		self.zbarrier set_pap_zbarrier_state( "power_on" );

		level waittill( "Pack_A_Punch_off" );

		self.zbarrier set_pap_zbarrier_state( "power_off" );

		level waittill( "Pack_A_Punch_on" );
	}
}

function private pap_initial()
{
	self ZBarrierPieceUseAttachWeapon( 3 );

	self SetZBarrierPieceState( 0, "closed" );
}

function private pap_power_off()
{
	self SetZBarrierPieceState( 0, "closing" );
}

function private pap_power_on()
{
	self endon( "zbarrier_state_change" );

	self SetZBarrierPieceState( 0, "opening" );
	while ( self GetZBarrierPieceState( 0 ) == "opening" )
	{
		{wait(.05);};
	}

	self playsound( "zmb_perks_power_on" );

	self thread set_pap_zbarrier_state( "powered" );
}

function private pap_powered()
{
	self endon( "zbarrier_state_change" );

	self SetZBarrierPieceState( 4, "closed" );
	
	while ( 1 )
	{
		wait( randomfloatrange( 180, 1800 ) );
		self SetZBarrierPieceState( 4, "opening" );

		wait( randomfloatrange( 180, 1800 ) );
		self SetZBarrierPieceState( 4, "closing" );
	}
}

function private pap_take_gun()
{
	self SetZBarrierPieceState( 1, "opening" );
	self SetZBarrierPieceState( 2, "opening" );
	self SetZBarrierPieceState( 3, "opening" );
}

function private pap_eject_gun()
{
	self SetZBarrierPieceState( 1, "closing" );
	self SetZBarrierPieceState( 2, "closing" );
	self SetZBarrierPieceState( 3, "closing" );
}

function private get_pap_zbarrier_state()
{
	return self.state;
}

function private set_pap_zbarrier_state( state )
{
	for ( i = 0; i < self GetNumZBarrierPieces(); i++ )
	{
		self HideZBarrierPiece( i );
	}

	self notify( "zbarrier_state_change" );
	
	self [[level.pap_zbarrier_state_func]]( state );
}

function private process_pap_zbarrier_state( state )
{
	switch ( state )
	{
		case "initial":
			self ShowZBarrierPiece( 0 );
			self thread pap_initial();
			self.state = "initial";
			break;
		case "power_off":
			self ShowZBarrierPiece( 0 );
			self thread pap_power_off();
			self.state = "power_off";
			break;
		case "power_on":
			self ShowZBarrierPiece( 0 );
			self thread pap_power_on();
			self.state = "power_on";
			break;
		case "powered":
			self ShowZBarrierPiece( 4 );
			self thread pap_powered();
			self.state = "powered";
			break;
		case "take_gun":
			self ShowZBarrierPiece( 1 );
			self ShowZBarrierPiece( 2 );
			self ShowZBarrierPiece( 3 );
			self thread pap_take_gun();
			self.state = "take_gun";
			break;
		case "eject_gun":
			self ShowZBarrierPiece( 1 );
			self ShowZBarrierPiece( 2 );
			self ShowZBarrierPiece( 3 );
			self thread pap_eject_gun();
			self.state = "eject_gun";
			break;
		default:
			if ( IsDefined( level.custom_pap_state_handler ) )
			{
				self [[ level.custom_pap_state_handler ]]( state );
			}
			break;
	}
}

