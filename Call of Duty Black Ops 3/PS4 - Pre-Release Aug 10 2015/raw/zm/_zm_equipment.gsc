#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                             
                                                                                                                               



#precache( "fx", "_t6/maps/zombie/fx_zmb_tranzit_electrap_explo" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_tranzit_shield_explo" );

#namespace zm_equipment;

function autoexec __init__sytem__() {     system::register("zm_equipment",&__init__,undefined,undefined);    }

function __init__()
{
	level.buildable_piece_count = 24;
		
	init_upgrade();
	
	level._equipment_disappear_fx = "_t6/maps/zombie/fx_zmb_tranzit_electrap_explo";
	
	level.placeable_equipment_destroy_fn=[];
	
	if(!( isdefined( level._no_equipment_activated_clientfield ) && level._no_equipment_activated_clientfield ))
	{
		clientfield::register( "scriptmover", "equipment_activated", 1, 4, "int" );
	}
	
	/#
		level thread run_equipment_devgui();
	#/
}

function signal_activated(val = 1)
{
	if(( isdefined( level._no_equipment_activated_clientfield ) && level._no_equipment_activated_clientfield ))
	{
		return;
	}
	
	self endon("death");
	self clientfield::set("equipment_activated", val);
	
	for(i = 0; i < 2; i ++)
	{
		util::wait_network_frame();
	}
	
	self clientfield::set("equipment_activated", 0);
}

function register( equipment_name, hint, howto_hint, hint_icon, equipmentVO)
{
	equipment = GetWeapon( equipment_name );

	struct = SpawnStruct();

	if ( !IsDefined( level.zombie_equipment ) )
	{
		level.zombie_equipment = [];
	}

	struct.equipment = equipment;
	struct.hint = hint;
	struct.howto_hint = howto_hint;
	struct.hint_icon = hint_icon;
	struct.vox = equipmentVO;
	struct.triggers = [];
	struct.models = [];

	struct.notify_strings = SpawnStruct();
	struct.notify_strings.activate = equipment.name + "_activate";
	struct.notify_strings.deactivate = equipment.name + "_deactivate";
	struct.notify_strings.taken = equipment.name + "_taken";
	struct.notify_strings.pickup = equipment.name + "_pickup";

	level.zombie_equipment[equipment] = struct;
	
	/#
		level thread add_devgui_equipment( equipment );
	#/
}


function is_included( equipment )
{
	if ( !IsDefined( level.zombie_include_equipment ) )
	{
		return false;
	}

	if ( IsString(equipment) )
	{
		equipment = GetWeapon( equipment ); 		
	}

	return IsDefined( level.zombie_include_equipment[equipment.rootWeapon] );
}


function include( equipment_name )
{
	if ( !IsDefined( level.zombie_include_equipment ) )
	{
		level.zombie_include_equipment = [];
	}

	level.zombie_include_equipment[GetWeapon( equipment_name )] = true;
}


function set_ammo_driven( equipment_name, start, refill_max_ammo = false )
{
	level.zombie_equipment[GetWeapon( equipment_name )].notake = true;
	level.zombie_equipment[GetWeapon( equipment_name )].start_ammo = start;
	level.zombie_equipment[GetWeapon( equipment_name )].refill_max_ammo = refill_max_ammo;
}


function limit( equipment_name, limited )
{
	if (!isdefined(level._limited_equipment))
	{
		level._limited_equipment = [];
	}

	if (limited)
	{
		level._limited_equipment[level._limited_equipment.size] = GetWeapon( equipment_name );
	}
	else
	{
		ArrayRemoveValue( level._limited_equipment, GetWeapon( equipment_name ), false );
	}
}


function init_upgrade()
{
	equipment_spawns = [];
	equipment_spawns = GetEntArray( "zombie_equipment_upgrade", "targetname" );

	for( i = 0; i < equipment_spawns.size; i++ )
	{
		equipment_spawns[i].equipment = GetWeapon( equipment_spawns[i].zombie_equipment_upgrade );

		hint_string = get_hint( equipment_spawns[i].equipment );
		equipment_spawns[i] SetHintString( hint_string );
		equipment_spawns[i] setCursorHint( "HINT_NOICON" );
		equipment_spawns[i] UseTriggerRequireLookAt();
		equipment_spawns[i] add_to_trigger_list( equipment_spawns[i].equipment );
		equipment_spawns[i] thread equipment_spawn_think();
	}
}


