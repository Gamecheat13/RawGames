#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_buildables;
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
	callback::on_connect( &placement_watcher);
	
	level._equipment_disappear_fx = "_t6/maps/zombie/fx_zmb_tranzit_electrap_explo";
	
	//for the riotshield
	//TODO T7 - move this into riotsheild init
	if( !( isdefined( level.disable_fx_zmb_tranzit_shield_explo ) && level.disable_fx_zmb_tranzit_shield_explo ) )
	{
		level._riotshield_dissapear_fx = "_t6/maps/zombie/fx_zmb_tranzit_shield_explo";
	}

	level.placeable_equipment_destroy_fn=[];
	
	if(!( isdefined( level._no_equipment_activated_clientfield ) && level._no_equipment_activated_clientfield ))
	{
		clientfield::register( "scriptmover", "equipment_activated", 1, 4, "int" );
	}
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

function register( equipment_name, hint, howto_hint, hint_icon, equipmentVO, watcher_thread, transfer_fn, drop_fn, pickup_fn, place_fn )
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
	struct.watcher_thread = watcher_thread;
	struct.transfer_fn = transfer_fn;
	struct.drop_fn = drop_fn;
	struct.pickup_fn = pickup_fn;
	struct.place_fn = place_fn;

	struct.notify_strings = SpawnStruct();
	struct.notify_strings.activate = equipment.name + "_activate";
	struct.notify_strings.deactivate = equipment.name + "_deactivate";
	struct.notify_strings.taken = equipment.name + "_taken";
	struct.notify_strings.pickup = equipment.name + "_pickup";

	level.zombie_equipment[equipment] = struct;
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


