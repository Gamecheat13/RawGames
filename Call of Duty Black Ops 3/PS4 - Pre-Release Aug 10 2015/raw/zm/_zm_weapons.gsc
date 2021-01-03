#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\gametypes\_weapons;

#using scripts\zm\_util;
#using scripts\zm\_bb;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_ballistic_knife;

                                                                                       	                                
                                                                                                                               

#precache( "material", "minimap_icon_mystery_box" );
#precache( "material", "specialty_instakill_zombies" );
#precache( "material", "specialty_firesale_zombies" );
#precache( "string", "ZOMBIE_WEAPON_TOGGLE_DISABLED" );
#precache( "string", "ZOMBIE_WEAPON_TOGGLE_ACTIVATE" );
#precache( "string", "ZOMBIE_WEAPON_TOGGLE_DEACTIVATE" );
#precache( "string", "ZOMBIE_WEAPON_TOGGLE_ACQUIRED" );

#namespace zm_weapons;

function init()
{
	init_weapons();
	init_weapon_upgrade();			//Wall buys
	
	level._weaponobjects_on_player_connect_override = &weaponobjects_on_player_connect_override;

	level._zombiemode_check_firesale_loc_valid_func = &default_check_firesale_loc_valid_func;

	level.missileEntities = [];	

	level thread onPlayerConnect();
}

function onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
	}
}


function onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self thread watchForGrenadeDuds();
		self thread watchForGrenadeLauncherDuds();
		self.staticWeaponsStartTime = getTime();
	}
}

function watchForGrenadeDuds()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	
	while ( true )
	{
		self waittill( "grenade_fire", grenade, weapon );
		if ( !zm_equipment::is_equipment( weapon ) && !zm_utility::is_placeable_mine( weapon ) )
		{
			grenade thread checkGrenadeForDud( weapon, true, self );
			grenade thread watchForScriptExplosion( weapon, true, self );
		}
	}
}

function watchForGrenadeLauncherDuds()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	
	while ( true )
	{
		self waittill( "grenade_launcher_fire", grenade, weapon );
		grenade thread checkGrenadeForDud( weapon, false, self );
		grenade thread watchForScriptExplosion( weapon, false, self );
	}
}


function grenade_safe_to_throw( player, weapon ) 
{
	if ( IsDefined( level.grenade_safe_to_throw ) )
	{
		return self [[level.grenade_safe_to_throw]]( player, weapon );
	}
	return true;
}

function grenade_safe_to_bounce( player, weapon ) 
{
	if ( IsDefined( level.grenade_safe_to_bounce ) )
	{
		return self [[level.grenade_safe_to_bounce]]( player, weapon );
	}
	return true;
}


function makeGrenadeDudAndDestroy()
{
	self endon("death");
	self notify("grenade_dud");
	self makeGrenadeDud();
	wait 3;
	if (isdefined(self))
	{
		self delete();
	}
}

function checkGrenadeForDud( weapon, isThrownGrenade, player )
{
	self endon("death");
	player endon("zombify");

	if ( !IsDefined( self ) )
	{
		// player must've been downed while throwing it
		return;
	}

	if ( !self grenade_safe_to_throw( player, weapon ) )
	{
		self thread makeGrenadeDudAndDestroy();
		return;
	}

	for ( ;; )
	{
		self util::waittill_any_timeout( 0.25, "grenade_bounce", "stationary" );
		if ( !self grenade_safe_to_bounce( player, weapon ) )
		{
			self thread makeGrenadeDudAndDestroy();
			return;
		}
	}
}


function wait_explode()
{
	self endon("grenade_dud");
	self endon("done");
	self waittill( "explode", position );
	level.explode_position = position;
	level.explode_position_valid = 1;
	self notify("done");
}

function wait_timeout(time)
{
	self endon("grenade_dud");
	self endon("done");
	self endon( "explode" );
	wait( time );
	if (IsDefined(self))
		self notify("done");
}

function wait_for_explosion(time)
{
	level.explode_position = (0,0,0);
	level.explode_position_valid = 0;
	self thread wait_explode();
	self thread wait_timeout(time);
	self waittill("done");
	self notify("death_or_explode",level.explode_position_valid,level.explode_position);
}

function watchForScriptExplosion( weapon, isThrownGrenade, player )
{
	self endon("grenade_dud");

	if ( zm_utility::is_lethal_grenade( weapon ) || weapon.isLauncher ) 
	{
		self thread wait_for_explosion(20);
		self waittill( "death_or_explode", exploded, position );
		if ( exploded )
		{
			level notify( "grenade_exploded", position, 256, 300, 75 );
		}
	}
}

// must be called on player; 
function get_nonalternate_weapon( weapon )
{
	alt = weapon.altWeapon;
	if ( alt.rootWeapon != level.weaponNone )
	{
		return alt;
	}

	return weapon; 
}

function switch_from_alt_weapon( weapon )
{
	alt = weapon.altWeapon;
	if ( alt.rootWeapon != level.weaponNone )
	{
		self SwitchToWeaponImmediate( alt );
		self util::waittill_any_timeout( 1, "weapon_change_complete" );

		return alt;
	}

	return weapon; 
}


function give_fallback_weapon()
{
	self GiveWeapon( level.weaponZMFists );
	self SwitchToWeapon( level.weaponZMFists );
}

function take_fallback_weapon()
{
	if ( self HasWeapon( level.weaponZMFists ) )
	{
		self TakeWeapon( level.weaponZMFists );
	}
}

function switch_back_primary_weapon( oldprimary )
{
	if ( ( isdefined( self.laststand ) && self.laststand ) )
	{
		return;
	}

	primaryWeapons = self GetWeaponsListPrimaries();
	if ( isdefined( oldprimary ) && IsInArray( primaryWeapons, oldprimary ) )
	{
		self SwitchToWeapon( oldprimary );
	}
	else if ( primaryWeapons.size > 0 )
	{
		self SwitchToWeapon( primaryWeapons[0] );
	}
}

function add_retrievable_knife_init_name( name )
{
	if ( !isdefined( level.retrievable_knife_init_names ) )
	{
		level.retrievable_knife_init_names = [];
	}

	level.retrievable_knife_init_names[level.retrievable_knife_init_names.size] = name;
}

function watchWeaponUsageZM()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	for ( ;; )
	{	
		self waittill ( "weapon_fired", curWeapon );
		self.lastFireTime = GetTime();

		self.hasDoneCombat = true;
		
		switch ( curWeapon.weapClass )
		{
			case "rifle":
			case "pistol":
			case "pistolspread":
			case "pistol spread":
			case "mg":
			case "smg":
			case "spread":
				self weapons::trackWeaponFire( curWeapon );
				level.globalShotsFired++;
				break;
			case "rocketlauncher":
			case "grenade":
				self AddWeaponStat( curWeapon, "shots", 1 );
				
				break;
				
			default:
				break;
		}
	}
}

function trackWeaponZM()
{
	self.currentWeapon = self getCurrentWeapon();
	self.currentTime = getTime();
	spawnid = getplayerspawnid( self );

	while ( 1 )
	{
		event = self util::waittill_any_return( "weapon_change", "death", "disconnect", "bled_out" );
		newTime = getTime();

		if ( event == "weapon_change" )
		{
			newWeapon = self getCurrentWeapon();
			if ( newWeapon != level.weaponNone && newWeapon != self.currentWeapon )
			{
				updateLastHeldWeaponTimingsZM( newTime );
				
				self.currentWeapon = newWeapon;
				self.currentTime = newTime;
			}
		}
		else
		{
			if ( event != "death" && event != "disconnect" )
			{
				updateWeaponTimingsZM( newTime );
			}
			
			return;
		}
	}
}

function updateLastHeldWeaponTimingsZM( newTime )
{
	if ( isDefined( self.currentWeapon ) && isDefined( self.currentTime ) )
	{
		curweapon = self.currentWeapon;
		totalTime = int ( ( newTime - self.currentTime ) / 1000 );
		if ( totalTime > 0 )
		{
			self AddWeaponStat( curweapon, "timeUsed", totalTime );
		}
	}
}

function updateWeaponTimingsZM( newTime )
{
	if ( self util::is_bot() )
	{
		return;
	}

	updateLastHeldWeaponTimingsZM( newTime );
	
	if ( !isDefined( self.staticWeaponsStartTime ) )
	{
		return;
	}
	
	totalTime = int ( ( newTime - self.staticWeaponsStartTime ) / 1000 );
	
	if ( totalTime < 0 )
	{
		return;
	}
	
	self.staticWeaponsStartTime = newTime;
}


function watchWeaponChangeZM()
{
	self endon("death");
	self endon("disconnect");
	
	self.lastDroppableWeapon = self GetCurrentWeapon();
	self.hitsThisMag = [];

	weapon = self getCurrentWeapon();

	while ( 1 )
	{
		previous_weapon = self GetCurrentWeapon();
		self waittill( "weapon_change", newWeapon );
		
		if ( weapons::mayDropWeapon( newWeapon ) )
		{
			self.lastDroppableWeapon = newWeapon;
		}
	}
}


function weaponobjects_on_player_connect_override_internal()
{
	self weaponobjects::createBaseWatchers();

	//Ensure that the watcher name is the weapon name minus _mp if you want to add weapon specific functionality.
	self zm_placeable_mine::setup_watchers();

	for ( i = 0; i < level.retrievable_knife_init_names.size; i++ )
	{
		self createBallisticKnifeWatcher_zm( level.retrievable_knife_init_names[i] );
	}

	//set up retrievable specific fields
	self weaponobjects::setupRetrievableWatcher();
	
	if ( !IsDefined(self.weaponObjectWatcherArray) )
	{
		self.weaponObjectWatcherArray = [];
	}

	self.concussionEndTime = 0;
	self.hasDoneCombat = false;
	self.lastFireTime = 0;
	self thread watchWeaponUsageZM();
	self thread weapons::watchGrenadeUsage();
	self thread weapons::watchMissileUsage();
	self thread watchWeaponChangeZM();
	self thread trackWeaponZM();
	
	self notify("weapon_watchers_created");
}

function weaponobjects_on_player_connect_override()
{
	add_retrievable_knife_init_name( "knife_ballistic" );
	add_retrievable_knife_init_name( "knife_ballistic_upgraded" );

	callback::on_connect( &weaponobjects_on_player_connect_override_internal);
}

function createBallisticKnifeWatcher_zm( weaponName ) // self == player
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher( weaponName, self.team );
	watcher.onSpawn = &_zm_weap_ballistic_knife::on_spawn;
	watcher.onSpawnRetrieveTriggers = &_zm_weap_ballistic_knife::on_spawn_retrieve_trigger;
	watcher.storeDifferentObject = true;
	watcher.headIcon = false;
}

