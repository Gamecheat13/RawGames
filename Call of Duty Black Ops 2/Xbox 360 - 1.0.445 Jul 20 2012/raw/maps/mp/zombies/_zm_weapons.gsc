#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_magicbox; 

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\mp\zombies\_zm_utility.gsh;


init()
{
/#	PrintLn( "ZM >> init (_zm_weapons.gsc)" );	#/

	init_weapons();
	init_weapon_upgrade();			//Wall buys
	init_weapon_toggle();
	init_pay_turret();
	init_weapon_cabinet();

	PreCacheShader( "minimap_icon_mystery_box" );
	PrecacheShader( "specialty_instakill_zombies" );
	PrecacheShader( "specialty_firesale_zombies" );
	PrecacheItem("zombie_fists_zm");
	
	level._weaponobjects_on_player_connect_override = ::weaponobjects_on_player_connect_override;

	level._zombiemode_check_firesale_loc_valid_func = ::default_check_firesale_loc_valid_func;

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self thread watchForGrenadeDuds();
	}
}

watchForGrenadeDuds()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	
	while(1)
	{
		self waittill( "grenade_fire", grenade, weapname );
		grenade thread checkGrenadeForDud(weapname, true, self);
	}
}



grenade_safe_to_throw(player,weapname) 
{
	if ( IsDefined(level.grenade_safe_to_throw) )
	{
		return self [[level.grenade_safe_to_throw]](player,weapname);
	}
	return true;
}

grenade_safe_to_bounce(player,weapname) 
{
	if ( IsDefined(level.grenade_safe_to_bounce) )
	{
		return self [[level.grenade_safe_to_bounce]](player,weapname);
	}
	return true;
}


checkGrenadeForDud( weapname, isThrownGrenade, player )
{
	self endon("death");

	if (!self grenade_safe_to_throw(player,weapname) )
	{
		self makeGrenadeDud();
		return;
	}
	for(;;)
	{
		self waittill( "grenade_bounce" );
		if (!self grenade_safe_to_bounce(player,weapname) )
		{
			self makeGrenadeDud();
			return;
		}
	}
}



give_fallback_weapon()
{
	self GiveWeapon("zombie_fists_zm");
	self SwitchToWeapon("zombie_fists_zm");
}

take_fallback_weapon()
{
	if ( self HasWeapon("zombie_fists_zm") )
		self TakeWeapon("zombie_fists_zm");
}


add_retrievable_knife_init_name( name )
{
	if ( !isdefined( level.retrievable_knife_init_names ) )
	{
		level.retrievable_knife_init_names = [];
	}

	level.retrievable_knife_init_names[level.retrievable_knife_init_names.size] = name;
}

weaponobjects_on_player_connect_override_internal()
{
	self maps\mp\gametypes\_weaponobjects::createBaseWatchers();

	//Ensure that the watcher name is the weapon name minus _mp if you want to add weapon specific functionality.
	self createClaymoreWatcher_zm();

	for ( i = 0; i < level.retrievable_knife_init_names.size; i++ )
	{
		self createBallisticKnifeWatcher_zm( level.retrievable_knife_init_names[i], level.retrievable_knife_init_names[i] + "_zm" );
	}

	//set up retrievable specific fields
	self maps\mp\gametypes\_weaponobjects::setupRetrievableWatcher();
	
	if ( !IsDefined(self.weaponObjectWatcherArray) )
	{
		self.weaponObjectWatcherArray = [];
	}

	self thread maps\mp\gametypes\_weaponobjects::watchWeaponObjectSpawn();
	self thread maps\mp\gametypes\_weaponobjects::watchWeaponProjectileObjectSpawn();
	self thread maps\mp\gametypes\_weaponobjects::deleteWeaponObjectsOn();

	self.concussionEndTime = 0;
	self.hasDoneCombat = false;
	self.lastFireTime = 0;
	self thread maps\mp\gametypes\_weapons::watchWeaponUsage();
	self thread maps\mp\gametypes\_weapons::watchGrenadeUsage();
	self thread maps\mp\gametypes\_weapons::watchMissileUsage();
	self thread maps\mp\gametypes\_weapons::watchWeaponChange();
	self thread maps\mp\gametypes\_weapons::watchTurretUse();
}

weaponobjects_on_player_connect_override()
{
	add_retrievable_knife_init_name( "knife_ballistic" );
	add_retrievable_knife_init_name( "knife_ballistic_upgraded" );

	OnPlayerConnect_Callback(::weaponobjects_on_player_connect_override_internal);
}


createClaymoreWatcher_zm() // self == player
{
	watcher = self maps\mp\gametypes\_weaponobjects::createProximityWeaponObjectWatcher( "claymore", "claymore_zm", self.team );
	maps\mp\gametypes\_weaponobjects::createRetrievableHint("claymore", &"WEAPON_CLAYMORE_PICKUP");
	watcher.pickup = level.pickup_claymores;
	watcher.pickup_trigger_listener = level.pickup_claymores_trigger_listener;
	watcher.skip_weapon_object_damage = true;
	watcher.headIcon = false;
	watcher.watchForFire = true;
}

createBallisticKnifeWatcher_zm( name, weapon ) // self == player
{
	watcher = self maps\mp\gametypes\_weaponobjects::createUseWeaponObjectWatcher( name, weapon, self.team );
	watcher.onSpawn = maps\mp\zombies\_zm_weap_ballistic_knife::on_spawn;
	watcher.onSpawnRetrieveTriggers = maps\mp\zombies\_zm_weap_ballistic_knife::on_spawn_retrieve_trigger;
	watcher.storeDifferentObject = true;
	watcher.headIcon = false;
}

default_check_firesale_loc_valid_func()
{
	return true;
}

add_zombie_weapon( weapon_name, upgrade_name, hint, cost, weaponVO, weaponVOresp, ammo_cost )
{
	if( IsDefined( level.zombie_include_weapons ) && !IsDefined( level.zombie_include_weapons[weapon_name] ) )
	{
		return;
	}
	
	// Check the table first
	table = "mp/zombiemode.csv";
	table_cost = TableLookUp( table, 0, weapon_name, 1 );
	table_ammo_cost = TableLookUp( table, 0, weapon_name, 2 );

	if( IsDefined( table_cost ) && table_cost != "" )
	{
		cost = round_up_to_ten( int( table_cost ) );
	}

	if( IsDefined( table_ammo_cost ) && table_ammo_cost != "" )
	{
		ammo_cost = round_up_to_ten( int( table_ammo_cost ) );
	}

	PrecacheString( hint );

	struct = SpawnStruct();

	if( !IsDefined( level.zombie_weapons ) )
	{
		level.zombie_weapons = [];
	}

	struct.weapon_name = weapon_name;
	struct.upgrade_name = upgrade_name;
	struct.weapon_classname = "weapon_" + weapon_name;
	struct.hint = hint;
	struct.cost = cost;
	struct.vox = weaponVO;
	struct.vox_response = weaponVOresp;
	
/#	println( "ZM >> Looking for weapon - " + weapon_name );	#/
	
	struct.is_in_box = level.zombie_include_weapons[weapon_name];

	if( !IsDefined( ammo_cost ) )
	{
		ammo_cost = round_up_to_ten( int( cost * 0.5 ) );
	}

	struct.ammo_cost = ammo_cost;

	level.zombie_weapons[weapon_name] = struct;
}