function set_ammo_driven( equipment_name, start )
{
	level.zombie_equipment[GetWeapon( equipment_name )].notake = true;
	level.zombie_equipment[GetWeapon( equipment_name )].start_ammo = start;
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
	/*
	if ( curr_weapon_was_curr_equipment )
	{
		// if they just traded in their current weapon, switch them to a primary 
		primaryWeapons = self GetWeaponsListPrimaries();
		if ( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}
	*/

	self set_player_equipment( equipment );
	self GiveWeapon( equipment );
	self start_ammo( equipment );
	//self setWeaponAmmoClip( equipment, 1 );
	self thread show_hint( equipment );
	self set_equipment_invisibility_to_player( equipment, true );
	self setactionslot( 1, "weapon", equipment );
	
	if(IsDefined(level.zombie_equipment[equipment].watcher_thread))
	{
		self thread [[level.zombie_equipment[equipment].watcher_thread]]();
	}

	self thread slot_watcher(equipment);
		
	self zm_audio::create_and_play_dialog( "weapon_pickup", level.zombie_equipment[equipment].vox );
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

		if ( IsDefined( level.zombie_equipment[equipment].watcher_thread ) )
		{		
			if ( curr_weapon == equipment )
			{
				if ( self.current_equipment_active[equipment] )
				{
					self notify( notify_strings.deactivate );
					self.current_equipment_active[equipment] = false;
				}
				else
				{
					self notify( notify_strings.activate );
					self.current_equipment_active[equipment] = true;
				}

				self waittill( "equipment_select_response_done" );
			}
		}
		else
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

function setup_client_hintelem()
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
		self.hintelem init_hint_hudelem(320, 220, "center", "bottom", 1.6, 1.0);
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

function show_hint_text( text, show_for_time = 3.20 )
{
	// T7todo - move this and similar HUD stuff into a separate file 

	self notify("hide_equipment_hint_text");
	{wait(.05);}; 
	self setup_client_hintelem();
	self.hintelem setText(text);
	self.hintelem.alpha = 1;
	self.hintelem.font = "small";
	self.hintelem.fontscale = 1.25;
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
// WATCHER CALLBACKS

// waits for the spawned grenade to settle. When it does the grenade is replaced with a more manageable entity, and a unitrigger
function on_spawn_retrievable_weapon_object( watcher, player ) // self == weapon (for example: the claymore)
{
	equipment = self.weapon;
	self.plant_parent = self;
	isWallMount = ( IsDefined( level.placeable_equipment_type[ equipment ] ) && level.placeable_equipment_type[ equipment ] == "wallmount" );
	
	if( !IsDefined(player.turret_placement) || !player.turret_placement["result"] )
	{
		if ( IsWallmount || !GetDvarInt( "turret_placement_ignores_bodies" ) )
		{
			self waittill("stationary");
			waittillframeend;
			
			// If WallMount...
			if ( isWallMount )
			{
				if ( ( isdefined( player.planted_wallmount_on_a_zombie ) && player.planted_wallmount_on_a_zombie ) )
				{
					thread disappear_fx( self.origin, undefined, self.angles );
					self Delete();
					
					if ( player HasWeapon( equipment ) )
					{
						//player setWeaponAmmoClip( equipment, 1 );
						player change_ammo( equipment, 1 );
					}
					
					player.planted_wallmount_on_a_zombie = undefined;
					
					return;
				}
			}
		}
		else
		{
			self.plant_parent = player;
			self.origin = player.origin;
			self.angles = player.angles;
			util::wait_network_frame();
		}
	}
	
	/#
	if ( !isdefined(player.current_equipment) || player.current_equipment != equipment )
	{
		assert( player has_deployed_equipment(equipment) );
		assert( !isdefined(player.current_equipment) );
	}
	#/
	if ( isdefined(player.current_equipment) && player.current_equipment == equipment )
		player to_deployed(equipment);
	if (isdefined(level.zombie_equipment[equipment].place_fn))
	{
		if( IsDefined(player.turret_placement) && player.turret_placement["result"] )
		{
			plant_origin = player.turret_placement["origin"];
			plant_angles = player.turret_placement["angles"];
		}
		else if ( IsDefined( level.placeable_equipment_type[ equipment ] ) && level.placeable_equipment_type[ equipment ] == "wallmount" )
		{
			plant_origin = self.origin;
			plant_angles = self.angles;
		}
		else 
		{
			plant_origin = self.origin;
			plant_angles = self.angles;
		}
		
		if (isdefined(level.check_force_deploy_origin))
		{
			if ( player [[level.check_force_deploy_origin]]( self, plant_origin, plant_angles ) )
			{
				plant_origin = player.origin;
				plant_angles = player.angles;
				self.plant_parent = player;
			}
		}
		else if (isdefined(level.check_force_deploy_z))
		{
			if ( player [[level.check_force_deploy_z]]( self, plant_origin, plant_angles ) )
			{
				plant_origin = ( plant_origin[0], plant_origin[1], player.origin[2]+10 );
			}
		}
		
		if ( ( isdefined( isWallMount ) && isWallMount ) )
		{
			self Ghost();
		}
		
		replacement = player [[level.zombie_equipment[equipment].place_fn]](plant_origin,plant_angles);
		if (isdefined(replacement))
		{
			replacement.owner = player;
			replacement.original_owner = player;
			replacement.name = self.name;
			replacement.equipment = equipment;

			player notify( "equipment_placed", replacement, equipment );
			if (isdefined(level.equipment_planted))
				player [[level.equipment_planted]](replacement,equipment,self.plant_parent);
			
			//stat tracking
			player zm_buildables::track_buildables_planted(self);
		}
		if (isdefined(self))
			self delete();
	}
}

function retrieve( player ) // self == weapon model (for example: the turbine)
{
	if (isdefined(self))
	{
		self StopLoopSound();
		original_owner = self.original_owner;
		equipment = self.equipment;
		if ( !IsDefined( original_owner ) )
		{
			player give( equipment );
			self.owner = player;
		}
		else
		{
			if ( player != original_owner )
			{
				transfer(equipment,original_owner,player);
				self.owner = player;
			}
		
			player from_deployed(equipment);
		}
		
		if (( isdefined( self.requires_pickup ) && self.requires_pickup ))
		{
			if (isdefined(level.zombie_equipment[equipment].pickup_fn))
			{
				self.owner = player;
				if (isdefined(self.damage))
					player player_set_equipment_damage(equipment,self.damage);
				player [[level.zombie_equipment[equipment].pickup_fn]](self);
			}
		}

		self.playDialog = false;
		self delete();

		if (!player HasWeapon( equipment ))
		{
			player GiveWeapon( equipment );
/*
			clip_ammo = player GetWeaponAmmoClip( equipment );
			clip_max_ammo = equipment.clipSize;

			if( clip_ammo < clip_max_ammo )
			{
				clip_ammo++;
			}
			player setWeaponAmmoClip( equipment, clip_ammo );
*/			
			player start_ammo( equipment );
		}

		//stat tracking 
		player zm_buildables::track_planted_buildables_pickedup( equipment );
	}
}

function drop_to_planted( equipment, player ) // self == weapon (for example: the claymore)
{
	/#
	if ( !isdefined(player.current_equipment) || player.current_equipment != equipment )
	{
		assert( player has_deployed_equipment(equipment) );
		assert( !isdefined(player.current_equipment) );
	}
	#/
	if ( isdefined(player.current_equipment) && player.current_equipment == equipment )
		player to_deployed(equipment);
	if (isdefined(level.zombie_equipment[equipment].place_fn))
	{
		replacement = player [[level.zombie_equipment[equipment].place_fn]](player.origin,player.angles);
		if (isdefined(replacement))
		{
			replacement.owner = player;
			replacement.original_owner = player;
			replacement.name = equipment.name;
			replacement.equipment = equipment;

			if (isdefined(level.equipment_planted))
				player [[level.equipment_planted]](replacement,equipment,player);
			player notify( "equipment_placed", replacement, equipment );
			
			//stat tracking
			player zm_buildables::track_buildables_planted(replacement);
		}
	}
}

//=============================================================================
// DEPLOYABLE EQUIPMENT

function transfer( equipment, fromplayer, toplayer )
{
	if( is_limited(equipment))
	{
		/# println("ZM EQUIPMENT: " + equipment.name + " transferred from " + fromplayer.name + " to " + toplayer.name + "\n"); #/
		toplayer orphaned(equipment);
		{wait(.05);};
		assert(!toplayer has_player_equipment(equipment));
		assert(fromplayer has_player_equipment(equipment));
		toplayer give(equipment);
		toplayer to_deployed(equipment);
		if (isdefined(level.zombie_equipment[equipment].transfer_fn))
		{
			[[level.zombie_equipment[equipment].transfer_fn]](fromplayer,toplayer);
		}
		fromplayer release(equipment);
		assert(toplayer has_player_equipment(equipment));
		assert(!fromplayer has_player_equipment(equipment));
		
		equipment_damage=0;
		toplayer player_set_equipment_damage( equipment, fromplayer player_get_equipment_damage(equipment) );
		fromplayer player_set_equipment_damage( equipment_damage ); 
	}
	else
	{
		/# println("ZM EQUIPMENT: " + equipment.name + " swapped from " + fromplayer.name + " to " + toplayer.name + "\n"); #/
		toplayer give(equipment);
		if ( isdefined(toplayer.current_equipment) && toplayer.current_equipment == equipment )
		{
			toplayer to_deployed(equipment);
		}
		if (isdefined(level.zombie_equipment[equipment].transfer_fn))
		{
			[[level.zombie_equipment[equipment].transfer_fn]](fromplayer,toplayer);
		}
		
		equipment_damage=toplayer player_get_equipment_damage(equipment);
		toplayer player_set_equipment_damage( equipment, fromplayer player_get_equipment_damage(equipment) ) ;
		fromplayer player_set_equipment_damage( equipment, equipment_damage ); 
	}
}

function release(equipment)
{
	/# println("ZM EQUIPMENT: " + self.name + " release " + equipment.name + "\n"); #/
	self take(equipment);
}

function drop(equipment)
{
	if (isdefined(level.zombie_equipment[equipment].place_fn))
	{
		drop_to_planted( equipment, self );
		/# println("ZM EQUIPMENT: " + self.name + " drop to planted " + equipment.name + "\n"); #/
	}
	else
	{
		if (isdefined(level.zombie_equipment[equipment].drop_fn))
		{
			if ( isdefined(self.current_equipment) && self.current_equipment == equipment )
			{
				self to_deployed(equipment);
			}
			item = self [[level.zombie_equipment[equipment].drop_fn]]();
			if (isdefined(item))
			{
				if (isdefined(level.equipment_planted))
				{
					self [[level.equipment_planted]](item,equipment,self);
				}
				item.owner = undefined;
				item.damage = self player_get_equipment_damage(equipment);
			}
			/# println("ZM EQUIPMENT: " + self.name + " dropped " + equipment.name + "\n"); #/
		}
		else
		{
			self take();
		}
	}
	self notify("equipment_dropped",equipment);
}

function grab(equipment,item)
{
	/# println("ZM EQUIPMENT: " + self.name + " picked up " + equipment.name + "\n"); #/
	self give(equipment);
	if (isdefined(level.zombie_equipment[equipment].pickup_fn))
	{
		item.owner = self;
		self player_set_equipment_damage(equipment,item.damage);
		self [[level.zombie_equipment[equipment].pickup_fn]](item);
	}
}

function orphaned(equipment)
{
	// eventually send existing equipment to another player - for now just delete it
	/# println("ZM EQUIPMENT: " + self.name + " orphaned " + equipment.name + "\n"); #/
	self take(equipment);
}

function to_deployed(equipment)
{
	/# println("ZM EQUIPMENT: " + self.name + " deployed " + equipment.name + "\n"); #/
	if (!isdefined(self.deployed_equipment))
	{
		self.deployed_equipment = [];
	}
	assert( self.current_equipment == equipment );
	self.deployed_equipment[self.deployed_equipment.size] = equipment;
	self.current_equipment = undefined;
	if ( equipment != level.weaponRiotshield &&
		 !( isdefined( level.zombie_equipment[equipment].notake ) && level.zombie_equipment[equipment].notake ) )
	{
		self TakeWeapon(equipment);
		self setactionslot( 1, "" );
	}
}

function from_deployed(equipment = level.weaponNone )
{
	/# println("ZM EQUIPMENT: " + self.name + " retrieved " + equipment.name + "\n"); #/
	if ( isdefined(self.current_equipment) && equipment != self.current_equipment )
	{
		self drop(self.current_equipment);
	}
	
	/#
	assert( self has_deployed_equipment(equipment) );
	#/
	
	self.current_equipment = equipment;
	if ( equipment != level.weaponRiotshield )
	{
		self GiveWeapon(equipment);
	}
	if (self HasWeapon(equipment))
	{
		//self setWeaponAmmoClip( equipment, 1 );
		self change_ammo( equipment, 1 );
	}
	self setactionslot( 1, "weapon", equipment );
	ArrayRemoveValue(self.deployed_equipment, equipment);

	notify_strings = get_notify_strings( equipment );
	self notify( notify_strings.pickup );
}


// place the unitrigger a few inches above the origin (or along the up axis) to avoid LOS issues with the ground


function eqstub_get_unitrigger_origin()
{
	if (isdefined(self.origin_parent))
	{
		return self.origin_parent.origin;
	}
	tup = AnglesToUp(self.angles);
	eq_unitrigger_offset = 12 * tup;
	return self.origin + eq_unitrigger_offset;
}

function eqstub_on_spawn_trigger( trigger )
{
	if ( isdefined(self.link_parent))
	{
		trigger EnableLinkTo();
		trigger LinkTo( self.link_parent );
		trigger SetMovingPlatformEnabled( true );
	}
}

function buy(equipment)
{
	if ( IsString(equipment) )
		equipment = GetWeapon( equipment ); 		

	/# println("ZM EQUIPMENT: " + self.name + " bought " + equipment.name + "\n"); #/
	if ( isdefined(self.current_equipment) && equipment != self.current_equipment )
	{
		self drop(self.current_equipment);
	}
	
	if ( equipment == level.weaponRiotshield && isdefined(self.player_shield_reset_health))
	{
		self [[self.player_shield_reset_health]]();
	}
	else
	{
		self player_set_equipment_damage(equipment,0);
	}
	self give( equipment );	
}


//=============================================================================
// UNITRIGGERS

function generate_unitrigger( classname, origin, angles, flags, radius, script_height, hint, equipment, think, moving )
{
	if(!isdefined(radius))
	{
		radius = 64;
	}
	
	if(!isdefined(script_height))
	{
		script_height = 64;
	}
	
	script_width = script_height;
	if(!isdefined(script_width))
	{
		script_width = 64;
	}

	script_length = script_height;
	if(!isdefined(script_length))
	{
		script_length = 64;
	}


	unitrigger_stub = spawnstruct();

	unitrigger_stub.origin = origin;
	if (isdefined(angles))
		unitrigger_stub.angles = angles;

	if(isdefined(script_length))
	{
		unitrigger_stub.script_length = script_length;
	}
	else
	{
		unitrigger_stub.script_length = 13.5;
	}
		
	if(isdefined(script_width))
	{
		unitrigger_stub.script_width = script_width;
	}
	else
	{
		unitrigger_stub.script_width = 27.5;
	}
		
	if(isdefined(script_height))
	{
		unitrigger_stub.script_height = script_height;
	}
	else
	{
		unitrigger_stub.script_height = 24;
	}
		
	unitrigger_stub.radius = radius;

	unitrigger_stub.hint_string = hint;
	unitrigger_stub.cursor_hint = "HINT_WEAPON";
	unitrigger_stub.cursor_hint_weapon = equipment;
		
	unitrigger_stub.script_unitrigger_type  = "unitrigger_box_use";
	unitrigger_stub.require_look_at = false; //true;

	switch(classname)
	{
		case "trigger_radius": 
			unitrigger_stub.script_unitrigger_type  = "unitrigger_radius";
			break;
		case "trigger_radius_use": 
			unitrigger_stub.script_unitrigger_type  = "unitrigger_radius_use";
			break;
		case "trigger_box":
			unitrigger_stub.script_unitrigger_type  = "unitrigger_box";
			break;
		case "trigger_box_use":
			unitrigger_stub.script_unitrigger_type  = "unitrigger_box_use";
			break;
	}

	//zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, true);
	//unitrigger_stub.prompt_and_visibility_func = &piecetrigger_update_prompt;

	unitrigger_stub.originFunc = &eqstub_get_unitrigger_origin;
	unitrigger_stub.onSpawnFunc = &eqstub_on_spawn_trigger;

	if (( isdefined( moving ) && moving ))
		zm_unitrigger::register_unitrigger(unitrigger_stub, think);
	else
		zm_unitrigger::register_static_unitrigger(unitrigger_stub, think);

	return unitrigger_stub;
}

function can_pick_up(equipment, equipment_trigger)
{
	if ( self laststand::player_is_in_laststand() || self zm_utility::in_revive_trigger())
		return false;
	if( self isThrowingGrenade() )
		return false;
	if( self zm_utility::is_jumping() )
		return false;
	if ( self is_player_equipment(equipment) )
		return false;
	if (( isdefined( self.pickup_equipment ) && self.pickup_equipment ))
		return false; 
	if ( ( isdefined( level.equipment_team_pick_up ) && level.equipment_team_pick_up ) && !self same_team_placed_equipment( equipment_trigger ) )
		return false;
	return true;
}

function same_team_placed_equipment( equipment_trigger )
{
	return ( IsDefined( equipment_trigger ) && 
	             IsDefined( equipment_trigger.stub ) &&
	             IsDefined( equipment_trigger.stub.model ) &&
	             IsDefined( equipment_trigger.stub.model.owner ) &&
	             equipment_trigger.stub.model.owner.pers["team"] == self.pers["team"] );
}

function placed_equipment_think( model, equipment, origin, angles, tradius, toffset )
{
	pickupModel = Spawn( "script_model", origin );
	if (isdefined(angles))
		pickupModel.angles = angles;
	pickupModel SetModel( model );
		
	if (isdefined(level.equipment_safe_to_drop))
	{
		if (! self [[level.equipment_safe_to_drop]](pickupModel) )
		{
			disappear_fx( pickupModel.origin, undefined, pickupModel.angles );
			pickupModel delete();
			self take(equipment);
			return undefined;
		}
	}

	watcherName = equipment.name;

	if( IsDefined(level.retrieveHints[watcherName]) )
	{
		hint = level.retrieveHints[watcherName].hint;
	}
	else
	{
		hint = &"MP_GENERIC_PICKUP";
	}
	icon = get_icon( equipment );
	
	if (!isdefined(tradius))
		tradius = 32;

	torigin = origin;
	if (isdefined (toffset))
	{
		tforward = AnglesToForward(angles);
		torigin = torigin + ( toffset * tforward );
	}
	tup = AnglesToUp(angles);
	eq_unitrigger_offset = 12 * tup;
	
	pickupModel.stub = generate_unitrigger( "trigger_radius_use", torigin + eq_unitrigger_offset, angles, 0, tradius, 64, hint, equipment, &placed_equipment_unitrigger_think, ( isdefined( pickupModel.canMove ) && pickupModel.canMove ) );

	pickupModel.stub.model = pickupModel;
	pickupModel.stub.equipment = equipment;
	pickupModel.equipment = equipment;

	pickupModel thread item_attract_zombies();
	//pickupModel thread item_watch_damage();
	pickupModel thread item_watch_explosions();
	
	if( is_limited(equipment)) 
	{
		if (!isdefined(level.dropped_equipment))
			level.dropped_equipment=[];
	
		if (isdefined(level.dropped_equipment[equipment]) && isdefined(level.dropped_equipment[equipment].model) )
		{
			level.dropped_equipment[equipment].model dropped_equipment_destroy(true);
		}
		level.dropped_equipment[equipment] = pickupModel.stub;
	}

	destructible_list_add( pickupModel );
	
	return pickupModel;
}


function watch_player_visibility( equipment )
{
	self endon("kill_trigger");
	
	self SetInvisibleToAll(); // Hide To Everyone On Spawn
	
	while (isdefined(self))
	{
		players = GetPlayers();
		foreach(player in players)
		{
			if (!isdefined(player))
				continue;
			invisible = (!player can_pick_up(equipment, self));
			if (isdefined(self))
				self SetInvisibleToPlayer( player, invisible );
			{wait(.05);};
		}
		wait 1;
	}
}

function placed_equipment_unitrigger_think()
{
	self endon("kill_trigger");

	self thread watch_player_visibility( self.stub.equipment );
	
	while (1)
	{
		self waittill( "trigger", player );
	
		if (!player can_pick_up(self.stub.equipment, self))
			continue;
	
		self thread pickup_placed( player );

		return;
	}
}

function pickup_placed( player )
{
	assert(!( isdefined( player.pickup_equipment ) && player.pickup_equipment ));
	player.pickup_equipment = 1;
	stub = self.stub;
	if ( isdefined(player.current_equipment) && stub.equipment != player.current_equipment )
	{
		player drop(player.current_equipment);
	}
	if( is_limited(stub.equipment)) 
	{
		if ( isdefined(level.dropped_equipment) &&  isdefined(level.dropped_equipment[stub.equipment]) && level.dropped_equipment[stub.equipment] == stub )
		{
			level.dropped_equipment[stub.equipment] = undefined;
		}
	}
	if (isdefined(stub.model))
	{
		stub.model retrieve( player );
	}
	thread zm_unitrigger::unregister_unitrigger(stub);
	wait 3;
	player.pickup_equipment = 0;
}

function dropped_equipment_think( model, equipment, origin, angles, tradius, toffset )
{

	pickupModel = Spawn( "script_model", origin );
	if (isdefined(angles))
		pickupModel.angles = angles;
	pickupModel SetModel( model );

	if (isdefined(level.equipment_safe_to_drop))
	{
		if (! self [[level.equipment_safe_to_drop]](pickupModel) )
		{
			disappear_fx( pickupModel.origin, undefined, pickupModel.angles );
			pickupModel delete();
			self take(equipment);
			return;
		}
	}

	watcherName = equipment.name;

	if( IsDefined(level.retrieveHints[watcherName]) )
	{
		hint = level.retrieveHints[watcherName].hint;
	}
	else
	{
		hint = &"MP_GENERIC_PICKUP";
	}
	icon = get_icon( equipment );
	
	if (!isdefined(tradius))
		tradius = 32;

	torigin = origin;
	if (isdefined (toffset))
	{
		offset = 64;
		tforward = AnglesToForward(angles);
		torigin = torigin + ( toffset * tforward ) + (0,0,8);
	}
	
	pickupModel.stub = generate_unitrigger( "trigger_radius_use", torigin, angles, 0, tradius, 64, hint, equipment, &dropped_equipment_unitrigger_think, ( isdefined( pickupModel.canMove ) && pickupModel.canMove ) );

	pickupModel.stub.model = pickupModel;
	pickupModel.stub.equipment = equipment;
	pickupModel.equipment = equipment;

	if (isdefined(level.equipment_planted))
		self [[level.equipment_planted]](pickupModel,equipment,self);
	
	if (!isdefined(level.dropped_equipment))
		level.dropped_equipment=[];

	if (isdefined(level.dropped_equipment[equipment]))
	{
		level.dropped_equipment[equipment].model dropped_equipment_destroy(true);
	}
	level.dropped_equipment[equipment] = pickupModel.stub;

	destructible_list_add( pickupModel );

	pickupModel thread item_attract_zombies();
	//pickupModel thread item_watch_damage();
	
	return pickupModel;
}

function dropped_equipment_unitrigger_think() //self == trigger
{
	self endon("kill_trigger");

	self thread watch_player_visibility( self.stub.equipment );
	
	while(1)
	{
		self waittill( "trigger", player );
	
		if (!player can_pick_up(self.stub.equipment,self))
			continue;
	
		self thread pickup_dropped( player ); //self == trigger
		return;
	}
}

function pickup_dropped( player ) //self == trigger
{
	player.pickup_equipment = 1;
	stub = self.stub;
	if ( isdefined(player.current_equipment) && stub.equipment != player.current_equipment )
	{
		player drop(player.current_equipment);
	}
	player grab(stub.equipment,stub.model);
	
	stub.model dropped_equipment_destroy();
	
	wait 3;
	player.pickup_equipment = 0;
}

function dropped_equipment_destroy( gusto ) // self == model
{
	stub = self.stub;
	if (( isdefined( gusto ) && gusto ))
	{
		disappear_fx( self.origin, undefined, self.angles );
	}
	if (isdefined(level.dropped_equipment))
		level.dropped_equipment[stub.equipment] = undefined;
	if (isdefined(stub.model))
		stub.model delete();
	if ( isdefined(self.original_owner) && ( is_limited(stub.equipment) || zm_weapons::is_weapon_included( stub.equipment ) ) )
		self.original_owner take(stub.equipment);
		
	thread zm_unitrigger::unregister_unitrigger(stub);
}

//=============================================================================
// EQUIPMENT PLACEMENT

function add_placeable( equipment_name, modelname, destroy_fn, type )
{
	if ( !isdefined(level.placeable_equipment) )
		level.placeable_equipment = [];
	
	equipment = GetWeapon( equipment_name );
	level.placeable_equipment[equipment]=modelname;

	if ( !isdefined(level.placeable_equipment_destroy_fn) )
		level.placeable_equipment_destroy_fn = [];
	level.placeable_equipment_destroy_fn[equipment]=destroy_fn;

	if ( !isdefined(level.placeable_equipment_type) )
		level.placeable_equipment_type = [];
	level.placeable_equipment_type[equipment]=type;
}

function is_placeable( equipment )
{
	if ( isdefined(level.placeable_equipment) &&  isdefined(level.placeable_equipment[equipment]) )
		return true;
	return false;
}

function placement_watcher()
{
	self endon ( "death_or_disconnect" );

	for ( ;; )
	{
		self waittill( "weapon_change", weapon );

		if ( self.sessionstate != "spectator" && is_placeable( weapon ) )
		{
			self thread watch_placement( weapon );
		}
	}
}

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
		return newammo;
	}
	return 0;
}