function default_check_firesale_loc_valid_func()
{
	return true;
}

function add_zombie_weapon( weapon_name, upgrade_name, hint, cost, weaponVO, weaponVOresp, ammo_cost, create_vox )
{
	weapon = GetWeapon( weapon_name );
	upgrade = undefined;
	if ( IsDefined( upgrade_name ) )
	{
		upgrade = GetWeapon( upgrade_name );
	}
	if ( IsDefined( level.zombie_include_weapons ) && !IsDefined( level.zombie_include_weapons[weapon] ) )
	{
		return;
	}

	struct = SpawnStruct();

	if ( !IsDefined( level.zombie_weapons ) )
	{
		level.zombie_weapons = [];
	}
	if ( !IsDefined( level.zombie_weapons_upgraded ) )
	{
		level.zombie_weapons_upgraded = [];
	}
	if ( isDefined(upgrade_name) )
	{
		level.zombie_weapons_upgraded[upgrade] = weapon;
	}

	struct.weapon = weapon;
	struct.upgrade = upgrade;
	struct.weapon_classname = "weapon_" + weapon_name + "_zm";
	struct.hint = &"ZOMBIE_WEAPONCOSTONLYFILL"; //hint;
	struct.cost = cost;
	struct.vox = weaponVO;
	struct.vox_response = weaponVOresp;
	
/#	println( "ZM >> Looking for weapon - " + weapon_name );	#/
	
	struct.is_in_box = level.zombie_include_weapons[weapon];

	if ( !IsDefined( ammo_cost ) )
	{
		ammo_cost = zm_utility::round_up_to_ten( int( cost * 0.5 ) );
	}
	struct.ammo_cost = ammo_cost;
	
	if ( weapon.isEmp || (IsDefined( upgrade ) && upgrade.isEmp ) )
	{
		level.should_watch_for_emp = true;
	}

	level.zombie_weapons[weapon] = struct;

	if ( zm_pap_util::can_swap_attachments() && isdefined( upgrade_name ) )
	{
		add_attachments( weapon_name, upgrade_name );
	}
	
	if ( isDefined( create_vox ) )
	{
		level.vox zm_audio::zmbVoxAdd( "player", "weapon_pickup", weapon, weaponVO ,undefined);
	}
	
/#
	if ( isdefined( level.devgui_add_weapon ) )
	{
		[[level.devgui_add_weapon]]( weapon, upgrade, hint, cost, weaponVO, weaponVOresp, ammo_cost );
	}
#/	
}

function add_attachments( weapon, upgrade )
{
	table = "gamedata/weapons/zm/pap_attach.csv";
	if ( isdefined( level.weapon_attachment_table ) )
	{
		table = level.weapon_attachment_table;
	}

	row = TableLookupRowNum( table, 0, upgrade );
	if ( row > -1 )
	{
		level.zombie_weapons[weapon].default_attachment = TableLookUp( table, 0, upgrade.name, 1 );
		level.zombie_weapons[weapon].addon_attachments = [];
		index = 2;
		next_addon = TableLookUp( table, 0, upgrade.name, index );
		while ( isdefined( next_addon ) && next_addon.size > 0 )
		{
			level.zombie_weapons[weapon].addon_attachments[level.zombie_weapons[weapon].addon_attachments.size] = next_addon;
			index++;
			next_addon = TableLookUp( table, 0, upgrade.name, index );
		}
	}
}


function is_weapon_included( weapon )
{
	if ( !IsDefined( level.zombie_weapons ) )
	{
		return false;
	}

	return IsDefined( level.zombie_weapons[weapon.rootWeapon] );
}

function is_weapon_or_base_included( weapon )
{
	return (IsDefined( level.zombie_weapons[weapon.rootWeapon] ) || IsDefined( level.zombie_weapons[get_base_weapon( weapon )] ));
}


function include_zombie_weapon( weapon_name, in_box )
{
	if ( !IsDefined( level.zombie_include_weapons ) )
	{
		level.zombie_include_weapons = [];
	}
	if ( !isDefined( in_box ) )
	{
		in_box = true;
	}

/#	println( "ZM >> Including weapon - " + weapon_name );	#/
	level.zombie_include_weapons[GetWeapon( weapon_name )] = in_box;
}


function init_weapons()
{
	if ( IsDefined( level._zombie_custom_add_weapons ) )
	{
		[[level._zombie_custom_add_weapons]]();
	}
}   

function add_limited_weapon( weapon_name, amount )
{
	if ( !IsDefined( level.limited_weapons ) )
	{
		level.limited_weapons = [];
	}

	level.limited_weapons[GetWeapon( weapon_name )] = amount;
}


//*****************************************************************************
//*****************************************************************************

function limited_weapon_below_quota( weapon, ignore_player, pap_triggers )
{
	if ( IsDefined( level.limited_weapons[weapon] ) )
	{
		if ( !isdefined( pap_triggers ) )
		{
			pap_triggers = zm_pap_util::get_triggers();
		}

		if ( ( isdefined( level.no_limited_weapons ) && level.no_limited_weapons ) )
		{
			return false;
		}
		
		upgradedweapon = weapon;
		if ( IsDefined( level.zombie_weapons[weapon] ) && IsDefined( level.zombie_weapons[weapon].upgrade ) )
		{
			upgradedweapon = level.zombie_weapons[weapon].upgrade;
		}

		players = GetPlayers();

		count = 0;
		limit = level.limited_weapons[weapon];

		for ( i = 0; i < players.size; i++ )
		{
			if ( isdefined( ignore_player ) && ignore_player == players[i] )
			{
				continue;
			}

			if ( players[i] has_weapon_or_upgrade( weapon ) )
			{
				count++;
				if ( count >= limit )
				{
					return false;
				}
			}
		}

		// Check the pack a punch machines to see if they are holding what we're looking for
		for ( k = 0; k < pap_triggers.size; k++ )
		{
			if ( IsDefined( pap_triggers[k].current_weapon ) && (pap_triggers[k].current_weapon == weapon || pap_triggers[k].current_weapon == upgradedweapon) )
			{
				count++;
				if ( count >= limit )
				{
					return false;
				}
			}
		}

		// Check the other boxes so we don't offer something currently being offered during a fire sale
		for ( chestIndex = 0; chestIndex < level.chests.size; chestIndex++ )
		{
			if ( IsDefined( level.chests[chestIndex].zbarrier.weapon ) && level.chests[chestIndex].zbarrier.weapon == weapon )
			{
				count++;
				if ( count >= limit )
				{
					return false;
				}
			}
		}
		
		if ( IsDefined( level.custom_limited_weapon_checks ) )
		{
			foreach ( check in level.custom_limited_weapon_checks )
			{
				count += [[check]]( weapon );
			}
			if ( count >= limit )
			{
				return false;
			}
		}

		if ( isdefined( level.random_weapon_powerups ) )
		{
			for ( powerupIndex = 0; powerupIndex < level.random_weapon_powerups.size; powerupIndex++ )
			{
				if ( IsDefined( level.random_weapon_powerups[powerupIndex] ) && level.random_weapon_powerups[powerupIndex].base_weapon == weapon )
				{
					count++;
					if ( count >= limit )
					{
						return false;
					}
				}
			}
		}
	}

	return true;
}


function add_custom_limited_weapon_check( callback )
{
	if ( !IsDefined( level.custom_limited_weapon_checks ) )
	{
		level.custom_limited_weapon_checks = [];
	}

	level.custom_limited_weapon_checks[level.custom_limited_weapon_checks.size] = callback;
}


//*****************************************************************************
//*****************************************************************************

function add_weapon_to_content( weapon_name, package )
{
	if ( !IsDefined( level.content_weapons ) )
	{
		level.content_weapons = [];
	}

	level.content_weapons[GetWeapon( weapon_name )] = package;
}                                          	

function player_can_use_content( weapon )
{
	if ( IsDefined( level.content_weapons ) )
	{
		if ( IsDefined( level.content_weapons[weapon] ) )
		{
			return self HasDLCAvailable( level.content_weapons[weapon] );
		}
	}

	return true;
} 

//*****************************************************************************
//*****************************************************************************

