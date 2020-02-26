#include common_scripts\utility;
#include maps\_utility;
#include maps\_so_code;

loot_preload()
{
	if ( !level.so.LOOT_DROPS )
		return;
		
	// precaches all possible loots
	for ( i = level.LOOT_INDEX_START; i <= level.LOOT_INDEX_END; i++ )
	{
		loot_ref = get_loot_ref_by_index( i );
		
		if( isdefined( loot_ref ) && get_loot_type( loot_ref ) == "weapon" )
			precache_loadout_item( loot_ref );

		if( isdefined( loot_ref ) && get_loot_type( loot_ref ) == "perk" )
			precacheModel(  get_loot_param( loot_ref ) );

		if( isdefined( loot_ref ) && get_loot_type( loot_ref ) == "special" )
			precacheModel(  get_loot_param( loot_ref ) );

	}
	
	// precaches all possible loot versions
	for ( i = level.LOOT_VERSION_INDEX_START; i <= level.LOOT_VERSION_INDEX_END; i++ )
	{
		loot_version = get_loot_version_by_index( i );
		
		if( isdefined( loot_version ) )
			precache_loadout_item( loot_version );
	}
	
	
	level._effect[ "drop_fx" ] = loadfx ("misc/fx_zombie_mini_nuke_hotness");
	level._effect[ "drop_fx_on" ] = loadfx ("misc/fx_zombie_powerup_on");
}

loot_postload()
{
	
}

loot_init()
{
	// Tweakables: Loot
	level.LOOT_TABLE						= "sp/so_war/war_loot.csv";		// loot data tablelookup
	
	level.TABLE_INDEX						= 0;	// indexing
	level.TABLE_REF							= 1;	// reference loot asset name
	level.TABLE_TYPE						= 2;	// loot type
	level.TABLE_NAME						= 3;	// name
	level.TABLE_DESC						= 4;	// description
	level.TABLE_CHANCE						= 5;	// drop probability
	level.TABLE_WAVE_UNLOCK					= 6;	// earliest wave this loot can drop at
	level.TABLE_WAVE_LOCK					= 7;	// wave at which this loot stops dropping
	level.TABLE_RANK						= 8;	// player rank required for this loot to drop
	level.TABLE_VAR1						= 9;	// misc var for special needs
	
	level.LOOT_INDEX_START					= 0;	// starting index of weapon loot items in string table
	level.LOOT_INDEX_END					= 20;	// ending index of weapon loot items in string table
	
	level.LOOT_VERSION_INDEX_START			= 100;	// starting index of weapon type permutations
	level.LOOT_VERSION_INDEX_END			= 199;	// starting index of weapon type permutations
	
	level.CONST_WEAPON_DROP_AMMO_CLIP		= 0.4;	// 0-1.0 rate of max ammo in clip on loot drops
	level.CONST_WEAPON_DROP_AMMO_STOCK		= 0.5;	// 0-1.0 rate of max ammo in stock on loot drops
	level.CONST_WEAPON_DROP_ALT_AMMO_CLIP	= 0.5;	// 0-1.0 rate of max ammo in clip of attachment
	level.CONST_WEAPON_DROP_ALT_AMMO_STOCK	= 0.5;	// 0-1.0 rate of max ammo in stock of attachment
	level.CONST_LOOT_TIMEOUT				= 60;
	level.CONST_PERK_TIMEOUT				= 30;
	
	level.CONST_LOOT_DROP_MIN_WAVES_LAST_DROP	= 2;	// Waves since a loot type has dropped before it can be dropped again (type not version)
	level.CONST_LOOT_LAST_WAVE_DROP_DEFAULT		= -999;	// When a loot is being dropped for the first time, this is the last wave it was dropped.	
	
	if (!isDefined(level.so.LOOT_DROPS) )
		level.so.LOOT_DROPS					= 1;


	loot_populate( level.LOOT_INDEX_START, level.LOOT_INDEX_END, level.LOOT_VERSION_INDEX_START, level.LOOT_VERSION_INDEX_END );
}

