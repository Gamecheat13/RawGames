    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_weapons;

#using scripts\mp\_util;
#using scripts\mp\gametypes\_weaponobjects;

                   

#namespace pickup_items;

function autoexec __init__sytem__() {     system::register("pickup_items",&__init__,undefined,undefined);    }





// group 1 - blue
#precache( "xmodel", "p7_perk_t7_hud_perk_flakjacket" );
#precache( "xmodel", "p7_perk_t7_hud_perk_blind_eye" );
#precache( "xmodel", "p7_perk_t7_hud_perk_hardline" );
#precache( "xmodel", "p7_perk_t7_hud_perk_ghost" );
#precache( "xmodel", "p7_perk_t7_hud_perk_jetsilencer" );
#precache( "xmodel", "p7_perk_t7_hud_perk_lightweight" );
#precache( "xmodel", "p7_perk_t7_hud_perk_jetcharge" );
#precache( "xmodel", "p7_perk_t7_hud_perk_overcharge" );

// group 2 - green
#precache( "xmodel", "p7_perk_t7_hud_perk_hardwired" );
#precache( "xmodel", "p7_perk_t7_hud_perk_scavenger" );
#precache( "xmodel", "p7_perk_t7_hud_perk_cold_blooded" );
#precache( "xmodel", "p7_perk_t7_hud_perk_fasthands" );
#precache( "xmodel", "p7_perk_t7_hud_perk_toughness" );
#precache( "xmodel", "p7_perk_t7_hud_perk_tracker" );
#precache( "xmodel", "p7_perk_t7_hud_perk_ante_up" );

// group 3 - red
#precache( "xmodel", "p7_perk_t7_hud_perk_dexterity" );
#precache( "xmodel", "p7_perk_t7_hud_perk_engineer" );
#precache( "xmodel", "p7_perk_t7_hud_perk_deadsilence" );
#precache( "xmodel", "p7_perk_t7_hud_perk_tacticalmask" );
#precache( "xmodel", "p7_perk_t7_hud_perk_awareness" );
#precache( "xmodel", "p7_perk_t7_hud_perk_sixthsense" );
#precache( "xmodel", "p7_perk_t7_hud_perk_marathon" );
#precache( "xmodel", "p7_perk_t7_hud_perk_gungho" );

#precache( "objective", "pickup_item" );

function __init__()
{
	callback::on_start_gametype( &start_gametype );
	
	level.pickup_items = [];
	
	level.pickupItemRespawn = true;
}

function on_player_spawned() // self == player
{
	self.pickup_damage_scale = undefined;
	self.pickup_damage_scale_time = undefined;
}

function start_gametype()
{
	callback::on_spawned( &on_player_spawned );

	pickup_triggers = GetEntArray( "pickup_item", "targetname" );
	pickup_models = GetEntArray( "pickup_model", "targetname" );

	visuals = [];
	
	foreach( trigger in pickup_triggers )
	{
		visuals[0] = get_visual_for_trigger( trigger, pickup_models );
		assert( isDefined( visuals[0]) );
		
		visuals[0] pickup_item_init();
		
		pickup_item_object = gameobjects::create_use_object( "neutral", trigger, visuals, (0,0,32), istring("pickup_item") );
		pickup_item_object gameobjects::allow_use( "any" );
		pickup_item_object gameobjects::set_use_time( 0 );
		pickup_item_object.onUse = &on_touch;
		
		
		level.pickup_items[level.pickup_items.size] = pickup_item_object;
	}
}

function get_visual_for_trigger( trigger, pickup_models )
{
	foreach( model in pickup_models )
	{
		if ( model istouchingswept( trigger ) )
			return model;
	}
	
	return undefined;
}

function set_pickup_bobbing()
{
	self Bobbing( (0,0,1), 4, 1 );
}

function set_pickup_rotation()
{
	self Rotate( (0,175,0) );
}

function get_item_for_pickup()
{
	if( self.items.size == 1 )
	{
		return self.items[0];
	}
	
	if ( self.items_shuffle.size == 0 )
	{
		self.items_shuffle = ArrayCopy( self.items );
		array::randomize( self.items_shuffle );
	}
	
	return array::pop_front( self.items_shuffle );
}