function init_spawnable_weapon_upgrade()
{
 
	// spawn_list construction must be matched in _zm_weapons.csc function init() or your level will not load.
	
	spawn_list = [];
	spawnable_weapon_spawns = struct::get_array( "weapon_upgrade", "targetname" );
	spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, struct::get_array( "bowie_upgrade", "targetname" ), true, false );
	spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, struct::get_array( "sickle_upgrade", "targetname" ), true, false );
	spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, struct::get_array( "tazer_upgrade", "targetname" ), true, false );
	spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, struct::get_array( "buildable_wallbuy", "targetname" ), true, false );
	
	if ( ( isdefined( level.use_autofill_wallbuy ) && level.use_autofill_wallbuy ) )
	{
		spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, level.active_autofill_wallbuys, true, false );
	}
	
	if ( !( isdefined( level.headshots_only ) && level.headshots_only ) )
	{
		spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, struct::get_array( "claymore_purchase", "targetname" ), true, false );
	}
	
	location = level.scr_zm_map_start_location;
	if ( (location == "default" || location == "") && IsDefined( level.default_start_location ) )
	{
		location = level.default_start_location;
	}	

	match_string = level.scr_zm_ui_gametype;
	if ( "" != location )
	{
		match_string = match_string + "_" + location;
	}
	match_string_plus_space = " " + match_string;

	for ( i = 0; i < spawnable_weapon_spawns.size; i++ )
	{
		spawnable_weapon = spawnable_weapon_spawns[i];

		spawnable_weapon.weapon = GetWeapon( spawnable_weapon.zombie_weapon_upgrade );
		if ( isDefined( spawnable_weapon.zombie_weapon_upgrade ) && spawnable_weapon.weapon.isGrenadeWeapon && ( isdefined( level.headshots_only ) && level.headshots_only ) )
		{
			continue;
		}
		
		if ( !isdefined( spawnable_weapon.script_noteworthy ) || spawnable_weapon.script_noteworthy == "" )
		{
			spawn_list[spawn_list.size] = spawnable_weapon;
		}
		else
		{
			matches = strTok( spawnable_weapon.script_noteworthy, "," );

			for ( j = 0; j < matches.size; j++ )
			{
				if ( matches[j] == match_string || matches[j] == match_string_plus_space )
				{
					spawn_list[spawn_list.size] = spawnable_weapon;
				}
			}
			
		}
	}
		
	tempModel = Spawn( "script_model", (0,0,0) );
	
	for ( i = 0; i < spawn_list.size; i++ )
	{
		clientFieldName = spawn_list[i].zombie_weapon_upgrade + "_" + spawn_list[i].origin;  // Name has origin appended, in case there are more than one of the same weapon placed.
		
		numBits = 2;
		
		if ( isdefined( level._wallbuy_override_num_bits ) )
		{
			numBits = level._wallbuy_override_num_bits;
		}
		
		clientfield::register( "world", clientFieldName, 1, numBits, "int" ); // 2 bit int client field - bit 1 : 0 = not bought 1 = bought.  bit 2: 0 = not hacked 1 = hacked.

		target_struct = struct::get( spawn_list[i].target, "targetname" );
		
		if ( spawn_list[i].targetname == "buildable_wallbuy" )
		{
			// For buildable wallbuys we defer the remainder of the initialization until add_dynamic_wallbuy() is called 
			// we also need to register an additional clientfield for transferring the weapon index 
			bits = 4;
			if ( IsDefined( level.buildable_wallbuy_weapons ) )
			{
				bits = GetMinBitCountForNum( level.buildable_wallbuy_weapons.size + 1 );
			}
			clientfield::register( "world", clientfieldName + "_idx", 1, bits, "int" );
			spawn_list[i].clientfieldName = clientfieldName;
			continue;
		}

		unitrigger_stub = spawnstruct();
		unitrigger_stub.origin = spawn_list[i].origin;
		unitrigger_stub.angles = spawn_list[i].angles;
		
		tempModel.origin = spawn_list[i].origin;
		tempModel.angles = spawn_list[i].angles;
		
		mins = undefined;
		maxs = undefined;
		absMins = undefined;
		absMaxs = undefined;
		
		tempModel setModel( target_struct.model );

		tempModel UseWeaponHideTags( spawn_list[i].weapon );
		
		mins = tempModel GetMins();
		maxs = tempModel GetMaxs();
		
		absMins = tempModel GetAbsMins();
		absMaxs = tempModel GetAbsMaxs();
		
		bounds = absMaxs - absMins;
		
		unitrigger_stub.script_length = bounds[0] * 0.25;
		unitrigger_stub.script_width = bounds[1];
		unitrigger_stub.script_height = bounds[2];

		unitrigger_stub.origin -= (AnglesToRight( unitrigger_stub.angles) * (unitrigger_stub.script_length * 0.4));
		
		unitrigger_stub.target = spawn_list[i].target;
		unitrigger_stub.targetname = spawn_list[i].targetname;
		
		unitrigger_stub.cursor_hint = "HINT_NOICON";
		
		if ( spawn_list[i].targetname == "weapon_upgrade" )
		{
			unitrigger_stub.cost = get_weapon_cost( spawn_list[i].weapon );
			unitrigger_stub.hint_string = get_weapon_hint( spawn_list[i].weapon ); 
			unitrigger_stub.hint_parm1 = unitrigger_stub.cost;
			unitrigger_stub.cursor_hint = "HINT_WEAPON";
			unitrigger_stub.cursor_hint_weapon = spawn_list[i].weapon;
		}
		
		unitrigger_stub.weapon = spawn_list[i].weapon;
			
		unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
		unitrigger_stub.require_look_at = true;
		if ( ( isdefined( spawn_list[i].require_look_from ) && spawn_list[i].require_look_from ) )
		{
			unitrigger_stub.require_look_from = true;
		}

		unitrigger_stub.clientFieldName = clientFieldName;
		zm_unitrigger::unitrigger_force_per_player_triggers( unitrigger_stub, true );
		
		if ( unitrigger_stub.weapon.isMeleeWeapon || unitrigger_stub.weapon.isGrenadeWeapon )
		{
			if ( unitrigger_stub.weapon.name == "tazer_knuckles" && IsDefined( level.taser_trig_adjustment ) )
			{
				unitrigger_stub.origin = unitrigger_stub.origin + level.taser_trig_adjustment;
			}
			zm_unitrigger::register_static_unitrigger( unitrigger_stub, &weapon_spawn_think );
		}
		else
		{
			unitrigger_stub.prompt_and_visibility_func = &wall_weapon_update_prompt;
			zm_unitrigger::register_static_unitrigger( unitrigger_stub, &weapon_spawn_think );
		}
		
		spawn_list[i].trigger_stub = unitrigger_stub;
		
	}
	
	level._spawned_wallbuys = spawn_list;
	
	tempModel delete();
	
}

function add_dynamic_wallbuy( weapon, wallbuy, pristine )
{
	spawned_wallbuy = undefined;

	// spawned_wallbuy is roughly equivalent to spawn_list[i] in init_spawnable_weapon_upgrade()
	// find the appropriate item
	for ( i = 0; i < level._spawned_wallbuys.size; i++ )
	{
		if ( level._spawned_wallbuys[i].target == wallbuy )
		{
			spawned_wallbuy = level._spawned_wallbuys[i];
			break;
		}
		
	}

	if ( !isdefined( spawned_wallbuy ) )
	{
		AssertMsg( "Cannot find dynamic wallbuy" );
		return;		
	}

	if ( isdefined( spawned_wallbuy.trigger_stub ) )
	{
		AssertMsg( "Dynamic wallbuy already added" );
		return;		
	}
	
	target_struct = struct::get( wallbuy, "targetname" );

	// this model is similar to tempModel above - it will only be deleted if the weapon exists in the list of known dynamic wallbuy weapons
	wallModel = zm_utility::spawn_weapon_model( weapon, undefined, target_struct.origin, target_struct.angles, undefined ); 

	clientfieldName = spawned_wallbuy.clientfieldName;
	
	model = weapon.worldModel;
	
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = target_struct.origin;
	unitrigger_stub.angles = target_struct.angles;
	
	wallModel.origin = target_struct.origin;
	wallModel.angles = target_struct.angles;
	
	mins = undefined;
	maxs = undefined;
	absMins = undefined;
	absMaxs = undefined;
	
	wallModel setModel( model );

	wallModel UseWeaponHideTags( weapon );
	
	mins = wallModel GetMins();
	maxs = wallModel GetMaxs();
	
	absMins = wallModel GetAbsMins();
	absMaxs = wallModel GetAbsMaxs();
	
	bounds = absMaxs - absMins;
	
	unitrigger_stub.script_length = bounds[0] * 0.25;
	unitrigger_stub.script_width = bounds[1];
	unitrigger_stub.script_height = bounds[2];
		
	unitrigger_stub.origin -= (AnglesToRight( unitrigger_stub.angles) * (unitrigger_stub.script_length * 0.4));
	
	unitrigger_stub.target = spawned_wallbuy.target;
	unitrigger_stub.targetname = "weapon_upgrade";
	
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	
	unitrigger_stub.first_time_triggered = !pristine;
	if ( !weapon.isMeleeWeapon )
	{
		if ( pristine || zm_utility::is_placeable_mine( weapon ) )
		{
			unitrigger_stub.hint_string = get_weapon_hint( weapon );
		}
		else
		{
			unitrigger_stub.hint_string = get_weapon_hint_ammo();
		}
		unitrigger_stub.cost = get_weapon_cost( weapon );
		unitrigger_stub.hint_parm1 = unitrigger_stub.cost;
	}
	
	unitrigger_stub.weapon = weapon;
	unitrigger_stub.weapon_upgrade = weapon;
		
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.require_look_at = true;
	unitrigger_stub.clientFieldName = clientFieldName;
	zm_unitrigger::unitrigger_force_per_player_triggers( unitrigger_stub, true );
	
	if ( weapon.isMeleeWeapon )
	{
		if ( weapon == "tazer_knuckles" && IsDefined(level.taser_trig_adjustment ) )
		{
			unitrigger_stub.origin = unitrigger_stub.origin + level.taser_trig_adjustment;
		}

		zm_melee_weapon::add_stub( unitrigger_stub, weapon );
		zm_unitrigger::register_static_unitrigger(unitrigger_stub, &zm_melee_weapon::melee_weapon_think);
	}
	else
	{
		unitrigger_stub.prompt_and_visibility_func = &wall_weapon_update_prompt;
		zm_unitrigger::register_static_unitrigger( unitrigger_stub, &weapon_spawn_think );
	}
	
	spawned_wallbuy.trigger_stub = unitrigger_stub;
	
	// see if this is a known weapon for dynamic wallbuys
	weaponidx = undefined;
	if ( isdefined( level.buildable_wallbuy_weapons ) )
	{
		for ( i = 0; i < level.buildable_wallbuy_weapons.size; i++ )
		{
			if ( weapon == level.buildable_wallbuy_weapons[i] )
			{
				weaponidx = i;
				break;
			}
		}
	}

	if ( isdefined( weaponidx ) )
	{
		level clientfield::set( clientFieldName + "_idx", weaponidx + 1 );
		wallModel delete();
		if ( !pristine )
		{
			level clientfield::set( clientFieldName, 1 );
		}
		
	}
	else
	{
		// unknown weapon - should probably be an error
		level clientfield::set( clientFieldName, 1 );
		wallModel show();
	}
}


function wall_weapon_update_prompt( player )
{
	weapon = self.stub.weapon;

	// Allow people to get ammo off the wall for upgraded weapons
	player_has_weapon = player has_weapon_or_upgrade( weapon ); 

	// Check for shared ammo weapon
	if ( !player_has_weapon && ( isdefined( level.weapons_using_ammo_sharing ) && level.weapons_using_ammo_sharing ) )
	{
		shared_ammo_weapon = player get_shared_ammo_weapon( self.zombie_weapon_upgrade );
		if ( IsDefined( shared_ammo_weapon ) )
		{
			weapon = shared_ammo_weapon;
			player_has_weapon = true;
		}
	}

	if ( !player_has_weapon )
	{
		self.stub.cursor_hint = "HINT_WEAPON";
		cost = get_weapon_cost( weapon );
		self.stub.hint_string = &"ZOMBIE_WEAPONCOSTONLYFILL"; 			
		self SetHintString( self.stub.hint_string, cost);
	}
	else if ( ( isdefined( level.use_legacy_weapon_prompt_format ) && level.use_legacy_weapon_prompt_format ) )
	{
		cost = get_weapon_cost( weapon );
		ammo_cost = get_ammo_cost( weapon );
		self.stub.hint_string = get_weapon_hint_ammo(); 
		self SetHintString( self.stub.hint_string, cost, ammo_cost );
	} 
	else
	{
		if ( player has_upgrade( weapon ) )
		{
			ammo_cost = get_upgraded_ammo_cost( weapon ); 
		}
		else
		{
			ammo_cost = get_ammo_cost( weapon );
		}
		self.stub.hint_string = &"ZOMBIE_WEAPONAMMOONLY"; //get_weapon_hint_ammo(); 
		self SetHintString( self.stub.hint_string, ammo_cost );
	}

	self.stub.cursor_hint = "HINT_WEAPON";
	self.stub.cursor_hint_weapon = weapon;
	self setCursorHint( self.stub.cursor_hint, self.stub.cursor_hint_weapon ); 

	return true;
}