function get_hint( equipment )
{
	Assert( IsDefined( level.zombie_equipment[equipment] ), equipment.name + " was not included or is not registered with the equipment system." );

	return level.zombie_equipment[equipment].hint;
}


function get_howto_hint( equipment )
{
	Assert( IsDefined( level.zombie_equipment[equipment] ), equipment.name + " was not included or is not registered with the equipment system." );

	return level.zombie_equipment[equipment].howto_hint;
}

function get_icon( equipment )
{
	Assert( IsDefined( level.zombie_equipment[equipment] ), equipment.name + " was not included or is not registered with the equipment system." );

	return level.zombie_equipment[equipment].hint_icon;
}

function get_notify_strings( equipment )
{
	Assert( IsDefined( level.zombie_equipment[equipment] ), equipment.name + " was not included or is not registered with the equipment system." );

	return level.zombie_equipment[equipment].notify_strings;
}


function add_to_trigger_list( equipment )
{
	Assert( IsDefined( level.zombie_equipment[equipment] ), equipment.name + " was not included or is not registered with the equipment system." );

	level.zombie_equipment[equipment].triggers[level.zombie_equipment[equipment].triggers.size] = self;

	// also need to add the model to the models list
	level.zombie_equipment[equipment].models[level.zombie_equipment[equipment].models.size] = GetEnt( self.target, "targetname" );
}


function equipment_spawn_think()
{
	for ( ;; )
	{
		self waittill( "trigger", player );

		if ( player zm_utility::in_revive_trigger() || ( player.is_drinking > 0 ) )
		{
			wait( 0.1 );
			continue;
		}
		
		if( is_limited(self.equipment)) //only one player can have limited equipment at a time
		{			
			player setup_limited(self.equipment);
			
			//move the equpiment respawn to a new location
			if(isDefined(level.hacker_tool_positions))
			{
				new_pos = array::random(level.hacker_tool_positions);
				self.origin = new_pos.trigger_org;
				model = getent(self.target,"targetname");
				model.origin = new_pos.model_org;
				model.angles = new_pos.model_ang;				
			}
			
		}		
		
		player give( self.equipment );
	}
}

function set_equipment_invisibility_to_player( equipment, invisible )
{
	triggers = level.zombie_equipment[equipment].triggers;
	for ( i = 0; i < triggers.size; i++ )
	{
		if(isDefined(triggers[i]))
		{
			triggers[i] SetInvisibleToPlayer( self, invisible );
		}
	}

	models = level.zombie_equipment[equipment].models;
	for ( i = 0; i < models.size; i++ )
	{
		if(isDefined(models[i]))
		{
			models[i] SetInvisibleToPlayer( self, invisible );
		}
	}
}