loot_populate( loot_start_idx, loot_end_idx, version_start_idx, version_end_idx )
{
	// Fill the loot version array
	level.loot_version_array = [];
	for ( i = version_start_idx; i <= version_end_idx; i++ )
	{
		version = get_loot_version_by_index( i );
		
		if ( isdefined( version ) && version != "" )
		{
			level.loot_version_array[ level.loot_version_array.size ] = version;
		}
	}
	
	// Next fill the loot info array
	level.loot_info_array = [];
	for ( i = loot_start_idx; i <= loot_end_idx; i++ )
	{
		loot_ref = get_loot_ref_by_index( i );
		
		if( !isdefined( loot_ref ) || loot_ref == "" )
			continue;
		
		loot_type = get_loot_type( loot_ref );
		
		if ( !isdefined( level.loot_info_array[ loot_type ] ) )
			level.loot_info_array[ loot_type ] = [];
			
		item 				= spawnstruct();
		item.index 			= i;
		item.ref			= loot_ref;
		item.type			= loot_type;
		item.name			= get_loot_name( loot_ref );
		item.desc			= get_loot_desc( loot_ref );
		item.chance			= get_loot_chance( loot_ref );
		item.wave_unlock	= get_loot_wave_unlock( loot_ref );
		item.wave_lock		= get_loot_wave_lock( loot_ref );
		item.wave_dropped	= level.CONST_LOOT_LAST_WAVE_DROP_DEFAULT;
		item.rank			= get_loot_rank( loot_ref );
		item.versions		= get_loot_versions( loot_ref );
		item.parameter		= get_loot_param( loot_ref );
		
		level.loot_info_array[ loot_type ][ loot_ref ] = item;
	}
	
	/#
	// Check to make sure that the loot version array does not include
	// an exact copy of an item in the loot info array. If this happens the
	// table look ups can find the loot version instead of the loot info
	// when populating
	foreach( type in level.loot_info_array )
		foreach( loot in type )
			foreach( version in level.loot_version_array )
				assert( loot.ref != version, "The loot table and the loot version table had an overlapping value of: " + version );	
	#/
}

loot_roll_type( type, chance_override )
{
	if ( !isdefined( level.loot_info_array ) || !isdefined( level.loot_info_array[ type ] ) )
		return false;
	if ( !isDefined(level.so.LOOT_DROPS) || level.so.LOOT_DROPS == 0 )
		return false;
	
	loot_item_array = [];
	
	// Collect loot type drop options according to required
	// rank and required wave number
	foreach( loot in level.loot_info_array[ type ] )
	{
		if	( 
			level.current_wave >= loot.wave_unlock
		&&	level.current_wave < loot.wave_lock
		&&	level.current_wave - loot.wave_dropped >= level.CONST_LOOT_DROP_MIN_WAVES_LAST_DROP
			)
		{
			loot_item_array[ loot_item_array.size ] = loot;
		}
	}
	
	if ( !loot_item_array.size )
		return false;
	
	// Sort loot according to last dropped
	loot_item_array = maps\_utility_code::exchange_sort_by_handler( loot_item_array, ::loot_roll_compare_type_wave_dropped );
	loot_version = undefined;
	loot = undefined;
	
	foreach( item in loot_item_array )
	{
		chance = ( isdefined( chance_override ) ? chance_override : item.chance );
		if ( chance > randomintrange( 0, 100 ) )
		{
			loot_version = item.versions[ randomint( item.versions.size ) ];
			loot = item;
			break;
		}
	}
	
	
	if (isDefined(loot))
	{
		loot.wave_dropped = level.current_wave;
		if ( type == "weapon" )
		{
			weapon_name 	= loot_version;
			weapon_model 	= getweaponmodel( weapon_name );
			self.dropweapon	= false;
			self thread loot_drop_weapon_on_death( "weapon_" + weapon_name, weapon_name, "weapon", weapon_model, "tag_stowed_back" );
			return true;
		}
		if ( type == "perk" )
		{
			self thread loot_drop_perk_on_death ( loot.ref, loot.name, loot.parameter );
			return true;
		}
		if ( type == "killstreak" )
		{
			self thread loot_drop_killstreak_on_death ( loot.ref );
			return true;
		}
		if ( type == "special" )
		{
			self thread loot_drop_special_on_death ( loot.ref, loot.name, loot.parameter );
			return true;
		}
		assertMsg("Unhandled loot case");
	}
	
	return false;
}