function reset_wallbuy_internal( set_hint_string )
{
	if ( ( isdefined( self.first_time_triggered ) && self.first_time_triggered ) )
	{
		self.first_time_triggered = false;
		
		if ( isdefined( self.clientFieldName ) )
		{
			level clientfield::set( self.clientFieldName, 0 );
		}
		
		if ( set_hint_string )
		{
			hint_string = get_weapon_hint( self.weapon ); 
			cost = get_weapon_cost( self.weapon );
	
			self SetHintString( hint_string, cost ); 			
		}
	}	
}

function reset_wallbuys()
{
	weapon_spawns = [];
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname");

	melee_and_grenade_spawns = [];
	melee_and_grenade_spawns = GetEntArray( "bowie_upgrade", "targetname" );
	melee_and_grenade_spawns = ArrayCombine( melee_and_grenade_spawns, GetEntArray( "sickle_upgrade", "targetname" ), true, false );
	melee_and_grenade_spawns = ArrayCombine( melee_and_grenade_spawns, GetEntArray( "tazer_upgrade", "targetname" ), true, false );
	
	if ( !( isdefined( level.headshots_only ) && level.headshots_only ) )
	{
		melee_and_grenade_spawns = ArrayCombine( melee_and_grenade_spawns, GetEntArray( "claymore_purchase", "targetname" ), true, false );	
	}

	for ( i = 0; i < weapon_spawns.size; i++ )
	{
		weapon_spawns[i].weapon = GetWeapon( weapon_spawns[i].zombie_weapon_upgrade );
		weapon_spawns[i] reset_wallbuy_internal( true );
	}
	
	for ( i = 0; i < melee_and_grenade_spawns.size; i++ )
	{
		melee_and_grenade_spawns[i].weapon = GetWeapon( melee_and_grenade_spawns[i].zombie_weapon_upgrade );
		melee_and_grenade_spawns[i] reset_wallbuy_internal( false );
	}
	
	if ( isdefined( level._unitriggers ) )
	{
		candidates = [];
		for ( i = 0; i < level._unitriggers.trigger_stubs.size; i++ )
		{
			stub = level._unitriggers.trigger_stubs[i];
			
			tn = stub.targetname;
			
			if ( tn == "weapon_upgrade" || tn == "bowie_upgrade" || tn == "sickle_upgrade" || tn == "tazer_upgrade" || tn == "claymore_purchase" )
			{
				stub.first_time_triggered = false;
				
				if ( isdefined( stub.clientFieldName ) )
				{
					level clientfield::set( stub.clientFieldName, 0 );
				}
				
				if ( tn == "weapon_upgrade" )
				{
					stub.hint_string = get_weapon_hint( stub.weapon );
					stub.cost = get_weapon_cost( stub.weapon );
					stub.hint_parm1 = stub.cost;
				}
			}
		}
	}
}

// For buying weapon upgrades in the environment
function init_weapon_upgrade()
{
	
	init_spawnable_weapon_upgrade();
	
	weapon_spawns = [];
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" ); 

	for ( i = 0; i < weapon_spawns.size; i++ )
	{
		weapon_spawns[i].weapon = GetWeapon( weapon_spawns[i].zombie_weapon_upgrade );

		hint_string = get_weapon_hint( weapon_spawns[i].weapon );
		cost = get_weapon_cost( weapon_spawns[i].weapon );

		weapon_spawns[i] SetHintString( hint_string, cost );
		weapon_spawns[i] setCursorHint( "HINT_NOICON" );
		
		weapon_spawns[i] UseTriggerRequireLookAt();

		weapon_spawns[i] thread weapon_spawn_think();
		model = getent( weapon_spawns[i].target, "targetname" );
		if ( isdefined( model ) )
		{
			model UseWeaponHideTags( weapon_spawns[i].weapon );
			model hide(); 
		} 
	}
}

// returns the trigger hint string for the given weapon
function get_weapon_hint( weapon )
{
	assert( IsDefined( level.zombie_weapons[weapon] ), weapon.name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon].hint;
}

function get_weapon_cost( weapon )
{
	assert( IsDefined( level.zombie_weapons[weapon] ), weapon.name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon].cost;
}

function get_ammo_cost( weapon )
{
	assert( IsDefined( level.zombie_weapons[weapon] ), weapon.name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon].ammo_cost;
}

function get_upgraded_ammo_cost( weapon )
{
	assert( IsDefined( level.zombie_weapons[weapon] ), weapon.name + " was not included or is not part of the zombie weapon list." );

	if (IsDefined(level.zombie_weapons[weapon].upgraded_ammo_cost))
		return level.zombie_weapons[weapon].upgraded_ammo_cost;

	return 4500;
}

function get_is_in_box( weapon )
{
	assert( IsDefined( level.zombie_weapons[weapon] ), weapon.name + " was not included or is not part of the zombie weapon list." );
	
	return level.zombie_weapons[weapon].is_in_box;
}

function weapon_supports_default_attachment( weapon )
{
	weapon = get_base_weapon( weapon );
	attachment = level.zombie_weapons[weapon].default_attachment;

	return isdefined( attachment );
}

function default_attachment( weapon )
{
	weapon = get_base_weapon( weapon );
	attachment = level.zombie_weapons[weapon].default_attachment;

	if ( isdefined( attachment ) )
	{
		return attachment;
	}
	else
	{
		return "none";
	}
}


function weapon_supports_attachments( weapon )
{
	weapon = get_base_weapon( weapon );
	attachments = level.zombie_weapons[weapon].addon_attachments;

	return (isdefined( attachments ) && attachments.size > 1);
}

function random_attachment( weapon, exclude )
{
	lo = 0;
	if ( isdefined( level.zombie_weapons[weapon].addon_attachments ) && level.zombie_weapons[weapon].addon_attachments.size > 0 )
	{
		attachments = level.zombie_weapons[weapon].addon_attachments;
	}
	else
	{
		attachments = weapon.supportedAttachments;
		lo = 1;
	}
	
	minatt = lo;
	if ( isdefined( exclude ) && exclude != "none" )
	{
		minatt = lo + 1;
	}

	if ( attachments.size > minatt )
	{
		while ( 1 )
		{
			idx = randomint( attachments.size - lo ) + lo;
			if ( !isdefined( exclude ) || attachments[idx] != exclude )
			{
				return attachments[idx];
			}
		}
	}

	return "none";
}

function get_attachment_index( weapon )
{
	attachments = weapon.attachments;
	if ( !attachments.size )
	{
		return -1;
	}

	base = weapon.rootWeapon;
	if ( attachments[0] == level.zombie_weapons[base].default_attachment )
	{
		return 0;
	}

	if ( isdefined( level.zombie_weapons[base].addon_attachments ) )
	{
		for ( i = 0; i < level.zombie_weapons[base].addon_attachments.size; i++ )
		{
			if ( level.zombie_weapons[base].addon_attachments[i] == attachments[0] )
			{
				return i + 1;
			}
		}
	}

	/# println("ZM WEAPON ERROR: Unrecognized attachment in weapon " + weapon.name ); #/
	return -1;
}

function weapon_supports_this_attachment( weapon, att )
{
	base = weapon.rootWeapon;
	if ( att == level.zombie_weapons[base].default_attachment )
	{
		return true;
	}

	if ( isdefined( level.zombie_weapons[base].addon_attachments ) )
	{
		for ( i = 0; i < level.zombie_weapons[base].addon_attachments.size; i++ )
		{
			if ( level.zombie_weapons[base].addon_attachments[i] == att )
			{
				return true;
			}
		}
	}

	return false;
}


function get_base_weapon( upgradedweapon )
{
	upgradedweapon = upgradedweapon.rootWeapon;

	if ( IsDefined( level.zombie_weapons_upgraded[upgradedweapon] ) )
	{
		return level.zombie_weapons_upgraded[upgradedweapon];
	}

	return upgradedweapon;
}

// Check to see if this is an upgraded version of another weapon
function get_upgrade_weapon( weapon, add_attachment )
{
	rootWeapon = weapon.rootWeapon;
	newWeapon = rootWeapon;
	baseWeapon = get_base_weapon( weapon );
	
	if ( !is_weapon_upgraded( rootWeapon ) )
	{
		newWeapon = level.zombie_weapons[rootWeapon].upgrade;
	}

	if ( ( isdefined( add_attachment ) && add_attachment ) && zm_pap_util::can_swap_attachments() )
	{
		oldatt = "none";
		if ( weapon.attachments.size )
		{
			oldatt = weapon.attachments[0];
		}
		att = random_attachment( baseWeapon, oldatt );
		newWeapon = GetWeapon( newWeapon.name, att );
	}
	else
	{
		if ( isdefined( level.zombie_weapons[rootWeapon] ) && isdefined( level.zombie_weapons[rootWeapon].default_attachment ) )
		{
			att = level.zombie_weapons[rootWeapon].default_attachment;
			newWeapon = GetWeapon( newWeapon.name, att );
		}
	}
	
	return newWeapon;
}

// Check to see if this is an upgraded version of another weapon
function can_upgrade_weapon( weapon )
{
	if ( weapon == level.weaponNone || weapon == level.weaponZMFists )
	{
		return false;
	}

	rootWeapon = weapon.rootWeapon;

	if ( !is_weapon_upgraded( rootWeapon ) )
	{
		return IsDefined( level.zombie_weapons[rootWeapon].upgrade );
	}

	if ( zm_pap_util::can_swap_attachments() && weapon_supports_attachments( rootWeapon ) )
	{
		return true;
	}

	return false;
}

// Check to see if this is an upgraded version of another weapon
function will_upgrade_weapon_as_attachment( weapon )
{
	if ( weapon == level.weaponNone || weapon == level.weaponZMFists )
	{
		return false;
	}

	rootWeapon = weapon.rootWeapon;

	if ( !is_weapon_upgraded( rootWeapon ) )
	{
		return false;
	}

	if ( zm_pap_util::can_swap_attachments() && weapon_supports_attachments( rootWeapon ) )
	{
		return true;
	}

	return false;
}

// Check to see if this is an upgraded version of another weapon
function is_weapon_upgraded( weapon )
{
	if ( weapon == level.weaponNone || weapon == level.weaponZMFists )
	{
		return false;
	}

	rootWeapon = weapon.rootWeapon;

	if ( IsDefined( level.zombie_weapons_upgraded[rootWeapon] ) )
	{
		return true;
	}

	return false;
}

function get_weapon_with_attachments( weapon )
{
	if ( self HasWeapon( weapon.rootWeapon, true ) )
	{
		return self GetBuildKitWeapon( weapon.rootWeapon );
	}
	
	return undefined; 
}