function cycle_item()
{
	self.current_item = self get_item_for_pickup();
		
	if ( isdefined( self.current_item.model ) )
	{
		self SetModel( self.current_item.model );
	}
}

function get_item_from_string_ammo(perks_string)
{
	item_struct = SpawnStruct();

	item_struct.name = "ammo";
	item_struct.weapon = GetWeapon( "scavenger_item" );
	item_struct.model = item_struct.weapon.worldmodel;
	self.angles = ( 0, 0, 90 );
	
	self thread weapons::scavenger_think();
	
	return item_struct;
}

function get_item_from_string_damage(perks_string)
{
	item_struct = SpawnStruct();

	item_struct.name = "damage";
	item_struct.damage_scale = float(perks_string);
	item_struct.model = "wpn_t7_igc_bullet_prop";
	self.angles = ( -45, 0, 0 );
	self SetScale ( 2 );

	return item_struct;
}

function get_item_from_string_health(perks_string)
{
	item_struct = SpawnStruct();

	item_struct.name = "health";
	item_struct.extra_health = int(perks_string);
	item_struct.model = "p7_medical_surgical_tools_syringe";
	self.angles = ( -45, 0, 45 );
	self SetScale ( 5 );

	return item_struct;
}

function get_item_from_string_perk(perks_string)
{
	item_struct = SpawnStruct();

	if ( !IsDefined(level.perkSpecialties[ perks_string ]) )
	{
		/#
		util::error("Invalid perk name " + perks_string + " for pick up item at " + self.origin);
		#/
		return;		
	}
	
	item_struct.name = perks_string;
	item_struct.specialties = StrTok( level.perkSpecialties[ perks_string ], "|" );
	item_struct.model = "p7_perk_" + level.perkIcons[ perks_string ];
	self SetScale ( 2 );

	return item_struct;
}

function get_item_from_string_weapon(weapon_and_attachments_string)
{
	item_struct = SpawnStruct();
	
	weapon_and_attachments = strtok(weapon_and_attachments_string, "+");
	weapon_name = GetSubStr(weapon_and_attachments[0],0,weapon_and_attachments[0].size);
	
	attachments = array::remove_index( weapon_and_attachments, 0 );
	
	item_struct.name = weapon_name;
	item_struct.weapon = GetWeapon( weapon_name, attachments );
	item_struct.model = item_struct.weapon.worldmodel;
	self SetScale ( 1.5 );
	
	return item_struct;
}

function get_item_from_string( item_string )
{
	switch( self.script_noteworthy )
	{
		case "ammo":
			return self get_item_from_string_ammo( item_string );
		case "damage":
			return self get_item_from_string_damage( item_string );
		case "health":
			return self get_item_from_string_health( item_string );
		case "perk":
			return self get_item_from_string_perk( item_string );
		case "weapon":
			return self get_item_from_string_weapon( item_string );
		}
}

function init_items_for_pickup()
{
	items_string = self.script_parameters;
	
	items_array = strtok(items_string, " ");
	
	items = [];
	
	foreach( item_string in items_array )
	{
		items[items.size] = self get_item_from_string( item_string );
	}
	
	return items;
}

function pickup_item_respawn_time()
{
	switch( self.script_noteworthy )
	{
		case "ammo":
			return 10;
		case "damage":
			return 30;
		case "health":
			return 10;
		case "perk":
			return 10;
		case "weapon":
			return 15;
		}
}

function pickup_item_sound_pickup()
{
	switch( self.script_noteworthy )
	{
		case "ammo":
			return "wpn_ammo_pickup";
		case "damage":
			return "wpn_weap_pickup";
		case "health":
			return "wpn_weap_pickup";
		case "perk":
			return "wpn_weap_pickup";
		case "weapon":
			return "wpn_weap_pickup";
		}
}

function pickup_item_sound_respawn()
{
	switch( self.script_noteworthy )
	{
		case "ammo":
			return "wpn_ammo_pickup";
		case "damage":
			return "wpn_weap_pickup";
		case "health":
			return "wpn_weap_pickup";
		case "perk":
			return "wpn_weap_pickup";
		case "weapon":
			return "wpn_weap_pickup";
		}
}