loot_roll( chance_override )
{
	chance = RandomInt(level.loot_info_array.size);
	switch (chance)
	{
		case 0:
			lootType = "weapon";
		break;
		case 1:
			lootType = "perk";
		break;
		case 2:
			lootType = "killstreak";
		break;
		case 3:
			lootType = "special";
		break;
		default:
			assertmsg("Unhandled case");
			lootType = undefined;
		break;
	}
	return loot_roll_type( lootType, chance_override );
}

loot_roll_compare_type_wave_dropped()
{
	assert( isdefined( self ) && isdefined( self.wave_dropped ), "self.wave_dropped not defined." );
	
	last_drop_wave = ( (isdefined( self ) && isdefined( self.wave_dropped )) ? self.wave_dropped : level.CONST_LOOT_LAST_WAVE_DROP_DEFAULT );
	return last_drop_wave;
}

trigger_timeout(secs)
{
	self endon("trigger");
	self endon("special_op_terminated");
	wait(secs);
	self notify("trigger");
}

loot_perk_watcher (perk_string, perk_award)
{
	self endon("death");
	self endon("special_op_terminated");
	
	trigger = spawn("trigger_radius",self.origin,0,64,64);
	if (isDefined(trigger))
	{
		trigger SetCursorHint( "HINT_NOICON" );
		trigger SetHintString( perk_string );
		trigger thread trigger_timeout(level.CONST_LOOT_TIMEOUT);
		trigger waittill("trigger", player ); 
		trigger delete();
		if ( isDefined(player) )
		{ 
			if ( !isDefined(player maps\_perks_sp::find_free_slot()) )
			{
				player maps\_perks_sp::take_perk_by_slot(0);
			}
			player maps\_perks_sp::give_perk_for_a_time(perk_award,level.CONST_PERK_TIMEOUT);
		}
		self delete();
	}
	else
	{
		self delete();
	}
}

loot_drop_perk_on_death ( loot_type, loot_name, model_name )
{
	level endon( "special_op_terminated" );
	self waittill_any( "death", "long_death" );
	
	if( IsDefined(self) )
	{
		loot_model = spawn( "script_model", self.origin + (0,0,32) );
		if ( isDefined(loot_model ) )
		{
			loot_model setmodel( model_name );
			loot_model thread loot_perk_watcher(loot_name, loot_type);
			loot_model thread drop_fx();
			loot_model thread drop_rotate();
			/#	
			// debug
			print3d( loot_model.origin, "perk loot!", (1 ,1, 0), 0.5, 1, 200 );
			#/	
		}
	}	
}


loot_drop_killstreak_on_death ( loot_type )
{
	level endon( "special_op_terminated" );
	self waittill_any( "death", "long_death" );
	if( !IsPlayer(self.attacker) )
	{
		return;
	}
	self.attacker maps\sp_killstreaks\_killstreaks::giveKillstreak( loot_type );
	playFx( level._effect[ "drop_fx" ], self.origin + ( 0, 0, 32 ) );

	/#
	// debug
	print3d( self.origin, "killstreak awarded!", (1 ,1, 0), 0.5, 1, 200 );
	#/	
}