function take( equipment )
{
	if ( !isdefined( equipment ) )
	{
		equipment = self zm_equipment::get_player_equipment();
	}
	if ( !isdefined( equipment ) )
	{
		return;
	}
	if ( equipment == level.weaponNone )
	{
		return;
	}
	if ( !self has_player_equipment( equipment ) )
	{
		return;
	}
	current = false;
	current_weapon = false;
	if ( isdefined(self zm_equipment::get_player_equipment()) && equipment == self zm_equipment::get_player_equipment() )
	{
		current = true;
	}
	if ( equipment == self GetCurrentWeapon() )
	{
		current_weapon = true;
	}
	
	/# println("ZM EQUIPMENT: " + self.name + " lost " + equipment.name + "\n"); #/


	notify_strings = get_notify_strings( equipment );
	if(( isdefined( self.current_equipment_active[equipment] ) && self.current_equipment_active[equipment] ))
	{
		self.current_equipment_active[equipment] = false;
		self notify( notify_strings.deactivate );
	}

	self notify( notify_strings.taken );

	self TakeWeapon( equipment );
	
	if( (!is_limited(equipment) ) || (is_limited(equipment) && !limited_in_use(equipment) )) 
	{
		self set_equipment_invisibility_to_player( equipment, false );
	}
	if (current)
	{
		self set_player_equipment( level.weaponNone );
		self setactionslot( 1, "" );
	}
	else
	{
		ArrayRemoveValue(self.deployed_equipment, equipment);
	}

	if ( current_weapon )
	{
		// if they just lost their current weapon, switch them to a primary 
		primaryWeapons = self GetWeaponsListPrimaries();
		if ( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}
}

function give( equipment )
{
	if( !IsDefined(equipment) )
	{
		return;
	}

	if (!isdefined(level.zombie_equipment[equipment]))
	{
		return;
	}
	
	// skip all this if they already have it
	if( self has_player_equipment(equipment) )
	{
		return;
	}

	/# println("ZM EQUIPMENT: " + self.name + " got " + equipment.name + "\n"); #/
	curr_weapon = self GetCurrentWeapon();
	curr_weapon_was_curr_equipment = self is_player_equipment( curr_weapon );
	self take();

	self set_player_equipment( equipment );
	self GiveWeapon( equipment );
	self start_ammo( equipment );
	self thread show_hint( equipment );
	self set_equipment_invisibility_to_player( equipment, true );
	self setactionslot( 1, "weapon", equipment );

	self thread slot_watcher(equipment);
		
	self zm_audio::create_and_play_dialog( "weapon_pickup", level.zombie_equipment[equipment].vox );
}

function buy(equipment)
{
	if ( IsString(equipment) )
		equipment = GetWeapon( equipment ); 		

	/# println("ZM EQUIPMENT: " + self.name + " bought " + equipment.name + "\n"); #/
	if ( isdefined(self.current_equipment) && equipment != self.current_equipment && self.current_equipment != level.weaponNone )
	{
		self take(self.current_equipment);
	}
	
	if ( equipment.isriotshield && isdefined(self.player_shield_reset_health))
	{
		self [[self.player_shield_reset_health]]();
	}
	self give( equipment );	
}

function slot_watcher(equipment)
{
	self notify("kill_equipment_slot_watcher");
	self endon("kill_equipment_slot_watcher");
	self endon("disconnect");

	notify_strings = get_notify_strings( equipment );
	while(1)
	{
		self waittill( "weapon_change", curr_weapon, prev_weapon );

		self.prev_weapon_before_equipment_change = undefined;
		if ( isdefined( prev_weapon ) && level.weaponNone != prev_weapon )
		{
			prev_weapon_type = prev_weapon.inventoryType;
			if ( "primary" == prev_weapon_type || "altmode" == prev_weapon_type )
			{
				self.prev_weapon_before_equipment_change = prev_weapon;
			}
		}

		{
			if ( curr_weapon == equipment && !self.current_equipment_active[equipment] )
			{
				self notify( notify_strings.activate );
				self.current_equipment_active[equipment] = true;
			}
			else if ( curr_weapon != equipment && self.current_equipment_active[equipment] )
			{
				self notify( notify_strings.deactivate );
				self.current_equipment_active[equipment] = false;
			}
		}		
	}
}

function is_limited(equipment)
{
	if(isDefined(level._limited_equipment))
	{
		for(i=0;i<level._limited_equipment.size;i++)
		{
			if(level._limited_equipment[i] == equipment)
			{
				return true;
			}
		}

	}	
	return false;
}

function limited_in_use(equipment)
{
	players = GetPlayers();
	for(i=0;i<players.size;i++)
	{
		current_equipment = players[i] zm_equipment::get_player_equipment();
		if(isDefined(current_equipment) && current_equipment == equipment)
		{
			return true;
		}
	}
	
	if ( isdefined(level.dropped_equipment) && isdefined(level.dropped_equipment[equipment]))
	{
		return true;
	}

	return false;
}

function setup_limited(equipment)
{
	players = GetPlayers();
	for(i=0;i<players.size;i++)
	{
		players[i] set_equipment_invisibility_to_player( equipment, true );
	}
		
	self thread release_limited_on_disconnect(equipment);
	self thread release_limited_on_taken(equipment);
}

function release_limited_on_taken(equipment)
{
	self endon("disconnect");

	notify_strings = get_notify_strings( equipment );
	self util::waittill_either( notify_strings.taken, "spawned_spectator" );
	
	players = GetPlayers();
	for(i=0;i<players.size;i++)
	{

		players[i] set_equipment_invisibility_to_player( equipment, false );
	}	
}

function release_limited_on_disconnect(equipment)
{
	notify_strings = get_notify_strings( equipment );
	self endon( notify_strings.taken );
	
	self waittill("disconnect");
	
	players = GetPlayers();
	for(i=0;i<players.size;i++)
	{
		if(isAlive(players[i]))
		{
			players[i] set_equipment_invisibility_to_player( equipment, false );
		}
	}	
}

function is_active(equipment)
{
	if(!IsDefined(self.current_equipment_active) || !IsDefined(self.current_equipment_active[equipment]))
	{
		return false;
	}
	
	return(self.current_equipment_active[equipment]);
}

function init_hint_hudelem(x, y, alignX, alignY, fontscale, alpha)
{
	self.x = x;
	self.y = y;
	self.alignX = alignX;
	self.alignY = alignY;
	self.fontScale = fontScale;
	self.alpha = alpha;
	self.sort = 20;
	//self.font = "objective";
}

function setup_client_hintelem( ypos = 220 )
{
	self endon("death");
	self endon("disconnect");

	if(!isDefined(self.hintelem))
	{
		self.hintelem = newclienthudelem(self);
	}

	if( level.splitscreen )
	{
		self.hintelem init_hint_hudelem( 160, 90, "center", "middle", 1.6, 1.0 );
	}
	else
	{
		self.hintelem init_hint_hudelem(320, ypos, "center", "bottom", 1.6, 1.0);
	}
}

function show_hint( equipment )
{
	self notify("kill_previous_show_equipment_hint_thread");
	self endon("kill_previous_show_equipment_hint_thread");
	self endon("death");
	self endon("disconnect");
	
	if ( ( isdefined( self.do_not_display_equipment_pickup_hint ) && self.do_not_display_equipment_pickup_hint ) )
	{
		return;
	}
	
	wait(.5);
	
	text = get_howto_hint( equipment );
	self show_hint_text( text );
}

function show_hint_text( text, show_for_time = 3.20, font_scale = 1.25, ypos = 220  )
{
	// T7todo - move this and similar HUD stuff into a separate file 

	self notify("hide_equipment_hint_text");
	{wait(.05);}; 
	self setup_client_hintelem( ypos );
	self.hintelem setText(text);
	self.hintelem.alpha = 1;
	self.hintelem.font = "small";
	self.hintelem.fontscale = font_scale;
	self.hintelem.hidewheninmenu = true;
	time = self util::waittill_any_timeout(show_for_time, "hide_equipment_hint_text", "death", "disconnect" );
	if (isdefined(time) && IsDefined(self) && IsDefined(self.hintelem) )
	{
		self.hintelem FadeOverTime( 0.25 );
		self.hintelem.alpha = 0;
		self util::waittill_any_timeout(0.25, "hide_equipment_hint_text" );
	}
	if ( IsDefined(self) && IsDefined(self.hintelem) )
	{
		self.hintelem settext("");
		self.hintelem destroy();
	}
}



//=============================================================================
// AMMO

function start_ammo( equipment )
{
	if (self HasWeapon(equipment))
	{
		maxammo = 1; 
		if ( ( isdefined( level.zombie_equipment[equipment].notake ) && level.zombie_equipment[equipment].notake ) )
		{
			maxammo = level.zombie_equipment[equipment].start_ammo;
		}
		self setWeaponAmmoClip( equipment, maxammo );
		self notify("equipment_ammo_changed", equipment); 
		return maxammo;
	}
	return 0;
}


function change_ammo( equipment, change )
{
	if (self HasWeapon(equipment))
	{
		oldammo = self getWeaponAmmoClip( equipment );
		maxammo = 1; 
		if ( ( isdefined( level.zombie_equipment[equipment].notake ) && level.zombie_equipment[equipment].notake ) )
		{
			maxammo = level.zombie_equipment[equipment].start_ammo;
		}
		newammo = int( min(maxammo, max(0, oldammo + change ) ) );
		self setWeaponAmmoClip( equipment, newammo );
		self notify("equipment_ammo_changed", equipment); 
		return newammo;
	}
	return 0;
}

//=============================================================================
// FX

function disappear_fx( origin, fx, angles )
{
	effect = level._equipment_disappear_fx;
	if(isDefined(fx))
	{
		effect = fx;
	}
	
	if ( IsDefined( angles ) )
	{
		PlayFX( effect, origin, AnglesToForward( angles ) );
	}
	else
	{
		PlayFX( effect, origin );
	}
	wait 1.1;
}

//==============================================================================
function register_for_level( weaponname )
{
	weapon = GetWeapon( weaponname );
	if ( is_equipment( weapon ) )
	{
		return;
	}

	if ( !isdefined( level.zombie_equipment_list ) )
	{
		level.zombie_equipment_list = [];
	}

	level.zombie_equipment_list[weapon] = weapon;
}

function is_equipment( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( level.zombie_equipment_list ) )
	{
		return false;
	}

	return isdefined(level.zombie_equipment_list[weapon]);
}