default_weighting_func()
{
	return 1;
}

default_tesla_weighting_func()
{
	num_to_add = 1;
	if( isDefined( level.pulls_since_last_tesla_gun ) )
	{
		// player has dropped the tesla for another weapon, so we set all future polls to 20%
		if( isDefined(level.player_drops_tesla_gun) && level.player_drops_tesla_gun == true )
		{						
			num_to_add += int(.2 * level.zombie_include_weapons.size);		
		}
		
		// player has not seen tesla gun in late rounds
		if( !isDefined(level.player_seen_tesla_gun) || level.player_seen_tesla_gun == false )
		{
			// after round 10 the Tesla gun percentage increases to 20%
			if( level.round_number > 10 )
			{
				num_to_add += int(.2 * level.zombie_include_weapons.size);
			}		
			// after round 5 the Tesla gun percentage increases to 15%
			else if( level.round_number > 5 )
			{
				// calculate the number of times we have to add it to the array to get the desired percent
				num_to_add += int(.15 * level.zombie_include_weapons.size);
			}						
		}
	}
	return num_to_add;
}


//
//	For weapons which should only appear once the box moves
default_1st_move_weighting_func()
{
	if( level.chest_moves > 0 )
	{	
		num_to_add = 1;

		return num_to_add;	
	}
	else
	{
		return 0;
	}
}


//
//	Default weighting for a high-level weapon that is too good for the normal box
default_upgrade_weapon_weighting_func()
{
	if ( level.chest_moves > 1 )
	{
		return 1;
	}
	else
	{
		return 0;
	}
}


//
//	Slightly elevate the chance to get it until someone has it, then make it even
default_cymbal_monkey_weighting_func()
{
	players = GET_PLAYERS();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] has_weapon_or_upgrade( "zombie_cymbal_monkey" ) )
		{
			count++;
		}
	}
	if ( count > 0 )
	{
		return 1;
	}
	else
	{
		if( level.round_number < 10 )
		{
			return 3;
		}
		else
		{
			return 5;
		}
	}
}


is_weapon_included( weapon_name )
{
	if( !IsDefined( level.zombie_weapons ) )
	{
		return false;
	}

	return IsDefined( level.zombie_weapons[weapon_name] );
}


include_zombie_weapon( weapon_name, in_box, collector, weighting_func )
{
	if( !IsDefined( level.zombie_include_weapons ) )
	{
		level.zombie_include_weapons = [];
		level.collector_achievement_weapons = [];
	}
	if( !isDefined( in_box ) )
	{
		in_box = true;
	}
	if( isDefined( collector ) && collector )
	{
		ARRAY_ADD( level.collector_achievement_weapons, weapon_name );
	}

/#	println( "ZM >> Including weapon - " + weapon_name );	#/
	level.zombie_include_weapons[weapon_name] = in_box;

	PrecacheItem( weapon_name );

	if( !isDefined( weighting_func ) )
	{
		level.weapon_weighting_funcs[weapon_name] = ::default_weighting_func;
	}
	else
	{
		level.weapon_weighting_funcs[weapon_name] = weighting_func;
	}
}


//
//Z2 add_zombie_weapon will call PrecacheItem on the weapon name.  So this means we're loading 
//		the model even if we're not using it?  This could save some memory if we change this.
init_weapons()
{
	if ( IsDefined( level._zombie_custom_add_weapons ) )
	{
		[[level._zombie_custom_add_weapons]]();
	}

	Precachemodel( "zombie_teddybear" );
}   

add_limited_weapon( weapon_name, amount )
{
	if( !IsDefined( level.limited_weapons ) )
	{
		level.limited_weapons = [];
	}

	level.limited_weapons[weapon_name] = amount;
}                                          	

// For pay turrets
init_pay_turret()
{
	pay_turrets = [];
	pay_turrets = GetEntArray( "pay_turret", "targetname" );
	
	for( i = 0; i < pay_turrets.size; i++ )
	{
		cost = level.pay_turret_cost;
		if( !isDefined( cost ) )
		{
			cost = 1000;
		}
		pay_turrets[i] SetHintString( &"ZOMBIE_PAY_TURRET", cost );
		pay_turrets[i] SetCursorHint( "HINT_NOICON" );
		pay_turrets[i] UseTriggerRequireLookAt();
		
		pay_turrets[i] thread pay_turret_think( cost );
	}
}

/*debug_spot()
{
	while(1)
	{
		print3d(self.origin, "+", (1,0,0), 1, 1, 1);
		wait(0.1);
	}
}*/

init_spawnable_weapon_upgrade()
{
 
	// spawn_list construction must be matched in _zm_weapons.csc function init() or your level will not load.
	
	spawn_list = [];
	spawnable_weapon_spawns = GetStructArray( "weapon_upgrade", "targetname");
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, GetStructArray( "bowie_upgrade", "targetname" ), true, false);
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, GetStructArray( "sickle_upgrade", "targetname" ), true, false);
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, GetStructArray( "tazer_upgrade", "targetname" ), true, false);
	spawnable_weapon_spawns = ArrayCombine(spawnable_weapon_spawns, GetStructArray( "claymore_purchase", "targetname" ), true, false);

	match_string = "";
	
	location = level.scr_zm_map_start_location;
	if ((location == "default" || location == "" ) && IsDefined(level.default_start_location))
	{
		location = level.default_start_location;
	}	

	match_string = level.scr_zm_ui_gametype + "_" + location;
	match_string_plus_space = " " + match_string;

	for(i = 0; i < spawnable_weapon_spawns.size; i ++)
	{
		spawnable_weapon = spawnable_weapon_spawns[i];
		
		if(!isdefined(spawnable_weapon.script_noteworthy) || spawnable_weapon.script_noteworthy == "")
		{
			spawn_list[spawn_list.size] = spawnable_weapon;
		}
		else
		{
			matches  = strTok( spawnable_weapon.script_noteworthy, "," );
			
			for(j = 0; j < matches.size; j ++)
			{
				if((matches[j] == match_string) || (matches[j] == match_string_plus_space ))
				{
					spawn_list[spawn_list.size] = spawnable_weapon;
				}
			}
			
		}
	}
		
	for(i = 0; i < spawn_list.size; i ++)
	{
		// Spawn a trigger based off of spawn_list[i].

/*		use_trigger = Spawn( "trigger_box_use", spawn_list[i].origin, 0, 27.5, 13.5, 64);

		use_trigger.angles = spawn_list[i].angles;
		use_trigger.target = spawn_list[i].target;
		use_trigger.targetname = spawn_list[i].targetname;
		use_trigger.zombie_weapon_upgrade = spawn_list[i].zombie_weapon_upgrade;
		use_trigger TriggerIgnoreTeam();
		
		use_trigger SetCursorHint( "HINT_NOICON" );		*/
		
		clientFieldName = spawn_list[i].zombie_weapon_upgrade + "_" + spawn_list[i].origin;  // Name has origin appended, in case there are more than one of the same weapon placed.
		
		RegisterClientField("world", clientFieldName, 2, "int"); // 2 bit int client field - bit 1 : 0 = not bought 1 = bought.  bit 2: 0 = not hacked 1 = hacked.

		target_struct = getstruct(spawn_list[i].target, "targetname");
		
		precachemodel(target_struct.model);
		
		unitrigger_stub = spawnstruct();
		unitrigger_stub.origin = spawn_list[i].origin;
		unitrigger_stub.angles = spawn_list[i].angles;
		if(isdefined(spawn_list[i].script_length))
		{
			unitrigger_stub.script_length = spawn_list[i].script_length;
		}
		else
		{
			unitrigger_stub.script_length = 13.5;
		}
		
		if(isdefined(spawn_list[i].script_width))
		{
			unitrigger_stub.script_width = spawn_list[i].script_width;
		}
		else
		{
			unitrigger_stub.script_width = 27.5;
		}
		
		if(isdefined(spawn_list[i].script_height))
		{
			unitrigger_stub.script_height = spawn_list[i].script_height;
		}
		else
		{
			unitrigger_stub.script_height = 24;
		}
		
		unitrigger_stub.target = spawn_list[i].target;
		unitrigger_stub.targetname = spawn_list[i].targetname;
		
		unitrigger_stub.cursor_hint = "HINT_NOICON";
		
		if(spawn_list[i].targetname == "weapon_upgrade")
		{
			unitrigger_stub.hint_string = get_weapon_hint( spawn_list[i].zombie_weapon_upgrade ); 
			unitrigger_stub.cost = get_weapon_cost( spawn_list[i].zombie_weapon_upgrade );
		}
		
		unitrigger_stub.weapon_upgrade = spawn_list[i].zombie_weapon_upgrade;
			
		unitrigger_stub.script_uintrigger_type = "unitrigger_box_use";
		unitrigger_stub.require_look_at = true;
		unitrigger_stub.zombie_weapon_upgrade = spawn_list[i].zombie_weapon_upgrade;
		unitrigger_stub.clientFieldName = clientFieldName;
		
		maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(unitrigger_stub, ::weapon_spawn_think);
		
		spawn_list[i].trigger_stub = unitrigger_stub;
		
	}
}

