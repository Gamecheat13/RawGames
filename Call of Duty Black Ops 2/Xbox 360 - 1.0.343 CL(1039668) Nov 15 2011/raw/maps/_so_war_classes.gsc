#include common_scripts\utility;
#include maps\_utility;
#include maps\_so_code;

#insert raw\maps\_utility.gsh;

classes_global_init()
{
	level.so.TABLE_CLASS_REF						= 1;	// Class type ref
	level.so.TABLE_CLASS_WEAPONS					= 2;	// List of weapons
	level.so.TABLE_CLASS_WEAPON_AMMO				= 3;	// List of weapon ammo
	level.so.TABLE_CLASS_GRENADES					= 4; 	// List of grenades
	level.so.TABLE_CLASS_GRENADE_AMMO				= 5;	// List of grenade ammo
	level.so.TABLE_CLASS_EQUIPMENT					= 6;	// Any additional equipment
	level.so.TABLE_CLASS_ARMOR						= 7;	// Armor value
	level.so.TABLE_CLASS_PERKS						= 8;	// List of perks
	level.so.TABLE_CLASS_KILLSTREAKS				= 9;	// List of killstreaks
	level.so.TABLE_CLASS_HEALTH						= 10;	// Health amount int
	level.so.TABLE_CLASS_SPEED						= 11;	// AI movement speed
	level.so.TABLE_CLASS_ACCURACY					= 12;	// AI Base accuracy
	level.so.TABLE_CLASS_ICON					= 13;	// ICON material


	level.so.TABLE_CLASS_INDEX_START				= 1000;	// First index for Class Table
	level.so.TABLE_CLASS_INDEX_END					= 1020;	// Last index for Class Table
	
	// Tweakables: Repeating Wave Difficulty Adjust
	level.so.CONST_AI_REPEAT_BOOST_HEALTH			= 0.10;	// 0.0-1.0 Percent health increase stacked for each repeated wave
	level.so.CONST_AI_REPEAT_BOOST_SPEED			= 0.05;	// 0.0-1.0 Percent speed increase stacked for each repeated wave
	level.so.CONST_AI_REPEAT_BOOST_ACCURACY			= 0.2;	// 0.0-1.0 Percent accuracy increase stacked for each repeated wave
}

init()
{
	level.war_classes = class_type_populate();
	
	// setup the classes the player can switch between
	level.player_classes = [];
		
	playerClass = get_class_struct( "player" );
	playerClass.spawner = GetEnt( "friendly_assault", "targetname" );
	playerClass.player = true;
	playerClass.hudElm = GetPlayers()[0] maps\_so_war_switch::ally_init_hudElem(playerClass.icon);

	assert( IsDefined( playerClass.spawner ), "Must have a friendly_assault spawner for the player" );
		
	level.player_classes[0] = playerClass;
	level.player_classes[0].ai_name = maps\_so_war::war_get_names();
}

preload()
{
	classes_global_init();
	
	preload_weapons();
}

postload()
{
}

preload_weapons()
{
	index_start = level.so.TABLE_CLASS_INDEX_START;
	index_end 	= level.so.TABLE_CLASS_INDEX_END;

	for( i = index_start; i <= index_end; i++ )
	{	
		ref = get_class_ref_by_index( i );
		
		if ( !isdefined( ref ) || ref == "" )
			continue;
		
		ai_weapons = get_class_weapons( ref, i );
		foreach( w in ai_weapons )
			precacheitem( w );
		
		ai_grenades = get_class_grenades( ref, i );
		foreach( w in ai_grenades )
			precacheitem( w );
	}
}