loot_special_watcher (loot_string, loot_type )
{
	self endon("death");
	self endon("special_op_terminated");
	
	trigger = spawn("trigger_radius",self.origin,0,64,64);
	if (isDefined(trigger))
	{
		trigger SetCursorHint( "HINT_NOICON" );
		trigger SetHintString( loot_string );
		trigger thread trigger_timeout(level.CONST_LOOT_TIMEOUT);
		trigger waittill("trigger", player ); 
		trigger delete();
		if ( isDefined(player) )
		{ 
			switch(loot_type)
			{
				case "armor":
					player maps\_so_war_support::give_armor( loot_type );
				break;
				case "laststand":
					player maps\_so_war_support::give_laststand( loot_type );
				break;
				case "friendly_assault":
					player maps\_so_war_support::give_friendlies();
				break;
				default:
					assertmsg("Unhandled special loot case");
				break;
			}
		}
		self delete();
	}
	else
	{
		self delete();
	}
}


loot_drop_special_on_death(  loot_type, loot_name, model_name )
{
	level endon( "special_op_terminated" );
	self waittill_any( "death", "long_death" );
	
	if( IsDefined(self) )
	{
		loot_model = spawn( "script_model", self.origin + (0,0,32) );
		if ( isDefined(loot_model ) )
		{
			loot_model setmodel( model_name );
			loot_model thread loot_special_watcher(loot_name, loot_type);
			loot_model thread drop_fx();
			loot_model thread drop_rotate();
			/#	
			// debug
			print3d( loot_model.origin, "special loot!", (1 ,1, 0), 0.5, 1, 200 );
			#/	
		}
	}	
}

loot_drop_weapon_on_death( loot_class, loot_name, loot_type, model_name, tag )
{
	level endon( "special_op_terminated" );
	
	// Link the model instead of using Attach() because attach
	// actually messes with the AI weapon management logic
	loot_model = spawn( "script_model", self gettagorigin( tag ) );
	loot_model setmodel( model_name );
	loot_model linkto( self, tag, (0, 0, 0), (0, 0, 0) );
	
	self waittill_any( "death", "long_death" );
		
	//assert( isdefined( self ), "Loot carrier self reference not valid after death." );
	if ( !isdefined( self ) )
		return;
	
	// Spawn the loot item
	loot_item = spawn( loot_class, self gettagorigin( tag ) );
	if ( isdefined( loot_type ) && loot_type == "weapon" )
	{
		ammo_in_clip 	= int( max( 1, level.CONST_WEAPON_DROP_AMMO_CLIP * weaponclipsize( loot_name ) ) );
		ammo_in_stock 	= int( max( 1, level.CONST_WEAPON_DROP_AMMO_STOCK * weaponmaxammo( loot_name ) ) );
		
		loot_item itemweaponsetammo( ammo_in_clip, ammo_in_stock );
		
		
		alt_weapon = weaponaltweaponname( loot_name );
		if ( alt_weapon != "none" )
		{
			ammo_alt_clip	= int( max( 1, level.CONST_WEAPON_DROP_ALT_AMMO_CLIP * weaponclipsize( alt_weapon ) ) );
			ammo_alt_stock	= int( max( 1, level.CONST_WEAPON_DROP_ALT_AMMO_STOCK * weaponmaxammo( alt_weapon ) ) );
			
			loot_item itemweaponsetammo( ammo_alt_clip, ammo_alt_stock, 1 );
		}
	}
	
	/#	
	// debug
	print3d( loot_item.origin, "loot!", (1 ,1, 0), 0.5, 1, 200 );
	#/	
	loot_model unlink();
	// Wait at least 0.05 to avoid error: cannot delete during think :-/
	wait 0.05;
	loot_model delete();
}

// displays money FX where an AI died
drop_fx()
{
	level endon( "special_op_terminated" );
	if ( !isdefined( self ) )
		return;
		
	playfxontag( getfx( "drop_fx_on" ), self, "tag_origin" );
}