reset_wallbuy_internal(set_hint_string)
{
	if(isdefined(self.first_time_triggered) && self.first_time_triggered == true)
	{
		self.first_time_triggered = false;
		
		if(isdefined(self.clientFieldName))
		{
			level SetClientField(self.clientFieldName, 0);
		}
		
		if(set_hint_string)
		{
			hint_string = get_weapon_hint( self.zombie_weapon_upgrade ); 
			cost = get_weapon_cost( self.zombie_weapon_upgrade );
	
			self SetHintString( hint_string, cost ); 			
		}
	}	
}

reset_wallbuys()
{
	weapon_spawns = [];
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname");

	melee_and_grenade_spawns = [];
	melee_and_grenade_spawns = GetEntArray( "bowie_upgrade", "targetname" );
	melee_and_grenade_spawns = ArrayCombine(melee_and_grenade_spawns, GetEntArray( "sickle_upgrade", "targetname" ), true, false);
	melee_and_grenade_spawns = ArrayCombine(melee_and_grenade_spawns, GetEntArray( "tazer_upgrade", "targetname" ), true, false);
	melee_and_grenade_spawns = ArrayCombine(melee_and_grenade_spawns, GetEntArray( "claymore_purchase", "targetname" ), true, false);	
	
	for(i = 0; i < weapon_spawns.size; i ++)
	{
		weapon_spawns[i] reset_wallbuy_internal(true);
	}
	
	for(i = 0; i < melee_and_grenade_spawns.size; i ++)
	{
		melee_and_grenade_spawns[i] reset_wallbuy_internal(false);
	}
	
	if(isdefined(level._unitriggers))
	{
		candidates = [];
		for(i = 0; i < level._unitriggers.trigger_stubs.size; i ++)
		{
			stub = level._unitriggers.trigger_stubs[i];
			
			tn = stub.targetname;
			
			if(tn == "weapon_upgrade" || tn == "bowie_upgrade" || tn == "sickle_upgrade" || tn == "tazer_upgrade" || tn == "claymore_purchase")
			{
				stub.first_time_triggered = false;
				
				if(isdefined(stub.clientFieldName))
				{
					level SetClientField(stub.clientFieldName, 0);
				}
				
				if(tn == "weapon_upgrade")
				{
					stub.hint_string = get_weapon_hint( stub.zombie_weapon_upgrade ); 
					stub.cost = get_weapon_cost( stub.zombie_weapon_upgrade );
				}
			}
		}
	}
}

// For buying weapon upgrades in the environment
init_weapon_upgrade()
{
	
	init_spawnable_weapon_upgrade();
	
	weapon_spawns = [];
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" ); 

	for( i = 0; i < weapon_spawns.size; i++ )
	{
		hint_string = get_weapon_hint( weapon_spawns[i].zombie_weapon_upgrade ); 
		cost = get_weapon_cost( weapon_spawns[i].zombie_weapon_upgrade );

		weapon_spawns[i] SetHintString( hint_string, cost ); 
		weapon_spawns[i] setCursorHint( "HINT_NOICON" ); 
		weapon_spawns[i] UseTriggerRequireLookAt();

		weapon_spawns[i] thread weapon_spawn_think(); 
		model = getent( weapon_spawns[i].target, "targetname" ); 
		if(isdefined(model))
		{
			model useweaponhidetags( weapon_spawns[i].zombie_weapon_upgrade );
			model hide(); 
		} 
	}
}

// For toggling which weapons can appear from the box
init_weapon_toggle()
{
	if ( !isdefined( level.magic_box_weapon_toggle_init_callback ) )
	{
		return;
	}

	level.zombie_weapon_toggles = [];
	level.zombie_weapon_toggle_max_active_count = 0;
	level.zombie_weapon_toggle_active_count = 0;

	PrecacheString( &"ZOMBIE_WEAPON_TOGGLE_DISABLED" );
	PrecacheString( &"ZOMBIE_WEAPON_TOGGLE_ACTIVATE" );
	PrecacheString( &"ZOMBIE_WEAPON_TOGGLE_DEACTIVATE" );
	PrecacheString( &"ZOMBIE_WEAPON_TOGGLE_ACQUIRED" );
	level.zombie_weapon_toggle_disabled_hint = &"ZOMBIE_WEAPON_TOGGLE_DISABLED";
	level.zombie_weapon_toggle_activate_hint = &"ZOMBIE_WEAPON_TOGGLE_ACTIVATE";
	level.zombie_weapon_toggle_deactivate_hint = &"ZOMBIE_WEAPON_TOGGLE_DEACTIVATE";
	level.zombie_weapon_toggle_acquired_hint = &"ZOMBIE_WEAPON_TOGGLE_ACQUIRED";

	PrecacheModel( "zombie_zapper_cagelight" );
	PrecacheModel( "zombie_zapper_cagelight_green" );
	PrecacheModel( "zombie_zapper_cagelight_red" );
	PrecacheModel( "zombie_zapper_cagelight_on" );
	level.zombie_weapon_toggle_disabled_light = "zombie_zapper_cagelight";
	level.zombie_weapon_toggle_active_light = "zombie_zapper_cagelight_green";
	level.zombie_weapon_toggle_inactive_light = "zombie_zapper_cagelight_red";
	level.zombie_weapon_toggle_acquired_light = "zombie_zapper_cagelight_on";

	weapon_toggle_ents = [];
	weapon_toggle_ents = GetEntArray( "magic_box_weapon_toggle", "targetname" );

	for ( i = 0; i < weapon_toggle_ents.size; i++ )
	{
		struct = SpawnStruct();

		struct.trigger = weapon_toggle_ents[i];
		struct.weapon_name = struct.trigger.script_string;
		struct.upgrade_name = level.zombie_weapons[struct.trigger.script_string].upgrade_name;
		struct.enabled = false;
		struct.active = false;
		struct.acquired = false;

		target_array = [];
		target_array = GetEntArray( struct.trigger.target, "targetname" );
		for ( j = 0; j < target_array.size; j++ )
		{
			switch ( target_array[j].script_string )
			{
			case "light":
				struct.light = target_array[j];
				struct.light setmodel( level.zombie_weapon_toggle_disabled_light );
				break;
			case "weapon":
				struct.weapon_model = target_array[j];
				struct.weapon_model hide();
				break;
			}
		}

		struct.trigger SetHintString( level.zombie_weapon_toggle_disabled_hint );
		struct.trigger setCursorHint( "HINT_NOICON" );
		struct.trigger UseTriggerRequireLookAt();

		struct thread weapon_toggle_think();

		level.zombie_weapon_toggles[struct.weapon_name] = struct;
	}

	//for initial enable and disable of toggles, and determination of which are activated
	level thread [[level.magic_box_weapon_toggle_init_callback]]();
}


