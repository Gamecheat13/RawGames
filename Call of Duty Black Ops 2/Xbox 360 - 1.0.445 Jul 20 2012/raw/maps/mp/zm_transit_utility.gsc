#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

// used to check if the player is currently trying to buy and has enough points
playerCanAfford( player, cost )
{
	if( !player UseButtonPressed() )
	{
		return false;
	}

	if( player in_revive_trigger() )
	{
		return false;
	}
		
	if (IsDefined(cost))
	{
		if (player.score < cost)
		{
			return false;
		}
		player maps\mp\zombies\_zm_score::minus_to_player_score( cost ); 
	}
	return true;
}

SetInvisibleToAll()
{
	players = GET_PLAYERS();
	for(playerIndex = 0; playerIndex < players.size; playerIndex++ )
	{
		self setInvisibleToPlayer( players[playerIndex] );
	}
}

SpawnAndLinkFXToTag(effect, ent, tag)
{
    fxEnt =  Spawn("script_model", ent GetTagOrigin(tag));
    fxEnt SetModel("tag_origin"); // tag_origin_animate
    fxEnt LinkTo(ent, tag);
    
	wait_network_frame();
    
    PlayFxOnTag(effect, fxEnt, "tag_origin");
    return fxEnt;
}

SpawnAndLinkFXToOffset(effect, ent, offsetOrigin, offsetAngles)
{
    fxEnt =  Spawn("script_model", (0,0,0));
    fxEnt SetModel("tag_origin"); // tag_origin_animate
    fxEnt LinkTo(ent, "", offsetOrigin, offsetAngles);
    
	wait_network_frame();
    
    PlayFxOnTag(effect, fxEnt, "tag_origin");
    return fxEnt;
}

custom_weapon_wall_prices()
{
	// bail out early, if the weapon array has not been defined
	if( !IsDefined( level.zombie_include_weapons ) )
	{
		return;
	}
	
	weapon_spawns = [];
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" ); 

	for( i = 0; i < weapon_spawns.size; i++ )
	{
		// weapon needs be in the weapons array
		if( !IsDefined(level.zombie_weapons[weapon_spawns[i].zombie_weapon_upgrade]) )
		{
			continue;
		}
		
		if( IsDefined(weapon_spawns[i].script_int) )
		{
			// set the new cost of the weapon
			cost = weapon_spawns[i].script_int;
			level.zombie_weapons[weapon_spawns[i].zombie_weapon_upgrade].cost = cost;
			
			// set the hint string to refect the new weapon cost
			//hint_string = maps\_zombiemode_weapons::get_weapon_hint( weapon_spawns[i].zombie_weapon_upgrade );
			//weapon_spawns[i] SetHintString( hint_string, cost );
		}
	}
}

/////////////////////////////////////////////////////////

pause_zombie_spawning()
{
	if ( !IsDefined(level.spawnPauseCount) )
	{
		level.spawnPauseCount = 0;
	}

	level.spawnPauseCount++;
	flag_clear("spawn_zombies");
}

try_resume_zombie_spawning()
{
	if ( !IsDefined(level.spawnPauseCount) )
	{
		level.spawnPauseCount = 0;
	}

	level.spawnPauseCount--;
	if ( level.spawnPauseCount <= 0 )
	{
		level.spawnPauseCount = 0;
		flag_set("spawn_zombies");
	}
}