function is_equipment_that_blocks_purchase( weapon )
{
	return is_equipment(weapon);
}

function is_player_equipment( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( self.current_equipment ) )
	{
		return false;
	}

	return self.current_equipment == weapon;
}

function has_deployed_equipment( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( self.deployed_equipment ) || self.deployed_equipment.size < 1 )
	{
		return false;
	}

	for ( i = 0; i < self.deployed_equipment.size; i++ )
	{
		if ( self.deployed_equipment[i] == weapon )
			return true;
	}
	return false;
}

function has_player_equipment( weapon )
{
	return ( self is_player_equipment( weapon ) || self has_deployed_equipment( weapon ) );
}

function get_player_equipment()
{
	equipment = level.weaponNone;
	
	if(IsDefined(self.current_equipment))
	{
		equipment = self.current_equipment;
	}
	
	return equipment;
}

function hacker_active()
{
	return(self is_active( GetWeapon( "equip_hacker" ) ));
}

function set_player_equipment( weapon )
{
	if(!IsDefined(self.current_equipment_active))
	{
		self.current_equipment_active = [];
	}
	
	if(IsDefined(weapon))
	{
		self.current_equipment_active[weapon] = false;
	}
	
	if(!IsDefined(self.equipment_got_in_round))
	{
		self.equipment_got_in_round = [];
	}
	
	if(IsDefined(weapon))
	{
		self.equipment_got_in_round[weapon] = level.round_number;
	}

	self notify( "new_equipment", weapon );
	self.current_equipment = weapon;
}