// Checks if proper weapon, regardless of attachments
// self is a player
function has_weapon_or_attachments( weapon )
{
	if ( self HasWeapon( weapon, true ) )
	{
		return true;
	}
	
	if ( zm_pap_util::can_swap_attachments() )
	{
		rootWeapon = weapon.rootWeapon;
		weapons = self GetWeaponsList( true );
		foreach ( w in weapons )
		{
			if ( rootWeapon == w.rootWeapon )
			{
				return true;
			}
		}
	}
	
	return false;
}


//	Check to see if the player has the upgraded version of the weapon
//	self is a player
function has_upgrade( weapon )
{
	rootWeapon = weapon.rootWeapon;

	has_upgrade = false;
	if ( IsDefined( level.zombie_weapons[rootWeapon ] ) && IsDefined( level.zombie_weapons[rootWeapon ].upgrade ) )
	{
		has_upgrade = self has_weapon_or_attachments( level.zombie_weapons[rootWeapon].upgrade );
	}

	// double check for the bowie variant on the ballistic knife	
	if ( !has_upgrade && rootWeapon.isBallisticKnife )
	{
		has_weapon = self zm_melee_weapon::has_upgraded_ballistic_knife();
	}

	return has_upgrade;
}


//	Check to see if the player has the normal or upgraded weapon
//	self is a player
function has_weapon_or_upgrade( weapon )
{
	rootWeapon = weapon.rootWeapon;

	upgradedweaponname = rootWeapon;
	if ( IsDefined( level.zombie_weapons[rootWeapon] ) && IsDefined( level.zombie_weapons[rootWeapon].upgrade ) )
	{
		upgradedweaponname = level.zombie_weapons[rootWeapon].upgrade;
	}

	has_weapon = false;
	// If the weapon you're checking doesn't exist, it will return undefined
	if ( IsDefined( level.zombie_weapons[rootWeapon] ) )
	{
		has_weapon = self has_weapon_or_attachments( rootWeapon ) || self has_upgrade( rootWeapon );
	}

	// double check for the bowie variant on the ballistic knife
	if ( !has_weapon && level.weaponBallisticKnife == rootWeapon )
	{
		has_weapon = self zm_melee_weapon::has_any_ballistic_knife();
	}

	if ( !has_weapon && zm_equipment::is_equipment( rootWeapon ) )
	{
		has_weapon = self zm_equipment::is_active( rootWeapon );
	}

	return has_weapon;
}


//	A "shared" ammo weapon will allow you to buy ammo off the wall of another weapon
function add_shared_ammo_weapon( weapon, base_weapon )
{
	level.zombie_weapons[ weapon ].shared_ammo_weapon = base_weapon;
}


//	Check if the player has a weapon that can "share" ammo with base_weapon
//	If so, return that weapon.
// self is a player
function get_shared_ammo_weapon( weapon )
{
	rootWeapon = weapon.rootWeapon;
	weapons = self GetWeaponsList( true ); 
	foreach ( w in weapons )
	{
		w = w.rootWeapon;

		// If the weapon isn't in the zombie_weapons list, check to see if it's
		//	in the upgraded weapons list.  If it is, it will provide the
		//	non-upgraded name for us.
		if ( !IsDefined( level.zombie_weapons[w] ) && IsDefined( level.zombie_weapons_upgraded[w] ) )
	    {
	    	// check for an upgraded weapon
			w = level.zombie_weapons_upgraded[w];
		}

		if ( IsDefined( level.zombie_weapons[w] ) && 
		     IsDefined( level.zombie_weapons[w].shared_ammo_weapon ) &&
		     level.zombie_weapons[w].shared_ammo_weapon == rootWeapon )
		{
			return w;
		}
	}
	
	return undefined;
}


//
// For most weapons if a player has any variety of the given weapon whether upgraded, or downgraded or with attachments added or whatever
// this should find it 
//
// This will not find different flavors of ballistic knives
//
function get_player_weapon_with_same_base( weapon )
{
	rootWeapon = weapon.rootWeapon;

	retweapon = self get_weapon_with_attachments( rootWeapon );
	if ( !isdefined( retweapon ) )
	{
		if ( isdefined( level.zombie_weapons[rootWeapon] ) )
		{
			if ( IsDefined(level.zombie_weapons[rootWeapon].upgrade) )
			{
				retweapon = self get_weapon_with_attachments( level.zombie_weapons[rootWeapon].upgrade );
			}
		}
		else if ( IsDefined( level.zombie_weapons_upgraded[rootWeapon] ) )
		{
			retweapon = self get_weapon_with_attachments( level.zombie_weapons_upgraded[rootWeapon] );
		}
	}

	return retweapon;
}

function get_weapon_hint_ammo()
{
	if ( isDefined( level.has_pack_a_punch ) && !level.has_pack_a_punch )
	{
		return &"ZOMBIE_WEAPONCOSTAMMO"; 
	}
	else
	{
		return &"ZOMBIE_WEAPONCOSTAMMO_UPGRADE"; 
	}
}


function weapon_set_first_time_hint( cost, ammo_cost )
{
	self SetHintString( get_weapon_hint_ammo(), cost, ammo_cost ); 

}