// an upgrade of a weapon toggle is also considered a weapon toggle
get_weapon_toggle( weapon_name )
{
	if ( !isdefined( level.zombie_weapon_toggles ) )
	{
		return undefined;
	}

	if ( isdefined( level.zombie_weapon_toggles[weapon_name] ) )
	{
		return level.zombie_weapon_toggles[weapon_name];
	}

	keys = GetArrayKeys( level.zombie_weapon_toggles );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( weapon_name == level.zombie_weapon_toggles[keys[i]].upgrade_name )
		{
			return level.zombie_weapon_toggles[keys[i]];
		}
	}

	return undefined;
}


is_weapon_toggle( weapon_name )
{
	return isdefined( get_weapon_toggle( weapon_name ) );
}


disable_weapon_toggle( weapon_name )
{
	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}

	if ( toggle.active )
	{
		level.zombie_weapon_toggle_active_count--;
	}
	toggle.enabled = false;
	toggle.active = false;

	toggle.light setmodel( level.zombie_weapon_toggle_disabled_light );
	toggle.weapon_model hide();
	toggle.trigger SetHintString( level.zombie_weapon_toggle_disabled_hint );
}


enable_weapon_toggle( weapon_name )
{
	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}

	toggle.enabled = true;
	toggle.weapon_model show();
	toggle.weapon_model useweaponhidetags( weapon_name );

	deactivate_weapon_toggle( weapon_name );
}


activate_weapon_toggle( weapon_name, trig_for_vox )
{
	if ( level.zombie_weapon_toggle_active_count >= level.zombie_weapon_toggle_max_active_count )
	{
        if( IsDefined( trig_for_vox ) )
        {
           trig_for_vox thread maps\mp\zombies\_zm_audio::weapon_toggle_vox( "max" );
        }
            
		return;
	}

	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}
	
	if( IsDefined( trig_for_vox ) )
	{
	    trig_for_vox thread maps\mp\zombies\_zm_audio::weapon_toggle_vox( "activate", weapon_name );
	}

	level.zombie_weapon_toggle_active_count++;
	toggle.active = true;

	toggle.light setmodel( level.zombie_weapon_toggle_active_light );
	toggle.trigger SetHintString( level.zombie_weapon_toggle_deactivate_hint );
}


deactivate_weapon_toggle( weapon_name, trig_for_vox )
{
	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}
	
	if( IsDefined( trig_for_vox ) )
	{
	    trig_for_vox thread maps\mp\zombies\_zm_audio::weapon_toggle_vox( "deactivate", weapon_name );
	}

	if ( toggle.active )
	{
		level.zombie_weapon_toggle_active_count--;
	}
	toggle.active = false;

	toggle.light setmodel( level.zombie_weapon_toggle_inactive_light );
	toggle.trigger SetHintString( level.zombie_weapon_toggle_activate_hint );
}


acquire_weapon_toggle( weapon_name, player )
{
	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}

	if ( !toggle.active || toggle.acquired )
	{
		return;
	}
	toggle.acquired = true;

	toggle.light setmodel( level.zombie_weapon_toggle_acquired_light );
	toggle.trigger SetHintString( level.zombie_weapon_toggle_acquired_hint );
	
	toggle thread unacquire_weapon_toggle_on_death_or_disconnect_thread( player );
}


unacquire_weapon_toggle_on_death_or_disconnect_thread( player )
{
	self notify( "end_unacquire_weapon_thread" );
	self endon( "end_unacquire_weapon_thread" );

	player waittill_any( "spawned_spectator", "disconnect" );

	unacquire_weapon_toggle( self.weapon_name );
}


unacquire_weapon_toggle( weapon_name )
{
	toggle = get_weapon_toggle( weapon_name );
	if ( !isdefined( toggle ) )
	{
		return;
	}

	if ( !toggle.active || !toggle.acquired )
	{
		return;
	}

	toggle.acquired = false;

	toggle.light setmodel( level.zombie_weapon_toggle_active_light );
	toggle.trigger SetHintString( level.zombie_weapon_toggle_deactivate_hint );

	toggle notify( "end_unacquire_weapon_thread" );
}


weapon_toggle_think()
{
	for( ;; )
	{
		self.trigger waittill( "trigger", player ); 		
		// if not first time and they have the weapon give ammo

		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}
        
		if ( !self.enabled || self.acquired )
		{
           self.trigger thread maps\mp\zombies\_zm_audio::weapon_toggle_vox( "max" );
		}
		else if ( !self.active )
		{
			activate_weapon_toggle( self.weapon_name, self.trigger );
		}
		else
		{
			deactivate_weapon_toggle( self.weapon_name, self.trigger );
		}
	}
}


// weapon cabinets which open on use
init_weapon_cabinet()
{
	// the triggers which are targeted at doors
	weapon_cabs = GetEntArray( "weapon_cabinet_use", "targetname" ); 

/#	PrintLn( "ZM >> init_weapon_cabinet (_zm_weapons.gsc) num=" + weapon_cabs.size );	#/

	for( i = 0; i < weapon_cabs.size; i++ )
	{

		weapon_cabs[i] SetHintString( &"ZOMBIE_CABINET_OPEN_1500" ); 
		weapon_cabs[i] setCursorHint( "HINT_NOICON" ); 
		weapon_cabs[i] UseTriggerRequireLookAt();
	}

	array_thread( weapon_cabs, ::weapon_cabinet_think ); 
}

// returns the trigger hint string for the given weapon
get_weapon_hint( weapon_name )
{
	assert( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].hint;
}

get_weapon_cost( weapon_name )
{
	assert( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].cost;
}