function watch_update_turret( turret, carry_dist )
{
	self endon( "weapon_change" );
	//self endon( "grenade_fire" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon("destroy_equipment_turret");

	carry_dist = carry_dist + 20;
	
	self.turret_placement=[];
	self.turret_placement["result"]=0;
	
	while( IsDefined(turret) )
	{
		angles = self.angles; 
		forward = AnglesToForward(angles);
		origin = self.origin + carry_dist * forward; 
		turret.origin = origin; 
		turret.angles = angles; 
		self.turret_placement["origin"]=origin;
		self.turret_placement["angles"]=angles;
		self.turret_placement["result"]=1;
		{wait(.05);};
	}
	
}

function watch_placement( equipment )
{
	self.turret_placement = undefined;
	carry_dist = 22;
	carry_angles = (0,0,0);
	if ( ( isdefined( level.zombie_equipment[equipment].notake ) && level.zombie_equipment[equipment].notake ) )
	{
		carry_dist = 64;
	}
	carry_offset = (carry_dist,0,0);
	SetDvar( "turret_placement_trace_dist" , carry_dist + 20.0 );

	placeTurret = spawnTurret( "auto_turret", self.origin, GetWeapon( equipment.name + "_turret" ) );
	placeTurret.angles = self.angles;
	placeTurret SetModel( level.placeable_equipment[equipment] );
	placeTurret setTurretCarried( true );
	placeTurret SetTurretOwner( self );
	placeTurret MakeTurretUnusable();
	if (IsDefined(level.placeable_equipment_type[equipment]))
		placeTurret SetTurretType( level.placeable_equipment_type[equipment] );
	//self CarryTurret(placeTurret, carry_offset, carry_angles);
	
	self thread watch_update_turret( placeTurret, carry_dist );
	
//placeTurret Linkto( self, "tag_origin", carry_offset, carry_angles );
	// 100774 - Zombies - ZM_Tranzit - Player may hold out any buildable in front of them and not take damage from zombies directly in front of the player. 
	if (isdefined(level.use_swipe_protection))
		self thread watch_melee_swipes(equipment,placeTurret);
	self notify("create_equipment_turret",equipment,placeTurret);

	if ( ( isdefined( level.zombie_equipment[equipment].notake ) && level.zombie_equipment[equipment].notake ) )
	{
		ammo = 1;
		do {
			ended = self util::waittill_any_return( "weapon_change", "grenade_fire", "death_or_disconnect" );
			//self.turret_placement = self canPlayerPlaceTurret();
			change = 0;
			if (ended == "weapon_change")
			{
				change = 1;
			}
			ammo = change_ammo( equipment, change );
		}
		while ( ended == "grenade_fire" && ammo > 0 );
	}
	else
	{
		ended = self util::waittill_any_return( "weapon_change", "grenade_fire", "death_or_disconnect" );
		//self.turret_placement = self canPlayerPlaceTurret();
		if (ended == "weapon_change")
		{
			self.turret_placement = undefined;
			if (self HasWeapon(equipment))
				self setWeaponAmmoClip( equipment, 1 );
		}
	}

	self notify("destroy_equipment_turret",equipment,placeTurret);
	//self stopCarryTurret(placeTurret); 
	placeTurret setTurretCarried( false );
	
	placeTurret delete();
}