drop_rotate()
{
	level endon( "special_op_terminated" );
	self endon("death");
	
	if ( !isdefined( self ) )
		return;

	while(1)
	{
		self RotateYaw(0, 1);
		self waittill ("rotatedone");
		self RotateYaw(180, 1);
		self waittill ("rotatedone");
	}
}


loot_item_exist( ref )
{
	return isdefined( level.loot_info_array ) && isdefined( level.loot_info_array[ ref ] );
}

get_loot_ref_by_index( idx )
{
	assert( idx >= level.LOOT_INDEX_START && idx <= level.LOOT_INDEX_END, "Tried to get loot outside of the bounds of the loot indexes." );
	return get_ref_by_index( idx );
}

get_ref_by_index( idx )
{
	return tablelookup( level.LOOT_TABLE, level.TABLE_INDEX, idx, level.TABLE_REF );
}

get_loot_type( ref )
{
	if ( loot_item_exist( ref ) )
		return level.loot_info_array[ ref ].type;
		
	return tablelookup( level.LOOT_TABLE, level.TABLE_REF, ref, level.TABLE_TYPE );
}

get_loot_name( ref )
{
	if ( loot_item_exist( ref ) )
		return level.loot_info_array[ ref ].name;
		
	return tablelookup( level.LOOT_TABLE, level.TABLE_REF, ref, level.TABLE_NAME );
}


get_loot_desc( ref )
{
	if ( loot_item_exist( ref ) )
		return level.loot_info_array[ ref ].desc;
		
	return tablelookup( level.LOOT_TABLE, level.TABLE_REF, ref, level.TABLE_DESC );
}

get_loot_chance( ref )
{
	if ( loot_item_exist( ref ) )
		return level.loot_info_array[ ref ].chance;
		
	return float( tablelookup(level.LOOT_TABLE, level.TABLE_REF, ref, level.TABLE_CHANCE ) );
}

get_loot_wave_unlock( ref )
{
	if ( loot_item_exist( ref ) )
		return level.loot_info_array[ ref ].wave_unlock;
		
	return int( tablelookup( level.LOOT_TABLE, level.TABLE_REF, ref, level.TABLE_WAVE_UNLOCK ) );
}

get_loot_wave_lock( ref )
{
	if ( loot_item_exist( ref ) )
		return level.loot_info_array[ ref ].wave_lock;
		
	return int( tablelookup( level.LOOT_TABLE, level.TABLE_REF, ref, level.TABLE_WAVE_LOCK ) );
}

get_loot_rank( ref )
{
	if ( loot_item_exist( ref ) )
		return level.loot_info_array[ ref ].rank;
		
	return int( tablelookup( level.LOOT_TABLE, level.TABLE_REF, ref, level.TABLE_RANK ) );
}

get_loot_version_by_index( idx )
{
	assert( idx >= level.LOOT_VERSION_INDEX_START && idx <= level.LOOT_VERSION_INDEX_END, "Tried to get loot version outside of the bounds of the loot indexes." );
	return get_ref_by_index( idx );
}

get_loot_versions( ref )
{
	if ( loot_item_exist( ref ) )
		return level.loot_info_array[ ref ].versions;
	
	assert( isdefined( level.loot_version_array ), "The loot version array has not been populated." );
	
	versions = [];
	
	base_ref = ref;
	
	// If weapon remove '_mp' to get the base name
	if ( get_loot_type( ref ) == "weapon" )
		base_ref = getsubstr( ref, 0, ref.size - 3 );
	
	foreach( v in level.loot_version_array )
	{
		if ( issubstr( v, base_ref ) )
		{
			versions[ versions.size ] = v;
		}
	}
	
	// If no versions were found use the original ref item
	if ( !versions.size )
		versions[ versions.size ] = ref;
	
	return versions;
}

get_loot_param( ref )
{
	if ( loot_item_exist( ref ) )
		return level.loot_info_array[ ref ].parameter;
		
	return tablelookup( level.LOOT_TABLE, level.TABLE_REF, ref, level.TABLE_VAR1 );
}