get_ammo_cost( weapon_name )
{
	assert( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].ammo_cost;
}

get_is_in_box( weapon_name )
{
	assert( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );
	
	return level.zombie_weapons[weapon_name].is_in_box;
}


// Check to see if this is an upgraded version of another weapon
//	weaponname can be any weapon name.
is_weapon_upgraded( weaponname )
{
	if( !isdefined( weaponname ) || weaponname == "" )
	{
		return false;
	}

	weaponname = ToLower( weaponname );

	ziw_keys = GetArrayKeys( level.zombie_weapons );
	for ( i=0; i<level.zombie_weapons.size; i++ )
	{
		if ( IsDefined(level.zombie_weapons[ ziw_keys[i] ].upgrade_name) && 
			 level.zombie_weapons[ ziw_keys[i] ].upgrade_name == weaponname )
		{
			return true;
		}
	}

	return false;
}


//	Check to see if the player has the upgraded version of the weapon
//	weaponname should only be a base weapon name
//	self is a player
has_upgrade( weaponname )
{
	has_upgrade = false;
	if( IsDefined(level.zombie_weapons[weaponname]) && IsDefined(level.zombie_weapons[weaponname].upgrade_name) )
	{
		has_upgrade = self HasWeapon( level.zombie_weapons[weaponname].upgrade_name );
	}

	// double check for the bowie variant on the ballistic knife	
	if ( !has_upgrade && "knife_ballistic_zm" == weaponname )
	{
		has_upgrade = has_upgrade( "knife_ballistic_bowie_zm" ) || has_upgrade( "knife_ballistic_sickle_zm" );
	}

	return has_upgrade;
}


//	Check to see if the player has the normal or upgraded weapon
//	weaponname should only be a base weapon name
//	self is a player
has_weapon_or_upgrade( weaponname )
{
	upgradedweaponname = weaponname;
	if ( IsDefined( level.zombie_weapons[weaponname] ) && IsDefined( level.zombie_weapons[weaponname].upgrade_name ) )
	{
		upgradedweaponname = level.zombie_weapons[weaponname].upgrade_name;
	}

	has_weapon = false;
	// If the weapon you're checking doesn't exist, it will return undefined
	if( IsDefined( level.zombie_weapons[weaponname] ) )
	{
		has_weapon = self HasWeapon( weaponname ) || self has_upgrade( weaponname );
	}

	// double check for the bowie variant on the ballistic knife	
	if ( !has_weapon && "knife_ballistic_zm" == weaponname )
	{
		has_weapon = has_weapon_or_upgrade( "knife_ballistic_bowie_zm" ) || has_weapon_or_upgrade( "knife_ballistic_sickle_zm" );
	}

	if ( !has_weapon && is_equipment( weaponname ) )
	{
		has_weapon = self is_equipment_active(weaponname);
	}

	return has_weapon;
}


pay_turret_think( cost )
{
	if( !isDefined( self.target ) )
	{
		return;
	}
	turret = GetEnt( self.target, "targetname" );

	if( !isDefined( turret ) )
	{
		return;
	}
	
	turret makeTurretUnusable();
	
	// figure out what zone it's in
	zone_name = turret get_current_zone();
	if ( !IsDefined( zone_name ) )
	{
		zone_name = "";
	}

	while( true )
	{
		self waittill( "trigger", player );
		
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

		if( IS_DRINKING(player.is_drinking) )
		{
			wait(0.1);
			continue;
		}
		
		if( player.score >= cost )
		{
			player maps\mp\zombies\_zm_score::minus_to_player_score( cost );
			bbPrint( "zombie_uses: playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type turret", player.name, player.score, level.round_number, cost, zone_name, self.origin );
			turret makeTurretUsable();
			turret UseBy( player );
			self disable_trigger();
			
			player maps\mp\zombies\_zm_audio::create_and_play_dialog( "weapon_pickup", "mg" );
			
			player.curr_pay_turret = turret;
			
			turret thread watch_for_laststand( player );
			turret thread watch_for_fake_death( player );
			if( isDefined( level.turret_timer ) )
			{
				turret thread watch_for_timeout( player, level.turret_timer );
			}
			
			while( isDefined( turret getTurretOwner() ) && turret getTurretOwner() == player )
			{
				wait( 0.05 );
			}
			
			turret notify( "stop watching" );
			
			player.curr_pay_turret = undefined;
			
			turret makeTurretUnusable();
			self enable_trigger();
		}
		else // not enough money
		{
			play_sound_on_ent( "no_purchase" );
			player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money", undefined, 0 );
		}
	}
}