//-------------------------------------------------
// name: 	triggerWeaponsLockerWatch
// self: 	trigger
// return:	nothing
// desc:	logic for the weapon storage locker
//--------------------------------------------------
triggerWeaponsLockerWatch(wallModel)
{
	storedAmmoClip	= undefined;
	storedAmmoStock	= undefined;
	storedWeapon	= undefined;
	
	emptyWallModel = wallModel.model;
		
	while (1)
	{
		self waittill("trigger", who);
		
		weaponToGive	= storedWeapon;
		clipAmmoToGive	= storedAmmoClip;
		stockAmmoToGive	= storedAmmoStock;
		
		
		primaries = who GetWeaponsListPrimaries();
		
		if(isDefined(who.weaponPlusPerkOn) && who.weaponPlusPerkOn)
		{
			maxWeapons = 3;
		}
		else
		{
			maxWeapons = 2;
		}
		
		hasWallWeapon = isDefined(weaponToGive) && who HasWeapon(weaponToGive);
		
		//Don't take away weapon if we can hold more weapons
		//If we already have the weapon just give the ammo
		if( hasWallWeapon || (isDefined( primaries ) && primaries.size < maxWeapons) )
		{
			storedWeapon 	= undefined;
			storedAmmoClip 	= undefined;
			storedAmmoStock = undefined;
			
			wallModel setModel(emptyWallModel);
			
			self SetHintString( "Hold [{+activate}] To Store Current Weapon");
			
			who playsoundtoplayer( "zmb_vault_weapon_withdraw", who );
		}
		else
		{
			storedWeapon 	= who GetCurrentWeapon();
			storedAmmoClip 	= who GetWeaponAmmoClip(storedWeapon);
			storedAmmoStock = who GetWeaponAmmoStock(storedWeapon);
			
			//Set view model
			weaponWorldModel = GetWeaponModel( storedWeapon );
			wallModel setModel(weaponWorldModel);
			wallModel useweaponhidetags( storedWeapon );
			
			who TakeWeapon(storedWeapon);
			//Switch to other weapon if we are not going to get a weapon back
			if(!isDefined(weaponToGive))
			{
				primaries = who GetWeaponsListPrimaries();
				who SwitchToWeapon(primaries[0]);
			}
			
			self SetHintString( "Hold [{+activate}] To Get Stored Weapon (" + storedWeapon + ").");
			
			who playsoundtoplayer( "zmb_vault_weapon_deposit", who );
		}
		
		if(isDefined(weaponToGive))
		{
			if( hasWallWeapon )
			{
				curretClipAmmo = who GetWeaponAmmoClip(weaponToGive);
				if(isDefined(curretClipAmmo))
				{
					stockAmmoToGive += curretClipAmmo;
				}
				curretStockAmmo = who GetWeaponAmmoStock(weaponToGive);
				if(isDefined(curretStockAmmo))
				{
					stockAmmoToGive += curretStockAmmo;
				}
				
				who SetWeaponAmmoStock(weaponToGive, stockAmmoToGive);
			}
			else
			{
				//Give weapon
				who GiveWeapon(weaponToGive, 0);
				who SetWeaponAmmoClip(weaponToGive, clipAmmoToGive);
				who SetWeaponAmmoStock(weaponToGive, stockAmmoToGive);
				who SwitchToWeapon( weaponToGive );
				if( !is_offhand_weapon( weaponToGive ) )
					who maps\mp\zombies\_zm_weapons::take_fallback_weapon();
			}
		}
		else
		{
			//Switch to a weapon, if we only stored one.
			primaries = who GetWeaponsListPrimaries();
			if(primaries.size>0)
			{
				who SwitchToWeapon(primaries[0]);
			}
		}
		
		wait(.5);
	}	
}

automatonSpeak( category, type, response, force_variant, override )
{
	if ( IsDefined( level.automaton ) )
	{
		level.automaton maps\mp\zombies\_zm_audio::create_and_play_dialog( category, type, response, force_variant, override );
	}
}

is_TheDouche()
{
	return ( self.characterIndex == 0 );
}

is_TheConspiracyTheorist()
{
	return ( self.characterIndex == 1 );
}

is_TheFarmersDaughter()
{
	return ( self.characterIndex == 2 );
}

is_TheElectricalEngineer()
{
	return ( self.characterIndex == 3 );
}

get_random_encounter_match(location)
{
	match_pool = [];
	
	//meat
	if(isDefined(level._registered_meat_matches) && level._registered_meat_matches.size > 0)
	{
		match = maps\mp\zombies\_zm_game_module_meat::get_registered_meat_match(undefined,location);
		if(isDefined(match))
		{
			match_pool[match_pool.size] = match;
		}
	}
	
	//race
	if(isDefined(level._registered_races) && level._registered_races.size > 0)
	{
		match = maps\mp\zombies\_zm_game_module_race::get_registered_race(undefined,location);
		if(isDefined(match))
		{
			match_pool[match_pool.size] = match;
		}
	}
	
	assert((match_pool.size > 0), "Could not find a random encounters match for " + location);

	//add others as they come online	
	return random(match_pool);
	
}