function watch_melee_swipes(equipment,turret)
{
	self endon( "weapon_change" );
	self endon( "grenade_fire" );
	self endon( "death" );
	self endon( "disconnect" );
	
	while(1)
	{
		self waittill("melee_swipe", zombie);
		if (distancesquared(zombie.origin,self.origin) > zombie.meleeattackdist*zombie.meleeattackdist )
			continue; // just flailing at nothing
		tpos = turret.origin;
		tangles = turret.angles;
		self player_damage_equipment( equipment, 200, zombie.origin ); 
		if ( self.equipment_damage[equipment] >= 1500 )
		{
			thread disappear_fx( tpos, undefined, tangles );
			primaryWeapons = self GetWeaponsListPrimaries(); 
			if (isdefined(primaryWeapons[0]))
				self SwitchToWeapon( primaryWeapons[0] );
			if( IsAlive( self ) )
			{
				self playlocalsound( level.zmb_laugh_alias );
			}
			self zm_stats::increment_client_stat( "cheat_total",false );
			self release(equipment);
			return;
		}
	}
}



//=============================================================================
// EQUIPMENT_DAMAGE


function player_get_equipment_damage( equipment ) 
{
	if (isdefined(self.equipment_damage) && isdefined(self.equipment_damage[equipment])) 
		return self.equipment_damage[equipment]; 
	return 0;
}