class_type_populate()
{
	index_start = level.so.TABLE_CLASS_INDEX_START;
	index_end 	= level.so.TABLE_CLASS_INDEX_END;
	
	class_types	= [];

	for( i = index_start; i <= index_end; i++ )
	{		
		ref = get_class_ref_by_index( i );
		
		if ( !isdefined( ref ) || ref == "" )
			continue;
		
		classtype 				= spawnstruct();
		classtype.idx			= i;
		classtype.ref			= ref;
		classtype.weapons 		= get_class_weapons( ref, i );
		classtype.weapon_ammo	= get_class_weapon_ammo( ref, i );
		classtype.grenades 		= get_class_grenades( ref, i );
		classtype.grenade_ammo	= get_class_grenade_ammo( ref, i );
		classtype.equipment		= get_class_equipment( ref, i );
		classtype.armor			= get_class_armor( ref, i );
		classtype.perks			= get_class_perks( ref, i );
		classtype.killstreaks	= get_class_killstreaks( ref, i );
		classtype.health		= get_class_health( ref, i );
		classtype.speed			= get_class_speed( ref, i );
		classtype.accuracy		= get_class_accuracy( ref, i );
		classtype.icon			= get_class_icon( ref, i );
		
		

		class_types[ ref ] = classtype;
	}
	
	return class_types;
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

add_to_player_classes()
{
	// add if it's not already in the list
	if( find_classtype_for_ai(self) < 0 )
	{
		// live AI carries info struct about his class
		if ( !isdefined( self.ai_type ) )
		{
			ai_ref = self maps\_so_war_ai::get_ai_type_ref();
			
			ai_type_struct = self maps\_so_war_ai::get_ai_struct( ai_ref );
			assert( isdefined( ai_type_struct ), "Failed to find struct for AI type: " + ai_ref );
			self.ai_type = ai_type_struct;
		}
		
		classtype = get_class_struct( self.ai_type.classtype );
		
		// record the spawner for future reference
		assert( IsDefined(self.spawner) );
		classtype.spawner = self.spawner;
		classtype.ai = self;

		classtype.hudElm = GetPlayers()[0] maps\_so_war_switch::ally_init_hudElem(classtype.icon);

		level.player_classes[ level.player_classes.size ] = classtype;
		level notify("ally_selection_update");
	}

//	self thread class_damage_feedback(level.player_classes[find_classtype_for_ai(self)].hudElm);
	self thread remove_from_player_classes_on_death();
}


remove_from_player_classes_on_death()
{
	self endon( "player_takeover" );
	
	self waittill("death");
	
	newArray = [];
	
	foreach( class in level.player_classes )
	{
		if (isDefined(class.ai) && class.ai == self)
		{
			maps\_so_war_switch::ally_hud_class_died(class);
			break;
		}
	}
	
	foreach( classType in level.player_classes )
	{
		if( IS_TRUE(classType.player) || ( IsDefined(classType.ai) && classType.ai != self ) )
		{
			newArray[ newArray.size ] = classType;
		}
	}
	
	level.player_classes = newArray;
	level notify("ally_selection_update");
}

find_classtype_for_ai( ai )
{
	for( i=0; i < level.player_classes.size; i++ )
	{
		classType = level.player_classes[i];
		if( IsDefined(classType.ai) && classType.ai == ai )
		{
			return i;
		}
	}
	
	return -1;
}

find_classtype_for_player()
{
	for( i=0; i < level.player_classes.size; i++ )
	{
		classType = level.player_classes[i];
		if( IS_TRUE(classType.player) )
		{
			return i;
		}
	}
	
	return -1;
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

// CLASS HOOKS ==============================================================
// tablelookup( stringtable path, search column, search value, return value at column );

class_exists( ref )
{
	return isdefined( level.war_classes ) && isdefined( level.war_classes[ ref ] );
}

get_class_index( ref )
{
	if ( class_exists( ref ) )
		return level.war_classes[ ref ].idx;
	
	return int( tablelookup( level.so.LOADOUT_TABLE_DEFAULT, level.so.TABLE_CLASS_REF, ref, level.so.TABLE_INDEX ) );	
}

get_class_ref_by_index( idx )
{
	return tablelookup( level.so.LOADOUT_TABLE_DEFAULT, level.so.TABLE_INDEX, idx, level.so.TABLE_CLASS_REF );
}

lookup_value( ref, idx, column_index )
{
	if( IsDefined(idx) )
		return tablelookup( level.so.LOADOUT_TABLE_DEFAULT, level.so.TABLE_INDEX, idx, column_index );
	else
		return tablelookup( level.so.LOADOUT_TABLE_DEFAULT, level.so.TABLE_CLASS_REF, ref, column_index );
}

get_class_struct( ref )
{
	msg = "Trying to get war class struct before stringtable is ready, or type doesnt exist.";
	assert( class_exists( ref ), msg );
	
	return level.war_classes[ ref ];
}

get_class_weapons( ref, idx )
{
	if ( class_exists( ref ) )
		return level.war_classes[ ref ].weapons;
		
	valueArray = lookup_value( ref, idx, level.so.TABLE_CLASS_WEAPONS );	
	return strtok( valueArray, " " );
}

get_class_weapon_ammo( ref, idx )
{
	if ( class_exists( ref ) )
		return level.war_classes[ ref ].weapon_ammo;
		
	valueArray = lookup_value( ref, idx, level.so.TABLE_CLASS_WEAPON_AMMO );	
	return strtok( valueArray, " " );
}

get_class_grenades( ref, idx )
{
	if ( class_exists( ref ) )
		return level.war_classes[ ref ].grenades;
		
	valueArray = lookup_value( ref, idx, level.so.TABLE_CLASS_GRENADES );	
	return strtok( valueArray, " " );
}

get_class_grenade_ammo( ref, idx )
{
	if ( class_exists( ref ) )
		return level.war_classes[ ref ].grenade_ammo;
		
	valueArray = lookup_value( ref, idx, level.so.TABLE_CLASS_GRENADE_AMMO );	
	return strtok( valueArray, " " );
}

get_class_equipment( ref, idx )
{
	if ( class_exists( ref ) )
		return level.war_classes[ ref ].equipment;
	
	valueArray = lookup_value( ref, idx, level.so.TABLE_CLASS_EQUIPMENT );	
	return strtok( valueArray, " " );
}

get_class_armor( ref, idx )
{
	if ( class_exists( ref ) )
		return level.war_classes[ ref ].armor;
		
	return lookup_value( ref, idx, level.so.TABLE_CLASS_ARMOR );
}

get_class_perks( ref, idx )
{
	if ( class_exists( ref ) )
		return level.war_classes[ ref ].perks;

	valueArray = lookup_value( ref, idx, level.so.TABLE_CLASS_PERKS );	
	return strtok( valueArray, " " );
}

get_class_killstreaks( ref, idx )
{
	if ( class_exists( ref ) )
		return level.war_classes[ ref ].killstreaks;
		
	valueArray = lookup_value( ref, idx, level.so.TABLE_CLASS_KILLSTREAKS );	
	return strtok( valueArray, " " );
}

get_class_health( ref, idx )
{
	// Scale health as waves repeat to increase difficulty
	if ( isdefined( level.war_waves_repeated ) )
		repeat_scale_health = 1.0 + level.war_waves_repeated * level.so.CONST_AI_REPEAT_BOOST_HEALTH;
	else
		repeat_scale_health = 1.0;
	
	if ( class_exists( ref ) )
		return int( level.war_classes[ ref ].health * repeat_scale_health );
	
	health = lookup_value( ref, idx, level.so.TABLE_CLASS_HEALTH );
	if ( health == "" )
		return undefined;
		
	return int ( int( health ) * repeat_scale_health );
}

get_class_speed( ref, idx )
{
	// Scale speed as waves repeat to increase difficulty
	if ( isdefined( level.war_waves_repeated ) )
		repeat_scale_speed = 1.0 + level.war_waves_repeated * level.so.CONST_AI_REPEAT_BOOST_SPEED;
	else
		repeat_scale_speed = 1.0;
	
	if ( class_exists( ref ) )
		return level.war_classes[ ref ].speed * repeat_scale_speed;
	
	speed = lookup_value( ref, idx, level.so.TABLE_CLASS_SPEED );
	if ( speed == "" )
		return undefined;
			
	return float( speed ) * repeat_scale_speed;
}

get_class_accuracy( ref, idx )
{
	// Scale accuracy as waves repeat to increase difficulty
	if ( isdefined( level.war_waves_repeated ) )
		repeat_scale_accuracy = 1.0 + level.war_waves_repeated * level.so.CONST_AI_REPEAT_BOOST_ACCURACY;
	else
		repeat_scale_accuracy = 1.0;
	
	if ( class_exists( ref ) )
	{
		if ( isdefined( level.war_classes[ ref ].accuracy ) )
			return level.war_classes[ ref ].accuracy * repeat_scale_accuracy;
		else
			return level.war_classes[ ref ].accuracy;
	}
	
	accuracy = lookup_value( ref, idx, level.so.TABLE_CLASS_ACCURACY );
	if ( accuracy == "" )
		return undefined;
	
	return float( accuracy ) * repeat_scale_accuracy;	
}

get_class_icon( ref, idx )
{
	return lookup_value( ref, idx, level.so.TABLE_CLASS_ICON );
}


//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
get_cur_player_class()
{
	classTypeIdx = find_classtype_for_player();
	if( classTypeIdx >= 0 )
	{		
		return level.player_classes[classTypeIdx].spawner.targetname;
	}
	return "unknown";
}

take_on_ally_class( ally )
{
	self endon("death");
	
	assert( IsDefined(ally) );

	classTypeIdx = find_classtype_for_player();
	
	if( classTypeIdx >= 0 )
	{		
		level.player_classes[classTypeIdx].player = false;	
	}

	classTypeIdx = find_classtype_for_ai( ally );
	
	if( classTypeIdx >= 0 )
	{
		self showViewModel();
		self enableweapons();

		self thread maps\_so_war_support::give_loadout( level.player_classes[classTypeIdx] );
		level.player_classes[classTypeIdx].ai = undefined;
		level.player_classes[classTypeIdx].player = true;
		level.player_classes[classTypeIdx].ai_name = ally.name;
		level notify("player_switch_"+level.player_classes[classTypeIdx].spawner.targetname);
		// don't remove from the class list on death
		ally notify( "player_takeover" );
	}
}

spawn_replacement_ally( startOrigin, startAngles, startStance, spawnStructCB )
{
	self endon("death");
	
	classTypeIdx = find_classtype_for_player();
	
	if( classTypeIdx >= 0 )
	{		
		level.player_classes[classTypeIdx].player = false;	
		
		newGuy = maps\_so_war_ai::spawn_single_ally( level.player_classes[classTypeIdx].spawner, startOrigin, startAngles, false );
		
		//restore the name and rank of AI;  When you spawn a new guy, he gets a new random name.
		newGuy.name = level.player_classes[classTypeIdx].ai_name;
		
		// set the correct pose for visual and stealth correctness
		newGuy.a.pose = startStance;
		
		// if still in stealth, run the proper threads
		if( level flag_exists( "_stealth_hidden" ) && level flag( "_stealth_hidden" ) )
		{
			newGuy.pacifist = true;
			newGuy thread maps\_stealth_logic::stealth_ai_logic();
		}
		
		level.player_classes[classTypeIdx].ai = newGuy;

		if (isDefined(spawnStructCB) )
		{
			switch (spawnStructCB.type)
			{
				case "spawn_thread_on_ent":
					spawnStructCB.ent thread [[spawnStructCB.cb]](level.player_classes[classTypeIdx].ai,spawnStructCB.param1,spawnStructCB.param2,spawnStructCB.param3);
				break;
			}
		}
	}
}

update_player_classtype()
{
	classTypeIdx = find_classtype_for_player();
	assert( classTypeIdx >= 0 );
	
	weaponArray = [];
	weaponAmmoArray = [];
	grenadeArray = [];
	grenadeAmmoArray = [];
	
	currentWeapons = self GetWeaponsList();
	
	foreach( weapon in currentWeapons )
	{
		//iprintln( weapon + ": " + WeaponClass(weapon) + ": " + WeaponType(weapon) + ": " + WeaponInventoryType(weapon) + ": " + self GetWeaponAmmoClip(weapon) + " / " + self GetWeaponAmmoStock(weapon) + " \n" );
			
		weaponInventoryType = WeaponInventoryType(weapon);
		
		// exclude melee and killstreaks
		if( weaponInventoryType == "primary" || weaponInventoryType == "altmode" || weaponInventoryType == "offhand" || weaponInventoryType == "item" )
		{
			if( WeaponType(weapon) == "grenade" )
			{
				grenadeArray[ grenadeArray.size ] = weapon;
				grenadeAmmoArray[ grenadeAmmoArray.size ] = self GetWeaponAmmoStock(weapon);
			}
			else
			{
				weaponArray[ weaponArray.size ] = weapon;
				weaponAmmoArray[ weaponAmmoArray.size ] = self GetWeaponAmmoStock(weapon);
			}
		}
	}
	
	level.player_classes[classTypeIdx].weapons = weaponArray;
	level.player_classes[classTypeIdx].weapon_ammo = weaponAmmoArray;
	
	level.player_classes[classTypeIdx].grenades = grenadeArray;
	level.player_classes[classTypeIdx].grenade_ammo = grenadeAmmoArray;
}

watchKillstreakUse()
{
	self endon("death");
	
	while(1)
	{
		self waittill( "killstreak_done", successful, killstreakType );
		
		if( successful )
		{
			// don't let it be used again
			idx = find_classtype_for_player();
			assert( idx >= 0 );
			
			level.player_classes[idx].killstreaks = array_remove( level.player_classes[idx].killstreaks, killstreakType );
		}
	}	
}

// check if the damage is enough to kill us and switch into an ally if one's available
Callback_PreventPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	self endon( "disconnect" );
	
	if( iDamage > self.health )
	{		
		for( i=0; i < level.player_classes.size; i++ )
		{
			if( IsDefined( level.player_classes[i].ai ) && IsAlive( level.player_classes[i].ai ) )
			{
				self.health = self.maxhealth;
				
				// stop the dog melee so it doesn't kill us on respawn
				if( IsDefined(eAttacker) && IS_TRUE(eAttacker.isdog) )
					self thread stopDogMeleeAttack( eAttacker );
				
				maps\_so_war_switch::ally_hud_class_died(level.player_classes[find_classtype_for_player()]);
				self notify("player_died");
				self thread maps\_so_war_support::do_ally_switch( level.player_classes[i].ai, false, true );
				
				return true;
			}
		}
		
		flag_set( "all_ally_dead" );
	}
	
	return false;
}

stopDogMeleeAttack( dog )
{
	self endon("death");
	
	//self waittill( "dog_attacks_player" );
	
	// wait for the checkinterrupt thread to start
	wait(0.05);
	
	// release the player
	self.specialDeath = undefined;
	self.quickDogMeleeRelease = true;
	dog notify("melee_stop");
	
	// stop the dog combat script
	dog.safetoChangeScript = true;
	dog ClearEnemy();
	dog notify("killanimscript");
	
	//self.quickDogMeleeRelease = undefined;
}

class_damage_feedback(hudElm)
{
	self endon("death");
	while(1)
	{
		self waittill("damage");
		self thread maps\_so_war_support::icon_jitter(hudElm);
	}
}