watch_for_laststand( player )
{
	self endon( "stop watching" );
	
	while( !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
	{
		if( isDefined( level.intermission ) && level.intermission )
		{
			intermission = true;
		}
		wait( 0.05 );
	}
	
	if( isDefined( self getTurretOwner() ) && self getTurretOwner() == player )
	{
		self UseBy( player );
	}
}

watch_for_fake_death( player )
{
	self endon( "stop watching" );
	
	player waittill( "fake_death" );
	
	if( isDefined( self getTurretOwner() ) && self getTurretOwner() == player )
	{
		self UseBy( player );
	}
}

watch_for_timeout( player, time )
{
	self endon( "stop watching" );
	
	self thread cancel_timer_on_end( player );
	
//	player thread maps\mp\zombies\_zm_timer::start_timer( time, "stop watching" );
	
	wait( time );
	
	if( isDefined( self getTurretOwner() ) && self getTurretOwner() == player )
	{
		self UseBy( player );
	}
}

cancel_timer_on_end( player )
{
	self waittill( "stop watching" );
	player notify( "stop watching" );
}

weapon_cabinet_door_open( left_or_right )
{
	if( left_or_right == "left" )
	{
		self rotateyaw( 120, 0.3, 0.2, 0.1 ); 	
	}
	else if( left_or_right == "right" )
	{
		self rotateyaw( -120, 0.3, 0.2, 0.1 ); 	
	}	
}

check_collector_achievement( bought_weapon )
{
	if ( !isdefined( self.bought_weapons ) )
	{
		self.bought_weapons = [];
		ARRAY_ADD( self.bought_weapons, bought_weapon );
	}
	else if ( !IsInArray( self.bought_weapons, bought_weapon ) )
	{
		ARRAY_ADD( self.bought_weapons, bought_weapon );
	}
	else
	{
		// don't bother checking, they've bought it before
		return;
	}
	
	for( i = 0; i < level.collector_achievement_weapons.size; i++ )
	{
		if ( !IsInArray( self.bought_weapons, level.collector_achievement_weapons[i] ) )
		{
			return;
		}
	}
	
	self giveachievement_wrapper( "SP_ZOM_COLLECTOR" );
}

weapon_set_first_time_hint( cost, ammo_cost )
{
	if ( isDefined( level.has_pack_a_punch ) && !level.has_pack_a_punch )
	{
		self SetHintString( &"ZOMBIE_WEAPONCOSTAMMO", cost, ammo_cost ); 
	}
	else
	{
		self SetHintString( &"ZOMBIE_WEAPONCOSTAMMO_UPGRADE", cost, ammo_cost ); 
	}
}

weapon_spawn_think()
{
	cost = get_weapon_cost( self.zombie_weapon_upgrade );
	ammo_cost = get_ammo_cost( self.zombie_weapon_upgrade );
	is_grenade = (WeaponType( self.zombie_weapon_upgrade ) == "grenade");

	second_endon = undefined;
	
	if(isdefined(self.stub))
	{
		second_endon = "kill_trigger";
		self.first_time_triggered = self.stub.first_time_triggered;
	}
	
	self thread decide_hide_show_hint("stop_hint_logic", second_endon);
	self endon("stop_hint_logic");
	
	if ( self is_buildable() )
	{
		playerWhoBuilt = self maps\mp\zombies\_zm_buildables::buildable_think( self.zombie_weapon_upgrade ); // Waits for it to be built
		
		model = getent( self.target, "targetname" ); 
		model show(); 
		
		model thread weapon_show( playerWhoBuilt ); 
		self.first_time_triggered = true; 
		if(isdefined(self.stub))
		{
			self.stub.first_time_triggered = true;
		}

		if(!is_grenade)
		{
			self weapon_set_first_time_hint( cost, ammo_cost );
		}
	}
	else
	{
		if(!isdefined(self.first_time_triggered))
		{
			self.first_time_triggered = false; 
			if(isdefined(self.stub))
			{
				self.stub.first_time_triggered = false;
			}
		}
		else if(self.first_time_triggered)
		{
			self weapon_set_first_time_hint( cost, get_ammo_cost( self.zombie_weapon_upgrade ) );			
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

		if( !player can_buy_weapon() )
		{
			wait( 0.1 );
			continue;
		}

		
		if( player has_powerup_weapon() )
		{
			wait( 0.1 );
			continue;
		}

		// Allow people to get ammo off the wall for upgraded weapons
		player_has_weapon = player has_weapon_or_upgrade( self.zombie_weapon_upgrade ); 

		if( !player_has_weapon )
		{
			// else make the weapon show and give it
			if( player.score >= cost )
			{
				if( self.first_time_triggered == false )
				{
					model = getent( self.target, "targetname" ); 
					//					model show();
					
					if(isdefined(model))
					{
						model thread weapon_show( player ); 
					}
					else if(isdefined(self.clientFieldName))
					{
						level SetClientField(self.clientFieldName, 1);
					}
					
					self.first_time_triggered = true; 
					if(isdefined(self.stub))
					{
						self.stub.first_time_triggered = true;
					}

					if(!is_grenade)
					{
						self weapon_set_first_time_hint( cost, ammo_cost );
					}
				}

				player maps\mp\zombies\_zm_score::minus_to_player_score( cost ); 

				bbPrint( "zombie_uses: playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type weapon",
						player.name, player.score, level.round_number, cost, self.zombie_weapon_upgrade, self.origin );

				if ( self.zombie_weapon_upgrade=="riotshield_zm" ) 
				{
					player maps\mp\zombies\_zm_equipment::equipment_give( "riotshield_zm" );
					if ( isdefined(player.player_shield_reset_health))
						player [[player.player_shield_reset_health]]();
					//player SwitchToWeapon( "riotshield_zm" );
				}
				else if ( self.zombie_weapon_upgrade=="jetgun_zm" ) 
				{
					player maps\mp\zombies\_zm_equipment::equipment_give( "jetgun_zm" );
				}
				else
				{
					if ( is_lethal_grenade( self.zombie_weapon_upgrade ) )
					{
						player takeweapon( player get_player_lethal_grenade() );
						player set_player_lethal_grenade( self.zombie_weapon_upgrade );
					}

					player weapon_give( self.zombie_weapon_upgrade );
				}

				player check_collector_achievement( self.zombie_weapon_upgrade );
			}
			else
			{
				play_sound_on_ent( "no_purchase" );
				player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money", undefined, 1 );
				
			}
		}
		else
		{
			// MM - need to check and see if the player has an upgraded weapon.  If so, the ammo cost is much higher
			if(IsDefined(self.hacked) && self.hacked)	// hacked wall buys have their costs reversed...
			{
				if ( !player has_upgrade( self.zombie_weapon_upgrade ) )
				{
					ammo_cost = 4500;
				}
				else
				{
					ammo_cost = get_ammo_cost( self.zombie_weapon_upgrade );
				}
			}
			else
			{
				if ( player has_upgrade( self.zombie_weapon_upgrade ) )
				{
					ammo_cost = 4500;
				}
				else
				{
					ammo_cost = get_ammo_cost( self.zombie_weapon_upgrade );
				}
			}
			if ( self.zombie_weapon_upgrade=="riotshield_zm" ) 
			{
				play_sound_on_ent( "no_purchase" );
			}
			else 
			// if the player does have this then give him ammo.
			if( player.score >= ammo_cost )
			{
				if( self.first_time_triggered == false )
				{
					model = getent( self.target, "targetname" ); 
					//					model show(); 
					if(isdefined(model))
					{
						model thread weapon_show( player ); 
					}
					self.first_time_triggered = true;
					if(isdefined(self.stub))
					{
						self.stub.first_time_triggered = true;
					}
					
					if(!is_grenade)
					{ 
						self weapon_set_first_time_hint( cost, get_ammo_cost( self.zombie_weapon_upgrade ) );
					}
				}

				player check_collector_achievement( self.zombie_weapon_upgrade );

				if ( self.zombie_weapon_upgrade=="riotshield_zm" ) 
				{
					if ( isdefined(player.player_shield_reset_health))
						ammo_given = player [[player.player_shield_reset_health]]();
					else
						ammo_given = false;
				}
				else
//				MM - I don't think this is necessary
// 				if( player HasWeapon( self.zombie_weapon_upgrade ) && player has_upgrade( self.zombie_weapon_upgrade ) )
// 				{
// 					ammo_given = player ammo_give( self.zombie_weapon_upgrade, true ); 
// 				}
//				else 
				if( player has_upgrade( self.zombie_weapon_upgrade ) )
				{
					ammo_given = player ammo_give( level.zombie_weapons[ self.zombie_weapon_upgrade ].upgrade_name );
				}
				else
				{
					ammo_given = player ammo_give( self.zombie_weapon_upgrade ); 
				}
				
				if( ammo_given )
				{
						player maps\mp\zombies\_zm_score::minus_to_player_score( ammo_cost ); // this give him ammo to early

					bbPrint( "zombie_uses: playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type ammo",
						player.name, player.score, level.round_number, ammo_cost, self.zombie_weapon_upgrade, self.origin );
				}
			}
			else
			{
				play_sound_on_ent( "no_purchase" );
				player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money", undefined, 0 );
			}
		}
	}
}

weapon_show( player )
{
	player_angles = VectorToAngles( player.origin - self.origin ); 

	player_yaw = player_angles[1]; 
	weapon_yaw = self.angles[1];

	if ( isdefined( self.script_int ) )
	{
		weapon_yaw -= self.script_int;
	}

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

get_pack_a_punch_weapon_options( weapon )
{
	if ( !isDefined( self.pack_a_punch_weapon_options ) )
	{
		self.pack_a_punch_weapon_options = [];
	}

	if ( !is_weapon_upgraded( weapon ) )
	{
		return self CalcWeaponOptions( 0, 0, 0, 0, 0 );
	}

	if ( isDefined( self.pack_a_punch_weapon_options[weapon] ) )
	{
		return self.pack_a_punch_weapon_options[weapon];
	}

	smiley_face_reticle_index = 21; // smiley face is reserved for the upgraded famas, keep it at the end of the list

	camo_index = 15;
	lens_index = randomIntRange( 0, 6 );
	reticle_index = randomIntRange( 0, smiley_face_reticle_index );
	reticle_color_index = randomIntRange( 0, 6 );

	if ( "famas_upgraded_zm" == weapon )
	{
		reticle_index = smiley_face_reticle_index;
	}
	
/*
/#
	if ( GetDvarInt( "scr_force_reticle_index" ) )
	{
		reticle_index = GetDvarInt( "scr_force_reticle_index" );
	}
#/
*/

	scary_eyes_reticle_index = 8; // weapon_reticle_zom_eyes
	purple_reticle_color_index = 3; // 175 0 255
	if ( reticle_index == scary_eyes_reticle_index )
	{
		reticle_color_index = purple_reticle_color_index;
	}
	letter_a_reticle_index = 2; // weapon_reticle_zom_a
	pink_reticle_color_index = 6; // 255 105 180
	if ( reticle_index == letter_a_reticle_index )
	{
		reticle_color_index = pink_reticle_color_index;
	}
	letter_e_reticle_index = 7; // weapon_reticle_zom_e
	green_reticle_color_index = 1; // 0 255 0
	if ( reticle_index == letter_e_reticle_index )
	{
		reticle_color_index = green_reticle_color_index;
	}

	self.pack_a_punch_weapon_options[weapon] = self CalcWeaponOptions( camo_index, lens_index, reticle_index, reticle_color_index );
	return self.pack_a_punch_weapon_options[weapon];
}

weapon_give( weapon, is_upgrade, magic_box )
{
	primaryWeapons = self GetWeaponsListPrimaries(); 
	current_weapon = self getCurrentWeapon(); 
	weapon_limit = 2;

	//if is not an upgraded perk purchase
	if( !IsDefined( is_upgrade ) )
	{
		is_upgrade = false;
	}

 	if ( self HasPerk( "specialty_additionalprimaryweapon" ) )
 	{
		weapon_limit = 3;
 	}

	// brought over from treasure_chest_give_weapon -EO
	if ( weapon == "riotshield_zm" )
	{
		self maps\mp\zombies\_zm_equipment::equipment_give( "riotshield_zm" );
		if ( isdefined(self.player_shield_reset_health))
			self [[self.player_shield_reset_health]]();
	}

	// brought over from treasure_chest_give_weapon -EO
	if( self HasWeapon( weapon ) )
	{
		if ( issubstr( weapon, "knife_ballistic_" ) )
		{
			self notify( "zmb_lost_knife" );
		}
		self GiveStartAmmo( weapon );
		self SwitchToWeapon( weapon );
		return;
	}

	if( is_melee_weapon( weapon ) )
	{
		current_weapon=maps\mp\zombies\_zm_melee_weapon::change_melee_weapon(weapon,current_weapon);
	}
	else if ( is_lethal_grenade( weapon ) )
	{
		old_lethal = self get_player_lethal_grenade();
		if ( IsDefined(old_lethal) )
		{
			self TakeWeapon( old_lethal ); 
			unacquire_weapon_toggle( old_lethal );
		}
		self set_player_lethal_grenade(weapon);
	}
	else if ( is_tactical_grenade( weapon ) )
	{
		old_tactical = self get_player_tactical_grenade();
		if ( IsDefined(old_tactical) )
		{
			self TakeWeapon( old_tactical ); 
			unacquire_weapon_toggle( old_tactical );
		}
		self set_player_tactical_grenade(weapon);
	} 
	else if ( is_placeable_mine( weapon ) )
	{
		old_mine = self get_player_placeable_mine();
		if ( IsDefined(old_mine) )
		{
			self TakeWeapon( old_mine ); 
			unacquire_weapon_toggle( old_mine );
		}
		self set_player_placeable_mine(weapon);
	} 

	if( !is_offhand_weapon( weapon ) )
		self maps\mp\zombies\_zm_weapons::take_fallback_weapon();

	// This should never be true for the first time.
	if( primaryWeapons.size >= weapon_limit )
	{

		if ( is_placeable_mine( current_weapon ) || is_equipment( current_weapon ) )
		{
			current_weapon = undefined;
		}

		if( isdefined( current_weapon ) )
		{
			if( !is_offhand_weapon( weapon ) )
			{
				// brought over from treasure_chest_give_weapon -EO
				if( current_weapon == "tesla_gun_zm" )
				{
					level.player_drops_tesla_gun = true;
				}
				
				if ( issubstr( current_weapon, "knife_ballistic_" ) )
				{
					self notify( "zmb_lost_knife" );
				}
				self TakeWeapon( current_weapon ); 
				unacquire_weapon_toggle( current_weapon );
			}
		} 
	}
	
	if( IsDefined( level.zombiemode_offhand_weapon_give_override ) )
	{
		if( self [[ level.zombiemode_offhand_weapon_give_override ]]( weapon ) )
		{
			return;
		}
	}

	if( weapon == "zombie_cymbal_monkey" )
	{
		self maps\mp\zombies\_zm_weap_cymbal_monkey::player_give_cymbal_monkey();
		self play_weapon_vo( weapon );
		return;
	}
	else if ( issubstr( weapon, "knife_ballistic_" ) )
	{
		weapon = self maps\mp\zombies\_zm_melee_weapon::give_ballistic_knife(weapon,issubstr( weapon, "upgraded" ));
	}

	self play_sound_on_ent( "purchase" );

	if (weapon == "ray_gun_zm")
	{
		playsoundatposition ("mus_raygun_stinger", (0,0,0));		
	}

	if ( !is_weapon_upgraded( weapon ) )
	{
		self GiveWeapon( weapon );
	}
	else
	{
		self GiveWeapon( weapon, 0, self get_pack_a_punch_weapon_options( weapon ) );
	}

	acquire_weapon_toggle( weapon, self );
	self GiveStartAmmo( weapon );

	if( !is_melee_weapon( weapon ) )
		self SwitchToWeapon( weapon );
	else
		self SwitchToWeapon( current_weapon );
	 
	self play_weapon_vo(weapon);
}

play_weapon_vo(weapon)
{
	//Added this in for special instances of New characters with differing favorite weapons
	if ( isDefined( level._audio_custom_weapon_check ) )
	{
		type = self [[ level._audio_custom_weapon_check ]]( weapon );
	}
	else
	{
	    type = self weapon_type_check(weapon);
	}
				
	self maps\mp\zombies\_zm_audio::create_and_play_dialog( "weapon_pickup", type );
}

weapon_type_check(weapon)
{
    if( !IsDefined( self.entity_num ) )
        return "crappy";    
    
    switch(self.entity_num)
    {
        case 0:   //DEMPSEY'S FAVORITE WEAPON: M16 UPGRADED: ROTTWEIL72
            if( weapon == "m16_zm" )
                return "favorite";
            else if( weapon == "rottweil72_upgraded_zm" )
                return "favorite_upgrade";   
            break;
            
        case 1:   //NIKOLAI'S FAVORITE WEAPON: FNFAL UPGRADED: HK21
            if( weapon == "fnfal_zm" )
                return "favorite";
            else if( weapon == "hk21_upgraded_zm" )
                return "favorite_upgrade";   
            break;
            
        case 2:   //TAKEO'S FAVORITE WEAPON: M202 UPGRADED: THUNDERGUN
            if( weapon == "china_lake_zm" )
                return "favorite";
            else if( weapon == "thundergun_upgraded_zm" )
                return "favorite_upgrade";   
            break;
            
        case 3:   //RICHTOFEN'S FAVORITE WEAPON: MP40 UPGRADED: CROSSBOW
            if( weapon == "mp40_zm" )
                return "favorite";
            else if( weapon == "crossbow_explosive_upgraded_zm" )
                return "favorite_upgrade";   
            break;                
    }
    
    if( IsSubStr( weapon, "upgraded" ) )
        return "upgrade";
    else
        return level.zombie_weapons[weapon].vox;
}


get_player_index(player)
{
	assert( IsPlayer( player ) );
	//assert( IsDefined( player.entity_num ) );
	assert( IsDefined( player.characterIndex ) );
	
/#
	// used for testing to switch player's VO in-game from devgui
	if( player.entity_num == 0 && GetDvar( "zombie_player_vo_overwrite" ) != "" )
	{
		new_vo_index = GetDvarInt( "zombie_player_vo_overwrite" );
		return new_vo_index;
	}
#/
	//return player.entity_num;
	return player.characterIndex;
}

ammo_give( weapon )
{
	// We assume before calling this function we already checked to see if the player has this weapon...

	// Should we give ammo to the player
	give_ammo = false; 

	// Check to see if ammo belongs to a primary weapon
	if( !is_offhand_weapon( weapon ) )
	{
		if( isdefined( weapon ) )  
		{
			// get the max allowed ammo on the current weapon
			stockMax = 0;	// scope declaration
			stockMax = WeaponStartAmmo( weapon ); 

			// Get the current weapon clip count
			clipCount = self GetWeaponAmmoClip( weapon ); 

			currStock = self GetAmmoCount( weapon );

			// compare it with the ammo player actually has, if more or equal just dont give the ammo, else do
			if( ( currStock - clipcount ) >= stockMax )	
			{
				give_ammo = false; 
			}
			else
			{
				give_ammo = true; // give the ammo to the player
			}
		}
	}
	else
	{
		// Ammo belongs to secondary weapon
		if( self has_weapon_or_upgrade( weapon ) )
		{
			// Check if the player has less than max stock, if no give ammo
			if( self getammocount( weapon ) < WeaponMaxAmmo( weapon ) )
			{
				// give the ammo to the player
				give_ammo = true; 					
			}
		}		
	}	

	if( give_ammo )
	{
		self play_sound_on_ent( "purchase" ); 
		self GiveStartAmmo( weapon );
// 		if( also_has_upgrade )
// 		{
// 			self GiveMaxAmmo( weapon+"_upgraded" );
// 		}
		return true;
	}

	if( !give_ammo )
	{
		return false;
	}
}



weapon_cabinet_think()
{
	weapons = getentarray( "cabinet_weapon", "targetname" ); 

	doors = getentarray( self.target, "targetname" );
	for( i = 0; i < doors.size; i++ )
	{
		doors[i] NotSolid();
	}

	self.has_been_used_once = false; 

	self thread decide_hide_show_hint();

	while( 1 )
	{
		self waittill( "trigger", player );

		if( !player can_buy_weapon() )
		{
			wait( 0.1 );
			continue;
		}

		cost = 1500;
		if( self.has_been_used_once )
		{
			cost = get_weapon_cost( self.zombie_weapon_upgrade );
		}
		else
		{
			if( IsDefined( self.zombie_cost ) )
			{
				cost = self.zombie_cost;
			}
		}

		ammo_cost = get_ammo_cost( self.zombie_weapon_upgrade );

		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}

		if( self.has_been_used_once )
		{
			player_has_weapon = player has_weapon_or_upgrade( self.zombie_weapon_upgrade );
			/*
			player_has_weapon = false;
			weapons = player GetWeaponsList( true ); 
			if( IsDefined( weapons ) )
			{
				for( i = 0; i < weapons.size; i++ )
				{
					if( weapons[i] == self.zombie_weapon_upgrade )
					{
						player_has_weapon = true; 
					}
				}
			}
			*/

			if( !player_has_weapon )
			{
				if( player.score >= cost )
				{
					self play_sound_on_ent( "purchase" );
					player maps\mp\zombies\_zm_score::minus_to_player_score( cost ); 
					player weapon_give( self.zombie_weapon_upgrade ); 
				}
				else // not enough money
				{
					play_sound_on_ent( "no_purchase" );
					player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money" );
				}			
			}
			else if ( player.score >= ammo_cost )
			{
				ammo_given = player ammo_give( self.zombie_weapon_upgrade ); 
				if( ammo_given )
				{
					self play_sound_on_ent( "purchase" );
					player maps\mp\zombies\_zm_score::minus_to_player_score( ammo_cost ); // this give him ammo to early
				}
			}
			else // not enough money
			{
				play_sound_on_ent( "no_purchase" );
				player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money" );
			}
		}
		else if( player.score >= cost ) // First time the player opens the cabinet
		{
			self.has_been_used_once = true;

			self play_sound_on_ent( "purchase" ); 

			self SetHintString( &"ZOMBIE_WEAPONCOSTAMMO", cost, ammo_cost ); 
			//		self SetHintString( get_weapon_hint( self.zombie_weapon_upgrade ) );
			self setCursorHint( "HINT_NOICON" ); 
			player maps\mp\zombies\_zm_score::minus_to_player_score( self.zombie_cost ); 

			doors = getentarray( self.target, "targetname" ); 

			for( i = 0; i < doors.size; i++ )
			{
				doors[i] thread weapon_cabinet_door_open( doors[i].script_noteworthy ); 
				
				/*if( doors[i].script_noteworthy == "left" )
				{
					doors[i] thread weapon_cabinet_door_open( "left" ); 
				}
				else if( doors[i].script_noteworthy == "right" )
				{
					doors[i] thread weapon_cabinet_door_open( "right" ); 
				}*/
			}

			player_has_weapon = player has_weapon_or_upgrade( self.zombie_weapon_upgrade ); 
			/*
			player_has_weapon = false;
			weapons = player GetWeaponsList( true ); 
			if( IsDefined( weapons ) )
			{
				for( i = 0; i < weapons.size; i++ )
				{
					if( weapons[i] == self.zombie_weapon_upgrade )
					{
						player_has_weapon = true; 
					}
				}
			}
			*/

			if( !player_has_weapon )
			{
				player weapon_give( self.zombie_weapon_upgrade ); 
			}
			else
			{
				if( player has_upgrade( self.zombie_weapon_upgrade ) )
				{
					player ammo_give( self.zombie_weapon_upgrade+"_upgraded" ); 
				}
				else
				{
					player ammo_give( self.zombie_weapon_upgrade ); 
				}
			}	
		}
		else // not enough money
		{
			play_sound_on_ent( "no_purchase" );
			player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money" );
		}		
	}
}