function player_set_equipment_damage( equipment, damage ) 
{
	if (!isdefined(self.equipment_damage))
		self.equipment_damage=[];
	self.equipment_damage[equipment]=damage; 
}


function player_damage_equipment( equipment, damage, origin ) 
{
	if (!isdefined(self.equipment_damage))
		self.equipment_damage=[];
	if (!isdefined(self.equipment_damage[equipment])) 
		self.equipment_damage[equipment]=0; 
	self.equipment_damage[equipment]+=damage; 
	if ( self.equipment_damage[equipment] > 1500 )
	{
		if ( isdefined( level.placeable_equipment_destroy_fn[equipment] ) )
		{
			self [[level.placeable_equipment_destroy_fn[equipment]]]();
		}
		else
			disappear_fx( origin );
		if ( !( isdefined( level.zombie_equipment[equipment].notake ) && level.zombie_equipment[equipment].notake ) )
		{
			self release(equipment);
		}
	}
}


function item_damage( damage )
{
	if (( isdefined( self.isRiotShield ) && self.isRiotShield ))
	{
		if (isdefined(level.riotshield_damage_callback) && isdefined(self.owner) )
		{
			self.owner [[level.riotshield_damage_callback]]( damage, false );
		}
		else if (isdefined(level.deployed_riotshield_damage_callback) )
		{
			self [[level.deployed_riotshield_damage_callback]]( damage );
		}
	}
	else if (isdefined(self.owner))
	{
		self.owner player_damage_equipment( self.equipment, damage, self.origin ); 
	}
	else
	{
		if ( !isdefined( self.damage ) )
		{
			self.damage = 0;
		}
		self.damage += damage;
		if ( self.damage > 1500 )
			self thread dropped_equipment_destroy(true);
	}
}