function init_player_equipment()
{
	self set_player_equipment( level.zombie_equipment_player_init );
}

//=============================================================================
// DEVGUI

/#

function run_equipment_devgui()
{
	SetDvar( "give_equipment", "" );

	{wait(.05);};
	level flag::wait_till( "start_zombie_round_logic" );
	{wait(.05);};

	str_cmd = "devgui_cmd \"ZM/Equipment/Take All:0\" \"set give_equipment " + "take" + "\"\n";
	AddDebugCommand( str_cmd );
	
	
	while ( true )
	{
		equipment_id = GetDvarString( "give_equipment" );

		if ( equipment_id != "" )
		{
			foreach ( player in GetPlayers() )
			{
				if ( equipment_id == "take" )
				{
					player take();
				}
				else if ( is_included( equipment_id ) )
				{
					player buy( equipment_id );
				}
			}

			SetDvar( "give_equipment", "" );
		}

		wait 0.05;
	}
}

#/

/#
function add_devgui_equipment( equipment )
{
	{wait(.05);};
	level flag::wait_till( "start_zombie_round_logic" );
	{wait(.05);};

	if ( isdefined( equipment ) )
	{
		equipment_id = equipment.name; 
		
		str_cmd = "devgui_cmd \"ZM/Equipment/" + equipment_id + "/Give:0\" \"set give_equipment " + equipment_id + "\"\n";
		AddDebugCommand( str_cmd );
	}
	
}
#/
	