function pickup_item_init()
{
	self.items_shuffle = [];
	
	// start the bobbing before calling the init functions so we can change the orientation of
	// the models on items without affecting the bob
	self set_pickup_bobbing();

	self.items = self init_items_for_pickup();
	self.respawn_time = self pickup_item_respawn_time();
	self.sound_pickup = self pickup_item_sound_pickup();
	self.sound_respawn = self pickup_item_sound_respawn();
	
	self set_pickup_rotation();
	self cycle_item();
}

function on_touch( player )
{
	pickup_item = self.visuals[0];
	switch( pickup_item.script_noteworthy )
	{
		case "ammo":
			pickup_item on_touch_ammo( player );
		break;
		case "damage":
			pickup_item on_touch_damage( player );
		break;
		case "health":
			pickup_item on_touch_health( player );
		break;
		case "perk":
			pickup_item on_touch_perk( player );
		break;
		case "weapon":
			pickup_item on_touch_weapon( player );
		break;
	}
	
	pickup_item PlaySound( pickup_item.sound_pickup );
	
	self gameobjects::set_model_visibility( false );
	self gameobjects::allow_use( "none" );

	if ( level.pickupItemRespawn )
	{
		wait ( pickup_item.respawn_time );
	
		pickup_item PlaySound( pickup_item.sound_respawn );
	
		pickup_item cycle_item();

		self gameobjects::set_model_visibility( true );
		self gameobjects::allow_use( "any" );
	}
}


function on_touch_ammo( player )
{
	self notify( "scavenger", player );
	player PickupAmmoEvent();
}

function on_touch_damage( player )
{
	damage_scale_length = 15 * 1000;
	player.pickup_damage_scale = self.current_item.damage_scale;
	player.pickup_damage_scale_time = GetTime() + damage_scale_length;
}

function on_touch_health( player )
{
	if ( self.current_item.extra_health <= 100 )
	{
		health = player.health + self.current_item.extra_health;
	
		if ( health > 100 )
			health = 100;
	}
	else
	{
		health = self.current_item.extra_health;
	}	
	
	player.health = health;
}

function on_touch_perk( player )
{
	foreach( specialty in self.current_item.specialties )
	{
		player setPerk( specialty );
	}
}

function take_player_gadgets()
{
		weapons = self GetWeaponsList( true );
		foreach ( weapon in weapons )
		{
			if ( weapon.isgadget )
			{
				self TakeWeapon(weapon);
			}
		}
}

function should_switch_to_pickup_weapon( weapon )
{
	if ( weapon.isgadget )
		return false;
	
	if ( weapon.isgrenadeweapon )
		return false;
		
	return true;
}

function on_touch_weapon( player )
{
	weapon = self.current_item.weapon;
	had_weapon = player HasWeapon( weapon );
	
	player PickupWeaponEvent(weapon);
	
//	ammo_in_clip = GetWeaponAmmoClip( weapon );
	ammo_in_reserve = player GetWeaponAmmoStock( weapon );
	
	if ( !had_weapon && weapon.isgadget && weapon.isheroweapon )
	{
		// need to take away what they currently have
		player take_player_gadgets();
	}
	
	player GiveWeapon( weapon );
	
	// if for some reason we did not get the weapon drop out
	if ( !player HasWeapon( weapon ) )
		return;
	
	if ( isDefined(self.script_ammo_clip) && isDefined(self.script_ammo_extra) )
	{
		// if they already have the weapon put everything into the reserve
		if ( had_weapon )
		{
			player SetWeaponAmmoStock( weapon, ammo_in_reserve + self.script_ammo_clip + self.script_ammo_extra );
		}
		else
		{
			if ( self.script_ammo_clip >= 0 )
			{
				player SetWeaponAmmoClip( weapon, self.script_ammo_clip );
			}	
			if ( self.script_ammo_extra >= 0 )
			{
				player SetWeaponAmmoStock( weapon, self.script_ammo_extra );
			}	
		}
	}
	
	if ( weapon.isgadget )
	{
		slot = player GadgetGetSlot( weapon );
		player GadgetPowerSet( slot, 100.0 );
	}
	
	if ( !had_weapon && should_switch_to_pickup_weapon( weapon ) )
	{
		player SwitchToWeapon(weapon);
	}
}