function item_watch_damage()
{
	self endon( "death" );
	self SetCanDamage(1); 
	self.health = 1500;
	while( 1 )
	{
		self waittill("damage",amount);
		self item_damage( amount );
	}
}

function item_watch_explosions()
{
	self endon( "death" );
	while( 1 )
	{
		level waittill("grenade_exploded",position,radius,idamage,odamage);
 		wait (randomfloatrange(0.05, 0.3));
		distsqrd = DistanceSquared( self.origin, position );
		if ( distsqrd < radius * radius )
		{
			dist = sqrt( distsqrd );
			dist = dist / radius;
			damage = odamage + ((idamage - odamage) * ( 1-dist ));
			self item_damage( damage * 5 );
		}
	}
}


/#

function get_item_health()
{
	damage = 0;
	if (( isdefined( self.isRiotShield ) && self.isRiotShield ))
	{
		damageMax = level.zombie_vars["riotshield_hit_points"]; 
		if (isdefined(self.owner) )
		{
			damage = self.owner.shieldDamageTaken;
		}
		else if (isdefined(level.deployed_riotshield_damage_callback) )
		{
			damage = self.shieldDamageTaken;
		}
	}
	else if (isdefined(self.owner))
	{
		damageMax = 1500; 
		damage = self.owner player_get_equipment_damage( self.equipment ); 
	}
	else
	{
		damageMax = 1500; 
		if (isdefined(self.damage))
			damage = self.damage; 
	}
	return (damageMax - damage) / damageMax;
}
	
	
function debugHealth()
{
	self endon( "death" );
	self endon( "stop_attracting_zombies" );
	while( 1 )
	{
		if ( GetDvarInt( "zombie_equipment_health") )
		{
			health = self get_item_health();
			
			color = (1-health,health,0);
			
			text = "" + health*100 + "";
			print3d(self.origin, text, color, 1, 0.5, 1);
		}
		{wait(.05);};
	}
}
#/