function weapon_spawn_think()
{
	cost = get_weapon_cost( self.weapon );
	ammo_cost = get_ammo_cost( self.weapon );
	is_grenade = self.weapon.isGrenadeWeapon;
	shared_ammo_weapon = undefined;
	
	second_endon = undefined;
	
	if ( isdefined( self.stub ) )
	{
		second_endon = "kill_trigger";
		self.first_time_triggered = self.stub.first_time_triggered;
	}
	
	if ( IsDefined( self.stub ) && ( isdefined( self.stub.trigger_per_player ) && self.stub.trigger_per_player ) )
	{
		self thread zm_magicbox::decide_hide_show_hint( "stop_hint_logic", second_endon, self.parent_player );
	}
	else
	{
		self thread zm_magicbox::decide_hide_show_hint( "stop_hint_logic", second_endon );
	}
	
	// we may want this instead
	//   if( zm_utility::is_offhand_weapon( self.zombie_weapon_upgrade ) )
	if ( is_grenade || zm_utility::is_melee_weapon( self.weapon ) )
	{
		self.first_time_triggered = false; 
		hint = get_weapon_hint( self.weapon );
		self SetHintString( hint, cost ); 

		cursor_hint = "HINT_WEAPON";
		cursor_hint_weapon = self.weapon;
		self setCursorHint( cursor_hint, cursor_hint_weapon ); 
	}
	else if ( !isdefined( self.first_time_triggered ) )
	{
		self.first_time_triggered = false; 
		if ( isdefined( self.stub ) )
		{
			self.stub.first_time_triggered = false;
		}
	}
	else if ( self.first_time_triggered )
	{
		if ( ( isdefined( level.use_legacy_weapon_prompt_format ) && level.use_legacy_weapon_prompt_format ) )
		{
			self weapon_set_first_time_hint( cost, get_ammo_cost( self.weapon ) );
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

		if ( !player zm_magicbox::can_buy_weapon() )
		{
			wait( 0.1 );
			continue;
		}

		if ( isdefined( self.stub ) && ( isdefined( self.stub.require_look_from ) && self.stub.require_look_from ) )
		{
			toplayer = player util::get_eye() - self.origin;
			forward = -1 * AnglesToRight( self.angles );
			dot = VectorDot( toplayer,forward );
			if ( dot < 0 )
			{
				continue;
			}
		}

		
		if ( player zm_utility::has_powerup_weapon() )
		{
			wait( 0.1 );
			continue;
		}

		// Allow people to get ammo off the wall for upgraded weapons
		player_has_weapon = player has_weapon_or_upgrade( self.weapon );

		// Check for shared ammo weapon
		if ( !player_has_weapon && ( isdefined( level.weapons_using_ammo_sharing ) && level.weapons_using_ammo_sharing ) )
		{
			shared_ammo_weapon = player get_shared_ammo_weapon( self.weapon );
			if ( IsDefined( shared_ammo_weapon ) )
			{
				player_has_weapon = true;
			}
		}
		
		// If the player has the weapon, we may want to overide it with a persistent ability "reward" weapon
		if ( ( isdefined( level.pers_upgrade_nube ) && level.pers_upgrade_nube ) )
		{
			player_has_weapon = zm_pers_upgrades_functions::pers_nube_should_we_give_raygun( player_has_weapon, player, self.weapon );
		}
		
		cost = get_weapon_cost( self.weapon );
		// If the player has the double points persistent upgrade, reduce the "cost" and "ammo cost"
		if ( player zm_pers_upgrades_functions::is_pers_double_points_active() )
		{
			cost = int( cost / 2 );
		}

		if ( IsDefined(player.check_override_wallbuy_purchase) )
		{
			if ( player [[player.check_override_wallbuy_purchase]]( self.weapon, self ) )
			{
				continue; 
			}
		}
				
		// If the player does not have the weapon
		if ( !player_has_weapon )
		{
			// Else make the weapon show and give it
			if ( player.score >= cost )
			{
				if ( self.first_time_triggered == false )
				{
					self show_all_weapon_buys( player, cost, ammo_cost, is_grenade );
				}

				player zm_score::minus_to_player_score( cost ); 
			
				level notify( "weapon_bought", player, self.weapon );
				
				if ( self.weapon.isriotshield ) 
				{
					player zm_equipment::give( self.weapon );
					if ( isdefined( player.player_shield_reset_health ) )
					{
						player [[player.player_shield_reset_health]]();
					}
				}
				else
				{
					if ( zm_utility::is_lethal_grenade( self.weapon ) )
					{
						player takeweapon( player zm_utility::get_player_lethal_grenade() );
						player zm_utility::set_player_lethal_grenade( self.weapon );
					}

					weapon = self.weapon;

					// Is the player persistent ability "nube" active?
					if ( ( isdefined( level.pers_upgrade_nube ) && level.pers_upgrade_nube ) )
					{
						weapon = zm_pers_upgrades_functions::pers_nube_weapon_upgrade_check( player, weapon );
					}

					if ( player bgb::is_enabled( "zm_bgb_wall_power" ) && can_upgrade_weapon( weapon ) )
					{
						weapon = get_upgrade_weapon( weapon );
						player notify( "zm_bgb_wall_power_used" );
					}
					
					player weapon_give( weapon );
				}
								
				//stat tracking
				player zm_stats::increment_client_stat( "wallbuy_weapons_purchased" );
				player zm_stats::increment_player_stat( "wallbuy_weapons_purchased" );
				bb::LogPurchaseEvent(player, self, cost, weapon.name, player has_upgrade(weapon), "_weapon", "_purchase");
				
			}
			else
			{
				zm_utility::play_sound_on_ent( "no_purchase" );
				player zm_audio::create_and_play_dialog( "general", "outofmoney" );
				
			}
		}
		else // If the player HAS the weapon, check for ammo update
		{
			weapon = self.weapon;

			if ( IsDefined( shared_ammo_weapon ) )
			{
				weapon = shared_ammo_weapon;
			}
				
			if ( ( isdefined( level.pers_upgrade_nube ) && level.pers_upgrade_nube ) )
			{
				weapon = zm_pers_upgrades_functions::pers_nube_weapon_ammo_check( player, weapon );
			}
			
			// MM - need to check and see if the player has an upgraded weapon.  If so, the ammo cost is much higher
			//    - hacked wall buys have their costs reversed...
			if ( IsDefined( self.hacked ) && self.hacked )
			{
				if ( !player has_upgrade( weapon ) )
				{
					ammo_cost = 4500;
				}
				else
				{
					ammo_cost = get_ammo_cost( weapon );
				}
			}
			else
			{
				if ( player has_upgrade( weapon ) )
				{
					ammo_cost = 4500;
				}
				else
				{
					ammo_cost = get_ammo_cost( weapon );
				}
			}

			// If we have the "nube" upgrade, we need to set the correct ammo cost if we are buying ammo for the olympia
			if ( ( isdefined( player.pers_upgrades_awarded["nube"] ) && player.pers_upgrades_awarded["nube"] ) )
			{
				ammo_cost = zm_pers_upgrades_functions::pers_nube_override_ammo_cost( player, self.weapon, ammo_cost );
			}

			// If the player has the double points persistent upgrade, reduce the "cost" and "ammo cost"
			if ( player zm_pers_upgrades_functions::is_pers_double_points_active() )
			{
				ammo_cost = int( ammo_cost / 2 );
			}
			
			if ( weapon.isriotshield )
			{
				zm_utility::play_sound_on_ent( "no_purchase" );
			}
			else if ( player.score >= ammo_cost ) // if the player does have this then give him ammo.
			{
				if ( self.first_time_triggered == false )
				{
					self show_all_weapon_buys( player, cost, ammo_cost, is_grenade );
				}
				
				// Stat tracking
				if ( player has_upgrade( weapon ) )
				{
					player zm_stats::increment_client_stat( "upgraded_ammo_purchased" );
					player zm_stats::increment_player_stat( "upgraded_ammo_purchased" );
				}
				else
				{
					player zm_stats::increment_client_stat( "ammo_purchased" );
					player zm_stats::increment_player_stat( "ammo_purchased" );
				}

				if ( player has_upgrade( weapon ) )
				{
					ammo_given = player ammo_give( level.zombie_weapons[weapon].upgrade );
				}
				else
				{
					ammo_given = player ammo_give( weapon ); 
				}
				
				if ( ammo_given )
				{
					player zm_score::minus_to_player_score( ammo_cost ); // this give him ammo to early
				}
				bb::LogPurchaseEvent(player, self, ammo_cost, weapon.name, player has_upgrade(weapon), "_ammo", "_purchase");
			}
			else
			{
				zm_utility::play_sound_on_ent( "no_purchase" );
				if ( isDefined( level.custom_generic_deny_vo_func ) )
				{
					player [[level.custom_generic_deny_vo_func]]();
				}
				else
				{
					player zm_audio::create_and_play_dialog( "general", "outofmoney" );
				}
			}
		}
		
		if ( isdefined( self.stub ) && isdefined( self.stub.prompt_and_visibility_func ) )
		{
			self [[self.stub.prompt_and_visibility_func]]( player );
		}

	}
}

function show_all_weapon_buys( player, cost, ammo_cost, is_grenade )
{
	model = getent( self.target, "targetname" ); 
	is_melee = zm_utility::is_melee_weapon( self.weapon );
	if ( isdefined( model ) )
	{
		model thread weapon_show( player ); 
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
		
	if ( !is_grenade && !is_melee )
	{
		self weapon_set_first_time_hint( cost, ammo_cost );
	}

	if ( !( isdefined( level.dont_link_common_wallbuys ) && level.dont_link_common_wallbuys ) && isdefined( level._spawned_wallbuys)  )
	{
		for ( i = 0; i < level._spawned_wallbuys.size; i++ )
		{
			wallbuy = level._spawned_wallbuys[i];
			
			if ( isdefined( self.stub ) && isdefined( wallbuy.trigger_stub ) && ( self.stub.clientFieldName == wallbuy.trigger_stub.clientFieldName ) )
			{
				continue;
			}

			if ( self.weapon == wallbuy.weapon )
			{
				if ( isdefined( wallbuy.trigger_stub ) && isdefined( wallbuy.trigger_stub.clientFieldName ) )
				{
					level clientfield::set( wallbuy.trigger_stub.clientFieldName, 1 );
				}
				else if ( isdefined( wallbuy.target ) )
				{
					model = getent( wallbuy.target, "targetname" ); 
					if ( isdefined( model ) )
					{
						model thread weapon_show( player ); 
					}					
				}
				
				if ( isdefined( wallbuy.trigger_stub ) )
				{
					wallbuy.trigger_stub.first_time_triggered = true;
					
					if ( isdefined( wallbuy.trigger_stub.trigger ) )
					{
						wallbuy.trigger_stub.trigger.first_time_triggered = true;
						
						if ( !is_grenade && !is_melee )
						{
							wallbuy.trigger_stub.trigger weapon_set_first_time_hint( cost, ammo_cost );
						}
					}
				}
				else
				{
					if ( !is_grenade && !is_melee )
					{
						wallbuy weapon_set_first_time_hint( cost, ammo_cost );
					}
				}
			}
		}
	}
}	

function weapon_show( player )
{
	player_angles = VectorToAngles( player.origin - self.origin ); 

	player_yaw = player_angles[1]; 
	weapon_yaw = self.angles[1];

	if ( isdefined( self.script_int ) )
	{
		weapon_yaw -= self.script_int;
	}

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
	self.origin = self.origin + (AnglesToForward( ( 0, yaw, 0 ) ) * 8);

	{wait(.05);}; 
	self Show(); 

	zm_utility::play_sound_at_pos( "weapon_show", self.origin, self );

	time = 1; 
	if ( !isdefined( self._linked_ent ) )
	{
		self MoveTo( self.og_origin, time ); 
	}
}

function get_pack_a_punch_camo_index()
{
	return 7;
}

function get_pack_a_punch_weapon_options( weapon )
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

	smiley_face_reticle_index = 1; // smiley face is reserved for the upgraded saritch

	camo_index = get_pack_a_punch_camo_index();
	
	lens_index = randomIntRange( 0, 6 );
	reticle_index = randomIntRange( 0, 16 );
	reticle_color_index = randomIntRange( 0, 6 );
	plain_reticle_index = 16;

	use_plain = ( randomint( 10 ) < 1 );
	
	if ( "saritch_upgraded" == weapon.rootWeapon.name )
	{
		reticle_index = smiley_face_reticle_index;
	}
	else if ( use_plain )
	{
		reticle_index = plain_reticle_index;
	}
	
	
/#
	if ( GetDvarInt( "scr_force_reticle_index" ) >= 0 )
	{
		reticle_index = GetDvarInt( "scr_force_reticle_index" );
	}
#/

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

function give_build_kit_weapon( weapon )
{
	weapon = self GetBuildKitWeapon( weapon );

	camo = undefined;
	if ( is_weapon_upgraded( weapon ) )
	{
		camo = get_pack_a_punch_camo_index();
	}
	weapon_options = self GetBuildKitWeaponOptions( weapon, camo );

	acvi = self GetBuildKitAttachmentCosmeticVariantIndexes( weapon );

	self GiveWeapon( weapon, weapon_options, acvi );

	return weapon;
}

function weapon_give( weapon, is_upgrade, magic_box, nosound ) // is_upgrade and magic_box are ignored
{
	primaryWeapons = self GetWeaponsListPrimaries(); 
	current_weapon = self getCurrentWeapon(); 
	current_weapon = self zm_weapons::switch_from_alt_weapon( current_weapon );

	assert( self player_can_use_content( weapon ) );

	//if is not an upgraded perk purchase
	if( !IsDefined( is_upgrade ) )
	{
		is_upgrade = false;
	}

	weapon_limit = zm_utility::get_player_weapon_limit( self );

	if ( zm_equipment::is_equipment( weapon ) )
	{
		self zm_equipment::give( weapon );
	}

	if ( weapon.isriotshield )
	{
		if ( isdefined( self.player_shield_reset_health ) )
		{
			self [[self.player_shield_reset_health]]();
		}
	}

	if ( self HasWeapon( weapon ) )
	{
		if ( weapon.isBallisticKnife )
		{
			self notify( "zmb_lost_knife" );
		}

		self GiveStartAmmo( weapon );
		if ( !zm_utility::is_offhand_weapon( weapon ) )
		{
			self SwitchToWeapon( weapon );
		}

		return;
	}

	if ( zm_utility::is_melee_weapon( weapon ) )
	{
		current_weapon=zm_melee_weapon::change_melee_weapon( weapon, current_weapon );
	}
	else if ( zm_utility::is_hero_weapon( weapon ) )
	{
		old_hero = self zm_utility::get_player_hero_weapon();
		if ( old_hero != level.weaponNone )
		{
			self TakeWeapon( old_hero ); 
		}

		self zm_utility::set_player_hero_weapon( weapon );
	}
	else if ( zm_utility::is_lethal_grenade( weapon ) )
	{
		old_lethal = self zm_utility::get_player_lethal_grenade();
		if ( old_lethal != level.weaponNone )
		{
			self TakeWeapon( old_lethal ); 
		}

		self zm_utility::set_player_lethal_grenade( weapon );
	}
	else if ( zm_utility::is_tactical_grenade( weapon ) )
	{
		old_tactical = self zm_utility::get_player_tactical_grenade();
		if ( old_tactical != level.weaponNone )
		{
			self TakeWeapon( old_tactical ); 
		}

		self zm_utility::set_player_tactical_grenade( weapon );
	} 
	else if ( zm_utility::is_placeable_mine( weapon ) )
	{
		old_mine = self zm_utility::get_player_placeable_mine();
		if ( old_mine != level.weaponNone )
		{
			self TakeWeapon( old_mine ); 
		}

		self zm_utility::set_player_placeable_mine( weapon );
	} 

	if ( !zm_utility::is_offhand_weapon( weapon ) )
	{
		self zm_weapons::take_fallback_weapon();
	}

	// This should never be true for the first time.
	if ( primaryWeapons.size >= weapon_limit )
	{

		if ( zm_utility::is_placeable_mine( current_weapon ) || zm_equipment::is_equipment( current_weapon ) )
		{
			current_weapon = undefined;
		}

		if ( isdefined( current_weapon ) )
		{
			if ( !zm_utility::is_offhand_weapon( weapon ) )
			{
				if ( current_weapon.isBallisticKnife )
				{
					self notify( "zmb_lost_knife" );
				}

				self TakeWeapon( current_weapon ); 
			}
		} 
	}
	
	if ( IsDefined( level.zombiemode_offhand_weapon_give_override ) )
	{
		if ( self [[ level.zombiemode_offhand_weapon_give_override ]]( weapon ) )
		{
			return;
		}
	}

	if ( weapon.isBallisticKnife )
	{
		weapon = self zm_melee_weapon::give_ballistic_knife( weapon, is_weapon_upgraded( weapon ) );
	}
	else if( zm_utility::is_placeable_mine( weapon ) )
	{
		self thread zm_placeable_mine::setup_for_player(weapon);
		self play_weapon_vo( weapon, magic_box );
		return;
	}
	
	// run any custom weapon callbacks here
	if ( IsDefined( level.zombie_weapons_callbacks ) && IsDefined( level.zombie_weapons_callbacks[ weapon ] ) )
	{
		self thread [[ level.zombie_weapons_callbacks[ weapon ] ]]();
		play_weapon_vo( weapon, magic_box );
		return;
	}

	if ( !( isdefined( nosound ) && nosound ) )
	{
		self zm_utility::play_sound_on_ent( "purchase" );
	}

	weapon = self give_build_kit_weapon( weapon );

	self GiveStartAmmo( weapon );

	if ( !zm_utility::is_offhand_weapon( weapon ) )
	{
		if( !zm_utility::is_melee_weapon( weapon ) )
		{
			self SwitchToWeapon( weapon );
		}
		else
		{
			self SwitchToWeapon( current_weapon );
		}
	}
	 
	self play_weapon_vo( weapon, magic_box );
}

function play_weapon_vo( weapon, magic_box )
{
	//Added this in for special instances of New characters with differing favorite weapons
	if ( isDefined( level._audio_custom_weapon_check ) )
	{
		type = self [[ level._audio_custom_weapon_check ]]( weapon, magic_box );
	}
	else
	{
	    type = self weapon_type_check( weapon );
	}

	if ( !IsDefined(type) )
	{
		return;
	}
	
	if( ( isdefined( magic_box ) && magic_box ) )
	{
		self zm_audio::create_and_play_dialog( "box_pickup", type );
	}
	else
	{
		if( randomintrange(0,100) <= 50 )
		{
			self zm_audio::create_and_play_dialog( "weapon_pickup", type );
		}
		else
		{
			self zm_audio::create_and_play_dialog( "weapon_pickup", "generic" );
		}
	}
}

function weapon_type_check( weapon )
{
	if( weapon.name == "zombie_beast_grapple_dwr" ||
	    weapon.name == "zombie_beast_lightning_dwl" ||
	    weapon.name == "zombie_beast_lightning_dwl2" ||
	    weapon.name == "zombie_beast_lightning_dwl3" )
	{
		return undefined;
	}
	
	if ( !IsDefined( self.entity_num ) )
	{
		return "crappy";
	}

	weapon = weapon.rootWeapon;
    
	if ( is_weapon_upgraded( weapon ) )
	{
		return "upgrade";
	}
	else
	{
		if ( IsDefined(level.zombie_weapons[weapon]) )
			return level.zombie_weapons[weapon].vox;
		return "crappy";
	}
}

function ammo_give( weapon )
{
	// We assume before calling this function we already checked to see if the player has this weapon...

	// Should we give ammo to the player
	give_ammo = false; 

	// Check to see if ammo belongs to a primary weapon
	if ( !zm_utility::is_offhand_weapon( weapon ) )
	{
		weapon = self get_weapon_with_attachments( weapon );
		
		if ( isdefined( weapon ) )
		{
			// get the max allowed ammo on the current weapon
			stockMax = 0;	// scope declaration
			stockMax = weapon.startAmmo;

			// Get the current weapon clip count
			clipCount = self GetWeaponAmmoClip( weapon ); 

			currStock = self GetAmmoCount( weapon );

			// compare it with the ammo player actually has, if more or equal just dont give the ammo, else do
			if ( ( currStock - clipcount ) >= stockMax )	
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
		if ( self has_weapon_or_upgrade( weapon ) )
		{
			// Check if the player has less than max stock, if no give ammo
			if ( self getammocount( weapon ) < weapon.maxAmmo )
			{
				// give the ammo to the player
				give_ammo = true; 					
			}
		}		
	}	

	if ( give_ammo )
	{
		self zm_utility::play_sound_on_ent( "purchase" ); 
		self GiveMaxAmmo( weapon );

		alt_weap = weapon.altWeapon;
		if ( level.weaponNone != alt_weap )
		{
			self GiveMaxAmmo( alt_weap );
		}
		
		return true;
	}

	if ( !give_ammo )
	{
		return false;
	}
}

function get_default_weapondata( weapon )
{
	weapondata = [];

	weapondata["weapon"] = weapon;

	dw_weapon = weapon.dualWieldWeapon;
	alt_weapon = weapon.altWeapon;

	weaponNone = GetWeapon( "none" ); 
	if ( IsDefined(level.weaponNone) )
		weaponNone = level.weaponNone;
	
	if ( weapon != weaponNone )
	{
		weapondata["clip"] = weapon.clipSize;
		weapondata["stock"] = weapon.maxAmmo;
		weapondata["fuel"] = weapon.fuelLife;
		weapondata["heat"] = 0;
		weapondata["overheat"] = 0;
	}

	if ( dw_weapon != weaponNone )
	{
		weapondata["lh_clip"] = dw_weapon.clipSize;
	}
	else
	{
		weapondata["lh_clip"] = 0;
	}

	if ( alt_weapon != weaponNone )
	{
		weapondata["alt_clip"] = alt_weapon.clipSize;
		weapondata["alt_stock"] = alt_weapon.maxAmmo;
	}
	else
	{
		weapondata["alt_clip"] = 0;
		weapondata["alt_stock"] = 0;
	}
	
	return weapondata;
}

function get_player_weapondata( player, weapon )
{
	weapondata = [];
	if ( !isdefined( weapon ) )
	{
		weapon = player GetCurrentWeapon();
	}

	weapondata["weapon"] = weapon;

	if ( weapondata["weapon"] != level.weaponNone )
	{
		weapondata["clip"] = player GetWeaponAmmoClip( weapon );
		weapondata["stock"] = player GetWeaponAmmoStock( weapon );
		weapondata["fuel"] = player GetWeaponAmmoFuel( weapon );
		weapondata["heat"] = player IsWeaponOverheating( 1, weapon );
		weapondata["overheat"] = player IsWeaponOverheating( 0, weapon );
	}
	else
	{
		weapondata["clip"] = 0;
		weapondata["stock"] = 0;
		weapondata["fuel"] = 0;
		weapondata["heat"] = 0;
		weapondata["overheat"] = 0;
	}

	dw_weapon = weapon.dualWieldWeapon;
	if ( dw_weapon != level.weaponNone )
	{
		weapondata["lh_clip"] = player GetWeaponAmmoClip( dw_weapon );
	}
	else
	{
		weapondata["lh_clip"] = 0;
	}

	alt_weapon = weapon.altWeapon;
	if ( alt_weapon != level.weaponNone )
	{
		weapondata["alt_clip"] = player GetWeaponAmmoClip( alt_weapon );
		weapondata["alt_stock"] = player GetWeaponAmmoStock( alt_weapon );
	}
	else
	{
		weapondata["alt_clip"] = 0;
		weapondata["alt_stock"] = 0;
	}

	return weapondata;
}



function weapon_is_better( left, right )
{
	if ( left != right )
	{
		left_upgraded = !IsDefined( level.zombie_weapons[ left ] );
		right_upgraded = !IsDefined( level.zombie_weapons[ right ] );
		if ( left_upgraded && right_upgraded )
		{
			leftatt = get_attachment_index( left );
			rightatt = get_attachment_index( right );
			return (leftatt > rightatt);
		}
		else if ( left_upgraded )
		{
			return true;
		}
	}
	return false;
}


function merge_weapons( oldweapondata, newweapondata )
{
	weapondata = [];

	if ( weapon_is_better( oldweapondata["weapon"], newweapondata["weapon"] ) )
	{
		weapondata["weapon"] = oldweapondata["weapon"];
	}
	else
	{
		weapondata["weapon"] = newweapondata["weapon"];
	}
	
	weapon = weapondata["weapon"];
	
	dw_weapon = weapon.dualWieldWeapon;
	alt_weapon = weapon.altWeapon;

	if ( weapon != level.weaponNone )
	{
		weapondata["clip"] = newweapondata["clip"] + oldweapondata["clip"];   
		weapondata["clip"] = int( min( weapondata["clip"], weapon.clipSize ) );
		weapondata["stock"] = newweapondata["stock"] + oldweapondata["stock"];   
		weapondata["stock"] = int( min( weapondata["stock"], weapon.maxAmmo ) );
		weapondata["fuel"] = newweapondata["fuel"] + oldweapondata["fuel"];   
		weapondata["fuel"] = int( min( weapondata["fuel"], weapon.fuelLife ) );
		weapondata["heat"] = int( min( newweapondata["heat"], oldweapondata["heat"] ) );
		weapondata["overheat"] = int( min( newweapondata["overheat"], oldweapondata["overheat"] ) );
	}

	if ( dw_weapon != level.weaponNone )
	{
		weapondata["lh_clip"] = newweapondata["lh_clip"] + oldweapondata["lh_clip"];   
		weapondata["lh_clip"] = int( min( weapondata["lh_clip"], dw_weapon.clipSize ) );
	}

	if ( alt_weapon != level.weaponNone )
	{
		weapondata["alt_clip"] = newweapondata["alt_clip"] + oldweapondata["alt_clip"];   
		weapondata["alt_clip"] = int( min( weapondata["alt_clip"], alt_weapon.clipSize ) );
		weapondata["alt_stock"] = newweapondata["alt_stock"] + oldweapondata["alt_stock"];   
		weapondata["alt_stock"] = int( min( weapondata["alt_stock"], alt_weapon.maxAmmo ) );
	}

	return weapondata;
}




function weapondata_give( weapondata )
{
	current = self get_player_weapon_with_same_base( weapondata["weapon"] );
	if ( isdefined( current ) )
	{
		curweapondata = get_player_weapondata( self, current );
		self TakeWeapon( current );

		weapondata = merge_weapons( curweapondata, weapondata );
	}

	weapon = weapondata["weapon"];
	
	weapon_give( weapon, undefined, undefined, true );

	if ( weapon != level.weaponNone )
	{
		self SetWeaponAmmoClip( weapon, weapondata["clip"] );
		self SetWeaponAmmoStock( weapon, weapondata["stock"] );
		if ( IsDefined( weapondata["fuel"] ) )
		{
			self SetWeaponAmmoFuel( weapon, weapondata["fuel"] );
		}
		if ( IsDefined( weapondata["heat"] ) && IsDefined( weapondata["overheat"] ) )
		{
			self SetWeaponOverheating( weapondata["overheat"], weapondata["heat"], weapon );
		}
	}

	dw_weapon = weapon.dualWieldWeapon;
	if ( dw_weapon != level.weaponNone )
	{
		if ( !self HasWeapon( dw_weapon ) )
		{
			self GiveWeapon( dw_weapon );
		}
		self SetWeaponAmmoClip( dw_weapon, weapondata["lh_clip"] );
	}

	alt_weapon = weapon.altWeapon;
	if ( alt_weapon != level.weaponNone )
	{
		if ( !self HasWeapon( alt_weapon ) )
		{
			self GiveWeapon( alt_weapon );
		}
		self SetWeaponAmmoClip( alt_weapon, weapondata["alt_clip"] );
		self SetWeaponAmmoStock( alt_weapon, weapondata["alt_stock"] );
	}
}

function weapondata_take( weapondata )
{
	weapon = weapondata["weapon"];
	if ( weapon != level.weaponNone )
	{
		if ( self HasWeapon( weapon ) )
		{
			self TakeWeapon( weapon );
		}
	}

	dw_weapon = weapon.dualWieldWeapon;
	if ( dw_weapon != level.weaponNone )
	{
		if ( self HasWeapon( dw_weapon ) )
		{
			self TakeWeapon( dw_weapon );
		}
	}

	alt_weapon = weapon.altWeapon;
	while ( alt_weapon != level.weaponNone )
	{
		if ( self HasWeapon( alt_weapon ) )
		{
			self TakeWeapon( alt_weapon );
		}
		alt_weapon = alt_weapon.altWeapon;
	}
}

// Create a loadout from an array of weapons that can later be applied to a player
function create_loadout( weapons )
{
	weaponNone = GetWeapon( "none" ); 
	if ( IsDefined(level.weaponNone) )
		weaponNone = level.weaponNone;
	loadout = SpawnStruct(); 
	loadout.weapons = [];
	foreach ( weapon in weapons )
	{
		if ( IsString(weapon) )
			weapon = GetWeapon(weapon);
		if ( weapon == weaponNone )
		{
			/# println("ZM WEAPON ERROR: Unrecognized weapon in loadout " + weapon.name ); #/
		}
		loadout.weapons[weapon.name] = get_default_weapondata( weapon );
		// use first weapon as current
		if (!IsDefined(loadout.current))
			loadout.current = weapon;
	}
	return loadout; 
}

// Get the player's existing loadout for later restoration
function player_get_loadout()
{
	loadout = SpawnStruct(); 
	loadout.current = self GetCurrentWeapon();
	loadout.weapons = [];
	foreach ( weapon in self GetWeaponsList() )
	{
		loadout.weapons[weapon.name] = get_player_weapondata( self, weapon );
	}
	
	return loadout; 
}

// Give a saved or created loadout to a player
function player_give_loadout( loadout, replace_existing = true )
{
	if ( ( isdefined( replace_existing ) && replace_existing ) )
		self TakeAllWeapons();
	foreach ( weapondata in loadout.weapons )
	{
		self weapondata_give( weapondata );
	}
	Self SwitchToWeapon(loadout.current);

}

// Take all weapons in a loadout away from a player
function player_take_loadout( loadout )
{
	foreach ( weapondata in loadout.weapons )
	{
		self weapondata_take( weapondata );
	}
}


// This function will be run when the player picks up the weapon for the first time
function register_zombie_weapon_callback( weapon, func )
{
	if ( !IsDefined( level.zombie_weapons_callbacks ) )
	{
		level.zombie_weapons_callbacks = [];
	}
	
	if ( !IsDefined( level.zombie_weapons_callbacks[weapon] ) )
	{
		level.zombie_weapons_callbacks[weapon] = func;
	}
}



















	
function checkStringValid( str )
{
	if( str != "" )
		return str;
	return undefined;
}
	
function load_weapon_spec_from_table( table, first_row )
{
	gametype = GetDvarString( "ui_gametype" );
	index = 1;
	row = TableLookupRow( table, index );
	while ( isdefined( row ) )
	{
		//Get this weapons data from the current tablerow
		weapon_name 		= checkStringValid( row[0] );
		upgrade_name 		= checkStringValid( row[1] );
		hint 				= checkStringValid( row[2] );
		cost 				= int( row[3] );
		weaponVO			= checkStringValid( row[4] );
		weaponVOresp 		= checkStringValid( row[5] );

		ammo_cost 			= undefined; // if unspecified, default to half the cost using undefined
		if ( "" != row[6] )
		{
			ammo_cost 			= int( row[6] );
		}

		create_vox 			= checkStringValid( row[7] );
		is_zcleansed 		= (ToLower( row[8] ) == "true");
		in_box 				= (ToLower( row[9] ) == "true");
		upgrade_in_box 		= (ToLower( row[10] ) == "true");
		is_limited 			= (ToLower( row[11] ) == "true");
		limit 				= int( row[12] );
		upgrade_limit 		= int( row[13] );
		content_restrict 	= row[14];
		wallbuy_autospawn 	= (ToLower( row[15] ) == "true");
		weapon_class 		= checkStringValid( row[16] );

		//Now use this data to include the weapon
		zm_utility::include_weapon( weapon_name, in_box );
		if ( isdefined( upgrade_name ) )
		{
			zm_utility::include_weapon( upgrade_name, upgrade_in_box );
		}

		add_zombie_weapon( weapon_name, upgrade_name, hint, cost, weaponVO, weaponVOresp, ammo_cost, create_vox );
		if ( is_limited )
		{
			if ( isdefined( limit ) )
			{
				add_limited_weapon( weapon_name, limit );
			}
			if ( isdefined( upgrade_limit ) )
			{
				add_limited_weapon( upgrade_name, upgrade_limit );
			}
		}

	/*	if ( IS_TRUE( content_restrict ) )
		{
			add_weapon_to_content( weapon_name, content_restrict );
		}*/
		
		/*weapon = GetWeapon( weapon_name );
		if ( !isdefined( level.wallbuy_autofill_weapons ) )
		{
			level.wallbuy_autofill_weapons = [];
			level.wallbuy_autofill_weapons["all"] = [];
		}
		level.wallbuy_autofill_weapons["all"][weapon] = wallbuy_autospawn;
		
		if ( weapon_class != "" )
		{
			if ( !isdefined( level.wallbuy_autofill_weapons[weapon_class] ) )
			{
				level.wallbuy_autofill_weapons[weapon_class] = [];
			}
			level.wallbuy_autofill_weapons[weapon_class][weapon] = weapon;
		}*/

		index++;
		row = TableLookupRow( table, index );
	}
}

function autofill_wallbuys_init()
{
	wallbuys = struct::get_array("wallbuy_autofill","targetname");

	if (!isdefined(wallbuys) || wallbuys.size == 0 || !isdefined(level.wallbuy_autofill_weapons) || level.wallbuy_autofill_weapons.size == 0 )
		return;
	
	level.use_autofill_wallbuy = true;
	level.active_autofill_wallbuys = [];
	
	array_keys["all"] = GetArrayKeys(level.wallbuy_autofill_weapons["all"]);
	class_all = [];
	index = 0;
		
	//Loop through all autospawn wallbuys
	foreach (wallbuy in wallbuys)
	{
		weapon_class = wallbuy.script_string;
		weapon = undefined;
		
		//If this wallbuy needs a specific class of weapons
		if (isdefined(weapon_class) && weapon_class != "")
		{
			//Check if there's any weapon of this class included
			if (!isdefined(array_keys[weapon_class]) && isdefined(level.wallbuy_autofill_weapons[weapon_class]))
				array_keys[weapon_class] = GetArrayKeys(level.wallbuy_autofill_weapons[weapon_class]);
			if (isdefined(array_keys[weapon_class]))
			{
				//Find the first not spawned weapon of this type
				for (i = 0 ; i < array_keys[weapon_class].size; i ++)
				{
					if (level.wallbuy_autofill_weapons["all"][array_keys[weapon_class][i]])
					{
						weapon = array_keys[weapon_class][i];
						//Mark this weapon spawned
						level.wallbuy_autofill_weapons["all"][weapon] = false;
						break;
					}
				}
			}
			else
			{
				continue;
			}
		}
		else
		{
			//Save for later
			class_all[class_all.size] = wallbuy;
			continue;
		}
		
		//No more weapon can be assigned to this wallbuy, skip it
		if (!isdefined(weapon))
			continue;
		
		wallbuy.zombie_weapon_upgrade = weapon.name;
		wallbuy.weapon = weapon;
		
		//Fix for the blue light effect
		right = AnglesToRight(wallbuy.angles);
		wallbuy.origin -= right * 2;
		
		wallbuy.target = "autofill_wallbuy_" + index;
		
		target_struct = SpawnStruct();
		target_struct.targetname = wallbuy.target;
		target_struct.angles = wallbuy.angles;
		target_struct.origin = wallbuy.origin;
		
		model = wallbuy.weapon.worldModel;
		target_struct.model = model;
		target_struct struct::init();
		level.active_autofill_wallbuys[level.active_autofill_wallbuys.size] = wallbuy;
		index ++;
	}
	
	foreach (wallbuy in class_all)
	{
		weapon = undefined;
		//Find the first available weapon in all weapons included
		for (i = 0 ; i < array_keys["all"].size; i ++)
		{
			if (level.wallbuy_autofill_weapons["all"][array_keys["all"][i]])
			{
				weapon = array_keys["all"][i];
				level.wallbuy_autofill_weapons["all"][weapon] = false;
				break;
			}
		}
		
		//No more weapon can be assigned to class all
		if (!isdefined(weapon))
			break;
		
		wallbuy.zombie_weapon_upgrade = weapon.name;
		wallbuy.weapon = weapon;
		
		//Fix for the blue light effect
		right = AnglesToRight(wallbuy.angles);
		wallbuy.origin -= right * 2;
		
		wallbuy.target = "autofill_wallbuy_" + index;
		
		target_struct = SpawnStruct();
		target_struct.targetname = wallbuy.target;
		target_struct.angles = wallbuy.angles;
		target_struct.origin = wallbuy.origin;
		
		model = wallbuy.weapon.worldModel;
		target_struct.model = model;
		target_struct struct::init();
		level.active_autofill_wallbuys[level.active_autofill_wallbuys.size] = wallbuy;
		index ++;
		
	}
}