function item_choke()
{
	if (!isdefined(level.item_choke_count))
		level.item_choke_count=0;
	level.item_choke_count++;

	if ( !(level.item_choke_count >= 10 ) )
	{
		{wait(.05);};
		level.item_choke_count = 0;
	}
}

function is_ignored( equipment )
{
	if (isdefined(level.equipment_ignored_by_zombies) && isdefined(level.equipment_ignored_by_zombies[equipment]) )
		return true;
	return false;
}
	
function enemies_ignore( equipment )
{
	if (!isdefined(level.equipment_ignored_by_zombies))
		level.equipment_ignored_by_zombies = [];
	level.equipment_ignored_by_zombies[equipment]=equipment;
}
	
function item_attract_zombies()
{
	self endon( "death" );
	self notify( "stop_attracting_zombies" );
	self endon( "stop_attracting_zombies" );
	/#
	self thread debugHealth();
	#/
	if ( is_ignored( self.equipment ) )
		return;
	while( 1 )
	{
		if (IsDefined(level.vert_equipment_attack_range))
			vDistMax = level.vert_equipment_attack_range;
		else
			vDistMax = 36;
		if (IsDefined(level.max_equipment_attack_range))
			distMax = level.max_equipment_attack_range * level.max_equipment_attack_range;
		else
			distMax = 64 * 64;
		if (IsDefined(level.min_equipment_attack_range))
			distMin = level.min_equipment_attack_range * level.min_equipment_attack_range;
		else
			distMin = 45 * 45;
		ai = GetAiTeamArray( level.zombie_team );
		for( i = 0; i < ai.size; i++ )
		{
			if (!isdefined(ai[i]))
			    continue;

			if( ( isdefined( ai[i].ignore_equipment ) && ai[i].ignore_equipment ) )
			{
				continue;
			}
			
			if ( isdefined( level.ignore_equipment ) )
			{
				if ( self [[ level.ignore_equipment ]]( ai[i] ) )
				{
					continue;
				}
			}

			if( ( isdefined( ai[i].is_inert ) && ai[i].is_inert ) )
			{
				continue;
			}
			
			if( ( isdefined( ai[i].is_traversing ) && ai[i].is_traversing ) )
			{
				continue;
			}
			
			vdist = abs( ai[i].origin[2] - self.origin[2] );
			distsqrd = Distance2DSquared( ai[i].origin, self.origin );

			// increase height delta for riotshield
			if ( isdefined( self.equipment ) && self.equipment == level.weaponRiotshield )
			{
				vDistMax = 108;
			}

			should_attack = false;
			if ( isdefined( level.should_attack_equipment ) )
			{
				should_attack = self [[ level.should_attack_equipment ]]( distsqrd );
			}

			if( ( distsqrd < distMax && distsqrd > distMin && vdist < vDistMax ) || should_attack )
			{
				if( !( isdefined( ai[i].isscreecher ) && ai[i].isscreecher ) && !ai[i] zm_utility::is_quad() && !ai[i] zm_utility::is_leaper() )
				{
					ai[i] thread attack_item(self);
					item_choke();
				}
			}
			item_choke();
		}

		wait( 0.1 );
	}
}

function attack_item(item)
{
	self endon ("death"); 
	item endon ("death"); 
	self endon ("start_inert");
	if ( ( isdefined( self.doing_equipment_attack ) && self.doing_equipment_attack ) )
	{
		return false;
	}

	if ( ( isdefined( self.not_interruptable ) && self.not_interruptable ) )
	{
		return false;
	}
	
	self thread attack_item_stop( item );
	self thread attack_item_interrupt( item );

	if(GetDvarString( "zombie_equipment_attack_freq") == "")
	{
		SetDvar("zombie_equipment_attack_freq","15");
	}
	freq = GetDvarInt( "zombie_equipment_attack_freq");
	
	// still very placeholder - based on the board reach-through anim

	//if( freq >= randomint(100) )
	{
		self.doing_equipment_attack = 1;
		self zm_spawner::zombie_history( "doing equipment attack 1 - " + GetTime() );
		//self.enemyoverride[0] = item.origin;
		//self.enemyoverride[1] = item;
		//wait ( randomint(25) / 100.0 );
		self.attack_item = item;

		if (!isDefined(self) || !isAlive(self))
			return;
		
		if (isdefined(item.zombie_attack_callback))
			item [[item.zombie_attack_callback]]( self );
		
		self notify( "bhtn_action_notify", "attack" );

		if ( isdefined( level.attack_item ) )
		{
			self [[ level.attack_item ]]();
		}

		melee_anim = "zm_window_melee";
		if ( self.missingLegs )
		{
			melee_anim = "zm_walk_melee_crawl";
			if ( self.a.gib_ref == "no_legs" )
			{
				melee_anim = "zm_stumpy_melee";
			}
			else
			{
				if ( self.zombie_move_speed == "run" || self.zombie_move_speed == "sprint" )
				{
					melee_anim = "zm_run_melee_crawl";
				}
			}
		}
						
		//self OrientMode( "face point",  item.origin );
		//self AnimScripted( self.origin, zm_utility::flat_angle( VectorToAngles( item.origin - self.origin ) ), melee_anim );
		//self window_notetracks( "window_melee_anim", item );

		self notify( "item_attack" );
		
		if( IsDefined( self.custom_item_dmg ) )
		{
			item thread item_damage( self.custom_item_dmg );
		}
		else
		{
			item thread item_damage( 100 );
		}
		item playsound( "fly_riotshield_zm_impact_flesh" );
		
		//if ( IsDefined( item ) && IsDefined( item.owner ) && IsDefined( item.owner.equipment_damage ) && IsDefined( item.equipment ) && ( item.owner.equipment_damage[ item.equipment ] + 100 > 1000 ) )
		//{
		//}
		
		wait ( randomint(100) / 100.0 );
		self.doing_equipment_attack = 0;
		self zm_spawner::zombie_history( "doing equipment attack 0 from wait - " + GetTime() );
		
		self OrientMode( "face default" );
	}

}

function attack_item_interrupt( item )
{
	if ( self.missingLegs ) // Already A Crawler
	{
		return;
	}
	
	self notify( "attack_item_interrupt" );
	self endon( "attack_item_interrupt" );
	
	self endon( "death" );
	
	while ( !self.missingLegs ) // Wait Until Made A Crawler
	{
		self waittill( "damage" );
	}
	
	self StopAnimScripted();
	self.doing_equipment_attack = 0;
	self zm_spawner::zombie_history( "doing equipment attack 0 from death - " + GetTime() );
	self.attack_item = undefined;
}

function attack_item_stop( item )
{
	self notify( "attack_item_stop" );
	self endon( "attack_item_stop" );
	
	self endon( "death" );
	
	item waittill( "death" );
	
	self StopAnimScripted();
	self.doing_equipment_attack = 0;
	self zm_spawner::zombie_history( "doing equipment attack 0 from death - " + GetTime() );
	self.attack_item = undefined;

	if ( isdefined( level.attack_item_stop ) )
	{
		self [[ level.attack_item_stop ]]();
	}
}

function window_notetracks(msg, equipment)
{
	self endon("death");
	equipment endon("death");

	while(self.doing_equipment_attack)
	{
		self waittill( msg, notetrack );

		if( notetrack == "end" )
		{
			return;
		}
		if( notetrack == "fire" )
		{
			equipment item_damage( 100 );
		}
	}
}

function destructible_list_check()
{
	if (!isdefined(level.destructible_equipment))
		level.destructible_equipment=[];

	i=0; 
	while( i<level.destructible_equipment.size )
	{
		if (!isdefined(level.destructible_equipment[i]))
		{
			ArrayRemoveIndex(level.destructible_equipment,i);
		}
		else
		{
			i++;
		}
	}
}

function destructible_list_add( item )
{
	destructible_list_check();
	level.destructible_equipment[level.destructible_equipment.size] = item;
}

function get_destructible_list()
{
	destructible_list_check();
	return level.destructible_equipment;
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
